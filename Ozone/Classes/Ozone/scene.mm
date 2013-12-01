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
 * File:   scene.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 21:00
 */

#include "player.h"
#include "scene.h"
#include "meshmanager.h"
#include "renderer.h"
#include "parsermanager.h"
#include "npcfactory.h"
#include "particlemanager.h"
#include "backgrounds.h"
#include "hud.h"
#include "gamemanager.h"
#include "menugamestate.h"
#include "levelgamestate.h"

//////////////////////////
//////////////////////////

Scene::Scene(Timer* pTimer, Timer* pMenuTimer)
{
    Log("+++ Scene::Scene ...\n");

    m_pGameTimer = pTimer;
    m_pMenuTimer = pMenuTimer;

    InitPointer(m_pInGameMenuMain);
    InitPointer(m_pInGameMenuDie);
    InitPointer(m_pInGameMenuEndLevel);
    InitPointer(m_pInGameMenuText);

    InitPointer(m_pPlayer);

    InitPointer(m_pCamera3D);
    InitPointer(m_pCamera2D);

    InitPointer(m_pInputCallbackBrake);
    InitPointer(m_pInputCallbackController);
    InitPointer(m_pInputCallbackFire);
    InitPointer(m_pInputCallbackNuclear);
    InitPointer(m_pInputCallbackDeflate);
    InitPointer(m_pInputCallbackMenu);

    InitPointer(m_pInputCallbackMenuInGameContinue);
    InitPointer(m_pInputCallbackMenuInGameMainMenu);
    InitPointer(m_pInputCallbackMenuInGameReset);
    InitPointer(m_pInputCallbackMenuInGameNextLevel);

    InitPointer(m_pPhysicsTickCallback);

    InitPointer(m_pTextFont);
    InitPointer(m_pTextFontSmall);

    InitPointer(m_pHud);

    InitPointer(m_pBackgrounds);

    InitPointer(m_pCameraFovInterpolator);

    m_bNeedCleanup = false;

    m_bIsFinalBoss = false;
    m_bIsCustomLevel = false;

    m_iBackground = 0;

    Log("+++ Scene::Scene correcto\n");
}

//////////////////////////
//////////////////////////

Scene::~Scene()
{
    Log("+++ Scene::~Scene ...\n");

    Cleanup();

    Log("+++ Scene::~Scene destruido\n");
}

//////////////////////////
//////////////////////////

void Scene::Init(void)
{
    m_bIsReadyToFinish = false;
    m_bIsReadyToReset = false;

    m_veclogControl = Vec3(0, 0, 0);

    m_iSectorCountX = 0;
    m_iSectorCountY = 0;
    m_iCurrentTutorialPopUp = 0;
    m_iGemCount = 0;

    m_iDynamicCountID = 0;

    m_iBackground = 0;
    m_bLevelCompleted = false;
    m_bIsCustomLevel = false;

    m_bIsFinalBoss = false;

    m_fLastTimeDeflateUpdated = 0.0f;

    m_pPhysicsTickCallback = new PhysicsCallback<Scene > (this, &Scene::PhysicsTickCallback);

    PhysicsManager::Instance().Init(1024, 2048, 2048, btVector3(-10, -10, -10), btVector3(1000, 1000, 1000));
    PhysicsManager::Instance().GetDynamicsWorld()->setGravity(btVector3(0, 0, 0));
    PhysicsManager::Instance().SetPhysicsCallback(m_pPhysicsTickCallback);

    ParticleManager::Instance().InitParticleArray(PARTICLE_INLINE_THROWING_ENEMY, 20, m_iDynamicCountID);
    ParticleManager::Instance().InitParticleArray(PARTICLE_SEARCH_THROWING_ENEMY, 60, m_iDynamicCountID);
    ParticleManager::Instance().InitParticleArray(PARTICLE_SPITTING_ENEMY, 30, m_iDynamicCountID);
    ParticleManager::Instance().InitParticleArray(PARTICLE_PLAYER_RED, 20, m_iDynamicCountID);
    ParticleManager::Instance().InitParticleArray(PARTICLE_SMOKE, 20, m_iDynamicCountID);
    ParticleManager::Instance().InitParticleArray(PARTICLE_GAS, 50, m_iDynamicCountID);
    ParticleManager::Instance().InitParticleArray(PARTICLE_ENEMY, 130, m_iDynamicCountID);
    ParticleManager::Instance().InitParticleArray(PARTICLE_ITEM, 16, m_iDynamicCountID);
    ParticleManager::Instance().InitParticleArray(PARTICLE_BOSS_SPACE, 15, m_iDynamicCountID);

    m_pPlayer = new Player();

    NPC::SetPlayer(m_pPlayer);
    NPC::SetScene(this);

    m_pCamera3D = new Camera();
    m_pCamera2D = new Camera();

    m_pCamera2D->SetMode(false);

    m_pCamera3D->SetTargeting(false);
    m_pCamera3D->SetFov(65.0f);
    m_pCamera3D->SetFarPlane(1500.0f);
    m_pCamera3D->SetNearPlane(100.0f);
    m_pCamera3D->SetMode(true);

    m_pCamera3D->SetPosition(0.0f, 640.0f, 0.0f);
    m_pCamera3D->SetPitch(MAT_ToRadians(90.0f));

    Renderer::Instance().SetCamera(m_pCamera3D, true);
    Renderer::Instance().SetCamera(m_pCamera2D, false);

    m_pInputCallbackBrake = new InputCallback<Scene > (this, &Scene::InputBrake);
    m_pInputCallbackDeflate = new InputCallback<Scene > (this, &Scene::InputDeflate);
    m_pInputCallbackFire = new InputCallback<Scene > (this, &Scene::InputFire);
    m_pInputCallbackNuclear = new InputCallback<Scene > (this, &Scene::InputNuclear);
    m_pInputCallbackController = new InputCallback<Scene > (this, &Scene::InputController);
    m_pInputCallbackMenu = new InputCallback<Scene > (this, &Scene::InputMenu);

    m_pInputCallbackMenuInGameContinue = new InputCallback<Scene > (this, &Scene::InputMenuInGameContinue);
    m_pInputCallbackMenuInGameMainMenu = new InputCallback<Scene > (this, &Scene::InputMenuInGameMainMenu);
    m_pInputCallbackMenuInGameReset = new InputCallback<Scene > (this, &Scene::InputMenuInGameReset);
    m_pInputCallbackMenuInGameNextLevel = new InputCallback<Scene > (this, &Scene::InputMenuInGameNextLevel);

    AddInputRegions();

    for (int i = 0; i < MAX_INPUT_BUTTON; i++)
    {
        m_bInputButtonsState[i] = false;
    }

    m_pBackgrounds = new Backgrounds();

    m_pHud = new Hud();
    m_pHud->Init(m_pPlayer);

    m_pTextFont = new TextFont();
    m_pTextFont->Init("game/fonts/game_01_font", "game/fonts/game_01_font", 500);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFontSmall = new TextFont();
    m_pTextFontSmall->Init("game/fonts/game_02_font", "game/fonts/game_02_font", 500);
#endif

    AudioManager::Instance().SetReferenceDistance(400.0f);
    AudioManager::Instance().SetMaxDistance(600.0f);

    m_pInGameMenuMain = new InGameMenuMain(m_pMenuTimer);
#ifdef GEARDOME_PLATFORM_IPAD
    m_pInGameMenuMain->Init(400.0f, 340.0f);
#else
    m_pInGameMenuMain->Init(150.0f, 130.0f);
#endif
    m_pInGameMenuMain->SetCallbackContinue(m_pInputCallbackMenuInGameContinue);
    m_pInGameMenuMain->SetCallbackMainMenu(m_pInputCallbackMenuInGameMainMenu);
    m_pInGameMenuMain->SetCallbackRestart(m_pInputCallbackMenuInGameReset);

    m_pInGameMenuDie = new InGameMenuDie(m_pMenuTimer);
#ifdef GEARDOME_PLATFORM_IPAD
    m_pInGameMenuDie->Init(360.0f, 260.0f);
#else
    m_pInGameMenuDie->Init(130.0f, 90.0f);
#endif
    m_pInGameMenuDie->SetCallbackMainMenu(m_pInputCallbackMenuInGameMainMenu);
    m_pInGameMenuDie->SetCallbackRestart(m_pInputCallbackMenuInGameReset);

    m_pInGameMenuEndLevel = new InGameMenuEndLevel(m_pMenuTimer);
#ifdef GEARDOME_PLATFORM_IPAD
    m_pInGameMenuEndLevel->Init(400.0f, 320.0f);
#else
    m_pInGameMenuEndLevel->Init(150.0f, 120.0f);
#endif
    m_pInGameMenuEndLevel->SetCallbackMainMenu(m_pInputCallbackMenuInGameMainMenu);
    m_pInGameMenuEndLevel->SetCallbackNext(m_pInputCallbackMenuInGameNextLevel);

    m_pInGameMenuText = new InGameMenuText(m_pMenuTimer);
#ifdef GEARDOME_PLATFORM_IPAD
    m_pInGameMenuText->Init(750.0f, 280.0f);
#else
    m_pInGameMenuText->Init(300.0f, 140.0f);
#endif
    m_pInGameMenuText->SetCallbackOK(m_pInputCallbackMenuInGameContinue);

    m_TimerCamera.Reset();
    m_TimerCamera.Stop();

    m_fCameraFov = 65.0f;
    m_CameraMovingFov = FOV_IDLE_OUT;
    m_pCameraFovInterpolator = new SinusoidalInterpolator(&m_fCameraFov, 54.0f, 65.0f, 15.0f, true, 15.0f);

    m_PlayTimer.Start();

}

//////////////////////////
//////////////////////////

void Scene::Reset(void)
{
    m_bIsReadyToReset = false;
    m_iCurrentTutorialPopUp = 0;
    m_bLevelCompleted = false;

    m_fCameraFov = 65.0f;
    m_CameraMovingFov = FOV_IDLE_OUT;

    if (m_pCameraFovInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pCameraFovInterpolator);
        m_pCameraFovInterpolator->Reset();
    }

    m_pHud->Reset();

    m_pPlayer->Reset();

    m_pCamera3D->SetPosition(m_pPlayer->GetPositionX(), 640.0f, m_pPlayer->GetPositionZ());
    m_pCamera3D->AddNoise(0.0f, m_pGameTimer);

    ParticleManager::Instance().ClearAll();

    for (int layer = 0; layer < 3; layer++)
    {
        TNPCVector::size_type staticCount = m_StaticNPCVector[layer].size();

        for (TNPCVector::size_type i = 0; i < staticCount; i++)
        {
            m_StaticNPCVector[layer][i]->Reset();
        }

        TNPCVector::size_type dynamicCount = m_DynamicNPCVector[layer].size();

        for (TNPCVector::size_type i = 0; i < dynamicCount; i++)
        {
            m_DynamicNPCVector[layer][i]->Reset();
        }
    }

    InputManager::Instance().ClearRegionEvents();
    AddInputRegions();

    m_pInGameMenuMain->Disable();
    m_pInGameMenuDie->Disable();
    m_pInGameMenuEndLevel->Disable();

    m_TimerCamera.Reset();

    m_PlayTimer.Start();

    m_pGameTimer->Continue();
}

//////////////////////////
//////////////////////////

void Scene::AddInputRegions(void)
{
#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddCircleRegionEvent(IPHONE_SCREEN_HEIGHT - 44.0f, IPHONE_SCREEN_WIDTH - 350.0f, 36.0f, m_pInputCallbackBrake);
    InputManager::Instance().AddCircleRegionEvent(20.0f + 62.0f, (IPHONE_SCREEN_WIDTH - 344.0f), 75.0f, m_pInputCallbackController, 0, true);
    InputManager::Instance().AddCircleRegionEvent(IPHONE_SCREEN_HEIGHT - 116.0f, IPHONE_SCREEN_WIDTH - 301.0f, 36.0f, m_pInputCallbackFire);
    InputManager::Instance().AddCircleRegionEvent(IPHONE_SCREEN_HEIGHT - 126.0f, IPHONE_SCREEN_WIDTH - 390.0f, 36.0f, m_pInputCallbackNuclear);
    InputManager::Instance().AddCircleRegionEvent(IPHONE_SCREEN_HEIGHT - 44.0f, IPHONE_SCREEN_WIDTH - 439.0f, 36.0f, m_pInputCallbackDeflate);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 115.0f, 0.0f, 115.0f, 70.0f, m_pInputCallbackMenu);
#else
    InputManager::Instance().AddCircleRegionEvent(IPHONE_SCREEN_HEIGHT - 39.0f, IPHONE_SCREEN_WIDTH - 43.0f, 36.0f, m_pInputCallbackBrake);
    InputManager::Instance().AddCircleRegionEvent(5.0f + 62.0f, (IPHONE_SCREEN_WIDTH - 67.0f), 75.0f, m_pInputCallbackController, 0, true);
    InputManager::Instance().AddCircleRegionEvent(IPHONE_SCREEN_HEIGHT - 112.0f, IPHONE_SCREEN_WIDTH - 30.0f, 30.0f, m_pInputCallbackFire);
    InputManager::Instance().AddCircleRegionEvent(IPHONE_SCREEN_HEIGHT - 88.0f, IPHONE_SCREEN_WIDTH - 87.0f, 30.0f, m_pInputCallbackNuclear);
    InputManager::Instance().AddCircleRegionEvent(IPHONE_SCREEN_HEIGHT - 32.0f, IPHONE_SCREEN_WIDTH - 112.0f, 30.0f, m_pInputCallbackDeflate);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 60.0f, 0.0f, 60.0f, 60.0f, m_pInputCallbackMenu);
#endif
}

//////////////////////////
//////////////////////////

void Scene::UpdateTutorialPopUps(void)
{
    stCurrentEpisodeAndLevel state = MenuGameState::Instance().GetCurrentSelection();

    ///--- tutorial
    if (state.episode == 0)
    {
        if (!m_bLevelCompleted && !m_pPlayer->IsDead() && !m_pInGameMenuText->IsActive())
        {
            bool showMenu = false;
            int showText = 0;

            switch (state.level)
            {
                case 0:
                {
                    switch (m_iCurrentTutorialPopUp)
                    {
                            ///--- welcome
                        case 0:
                        {
                            if (LevelGameState::Instance().IsFaderFinished())
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(280.0f);
#else
                                m_pInGameMenuText->SetHeight(130.0f);
#endif
                                showMenu = true;
                                showText = 0;
                            }
                            break;
                        }
                            ///--- move
                        case 1:
                        {
                            if (PlayerDistanceTo(Vec3(790.0f, 0.0f, 2810.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(320.0f);
#else
                                m_pInGameMenuText->SetHeight(150.0f);
#endif
                                showMenu = true;
                                showText = 1;
                            }
                            break;
                        }
                            ///--- bounce
                        case 2:
                        {
                            if (PlayerDistanceTo(Vec3(700.0f, 0.0f, 2150.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(220.0f);
#else
                                m_pInGameMenuText->SetHeight(100.0f);
#endif
                                showMenu = true;
                                showText = 14;
                            }
                            break;
                        }
                            ///--- deflate
                        case 3:
                        {
                            if (PlayerDistanceTo(Vec3(420.0f, 0.0f, 1520.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(220.0f);
#else
                                m_pInGameMenuText->SetHeight(100.0f);
#endif
                                showMenu = true;
                                showText = 2;
                            }
                            break;
                        }
                            ///--- air
                        case 4:
                        {
                            if (PlayerDistanceTo(Vec3(420.0f, 0.0f, 1070.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(300.0f);
#else
                                m_pInGameMenuText->SetHeight(140.0f);
#endif
                                showMenu = true;
                                showText = 3;
                            }
                            break;
                        }
                            ///--- orbs
                        case 5:
                        {
                            if (PlayerDistanceTo(Vec3(900.0f, 0.0f, 810.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(220.0f);
#else
                                m_pInGameMenuText->SetHeight(100.0f);
#endif
                                showMenu = true;
                                showText = 4;
                            }
                            break;
                        }
                            ///--- exit
                        case 6:
                        {
                            if (PlayerDistanceTo(Vec3(2880.0f, 0.0f, 880.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(200.0f);
#else
                                m_pInGameMenuText->SetHeight(90.0f);
#endif
                                showMenu = true;
                                showText = 5;
                            }
                            break;
                        }
                    }
                    break;
                }
                case 1:
                {
                    switch (m_iCurrentTutorialPopUp)
                    {
                            ///--- door
                        case 0:
                        {
                            if (PlayerDistanceTo(Vec3(1140.0f, 0.0f, 400.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(220.0f);
#else
                                m_pInGameMenuText->SetHeight(100.0f);
#endif
                                showMenu = true;
                                showText = 6;
                            }
                            break;
                        }
                            ///--- teleport
                        case 1:
                        {
                            if (PlayerDistanceTo(Vec3(3460.0f, 0.0f, 910.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(140.0f);
#else
                                m_pInGameMenuText->SetHeight(60.0f);
#endif
                                showMenu = true;
                                showText = 7;
                            }
                            break;
                        }
                    }
                    break;
                }
                case 2:
                {
                    switch (m_iCurrentTutorialPopUp)
                    {
                            ///--- enemies
                        case 0:
                        {
                            if (PlayerDistanceTo(Vec3(1500.0f, 0.0f, 840.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(220.0f);
#else
                                m_pInGameMenuText->SetHeight(100.0f);
#endif
                                showMenu = true;
                                showText = 8;
                            }
                            break;
                        }
                            ///--- plasma
                        case 1:
                        {
                            if (PlayerDistanceTo(Vec3(3870.0f, 0.0f, 840.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(300.0f);
#else
                                m_pInGameMenuText->SetHeight(140.0f);
#endif
                                showMenu = true;
                                showText = 9;
                            }
                            break;
                        }
                            ///--- lighting
                        case 2:
                        {
                            if (PlayerDistanceTo(Vec3(4140.0f, 0.0f, 2270.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(220.0f);
#else
                                m_pInGameMenuText->SetHeight(100.0f);
#endif
                                showMenu = true;
                                showText = 10;
                            }
                            break;
                        }
                            ///--- nuke
                        case 3:
                        {
                            if (PlayerDistanceTo(Vec3(1600.0f, 0.0f, 2170.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(300.0f);
#else
                                m_pInGameMenuText->SetHeight(140.0f);
#endif
                                showMenu = true;
                                showText = 11;
                            }
                            break;
                        }
                    }
                    break;
                }
                case 3:
                {
                    switch (m_iCurrentTutorialPopUp)
                    {
                            ///--- strength
                        case 0:
                        {
                            if (PlayerDistanceTo(Vec3(940.0f, 0.0f, 400.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(260.0f);
#else
                                m_pInGameMenuText->SetHeight(120.0f);
#endif
                                showMenu = true;
                                showText = 12;
                            }
                            break;
                        }
                    }
                    break;
                }
                case 4:
                {
                    switch (m_iCurrentTutorialPopUp)
                    {
                            ///--- air
                        case 0:
                        {
                            if (PlayerDistanceTo(Vec3(960.0f, 0.0f, 400.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(240.0f);
#else
                                m_pInGameMenuText->SetHeight(110.0f);
#endif
                                showMenu = true;
                                showText = 13;
                            }
                            break;
                        }/*
                            ///--- bounce
                        case 1:
                        {
                            if (PlayerDistanceTo(Vec3(460.0f, 0.0f, 400.0f)) < 320.0f)
                            {
                                m_pInGameMenuText->SetHeight(100.0f);
                                showMenu = true;
                                showText = 14;
                            }
                            break;
                        }*/

                    }
                    break;
                }
                case 5:
                {
                    switch (m_iCurrentTutorialPopUp)
                    {
                            ///--- ready
                        case 0:
                        {
                            if (PlayerDistanceTo(Vec3(730.0f, 0.0f, 810.0f)) < 320.0f)
                            {
#ifdef GEARDOME_PLATFORM_IPAD
                                m_pInGameMenuText->SetHeight(220.0f);
#else
                                m_pInGameMenuText->SetHeight(100.0f);
#endif
                                showMenu = true;
                                showText = 15;
                            }
                            break;
                        }
                    }
                    break;
                }
            }

            if (showMenu)
            {
                InputManager::Instance().ClearRegionEvents();

                for (int i = 0; i < MAX_INPUT_BUTTON; i++)
                {
                    m_bInputButtonsState[i] = false;
                }

                m_veclogControl = Vec3(0, 0, 0);

                m_pInGameMenuText->SetCurrentTutorialPopUp(showText);
                m_pInGameMenuText->Show();

                m_iCurrentTutorialPopUp++;

                m_pGameTimer->Stop();
            }
        }
    }
}

//////////////////////////
//////////////////////////

void Scene::UpdateHud(void)
{
    COLOR cFont = {1.0f, 1.0f, 1.0f, 1.0f};

    if (!m_bLevelCompleted && m_pPlayer->IsDeadTimer() && !m_pInGameMenuDie->IsActive())
    {
        InputManager::Instance().ClearRegionEvents();

        for (int i = 0; i < MAX_INPUT_BUTTON; i++)
        {
            m_bInputButtonsState[i] = false;
        }

        m_veclogControl = Vec3(0, 0, 0);

        m_pInGameMenuDie->Show();
    }

    if (m_bLevelCompleted && (m_pPlayer->IsEndLevelTimer() || m_pPlayer->IsEndBossTimer()) && !m_pInGameMenuEndLevel->IsActive())
    {
        InputManager::Instance().ClearRegionEvents();

        for (int i = 0; i < MAX_INPUT_BUTTON; i++)
        {
            m_bInputButtonsState[i] = false;
        }

        m_veclogControl = Vec3(0, 0, 0);

        stCurrentEpisodeAndLevel state = MenuGameState::Instance().GetCurrentSelection();

        bool sendScore = false;
        if (state.episode == 0 && state.level == 5)
        {
            sendScore = true;
        }
        else if (state.episode > 0 && state.level == 11)
        {
            sendScore = true;
        }

        if (sendScore)
        {
            SaveManager::Instance().StoreForUpload();
            m_pInGameMenuEndLevel->SetEndOfEpisode();
        }

        m_pInGameMenuEndLevel->Show();
    }

    UpdateTutorialPopUps();

    m_pInGameMenuMain->Update();
    m_pInGameMenuDie->Update();
    m_pInGameMenuEndLevel->Update();
    m_pInGameMenuText->Update();

    m_pHud->Update(m_pGameTimer, m_bInputButtonsState, m_veclogControl);


    char mens[5];

    if (m_bIsFinalBoss)
    {
        float actualTime = m_pGameTimer->GetActualTime();
        int integer = (int) actualTime;
        float rem = actualTime - integer;

        if (integer % 2 == 0)
        {
            rem = 1.0f - rem;
        }

        cFont.a = rem;

#ifdef GEARDOME_PLATFORM_IPAD
        m_pTextFont->Add("BOSS", 56.0f, 23.0f, 10.0f, cFont, true);
#else
        m_pTextFont->Add("BOSS", 10.0f, 13.0f, 10.0f, cFont);
#endif
    }
    else
    {
        int gemsLeft = m_iGemCount - m_pPlayer->GetGemCounter();

        if (gemsLeft == 0)
        {
            float actualTime = m_pGameTimer->GetActualTime();
            int integer = (int) actualTime;
            float rem = actualTime - integer;

            if (integer % 2 == 0)
            {
                rem = 1.0f - rem;
            }

            cFont.a = rem;

#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFont->Add("Exit", 56.0f, 23.0f, 10.0f, cFont, true);
#else
            m_pTextFont->Add("Exit", 11.0f, 13.0f, 10.0f, cFont);
#endif
        }
        else
        {
            int digits = 1 + (int) log10(gemsLeft);

            sprintf(mens, "%d", gemsLeft);

#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFont->Add(mens, 56.0f, 23.0f, 10.0f, cFont, true);
#else
            m_pTextFont->Add(mens, 27.0f - ((10.0f * digits) / 2.0f), 13.0f, 10.0f, cFont);
#endif
        }
    }

    cFont.a = 1.0f;

    float steelAmmo = m_pPlayer->GetAmmo(STEEL_AMMO);

    if (steelAmmo > 0.0f)
    {
        int digits = 1 + (int) log10(steelAmmo);

        if (digits > 0)
        {
            sprintf(mens, "%d", (int) steelAmmo);

#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFontSmall->Add(mens, IPHONE_SCREEN_HEIGHT - 44.0f, IPHONE_SCREEN_WIDTH - 439.0f - 8.0f, 10.0f, cFont, true);
#else
            m_pTextFont->Add(mens, 450.0f - ((10.0f * digits) / 2.0f), 200.0f, 10.0f, cFont);
#endif
        }
    }

    float electricAmmo = m_pPlayer->GetAmmo(ELECTRIC_AMMO);

    if (electricAmmo > 0.0f)
    {
        int digits = 1 + (int) log10(electricAmmo);

        if (digits > 0)
        {
            sprintf(mens, "%d", (int) electricAmmo);
#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFontSmall->Add(mens, IPHONE_SCREEN_HEIGHT - 44.0f, IPHONE_SCREEN_WIDTH - 530.0f - 8.0f, 10.0f, cFont, true);
#else
            m_pTextFont->Add(mens, 450.0f - ((10.0f * digits) / 2.0f), 143.0f, 10.0f, cFont);
#endif
        }
    }

    float normalAmmo = m_pPlayer->GetAmmo(NORMAL_AMMO);

    if (normalAmmo > 0.0f)
    {
        int digits = 1 + (int) log10(normalAmmo);

        if (digits > 0)
        {
            sprintf(mens, "%d", (int) normalAmmo);
#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFontSmall->Add(mens, IPHONE_SCREEN_HEIGHT - 116.0f, IPHONE_SCREEN_WIDTH - 301.0f - 8.0f, 10.0f, cFont, true);
#else
            m_pTextFont->Add(mens, 371.0f - ((10.0f * digits) / 2.0f), 282.0f, 10.0f, cFont);
#endif
        }
    }

    float nuclearAmmo = m_pPlayer->GetAmmo(NUCLEAR_AMMO);

    if (nuclearAmmo > 0.0f)
    {
        int digits = 1 + (int) log10(nuclearAmmo);

        if (digits > 0)
        {
            sprintf(mens, "%d", (int) nuclearAmmo);
#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFontSmall->Add(mens, IPHONE_SCREEN_HEIGHT - 126.0f, IPHONE_SCREEN_WIDTH - 390.0f - 8.0f, 10.0f, cFont, true);
#else
            m_pTextFont->Add(mens, 394.0f - ((10.0f * digits) / 2.0f), 225.0f, 10.0f, cFont);
#endif
        }
    }
}

//////////////////////////
//////////////////////////

void Scene::UpdateBackground(void)
{
    m_pBackgrounds->Update(m_pGameTimer, m_pCamera3D->GetPosition());
}

//////////////////////////
//////////////////////////

void Scene::AddNPCToProperSector(NPC* pNPC, int layer)
{
    int sectorX = ((int) pNPC->GetPositionX()) / SECTOR_WIDTH;
    int sectorY = ((int) pNPC->GetPositionZ()) / SECTOR_HEIGHT;

    if (sectorX >= 0 && sectorX < m_iSectorCountX && sectorY >= 0 && sectorY < m_iSectorCountY)
    {
        int sector = (sectorY * m_iSectorCountX) + sectorX;

        m_SectorVector[layer][sector]->GetDynamicNPCList().push_back(pNPC);
    }
}

//////////////////////////
//////////////////////////

void Scene::UpdateNPCs(void)
{
    m_pPlayer->Update(m_pGameTimer);

    for (int layer = 0; layer < 3; layer++)
    {
        TNPCVector::size_type staticCount = m_StaticNPCVector[layer].size();

        for (TNPCVector::size_type i = 0; i < staticCount; i++)
        {
            NPC* pNPC = m_StaticNPCVector[layer][i];

            if (pNPC->IsEnable())
            {
                pNPC->Update(m_pGameTimer);
            }
        }

        TNPCVector::size_type dynamicCount = m_DynamicNPCVector[layer].size();

        for (TNPCVector::size_type i = 0; i < dynamicCount; i++)
        {
            NPC* pNPC = m_DynamicNPCVector[layer][i];

            if (pNPC->IsEnable())
            {
                pNPC->Update(m_pGameTimer);

                AddNPCToProperSector(pNPC, layer);
            }
        }
    }

    ParticleManager::Instance().Update(m_pGameTimer, this);
}

//////////////////////////
//////////////////////////

void Scene::UpdateInput(void)
{
    float inputLength = m_veclogControl.length();

    if (inputLength > 15.0f)
    {
        m_pPlayer->Thrust(m_veclogControl, m_fDeltaTime);
    }

    if (m_bInputButtonsState[INPUT_BUTTON_BRAKE])
    {
        m_pPlayer->Brake(m_fDeltaTime);
    }

    if (m_bInputButtonsState[INPUT_BUTTON_DEFLATE] && (m_pPlayer->GetAmmo(STEEL_AMMO) <= 0.0f) && !m_pPlayer->IsDead())
    {
        m_pPlayer->Deflate(PLAYER_INPUT_DEFLATE_RATE * m_fDeltaTime, true);

        float actualTime = m_pGameTimer->GetActualTime();

        if (actualTime - m_fLastTimeDeflateUpdated > 0.2f)
        {
            m_fLastTimeDeflateUpdated = actualTime;

            ParticleManager::Instance().AddExplosion(PARTICLE_GAS, m_pPlayer->GetPosition(), 0.9f, 1.1f, Vec3(0, 0, 0), 5, 0.0f);
        }
    }
}

//////////////////////////
//////////////////////////

void Scene::UpdateCamera(void)
{
    Vec3 vecBallPos = m_pPlayer->GetPosition();

    if (m_bLevelCompleted && !m_bIsFinalBoss)
    {
        vecBallPos = m_vecExitPos;
    }

    Vec3 vecCamPos = m_pCamera3D->GetPosition();

    float resx = vecBallPos.x - vecCamPos.x;
    float resz = vecBallPos.z - vecCamPos.z;

    vecCamPos.x += (resx * m_fDeltaTime * 3.0f);
    vecCamPos.z += (resz * m_fDeltaTime * 3.0f);

    m_pCamera3D->SetPosition(vecCamPos);

    AudioManager::Instance().SetListenerPosition(vecBallPos.x, 40.0f, vecBallPos.z);
    AudioManager::Instance().SetListenerOrientation(0.0f, -1.0f, 0.0f, 0.0f, 0.0f, -1.0f);

    btVector3 playerVel = m_pPlayer->GetRigidBody()->getLinearVelocity();

    switch (m_CameraMovingFov)
    {
        case FOV_IDLE_OUT:
        {
            if (m_pPlayer->IsInContactWithAirPump() || m_pPlayer->IsDead())
            {
                m_TimerCamera.Reset();
            }
            else
            {
                if ((MAT_abs(playerVel.x()) < 0.6f) && (MAT_abs(playerVel.z()) < 0.6f))
                {
                    if (m_TimerCamera.IsRunning())
                    {
                        if (m_TimerCamera.GetActualTime() > 5.0f)
                        {
                            m_pCameraFovInterpolator->Redefine(54.0f, 65.0f, 15.0f, true, 15.0f);
                            InterpolatorManager::Instance().Add(m_pCameraFovInterpolator, false, m_pGameTimer);
                            m_CameraMovingFov = FOV_GOING_IN;
                        }
                    }
                    else
                    {
                        m_TimerCamera.Start();
                    }
                }
            }

            break;
        }
        case FOV_GOING_IN:
        {
            if (!m_pCameraFovInterpolator->IsActive())
            {
                m_CameraMovingFov = FOV_IDLE_IN;
                break;
            }

            if ((MAT_abs(playerVel.x()) >= 0.6f) || (MAT_abs(playerVel.z()) >= 0.6f))
            {
                InterpolatorManager::Instance().Delete(m_pCameraFovInterpolator);
                m_pCameraFovInterpolator->Redefine(m_fCameraFov, 65.0f, 2.0f, false, 2.0f);
                InterpolatorManager::Instance().Add(m_pCameraFovInterpolator, false, m_pGameTimer);

                m_CameraMovingFov = FOV_GOING_OUT;
            }
            break;
        }
        case FOV_IDLE_IN:
        {
            if ((MAT_abs(playerVel.x()) >= 0.6f) || (MAT_abs(playerVel.z()) >= 0.6f))
            {
                m_pCameraFovInterpolator->Redefine(m_fCameraFov, 65.0f, 2.0f, false, 2.0f);
                InterpolatorManager::Instance().Add(m_pCameraFovInterpolator, false, m_pGameTimer);

                m_CameraMovingFov = FOV_GOING_OUT;
            }
            break;
        }
        case FOV_GOING_OUT:
        {
            if (!m_pCameraFovInterpolator->IsActive())
            {
                m_CameraMovingFov = FOV_IDLE_OUT;
                m_TimerCamera.Stop();
                m_TimerCamera.Reset();
            }
            break;
        }
    }

    m_pCamera3D->SetFov(m_fCameraFov);
}

//////////////////////////
//////////////////////////

void Scene::UpdateSectors(void)
{
    Vec3 camPos = m_pCamera3D->GetPosition();

    int sectorX = ((int) camPos.x) / SECTOR_WIDTH;
    int sectorY = ((int) camPos.z) / SECTOR_HEIGHT;

    int minX = MAT_Clamp((sectorX - 1), 0, m_iSectorCountX - 1);
    int maxX = MAT_Clamp((sectorX + 1), 0, m_iSectorCountX - 1);
    int minY = MAT_Clamp((sectorY - 1), 0, m_iSectorCountY - 1);
    int maxY = MAT_Clamp((sectorY + 1), 0, m_iSectorCountY - 1);

    SetupSectorsForRendering(minX, maxX, minY, maxY);
}

//////////////////////////
//////////////////////////

void Scene::SetupSectorsForRendering(int minX, int maxX, int minY, int maxY)
{
    ClearRenderBitSets();

    for (int layer = 0; layer < 3; layer++)
    {
        for (int sx = minX; sx <= maxX; sx++)
        {
            for (int sy = minY; sy <= maxY; sy++)
            {
                Vec3 camPos = m_pCamera3D->GetPosition();
                float x = (sx * SECTOR_WIDTH) + (SECTOR_WIDTH / 2.0f);
                float y = (sy * SECTOR_HEIGHT) + (SECTOR_HEIGHT / 2.0f);

#ifdef GEARDOME_PLATFORM_IPAD
                if ((x >= (camPos.x - 750.0f)) && (x <= (camPos.x + 700.0f))
                        && (y >= (camPos.z - 600.0f)) && (y <= (camPos.z + 650.0f)))
#else
                if ((x >= (camPos.x - 750.0f)) && (x <= (camPos.x + 700.0f))
                        && (y >= (camPos.z - 550.0f)) && (y <= (camPos.z + 600.0f)))
#endif          
                {
                    RenderSector(layer, (sy * m_iSectorCountX) + sx);
                }
            }
        }
    }
}

//////////////////////////
//////////////////////////

void Scene::ClearSectors(void)
{
    for (int layer = 0; layer < 3; layer++)
    {
        TSectorVector::size_type size = m_SectorVector[layer].size();

        for (TSectorVector::size_type s = 0; s < size; s++)
        {
            m_SectorVector[layer][s]->GetDynamicNPCList().clear();
        }
    }
}

//////////////////////////
//////////////////////////

void Scene::RenderSector(int layer, int sector)
{
    if (layer == 0)
    {
        Renderer::Instance().Add(m_SectorVector[layer][sector]->GetStaticLevel());
    }

    NPC** staticNPCArray = m_SectorVector[layer][sector]->GetStaticNPCArray();
    int staticArraySize = m_SectorVector[layer][sector]->GetStaticCount();

    for (int i = 0; i < staticArraySize; i++)
    {
        NPC* pNPC = staticNPCArray[i];
        int npc_id = pNPC->GetID();

        if (pNPC->IsEnable())
        {
            if (!m_StaticRenderedBitset[layer].IsSet(npc_id))
            {
                m_StaticRenderedBitset[layer].Set(npc_id);

                Vec3 npcPos = pNPC->GetPosition();

                if (CheckVisiblePosition(npcPos.x, npcPos.z))
                {
                    Renderer::Instance().Add(pNPC);
                }
            }
        }
    }

    ///--- dibujar dinamicos

    for (Sector::TSectorNPCListIterator it = m_SectorVector[layer][sector]->GetDynamicNPCList().begin();
            it != m_SectorVector[layer][sector]->GetDynamicNPCList().end(); it++)
    {
        NPC* pNPC = (*it);
        int npc_id = pNPC->GetID();

        if (pNPC->IsEnable())
        {
            if (!m_DynamicRenderedBitset[layer].IsSet(npc_id))
            {
                m_DynamicRenderedBitset[layer].Set(npc_id);

                Vec3 npcPos = pNPC->GetPosition();

                if (CheckVisiblePosition(npcPos.x, npcPos.z))
                {
                    Renderer::Instance().Add(pNPC);
                }
            }
        }
    }
}

//////////////////////////
//////////////////////////

void Scene::UpdatePhysics(void)
{
    ConveyorBeltPlace::ClearContactingWithPlayer();
    AirPumpPlace::ClearContactingWithPlayer();

    m_CollisionPairCacheList.clear();

    PhysicsManager::Instance().Update(m_fDeltaTime);

    for (TCollisionPairListIterator it = m_CollisionPairCacheList.begin();
            it != m_CollisionPairCacheList.end(); it++)
    {
        CollisionInfo* obj1 = (*it).pObj1;
        CollisionInfo* obj2 = (*it).pObj2;
        float impulse = (*it).impulse;

        if (obj1->GetType() == COL_OBJ_PLAYER && obj2->GetType() == COL_OBJ_NPC)
        {
            ((NPC*) obj2->GetPointer())->ContactWithPlayer((Player*) obj1->GetPointer(), impulse, m_pGameTimer);
            //Log("------- Scene::PhysicsTickCallback ******** player with npc rigid 1 **********\n");
            continue;
        }

        if (obj1->GetType() == COL_OBJ_NPC && obj2->GetType() == COL_OBJ_PLAYER)
        {
            ((NPC*) obj1->GetPointer())->ContactWithPlayer((Player*) obj2->GetPointer(), impulse, m_pGameTimer);
            //Log("------- Scene::PhysicsTickCallback ******** player with npc rigid 2 **********\n");
            continue;
        }

        if (obj1->GetType() == COL_OBJ_GHOST_PLAYER && obj2->GetType() == COL_OBJ_NPC)
        {
            ((NPC*) obj2->GetPointer())->ContactWithPlayer((Player*) obj1->GetPointer(), impulse, m_pGameTimer);
            //Log("------- Scene::PhysicsTickCallback ******** player with npc 1 **********\n");
            continue;
        }

        if (obj1->GetType() == COL_OBJ_NPC && obj2->GetType() == COL_OBJ_GHOST_PLAYER)
        {
            ((NPC*) obj1->GetPointer())->ContactWithPlayer((Player*) obj2->GetPointer(), impulse, m_pGameTimer);
            //Log("------- Scene::PhysicsTickCallback ******** player with npc 2 **********\n");
            continue;
        }

        if (obj1->GetType() == COL_OBJ_GHOST_NUKE && obj2->GetType() == COL_OBJ_NPC)
        {
            ((NPC*) obj2->GetPointer())->ContactWithPlayerNuke((Player*) obj1->GetPointer(), impulse, m_pGameTimer, obj2->GetAdditionalData());
            continue;
        }

        if (obj1->GetType() == COL_OBJ_NPC && obj2->GetType() == COL_OBJ_GHOST_NUKE)
        {
            ((NPC*) obj1->GetPointer())->ContactWithPlayerNuke((Player*) obj2->GetPointer(), impulse, m_pGameTimer, obj1->GetAdditionalData());
            continue;
        }

        if (obj1->GetType() == COL_OBJ_GHOST_ELECTRIC && obj2->GetType() == COL_OBJ_NPC)
        {
            ((Player*) obj1->GetPointer())->AddNPCToInRangeElectricList(((Enemy*) obj2->GetPointer()));
            continue;
        }

        if (obj1->GetType() == COL_OBJ_NPC && obj2->GetType() == COL_OBJ_GHOST_ELECTRIC)
        {
            ((Player*) obj2->GetPointer())->AddNPCToInRangeElectricList(((Enemy*) obj1->GetPointer()));
            continue;
        }

        if (obj1->GetType() == COL_OBJ_NPC && obj2->GetType() == COL_OBJ_NPC)
        {
            ((NPC*) obj1->GetPointer())->ContactWithNPC((NPC*) obj2->GetPointer(), impulse, m_pGameTimer, obj1->GetAdditionalData(), obj2->GetAdditionalData());
            ((NPC*) obj2->GetPointer())->ContactWithNPC((NPC*) obj1->GetPointer(), impulse, m_pGameTimer, obj2->GetAdditionalData(), obj1->GetAdditionalData());

            //Log("------- Scene::PhysicsTickCallback ******** npc with npc **********\n");
            continue;
        }
    }
}

//////////////////////////
//////////////////////////

void Scene::PhysicsTickCallback(const btDynamicsWorld *world, btScalar timeStep)
{
    const int manifold_count = PhysicsManager::Instance().GetDynamicsWorld()->getDispatcher()->getNumManifolds();

    for (int i = 0; i < manifold_count; ++i)
    {
        btPersistentManifold* contact_manifold = PhysicsManager::Instance().GetDynamicsWorld()->getDispatcher()->getManifoldByIndexInternal(i);
        const int contact_count = contact_manifold->getNumContacts();

        bool added = false;
        stCollisionPair tmpPair;
        float maxImpulse = 0.0f;

        for (int j = 0; j < contact_count; ++j)
        {
            btManifoldPoint const& pt = contact_manifold->getContactPoint(j);

            //Log("------- Scene::PhysicsTickCallback collision\n");

            btCollisionObject* obA = static_cast<btCollisionObject*> (contact_manifold->getBody0());
            btCollisionObject* obB = static_cast<btCollisionObject*> (contact_manifold->getBody1());

            if (!added && (obA && obB))
            {
                if (obA->getUserPointer() && obB->getUserPointer())
                {
                    tmpPair.pObj1 = (CollisionInfo*) obA->getUserPointer();
                    tmpPair.pObj2 = (CollisionInfo*) obB->getUserPointer();

                    added = true;
                }
            }

            if (added && (pt.getAppliedImpulse() > maxImpulse))
            {
                maxImpulse = pt.getAppliedImpulse();
            }
        }

        if (added)
        {
            tmpPair.impulse = maxImpulse;
            m_CollisionPairCacheList.insert(tmpPair);
        }
    }
}

//////////////////////////
//////////////////////////

bool Scene::CheckVisiblePosition(float x, float y)
{
    Vec3 camPos = m_pCamera3D->GetPosition();

#ifdef GEARDOME_PLATFORM_IPAD
    if ((x > (camPos.x + 650.0f)) || (x < (camPos.x - 650.0f))
            || (y > (camPos.z + 450.0f)) || (y < (camPos.z - 450.0f)))
#else
    if ((x > (camPos.x + 600.0f)) || (x < (camPos.x - 600.0f))
            || (y > (camPos.z + 450.0f)) || (y < (camPos.z - 450.0f)))
#endif
    {
        return false;
    }
    else
    {
        return true;
    }
}

//////////////////////////
//////////////////////////

void Scene::Update(void)
{
    m_fDeltaTime = m_pGameTimer->GetDeltaTime();

    m_pTextFont->Begin();

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFontSmall->Begin();
#endif

    UpdateInput();

    UpdatePhysics();

    ClearSectors();

    UpdateNPCs();

    UpdateSectors();

    UpdateBackground();

    UpdateCamera();

    UpdateHud();

    Renderer::Instance().Add(m_pPlayer);

#ifdef DEBUG_OZONE

    COLOR cFont = {1.0f, 1.0f, 1.0f, 1.0f};

    char mens[100];

    sprintf(mens, "FPS: %.2f  DC: %d  PC: %d T: %d", m_pGameTimer->GetFPS(), Renderer::Instance().GetDrawCalls() + m_pTextFont->GetRenderListCount() + 1, Renderer::Instance().GetPolyCount(), (int) floor(m_PlayTimer.GetActualTime()));
    m_pTextFont->Add(mens, 55, 14, 10, cFont);
    /*
        sprintf(mens, "MS: %.6f", m_pTimer->GetDeltaTime() * 1000.0f);
        m_pTextFont->Add(mens, 0, 30, 10, cFont);

        sprintf(mens, "CX: %.2f  CZ: %.2f", m_pCamera3D->GetPosition().x, m_pCamera3D->GetPosition().z);
        m_pTextFont->Add(mens, 0, 70, 10);
    
                sprintf(mens, "DirX: %.2f  DirY: %.2f", m_veclogControl.x, m_veclogControl.y);
                m_pTextFont->Add(mens, 0, 60, 10);
     

        sprintf(mens, "DC: %d  PC: %d", Renderer::Instance().GetDrawCalls() + m_pTextFont->GetRenderListCount() + 1, Renderer::Instance().GetPolyCount());
        m_pTextFont->Add(mens, 0, 30, 10, cFont);*/

#endif

    m_pTextFont->End();

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFontSmall->End();
#endif

    if (m_pInGameMenuDie->IsActive() || m_pInGameMenuEndLevel->IsActive() || m_pInGameMenuMain->IsActive() || m_pInGameMenuText->IsActive())
    {
        m_PlayTimer.Stop();
    }
    else
    {
        m_PlayTimer.Continue();
    }
}

//////////////////////////
//////////////////////////

void Scene::LoadLevelLayer(int layer, FILE* pFile,
        std::vector<stCUBE_CONFIG_FILE>& cubeConfigVector,
        std::vector<stDECO_CONFIG_FILE>& decoConfigVector)
{
    int staticCount;
    fread(&staticCount, sizeof (int), 1, pFile);

    Log("+++ Scene::LoadLevelLayer LAYER: %d\n", layer);

    Log("+++ Scene::LoadLevelLayer %d, Static count: %d\n", layer, staticCount);

    m_StaticRenderedBitset[layer].Init(staticCount);

    for (int i = 0; i < staticCount; i++)
    {
        u8 type;
        u8 type_id;
        short posX;
        short posY;
        u8 rotation;
        short width;
        short height;
        char script[256] = {0};
        char style[256] = {0};
        int upper;
        u8 sides;
        u8 len;

        fread(&type, sizeof (u8), 1, pFile);
        fread(&type_id, sizeof (u8), 1, pFile);
        fread(&posX, sizeof (short), 1, pFile);
        fread(&posY, sizeof (short), 1, pFile);
        fread(&rotation, sizeof (u8), 1, pFile);
        fread(&width, sizeof (short), 1, pFile);
        fread(&height, sizeof (short), 1, pFile);

        fread(&len, sizeof (u8), 1, pFile);
        fread(&script, sizeof (char), len, pFile);
        script[len] = 0;

        fread(&len, sizeof (u8), 1, pFile);
        fread(&style, sizeof (char), len, pFile);
        style[len] = 0;

        fread(&upper, sizeof (int), 1, pFile);

        NPC* tmp = NULL;

        switch (type)
        {
            case OBJ_TYPE_CUBE:
            {
                fread(&sides, sizeof (u8), 1, pFile);
                tmp = NPCFactory::Instance().GetCube(layer, type_id, posX, posY, width, height, rotation, cubeConfigVector, m_szEpisode);
                break;
            }
            case OBJ_TYPE_ITEM:
            {
                tmp = NPCFactory::Instance().GetItem(type_id, posX, posY, rotation, width, height, script);

                if (IsValidPointer(tmp))
                {
                    if (type_id == ITEM_START_PLACE_TYPE)
                    {
                        m_pPlayer->Init(tmp->GetPosition());
                        m_pCamera3D->SetPosition(m_pPlayer->GetPositionX(), 640.0f, m_pPlayer->GetPositionZ());
                    }
                    else if (type_id == ITEM_EXIT_PLACE_TYPE)
                    {
                        m_vecExitPos = tmp->GetPosition();
                    }
                }
                else
                {
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                    Log("@@@ Scene::LoadLevelLayer %d, Item incorrecto: %d %d\n", layer, type, type_id);
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                }
                break;
            }
            case OBJ_TYPE_ENEMY:
            {
                ///--- es un monstruo final
                if (type_id > 17)
                {
                    m_bIsFinalBoss = true;
                }

                tmp = NPCFactory::Instance().GetEnemy(type_id, posX, posY, rotation, width, height, script);

                if (!IsValidPointer(tmp))
                {
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                    Log("@@@ Scene::LoadLevelLayer %d, Enemy incorrecto: %d %d\n", layer, type, type_id);
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                }
                break;
            }
            case OBJ_TYPE_TRANSPORTER:
            {
                tmp = NPCFactory::Instance().GetTeleporterPlace(type_id, posX, posY, rotation, width, height, script);

                int id = rotation;

                TeleporterPlace* pTeleport = static_cast<TeleporterPlace*> (tmp);

                for (TNPCVector::size_type t = 0; t < m_StaticNPCVector[layer].size(); t++)
                {
                    TeleporterPlace* tp = dynamic_cast<TeleporterPlace*> (m_StaticNPCVector[layer][t]);

                    if (IsValidPointer(tp))
                    {
                        if (tp->GetID() == id)
                        {
                            pTeleport->SetPartner(tp);
                            tp->SetPartner(pTeleport);
                            break;
                        }
                    }
                }

                break;
            }
            case OBJ_TYPE_DECO:
            {
                tmp = NPCFactory::Instance().GetDecoration(layer, type_id, posX, posY, rotation, width, height, decoConfigVector, m_szEpisode);

                if (GameManager::Instance().DeviceType() == GameManager::DEVICE_1ST_GEN && layer == 2)
                {
                    tmp->GetMainRenderObject()->Activate(false);
                }

                break;
            }
            default:
            {
                ///--- TODO !!! arreglar esto !!!
                Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                Log("@@@ Scene::LoadLevelLayer %d, Elemento irreconocible: %d\n", layer, type);
                Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                break;
            }
        }

        tmp->SetID(i);
        m_StaticNPCVector[layer].push_back(tmp);

    }


    int dynamicCount;
    fread(&dynamicCount, sizeof (int), 1, pFile);

    Log("+++ Scene::LoadLevelLayer %d, Dynamic count: %d\n", layer, dynamicCount);

    m_DynamicRenderedBitset[layer].Init(dynamicCount + m_iDynamicCountID);

    for (int i = 0; i < dynamicCount; i++)
    {
        u8 type;
        u8 type_id;
        short posX;
        short posY;
        u8 rotation;
        short width;
        short height;
        char script[256] = {0};
        char style[256] = {0};
        int upper;
        u8 sides;
        u8 len;

        fread(&type, sizeof (u8), 1, pFile);
        fread(&type_id, sizeof (u8), 1, pFile);
        fread(&posX, sizeof (short), 1, pFile);
        fread(&posY, sizeof (short), 1, pFile);
        fread(&rotation, sizeof (u8), 1, pFile);
        fread(&width, sizeof (short), 1, pFile);
        fread(&height, sizeof (short), 1, pFile);

        fread(&len, sizeof (u8), 1, pFile);
        fread(&script, sizeof (char), len, pFile);
        script[len] = 0;

        fread(&len, sizeof (u8), 1, pFile);
        fread(&style, sizeof (char), len, pFile);
        style[len] = 0;

        fread(&upper, sizeof (int), 1, pFile);

        NPC* tmp = NULL;

        switch (type)
        {
            case OBJ_TYPE_CUBE:
            {
                fread(&sides, sizeof (u8), 1, pFile);
                tmp = NPCFactory::Instance().GetCube(layer, type_id, posX, posY, width, height, rotation, cubeConfigVector, m_szEpisode);
                break;
            }
            case OBJ_TYPE_ITEM:
            {
                tmp = NPCFactory::Instance().GetItem(type_id, posX, posY, rotation, width, height, script);

                if (IsValidPointer(tmp))
                {
                    if (type_id == ITEM_START_PLACE_TYPE)
                    {
                        m_pPlayer->Init(tmp->GetPosition());
                    }
                }
                else
                {
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                    Log("@@@ Scene::LoadLevelLayer %d, Item incorrecto: %d %d\n", layer, type, type_id);
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                }
                break;
            }
            case OBJ_TYPE_ENEMY:
            {
                ///--- es un monstruo final
                if (type_id > 17)
                {
                    m_bIsFinalBoss = true;
                }

                tmp = NPCFactory::Instance().GetEnemy(type_id, posX, posY, rotation, width, height, script);

                if (!IsValidPointer(tmp))
                {
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                    Log("@@@ Scene::LoadLevelLayer %d, Enemy incorrecto: %d %d\n", layer, type, type_id);
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                    Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                }
                break;
            }
            case OBJ_TYPE_TRANSPORTER:
            {
                tmp = NPCFactory::Instance().GetTeleporterPlace(type_id, posX, posY, rotation, width, height, script);
                break;
            }
            case OBJ_TYPE_DECO:
            {
                tmp = NPCFactory::Instance().GetDecoration(layer, type_id, posX, posY, rotation, width, height, decoConfigVector, m_szEpisode);

                if (GameManager::Instance().DeviceType() == GameManager::DEVICE_1ST_GEN && layer == 2)
                {
                    tmp->GetMainRenderObject()->Activate(false);
                }

                break;
            }
            default:
            {
                Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                Log("@@@ Scene::LoadLevelLayer %d, Elemento irreconocible: %d\n", layer, type);
                Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                Log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\n");
                break;
            }
        }

        tmp->SetStatic(false);
        tmp->SetID(m_iDynamicCountID);
        m_iDynamicCountID++;
        m_DynamicNPCVector[layer].push_back(tmp);
    }

    int sectorCount;

    fread(&m_iSectorCountX, sizeof (int), 1, pFile);
    fread(&m_iSectorCountY, sizeof (int), 1, pFile);

    sectorCount = m_iSectorCountX * m_iSectorCountY;

    Log("+++ Scene::LoadLevelLayer %d, Sectors: X %d, Y %d, Count %d\n", layer, m_iSectorCountX, m_iSectorCountY, sectorCount);

    for (int i = 0; i < sectorCount; i++)
    {
        short count;
        fread(&count, sizeof (short), 1, pFile);

        Sector* tmpSector = new Sector(count);
        NPC** staticNPCArray = tmpSector->GetStaticNPCArray();

        for (int j = 0; j < count; j++)
        {
            int index;
            fread(&index, sizeof (int), 1, pFile);

            staticNPCArray[j] = m_StaticNPCVector[layer][index];
        }

        m_SectorVector[layer].push_back(tmpSector);
    }
}

//////////////////////////
//////////////////////////

void Scene::ClearRenderBitSets(void)
{
    for (int i = 0; i < 3; i++)
    {
        m_StaticRenderedBitset[i].ResetAll();
        m_DynamicRenderedBitset[i].ResetAll();
    }
}

//////////////////////////
//////////////////////////

void Scene::LoadFromFile(char* szPath, bool isCustomLevel)
{
    Log("+++ Scene::LoadFromFile ...\n");
    
    m_bIsCustomLevel = isCustomLevel;

    FILE* pFile = NULL;

    if (isCustomLevel)
    {
        pFile = fopen(szPath, "r");
    }
    else
    {
        char* ind = strrchr(szPath, '/');
        char* nameSize = ind + 1;
        char pathSize[256] = {0};
        strncpy(pathSize, szPath, ind - szPath);
        pathSize[ind - szPath] = 0;

        NSString* OCpathSize = [NSString stringWithCString : pathSize encoding : [NSString defaultCStringEncoding]];
        NSString* OCpathName = [NSString stringWithCString : nameSize encoding : [NSString defaultCStringEncoding]];
        NSString* path = [[NSBundle mainBundle] pathForResource : OCpathName ofType : @"oil" inDirectory : OCpathSize];

        pFile = fopen([path cStringUsingEncoding : 1], "r");
    }

    if (pFile == NULL)
    {
        Log("@@@ Scene::LoadFromFile Imposible abrir el nivel: %s\n", szPath);
        return;
    }

    int pad = isCustomLevel ? 1 : 0;
    int offset;
    int gemCount;
    char episode[30];
    u8 len;

    fseek(pFile, -4 -pad, SEEK_END);
    fread(&offset, sizeof (int), 1, pFile);

    fseek(pFile, -8 -pad, SEEK_END);
    fread(&gemCount, sizeof (int), 1, pFile);

    m_iGemCount = gemCount;

    fseek(pFile, -offset -pad, SEEK_END);
    fread(&len, sizeof (u8), 1, pFile);
    fread(&episode, sizeof (char), len, pFile);
    episode[len] = 0;

    strcpy(m_szEpisode, episode);

    char szCubeConfigPath[100];
    char szDecoConfigPath[100];

    sprintf(szCubeConfigPath, "game/episodes/%s/cubes/cubes", m_szEpisode);
    sprintf(szDecoConfigPath, "game/episodes/%s/decorations/decor", m_szEpisode);

    std::vector<stCUBE_CONFIG_FILE> cubeConfigVector;
    ParserManager::Instance().GetCubeConfigData(&cubeConfigVector, szCubeConfigPath);

    std::vector<stDECO_CONFIG_FILE> decoConfigVector;
    ParserManager::Instance().GetDecoConfigData(&decoConfigVector, szDecoConfigPath);


    fseek(pFile, 0, SEEK_SET);

    u8 version;
    char signature[15];

    fread(&version, sizeof (u8), 1, pFile);
    ///--- saltamos la longitud de la cadena
    fseek(pFile, sizeof (char), SEEK_CUR);
    fread(signature, sizeof (char), 14, pFile);

    signature[14] = 0;

    Log("+++ Scene::LoadFromFile Cargando nivel: %s\n", szPath);
    Log("+++ Scene::LoadFromFile Version: %d\n", version);
    Log("+++ Scene::LoadFromFile Signature: %s\n", signature);

    if (strcmp(signature, "GEARDOME OZONE") != 0)
    {
        Log("@@@ Scene::LoadFromFile Signature incorrecta");
        return;
    }

    if (version != LEVEL_VERSION)
    {
        Log("@@@ Scene::LoadFromFile Version de nivel incorrecta");
        return;
    }

    u8 bg;
    fread(&bg, sizeof (u8), 1, pFile);
    m_iBackground = bg;

    LoadLevelLayer(0, pFile, cubeConfigVector, decoConfigVector);
    LoadLevelLayer(1, pFile, cubeConfigVector, decoConfigVector);
    LoadLevelLayer(2, pFile, cubeConfigVector, decoConfigVector);

    fclose(pFile);

    ClearRenderBitSets();

    for (int sx = 0; sx < m_iSectorCountX; sx++)
    {
        for (int sy = 0; sy < m_iSectorCountY; sy++)
        {
            int sector = (sy * m_iSectorCountX) + sx;

            GenerateStaticLevel(sector, sx, sy);
        }
    }

    ///--- liberamos las mallas inecesarias de los staticLevel
    for (std::vector<stCUBE_CONFIG_FILE>::size_type i = 0; i < decoConfigVector.size(); i++)
    {
        ///--- es staticlevel
        if (decoConfigVector[i].opacity == DECO_OPACITY_NO)
        {
            if (IsValidPointer(decoConfigVector[i].pMesh))
            {
                MeshManager::Instance().UnloadMesh(decoConfigVector[i].pMesh);
            }
        }
    }

    ClearRenderBitSets();

    char szBackgroundPath[40];

    if (m_iBackground < 10)
    {
        sprintf(szBackgroundPath, "game/backgrounds/0%i", m_iBackground);
    }
    else
    {
        sprintf(szBackgroundPath, "game/backgrounds/%i", m_iBackground);
    }

    char szDepthPath[100];
    sprintf(szDepthPath, "game/episodes/%s/depth", m_szEpisode);

    m_pBackgrounds->Init(szBackgroundPath, szDepthPath, (m_iSectorCountX + 1) * SECTOR_WIDTH, (m_iSectorCountY + 1) * SECTOR_HEIGHT);

    m_bNeedCleanup = true;

    Log("+++ Scene::LoadFromFile correcto\n");
}

//////////////////////////
//////////////////////////

void Scene::LoadBackground(const char* szStyle) { }

bool SortNPCByTexturePredicate(NPC* lhs, NPC * rhs)
{
    return strcmp(lhs->GetMainRenderObject()->GetTexture()->GetName(), rhs->GetMainRenderObject()->GetTexture()->GetName()) < 0;
}

//////////////////////////
//////////////////////////

void Scene::GenerateStaticLevel(int sector, int sectorX, int sectorY)
{
    TNPCList staticLevelList;

    for (int layer = 0; layer < 3; layer++)
    {
        NPC** staticNPCArray = m_SectorVector[layer][sector]->GetStaticNPCArray();
        int staticArraySize = m_SectorVector[layer][sector]->GetStaticCount();

        for (int i = 0; i < staticArraySize; i++)
        {
            NPC* pNPC = staticNPCArray[i];
            int npc_id = pNPC->GetID();

            if (pNPC->IsStaticLevel() && !m_StaticRenderedBitset[layer].IsSet(npc_id) && pNPC->GetMainRenderObject()->IsActive())
            {
                m_StaticRenderedBitset[layer].Set(npc_id);

                staticLevelList.push_back(pNPC);
            }
        }
    }

    staticLevelList.sort(SortNPCByTexturePredicate);

    TNPCListIterator itor = staticLevelList.begin();

    TNPCList textureList;

    while (itor != staticLevelList.end())
    {
        NPC* pCurrentNPC = (*itor);
        Texture* pTempTexture = (*itor)->GetMainRenderObject()->GetTexture();

        RenderObject* pTempRenderObject = new RenderObject();
        Mesh* pTempMesh = MeshManager::Instance().GetCustomMesh();
        pTempRenderObject->Init(pTempMesh, pTempTexture, RENDER_OBJECT_NORMAL);
        pTempRenderObject->SetPosition(Vec3(SECTOR_WIDTH * sectorX, 0.0f, SECTOR_HEIGHT * sectorY));

        m_SectorVector[0][sector]->GetStaticLevel()->GetRenderObjectList().push_back(pTempRenderObject);

        int totalIndexCount = 0;
        int totalVertexCount = 0;

        int indexOffset = 0;
        int vertexOffset = 0;

        textureList.clear();

        while ((itor != staticLevelList.end()) && ((*itor)->GetMainRenderObject()->GetTexture() == pTempTexture))
        {
            pCurrentNPC = (*itor);
            pTempTexture = pCurrentNPC->GetMainRenderObject()->GetTexture();

            totalIndexCount += pCurrentNPC->GetMainRenderObject()->GetMesh()->GetFaceCount() * 3;
            totalVertexCount += pCurrentNPC->GetMainRenderObject()->GetMesh()->GetVertexCount();

            textureList.push_back(pCurrentNPC);

            itor++;
        }

        VERTEX_3D* finalVerts = new VERTEX_3D[totalVertexCount];
        u16* finalIndices = new u16[totalIndexCount];

        pTempMesh->SetFaceCount(totalIndexCount / 3);
        pTempMesh->SetVertexCount(totalVertexCount);
        pTempMesh->SetIndices(finalIndices);
        pTempMesh->SetVertices(finalVerts);

        for (TNPCListIterator it = textureList.begin(); it != textureList.end(); it++)
        {
            VERTEX_3D* pVerts = (VERTEX_3D*) (*it)->GetMainRenderObject()->GetMesh()->GetVertices();
            u16* pIndices = (*it)->GetMainRenderObject()->GetMesh()->GetIndices();
            int indCount = (*it)->GetMainRenderObject()->GetMesh()->GetFaceCount() * 3;
            int vertCount = (*it)->GetMainRenderObject()->GetMesh()->GetVertexCount();

            for (int i = 0; i < indCount; i++)
            {
                finalIndices[i + indexOffset] = pIndices[i] + vertexOffset;
            }

            indexOffset += indCount;

            MATRIX mtxT;
            Vec3 vPos = (*it)->GetPosition();

            MatrixTranslation(mtxT, (vPos.x - (SECTOR_WIDTH * sectorX)) * 16.0f, vPos.y * 16.0f, (vPos.z - (SECTOR_HEIGHT * sectorY)) * 16.0f);

            for (int i = 0; i < vertCount; i++)
            {
                Vec4 vIn(pVerts[i].x, pVerts[i].y, pVerts[i].z, 1.0f);
                Vec4 vRotated;
                Vec4 vOut;

                TransTransform(&vRotated, &vIn, &(*it)->GetRotation());
                TransTransform(&vOut, &vRotated, &mtxT);

                finalVerts[i + vertexOffset] = pVerts[i];

                finalVerts[i + vertexOffset].x = vOut.x;
                finalVerts[i + vertexOffset].y = vOut.y;
                finalVerts[i + vertexOffset].z = vOut.z;
            }

            vertexOffset += vertCount;
        }

        MeshManager::Instance().TransformMeshToVBO(pTempMesh);
    }
}

//////////////////////////
//////////////////////////

void Scene::LoadFromURL(char* szURL)
{
    Log("+++ Scene::LoadFromURL ...\n");

    Log("+++ Scene::LoadFromURL correcto\n");
}

//////////////////////////
//////////////////////////

void Scene::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ Scene::Cleanup ...\n");

        PhysicsManager::Instance().Cleanup();

        for (int layer = 0; layer < 3; layer++)
        {
            int staticVectorSize = m_StaticNPCVector[layer].size();

            for (int i = 0; i < staticVectorSize; i++)
            {
                NPC* tmp = m_StaticNPCVector[layer][i];

                SafeDelete(tmp);
            }

            m_StaticNPCVector[layer].clear();

            /////

            int dynamicVectorSize = m_DynamicNPCVector[layer].size();

            for (int i = 0; i < dynamicVectorSize; i++)
            {
                NPC* tmp = m_DynamicNPCVector[layer][i];

                SafeDelete(tmp);
            }

            m_DynamicNPCVector[layer].clear();

            /////

            int sectorVectorSize = m_SectorVector[layer].size();

            for (int i = 0; i < sectorVectorSize; i++)
            {
                SafeDelete(m_SectorVector[layer][i]);
            }

            m_SectorVector[layer].clear();

            /////

            m_RenderNPCVector[layer].clear();
        }

        SafeDelete(m_pInGameMenuMain);
        SafeDelete(m_pInGameMenuDie);
        SafeDelete(m_pInGameMenuEndLevel);
        SafeDelete(m_pInGameMenuText);

        SafeDelete(m_pPlayer);

        SafeDelete(m_pCamera3D);
        SafeDelete(m_pCamera2D);

        SafeDelete(m_pInputCallbackBrake);
        SafeDelete(m_pInputCallbackController);
        SafeDelete(m_pInputCallbackFire);
        SafeDelete(m_pInputCallbackNuclear);
        SafeDelete(m_pInputCallbackDeflate);
        SafeDelete(m_pInputCallbackMenu);

        SafeDelete(m_pInputCallbackMenuInGameContinue);
        SafeDelete(m_pInputCallbackMenuInGameMainMenu);
        SafeDelete(m_pInputCallbackMenuInGameReset);
        SafeDelete(m_pInputCallbackMenuInGameNextLevel);

        SafeDelete(m_pPhysicsTickCallback);

        SafeDelete(m_pTextFont);
        SafeDelete(m_pTextFontSmall);

        SafeDelete(m_pHud);

        SafeDelete(m_pBackgrounds);

        SafeDelete(m_pCameraFovInterpolator);

        ParticleManager::Instance().Cleanup();

        m_bNeedCleanup = false;

        Log("+++ Scene::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void Scene::InputController(stInputCallbackParameter parameter, int id)
{
    if (parameter.type != PRESS_END)
    {
        m_veclogControl = parameter.vector;
    }
    else
    {
        m_veclogControl = Vec3(0, 0, 0);
    }
}

//////////////////////////
//////////////////////////

void Scene::InputBrake(stInputCallbackParameter parameter, int id)
{
    m_bInputButtonsState[INPUT_BUTTON_BRAKE] = (parameter.type != PRESS_END);
}

//////////////////////////
//////////////////////////

void Scene::InputDeflate(stInputCallbackParameter parameter, int id)
{
    m_bInputButtonsState[INPUT_BUTTON_DEFLATE] = (parameter.type != PRESS_END);
}


//////////////////////////
//////////////////////////

void Scene::InputFire(stInputCallbackParameter parameter, int id)
{
    m_bInputButtonsState[INPUT_BUTTON_FIRE] = (parameter.type != PRESS_END);

    if (parameter.type == PRESS_START && m_pPlayer->GetAmmo(NORMAL_AMMO) > 0.0f)
    {
        m_pPlayer->Shoot(NORMAL_AMMO);
    }
}

//////////////////////////
//////////////////////////

void Scene::InputMenu(stInputCallbackParameter parameter, int id)
{
    //m_bInputButtonsState[INPUT_BUTTON_MENU] = (parameter.type != PRESS_END);

    if (parameter.type == PRESS_START && !m_pInGameMenuMain->IsActive() && !m_pPlayer->IsDead() && !m_pInGameMenuText->IsActive() && LevelGameState::Instance().IsFaderFinished())
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_OPEN_INGAME_MENU));

        InputManager::Instance().ClearRegionEvents();

        for (int i = 0; i < MAX_INPUT_BUTTON; i++)
        {
            m_bInputButtonsState[i] = false;
        }

        m_veclogControl = Vec3(0, 0, 0);

        m_pInGameMenuMain->Show();

        m_pGameTimer->Stop();

        //m_bIsReadyToFinish = true;
    }
}

//////////////////////////
//////////////////////////

void Scene::InputNuclear(stInputCallbackParameter parameter, int id)
{
    m_bInputButtonsState[INPUT_BUTTON_NUCLEAR] = (parameter.type != PRESS_END);

    if (parameter.type == PRESS_START && m_pPlayer->GetAmmo(NUCLEAR_AMMO) > 0.0f)
    {
        m_pPlayer->Shoot(NUCLEAR_AMMO);
    }
}

//////////////////////////
//////////////////////////

void Scene::InputMenuInGameContinue(stInputCallbackParameter parameter, int id)
{
    InputManager::Instance().ClearRegionEvents();
    AddInputRegions();
    m_pInGameMenuMain->Hide();
    m_pInGameMenuText->Hide();
    m_pGameTimer->Continue();
}

//////////////////////////
//////////////////////////

void Scene::InputMenuInGameMainMenu(stInputCallbackParameter parameter, int id)
{
    m_bIsReadyToFinish = true;
    m_bLevelCompleted = false;
}

//////////////////////////
//////////////////////////

void Scene::InputMenuInGameNextLevel(stInputCallbackParameter parameter, int id)
{
    m_bIsReadyToFinish = true;
}

//////////////////////////
//////////////////////////

void Scene::InputMenuInGameReset(stInputCallbackParameter parameter, int id)
{
    m_bIsReadyToReset = true;
}