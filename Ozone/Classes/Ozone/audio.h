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
 * File:   audio.h
 * Author: nacho
 *
 * Created on 9 de noviembre de 2009, 1:04
 */

#ifndef _AUDIO_H
#define	_AUDIO_H

#include "singleton.h"
#include "audiomanager.h"

#define MAX_CUBE_SOUNDS 30

enum eMUSICS
{

    kMUSIC_MENU = 0,
    kMAX_MUSICS
};

enum eSOUNDS
{

    kSOUND_YELLOW_GEM_1 = 0,
    kSOUND_YELLOW_GEM_2,
    kSOUND_PLAYER_AIR,
    kSOUND_PLAYER_DEFLATE,
    kSOUND_COLLECT_KEY,
    kSOUND_CLOSED_DOOR,
    kSOUND_COLLECT_ITEM,
    kSOUND_LEVEL_END,
    kSOUND_CONVEYOR_BELT,
    kSOUND_AIR_PUMP,
    kSOUND_LANCES,
    kSOUND_BLADES,
    kSOUND_CUBE_BREAK,
    kSOUND_PLAYER_DEAD,
    kSOUND_NPC_DEAD,
    kSOUND_NORMAL_WEAPON,
    kSOUND_NUCLEAR_WEAPON,
    kSOUND_PLAYER_HURT,
    kSOUND_ELECTRICITY,
    kSOUND_ELECTRICITY_PLAYER,
    kSOUND_BOUNCE_HIT,
    kSOUND_METALIC_HIT,
    kSOUND_OPEN_INGAME_MENU,
    kSOUND_INGAME_MENU_SELECTION,
    kSOUND_INLINE_THROWING,
    kSOUND_SEARCH_THROWING,
    kSOUND_SEARCH_ENEMY_ACTIVATE,
    kSOUND_TELEPORT,
    kSOUND_METALIC_BOUNCE,
    kSOUND_BOSS_STATE,

    kSOUND_MENU_SELECTION,
    kSOUND_MENU_BACK,
    kSOUND_MENU_EPISODE_UNLOCK,

    kMAX_SOUNDS
};

class Audio : public Singleton<Audio>
{

    ////friend class Singleton<Audio>;

private:

    int m_iCurrentCubeSound;
    bool m_bNeedCleanup;

    char m_szCurrentEpisode[200];

    MUSIC m_Musics[kMAX_MUSICS];
    EFFECT m_Sounds[kMAX_SOUNDS];

    MUSIC m_CurrentMusic;

    EFFECT m_CubeSounds[MAX_CUBE_SOUNDS];

    
public:

    Audio(void)
    {
        Log("+++ Audio::Audio ...\n");

        m_bNeedCleanup = false;
        m_iCurrentCubeSound = 0;

        Log("+++ Audio::Audio correcto\n");
    };

    ~Audio()
    {
        Log("+++ Audio::~Audio ...\n");

        UnloadCubeSounds();

        Log("+++ Audio::~Audio destruido\n");
    };

    MUSIC GetCurrentMusic(void)
    {
        return m_CurrentMusic;
    };

    void SetCurrentMusic(MUSIC music)
    {
        m_CurrentMusic = music;
    };

    EFFECT GetEffect(eSOUNDS sound)
    {
        return m_Sounds[sound];
    };

    void LoadEffect(eSOUNDS sound, const char* szPath)
    {
        m_Sounds[sound] = AudioManager::Instance().LoadEffect(szPath);
    };

    void LoadLoopingEffect(eSOUNDS sound, const char* szPath)
    {
        m_Sounds[sound] = AudioManager::Instance().LoadLoopingEffect(szPath);
    };

    void SetEffect(eSOUNDS sound, EFFECT var)
    {
        m_Sounds[sound] = var;
    };

    MUSIC GetMusic(eMUSICS music)
    {
        return m_Musics[music];
    };

    void SetMusic(eMUSICS music, MUSIC var)
    {
        m_Musics[music] = var;
    };

    void ResetCurrentCubeSound(void)
    {
        m_iCurrentCubeSound = 0;
    };

    void LoadCubeSounds(const char* szPath)
    {
        Log("+++ Audio::LoadCubeSounds %s ...\n", szPath);

        if (strcmp(szPath, m_szCurrentEpisode) != 0)
        {
            UnloadCubeSounds();

            strcpy(m_szCurrentEpisode, szPath);

            for (int i = 0; i < MAX_CUBE_SOUNDS; i++)
            {
                char szFinalPath[200];

                sprintf(szFinalPath, "%s/sounds/nivel_toque%i", szPath, i + 1);

                m_CubeSounds[i] = AudioManager::Instance().LoadEffect(szFinalPath);
            }

            m_bNeedCleanup = true;
        }

        Log("+++ Audio::LoadCubeSounds %s correcto\n", szPath);

    };

    void PlayNextCubeSound(Vec3 pos)
    {
        AudioManager::Instance().PlayEffect(m_CubeSounds[m_iCurrentCubeSound], pos);

        m_iCurrentCubeSound++;

        m_iCurrentCubeSound %= MAX_CUBE_SOUNDS;
    };

    void UnloadCubeSounds(void)
    {
        Log("+++ Audio::UnloadCubeSounds ...\n");

        if (m_bNeedCleanup)
        {
            for (int i = 0; i < MAX_CUBE_SOUNDS; i++)
            {
                AudioManager::Instance().UnloadEffect(m_CubeSounds[i]);
            }

            m_bNeedCleanup = false;
        }

        Log("+++ Audio::UnloadCubeSounds correcto\n");
    };
};

#endif	/* _AUDIO_H */

