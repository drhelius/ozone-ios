/*
* Ozone - iOS Edition
* Copyright (C) 2009-2013 Ignacio Sanchez

* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* any later version.

* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.

* You should have received a copy of the GNU General Public License
* along with this program. If not, see http://www.gnu.org/licenses/
*
*/

/* 
 * File:   levelgamestate.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 21:02
 */

#include "scene.h"
#include "renderer.h"
#include "levelgamestate.h"
#include "inputmanager.h"
#include "meshmanager.h"
#include "interpolatormanager.h"
#include "audio.h"
#include "menugamestate.h"
#include "gamemanager.h"
#include "SaveManager.h"

LevelGameState::LevelGameState(void) : GameState()
{
    Log("+++ LevelGameState::LevelGameState ...\n");

    InitPointer(m_pMainTimer);
    InitPointer(m_pMenuTimer);
    InitPointer(m_pFader);
    InitPointer(m_pScene);

    m_iLevel = 0;
    m_bChangeMusic = false;
    m_bIsCustomLevel = false;

    Log("+++ LevelGameState::LevelGameState correcto\n");
}

//////////////////////////
//////////////////////////

LevelGameState::~LevelGameState()
{
    Log("+++ LevelGameState::~LevelGameState ...\n");

    Cleanup();

    Log("+++ LevelGameState::~LevelGameState destruido\n");
}

//////////////////////////
//////////////////////////

void LevelGameState::Init(void)
{
    Log("+++ LevelGameState::Init ...\n");

    m_bNeedCleanup = true;
    m_bFinishing = false;
    m_bReseting = false;

    Audio::Instance().LoadCubeSounds(m_szCurrentEpisode);

    if (m_bChangeMusic || (m_iLevel > 10))
    {
        AudioManager::Instance().StopMusic(Audio::Instance().GetCurrentMusic());
        AudioManager::Instance().UnloadMusic(Audio::Instance().GetCurrentMusic());

        char szMusicPath[200];
        sprintf(szMusicPath, "%s/music/music_s", m_szCurrentEpisode);

        MUSIC episodeMusic = (((m_iLevel > 10) && !m_bIsCustomLevel) ? AudioManager::Instance().LoadMusic("game/sounds/s_music_boss") : AudioManager::Instance().LoadMusic(szMusicPath));
        AudioManager::Instance().SetMusicLoops(episodeMusic, 9999);
        AudioManager::Instance().PlayMusic(episodeMusic);
        Audio::Instance().SetCurrentMusic(episodeMusic);
    }

    m_pMainTimer = new Timer(true);
    m_pMenuTimer = new Timer();
    m_pFader = new Fader();
    m_pScene = new Scene(m_pMainTimer, m_pMenuTimer);

    m_pScene->Init();
    m_pScene->LoadFromFile(m_szCurrentLevel, m_bIsCustomLevel);

    m_pFader->SetLayer(1000);
    m_pFader->StartFade(0.0f, 0.0f, 0.0f, true, 0.5f, 90.0f);

    Renderer::Instance().SetClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    Renderer::Instance().EnableClearColor(true);

    m_pMainTimer->Start();
    m_pMenuTimer->Start();

    Log("+++ LevelGameState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void LevelGameState::PrepareLevelForLoading(const char* szLevelPath, const char* szEpisodePath, int level, bool changeMusic, bool isCustomLevel)
{
    m_bChangeMusic = changeMusic;
    m_iLevel = level;
    strcpy(m_szCurrentLevel, szLevelPath);
    strcpy(m_szCurrentEpisode, szEpisodePath);
    m_bIsCustomLevel = isCustomLevel;
}

//////////////////////////
//////////////////////////

void LevelGameState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ LevelGameState::Cleanup ...\n");

        MeshManager::Instance().UnloadAll();
        TextureManager::Instance().UnloadAll();

        InputManager::Instance().ClearRegionEvents();

        InterpolatorManager::Instance().DeleteAll();

        Renderer::Instance().ClearLayers();

        SafeDelete(m_pMainTimer);
        SafeDelete(m_pMenuTimer);
        SafeDelete(m_pFader);
        SafeDelete(m_pScene);

        m_bNeedCleanup = false;

        Log("+++ LevelGameState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void LevelGameState::Pause(void) { }

//////////////////////////
//////////////////////////

void LevelGameState::Resume(void) { }

//////////////////////////
//////////////////////////

void LevelGameState::Update(void)
{
    m_pMainTimer->Update();
    m_pMenuTimer->Update();

    InterpolatorManager::Instance().Update(m_pMainTimer->GetDeltaTime());

    InputManager::Instance().Update();

    m_pScene->Update();

    if (m_pScene->IsReadyToFinish())
    {
        m_pFader->Update(m_pMenuTimer->GetDeltaTime());

        if (!m_bFinishing)
        {
            m_bFinishing = true;
            m_pFader->StartFade(0.0f, 0.0f, 0.0f, false, 0.5f, 90.0f);
        }

        m_pFader->Update(m_pMenuTimer->GetDeltaTime());

        if (m_bFinishing && m_pFader->IsFinished())
        {
            if (m_pScene->IsLevelcompleted())
            {
                stCurrentEpisodeAndLevel state = MenuGameState::Instance().GetCurrentSelection();
                state.finished = true;
                MenuGameState::Instance().SetCurrentSelection(state);
                SaveManager::Instance().SaveToFile();
            }

            GameManager::Instance().ChangeState(&MenuGameState::Instance());
        }
    }
    else if (m_pScene->IsReadyToReset())
    {
        if (!m_bReseting)
        {
            m_bReseting = true;
            m_pFader->StartFade(0.0f, 0.0f, 0.0f, false, 0.5f, 90.0f);
        }

        if (m_bReseting && m_pFader->IsFinished())
        {
            m_bReseting = false;
            m_pScene->Reset();
            m_pFader->StartFade(0.0f, 0.0f, 0.0f, true, 0.5f, 90.0f);
        }

        m_pFader->Update(m_pMenuTimer->GetDeltaTime());
    }
    else
    {
        m_pFader->Update(m_pMainTimer->GetDeltaTime());
    }
}