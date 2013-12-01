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
 * File:   gamemanager.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 21:00
 */

#include <sys/sysctl.h>
#include "gamemanager.h"
#include "gamestate.h"
#include "introgamestate.h"
#include "menugamestate.h"
#include "inputmanager.h"
#include "audio.h"
#include "SaveManager.h"

//////////////////////////
//////////////////////////

GameManager::GameManager(void)
{
    Log("+++ GameManager::GameManager ...\n");

    m_pTheState = NULL;
    m_bIsClean = true;
    m_bPlayAllLevels = false;

    SaveManager::Instance().LoadFromFile();

    Log("+++ GameManager::GameManager correcto\n");
}

//////////////////////////
//////////////////////////

GameManager::~GameManager()
{
    Log("+++ GameManager::~GameManager ...\n");

    Cleanup();

    SaveManager::Instance().SaveToFile();

    Log("+++ GameManager::~GameManager destruido\n");
}

//////////////////////////
//////////////////////////

void GameManager::CheckDeviceType(void)
{
    // Query device hardware
    int mib[6] = {0};
    size_t length = sizeof ( int);
    int cpuF = 0;

    // Get cpu speed
    mib[0] = CTL_HW;
    mib[1] = HW_CPU_FREQ;
    sysctl(mib, 2, &cpuF, &length, 0, 0);

    // From querying hardware:
    // 1st gen ipod, 3G  iphone cpuF = 412000000
    // 2nd gen ipod             cpuF = 532000000
    // 3rd gen ipod, 3GS iphone cpuF = 600000000

    // 3rd gen device?
    if (cpuF >= 600000000 || cpuF <= 0)
    {
        Log("+++ GameManager::CheckDeviceType 3rd gen device %d\n", cpuF);
        m_DeviceType = DEVICE_3RD_GEN;
    }
        // 2nd gen device?
    else if (cpuF >= 532000000)
    {
        Log("+++ GameManager::CheckDeviceType 2nd gen device %d\n", cpuF);
        m_DeviceType = DEVICE_2ND_GEN;
    }
        // 1st gen
    else
    {
        Log("+++ GameManager::CheckDeviceType 1st gen device %d\n", cpuF);
        m_DeviceType = DEVICE_1ST_GEN;
    }
}

//////////////////////////
//////////////////////////

void GameManager::Init(bool isHomeRight, OzoneAppDelegate* pDelegate, UIWindow* pWindow)
{
    Log("+++ GameManager::Init ...\n");

    m_pDelegate = pDelegate;
    m_pWindow = pWindow;

    m_bIsHomeRight = isHomeRight;
    m_bIsClean = false;
    m_bWantsToChangeState = false;

    m_dBeginTime = 0.0;

    MAT_RandomInit();

    CheckDeviceType();

    BOOL isDir;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    if ([paths count] == 1) {

        NSFileManager *fileManager = [[NSFileManager alloc] init];

        NSString *levelPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"levels"];

        if (!([fileManager fileExistsAtPath:levelPath isDirectory:&isDir] && isDir))
        {
           [fileManager createDirectoryAtPath:levelPath withIntermediateDirectories:YES attributes:nil error:nil];
        }

        [fileManager release];
    }


    Audio::Instance().LoadEffect(kSOUND_YELLOW_GEM_1, "game/sounds/s_gema_amarilla_1");
    Audio::Instance().LoadEffect(kSOUND_YELLOW_GEM_2, "game/sounds/s_gema_amarilla_2");
    Audio::Instance().LoadLoopingEffect(kSOUND_PLAYER_AIR, "game/sounds/s_aire_player_loop");
    Audio::Instance().LoadLoopingEffect(kSOUND_PLAYER_DEFLATE, "game/sounds/s_desinflando_loop");
    Audio::Instance().LoadEffect(kSOUND_COLLECT_KEY, "game/sounds/s_coger_llave");
    Audio::Instance().LoadEffect(kSOUND_CLOSED_DOOR, "game/sounds/s_chocar_puerta_cerrada");
    Audio::Instance().LoadEffect(kSOUND_COLLECT_ITEM, "game/sounds/s_coger_item");
    Audio::Instance().LoadEffect(kSOUND_LEVEL_END, "game/sounds/s_fin_nivel");
    Audio::Instance().LoadLoopingEffect(kSOUND_CONVEYOR_BELT, "game/sounds/s_cinta_transportadora_loop");
    Audio::Instance().LoadLoopingEffect(kSOUND_AIR_PUMP, "game/sounds/s_inflador_loop");
    Audio::Instance().LoadEffect(kSOUND_LANCES, "game/sounds/s_movimiento_pinchos");
    Audio::Instance().LoadEffect(kSOUND_BLADES, "game/sounds/s_movimiento_cuchillas");
    Audio::Instance().LoadEffect(kSOUND_CUBE_BREAK, "game/sounds/s_romper_cubos");
    Audio::Instance().LoadEffect(kSOUND_PLAYER_DEAD, "game/sounds/s_explosion_player_muere");
    Audio::Instance().LoadEffect(kSOUND_NPC_DEAD, "game/sounds/s_explosion_npc_muere");
    Audio::Instance().LoadEffect(kSOUND_NORMAL_WEAPON, "game/sounds/s_disparo_normal");
    Audio::Instance().LoadEffect(kSOUND_NUCLEAR_WEAPON, "game/sounds/s_disparo_nuclear");
    Audio::Instance().LoadEffect(kSOUND_PLAYER_HURT, "game/sounds/s_impacto_enemigo");
    Audio::Instance().LoadLoopingEffect(kSOUND_ELECTRICITY, "game/sounds/s_electricidad_loop");
    Audio::Instance().LoadLoopingEffect(kSOUND_ELECTRICITY_PLAYER, "game/sounds/s_electricidad_loop");
    Audio::Instance().LoadEffect(kSOUND_BOUNCE_HIT, "game/sounds/s_toque_con_piedra");
    Audio::Instance().LoadEffect(kSOUND_METALIC_HIT, "game/sounds/s_toque_bola_metalica");
    Audio::Instance().LoadEffect(kSOUND_OPEN_INGAME_MENU, "game/sounds/s_abrir_menu_ingame");
    Audio::Instance().LoadEffect(kSOUND_INGAME_MENU_SELECTION, "game/sounds/s_seleccion_menu_ingame");
    Audio::Instance().LoadEffect(kSOUND_INLINE_THROWING, "game/sounds/s_disparo_cervatana");
    Audio::Instance().LoadEffect(kSOUND_SEARCH_THROWING, "game/sounds/s_disparo_cervatana_dirigida");
    Audio::Instance().LoadEffect(kSOUND_SEARCH_ENEMY_ACTIVATE, "game/sounds/s_enemigo_que_busca_se_activa");
    Audio::Instance().LoadEffect(kSOUND_TELEPORT, "game/sounds/s_teleport");
    Audio::Instance().LoadEffect(kSOUND_METALIC_BOUNCE, "game/sounds/s_toque_bola_metalica");
#ifndef OZONE_LITE
    Audio::Instance().LoadEffect(kSOUND_BOSS_STATE, "game/sounds/s_enemigo_estado");
#endif

    Audio::Instance().LoadEffect(kSOUND_MENU_SELECTION, "menu/sounds/s_seleccionar_menu");
    Audio::Instance().LoadEffect(kSOUND_MENU_BACK, "menu/sounds/s_volver");
    Audio::Instance().LoadEffect(kSOUND_MENU_EPISODE_UNLOCK, "menu/sounds/s_episodio_desbloqueado");

    Audio::Instance().SetMusic(kMUSIC_MENU, AudioManager::Instance().LoadMusic("menu/sounds/music_s"));
    AudioManager::Instance().SetMusicLoops(Audio::Instance().GetMusic(kMUSIC_MENU), 9999);
    AudioManager::Instance().PlayMusic(Audio::Instance().GetMusic(kMUSIC_MENU));
    Audio::Instance().SetCurrentMusic(Audio::Instance().GetMusic(kMUSIC_MENU));

    Renderer::Instance().EnableClearColor(true);
    COLOR clear = {1.0f, 1.0f, 1.0f, 1.0f};
    Renderer::Instance().SetClearColor(clear);

    InputManager::Instance().SetRotated90(true);

    ChangeState(&IntroGameState::Instance());

    Log("+++ GameManager::Init correcto\n");
}

//////////////////////////
//////////////////////////

void GameManager::Cleanup(void)
{
    if (!m_bIsClean)
    {
        Log("+++ GameManager::Cleanup ...\n");

        if (IsValidPointer(m_pTheState))
        {
            m_pTheState->Cleanup();
            m_pTheState = NULL;
        }

        m_pNextState = NULL;

        m_bIsClean = true;
        m_bWantsToChangeState = false;

        Log("+++ GameManager::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void GameManager::ChangeState(GameState* state)
{
    Log("+++ GameManager::ChangeState ...\n");

    m_bWantsToChangeState = true;

    m_pNextState = state;

    Log("+++ GameManager::ChangeState correcto\n");
}

//////////////////////////
//////////////////////////

void GameManager::Update(void)
{
    Renderer::Instance().BeginRender();

    if (m_bWantsToChangeState)
    {
        m_bWantsToChangeState = false;

        if (IsValidPointer(m_pTheState))
        {
            m_pTheState->Cleanup();
        }

        m_pTheState = m_pNextState;

        m_pTheState->Init();
    }

    m_pTheState->Update();

    Renderer::Instance().Render();

    double sleep = (ANIMATION_INTERVAL) - (((double) CFAbsoluteTimeGetCurrent()) - m_dBeginTime);

    if (sleep > 0.0)
    {
        [ NSThread sleepForTimeInterval : sleep];
    }

    m_dBeginTime = (double) CFAbsoluteTimeGetCurrent();

    Renderer::Instance().EndRender();
}

