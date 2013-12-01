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
 * File:   InGameMenuEndLevel.mm
 * Author: nacho
 * 
 * Created on 23 de febrero de 2010, 16:19
 */

#include "InGameMenuEndLevel.h"
#include "renderer.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "audio.h"
#include "SaveManager.h"
#include "menugamestate.h"

//////////////////////////
//////////////////////////

InGameMenuEndLevel::InGameMenuEndLevel(Timer* pTimer) : InGameMenu()
{
    m_pTimer = pTimer;

    InitPointer(m_pInputCallbackNext);
    InitPointer(m_pInputCallbackMainMenu);
    InitPointer(m_pInputResponseNext);
    InitPointer(m_pInputResponseMainMenu);
}

//////////////////////////
//////////////////////////

InGameMenuEndLevel::~InGameMenuEndLevel()
{
    SafeDelete(m_pInputCallbackNext);
    SafeDelete(m_pInputCallbackMainMenu);
}

//////////////////////////
//////////////////////////

void InGameMenuEndLevel::Init(float width, float height)
{
    InGameMenu::Init(width, height);

    Texture* pTexHud = TextureManager::Instance().GetTexture("game/hud/hud_02");

#ifdef GEARDOME_PLATFORM_IPAD
    m_NextRO.Init(MeshManager::Instance().GetBoardMesh(0, 48, 220, 46,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_NextRO.UseColor(true);

    m_MainMenuRO.Init(MeshManager::Instance().GetBoardMesh(0, 96, 220, 46,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_MainMenuRO.UseColor(true);
#else
    m_NextRO.Init(MeshManager::Instance().GetBoardMesh(0, 24, 110, 23,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_NextRO.UseColor(true);

    m_MainMenuRO.Init(MeshManager::Instance().GetBoardMesh(0, 48, 110, 23,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_MainMenuRO.UseColor(true);
#endif

    m_Renderable.GetRenderObjectList().push_back(&m_NextRO);
    m_Renderable.GetRenderObjectList().push_back(&m_MainMenuRO);

    m_pInputCallbackNext = new InputCallback<InGameMenuEndLevel > (this, &InGameMenuEndLevel::InputNext);
    m_pInputCallbackMainMenu = new InputCallback<InGameMenuEndLevel > (this, &InGameMenuEndLevel::InputMainMenu);
}

//////////////////////////
//////////////////////////

void InGameMenuEndLevel::Update(void)
{

    if (m_bActive)
    {
        m_pTextFont->Begin();

        float centerX = IPHONE_SCREEN_HEIGHT / 2.0f;
        float centerY = IPHONE_SCREEN_WIDTH / 2.0f;

#ifdef GEARDOME_PLATFORM_IPAD
        m_NextRO.SetPosition(centerX - 110.0f - (m_fMotion * 2.0f), centerY - 22.0f - 50.0f, 1.0f);
        m_MainMenuRO.SetPosition(centerX - 110.0f + (m_fMotion * 2.0f), centerY - 22.0f + 50.0f, 1.0f);
#else
        m_NextRO.SetPosition(centerX - 55.0f - m_fMotion, centerY - 11.0f - 25.0f, 1.0f);
        m_MainMenuRO.SetPosition(centerX - 55.0f + m_fMotion, centerY - 11.0f + 25.0f, 1.0f);
#endif

        m_NextRO.SetColor(1.0f, 1.0f, 1.0f, (m_iSelection == 1) ? MAT_Min(m_fAlpha, m_fSelectionOpacity) : m_fAlpha);
        m_MainMenuRO.SetColor(1.0f, 1.0f, 1.0f, (m_iSelection == 2) ? MAT_Min(m_fAlpha, m_fSelectionOpacity) : m_fAlpha);

        m_MainMenuRO.Activate(!m_bEndOfEpisode);

        COLOR cFont = {1.0f, 1.0f, 1.0f, m_fAlpha};
        char text[100];


        if (!MenuGameState::Instance().GetCurrentSelection().customLevel)
        {
#ifdef GEARDOME_PLATFORM_IPAD
            if (m_bEndOfEpisode)
            {
                sprintf(text, "EPISODE COMPLETE\n \nSCORE: %d", SaveManager::Instance().GetScore());
                m_pTextFont->Add(text, centerX, centerY + 6.0f, 10.0f, cFont, true);
            }
            else
            {
                sprintf(text, "SCORE: %d", SaveManager::Instance().GetScore());
                m_pTextFont->Add(text, centerX, centerY + 112.0f, 10.0f, cFont, true);
            }
#else       
            if (m_bEndOfEpisode)
            {
                sprintf(text, "EPISODE COMPLETE\n \nSCORE: %d", SaveManager::Instance().GetScore());
                m_pTextFont->Add(text, centerX, centerY + 3.0f, 10.0f, cFont, true);
            }
            else
            {
                sprintf(text, "SCORE: %d", SaveManager::Instance().GetScore());
                m_pTextFont->Add(text, centerX, centerY + 56.0f, 10.0f, cFont, true);
            }       
#endif
        }
        switch (m_iSelection)
        {
            case 1:
            {
                if (m_pSelectionInterpolator->IsFinished())
                {
                    m_iSelection = -1;

                    if (IsValidPointer(m_pInputResponseNext))
                    {
                        stInputCallbackParameter parameter;
                        parameter.type = PRESS_START;
                        m_pInputResponseNext->Execute(parameter, 0);
                    }
                }
                break;
            }
            case 2:
            {
                if (m_pSelectionInterpolator->IsFinished())
                {
                    m_iSelection = -1;

                    if (IsValidPointer(m_pInputResponseMainMenu))
                    {
                        stInputCallbackParameter parameter;
                        parameter.type = PRESS_START;
                        m_pInputResponseMainMenu->Execute(parameter, 0);
                    }
                }
                break;
            }
        }

        m_pTextFont->End();
    }
    else
    {
        m_bEndOfEpisode = false;
    }


    InGameMenu::Update();
}

//////////////////////////
//////////////////////////

void InGameMenuEndLevel::Show(void)
{
    InGameMenu::Show();

    float centerX = IPHONE_SCREEN_HEIGHT / 2.0f;
    float centerY = IPHONE_SCREEN_WIDTH / 2.0f;

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(centerX - 150.0f, centerY - 38.0f - 50.0f, 300.0f, 76.0f, m_pInputCallbackNext);

    if (!m_bEndOfEpisode)
    {
        InputManager::Instance().AddRectRegionEvent(centerX - 150.0f, centerY - 38.0f + 50.0f, 300.0f, 76.0f, m_pInputCallbackMainMenu);
    }
#else
    InputManager::Instance().AddRectRegionEvent(centerX - 75.0f, centerY - 19.0f - 25.0f, 150.0f, 38.0f, m_pInputCallbackNext);

    if (!m_bEndOfEpisode)
    {
        InputManager::Instance().AddRectRegionEvent(centerX - 75.0f, centerY - 19.0f + 25.0f, 150.0f, 38.0f, m_pInputCallbackMainMenu);
    }
#endif
}

//////////////////////////
//////////////////////////

void InGameMenuEndLevel::InputNext(stInputCallbackParameter parameter, int id)
{
    if (parameter.type == PRESS_START && m_iSelection == 0)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INGAME_MENU_SELECTION));

        m_pSelectionInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false, m_pTimer);

        m_iSelection = 1;
    }
}

//////////////////////////
//////////////////////////

void InGameMenuEndLevel::InputMainMenu(stInputCallbackParameter parameter, int id)
{
    if (parameter.type == PRESS_START && m_iSelection == 0 && !m_bEndOfEpisode)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INGAME_MENU_SELECTION));

        m_pSelectionInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false, m_pTimer);

        m_iSelection = 2;
    }
}
