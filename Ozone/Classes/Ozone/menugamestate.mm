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
 * File:   menugamestate.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 21:01
 */

#include "renderer.h"
#include "renderable.h"
#include "menugamestate.h"
#include "meshmanager.h"
#include "submenumainstate.h"
#include "SubMenuAwardsState.h"
#include "SubMenuCreditsState.h"
#include "SubMenuFullVersionState.h"
#include "SubMenuHighScoresState.h"
#include "SubMenuLevelSelectionState.h"
#include "SubMenuCustomLevelsState.h"
#include "SubMenuOptionsState.h"
#include "SubMenuSaveSelectionState.h"
#include "levelgamestate.h"
#include "gamemanager.h"
#include "SubMenuEpisodeSelectionState.h"
#include "SubMenuHelpState.h"
#include "episode.h"

MenuGameState::MenuGameState(void) : GameState()
{
    Log("+++ MenuGameState::MenuGameState ...\n");

    InitPointer(m_pMainTimer);
    InitPointer(m_pFader);
    InitPointer(m_pTextFont);

    InitPointer(m_pCurrentSubMenuState);

    m_bWantsToChangeSubMenu = false;
    InitPointer(m_pNextSubMenuState);

    InitPointer(m_pCamera3DCubeSmall);
    InitPointer(m_pRenderableMidLayer3DCubeSmall);
    InitPointer(m_pCubeSmall);
    InitPointer(m_pCamera2D);
    InitPointer(m_pRenderableLowLayer2D);
    InitPointer(m_pRenderableHighLayer2D);
    InitPointer(m_pBackground);
    InitPointer(m_pBackgroundTop);
    InitPointer(m_pShadowRight);
    InitPointer(m_pShadowLeft);
    InitPointer(m_pWordGlow);

    for (int i = 0; i < 5; i++)
    {
        InitPointer(m_pOzoneWord[i]);
    }

    m_CurrentSelection.episode = -1;
    m_CurrentSelection.level = -1;
    m_CurrentSelection.finished = false;
    m_CurrentSelection.previouslyCompleted = false;
    m_CurrentSelection.customLevel = false;

    Log("+++ MenuGameState::MenuGameState correcto\n");
}

//////////////////////////
//////////////////////////

MenuGameState::~MenuGameState()
{
    Log("+++ MenuGameState::~MenuGameState ...\n");

    Cleanup();

    Log("+++ MenuGameState::~MenuGameState correcto\n");
}

//////////////////////////
//////////////////////////

void MenuGameState::Init(void)
{
    Log("+++ MenuGameState::Init ...\n");

    m_bNeedCleanup = true;

    m_pCamera2D = new Camera();
    m_pCamera3DCubeSmall = new Camera();
    m_pRenderableMidLayer3DCubeSmall = new Renderable();
    m_pRenderableLowLayer2D = new Renderable();
    m_pRenderableHighLayer2D = new Renderable();
    m_pBackground = new RenderObject();
    m_pBackgroundTop = new RenderObject();
    m_pShadowLeft = new RenderObject();
    m_pShadowRight = new RenderObject();
    m_pCubeSmall = new MenuItem();
    m_pWordGlow = new RenderObject();

    for (int i = 0; i < 5; i++)
    {
        m_pOzoneWord[i] = new RenderObject();
        m_pRenderableHighLayer2D->GetRenderObjectList().push_back(m_pOzoneWord[i]);
    }

    Texture* pTexMenu = TextureManager::Instance().GetTexture("menu/gfx/menu_01");

#ifdef GEARDOME_PLATFORM_IPAD
    m_pBackground->Init(MeshManager::Instance().GetBoardMesh(0, 0, 1024, 768,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_NORMAL);
    m_pBackground->SetPosition(0.0f, 0.0f, -90.0f);

    m_pWordGlow->Init(MeshManager::Instance().GetBoardMesh(772, 769, 212, 154,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_ADDITIVE);
    m_pWordGlow->SetPosition(408.0f, 12.0f, 20.0f);
    m_pWordGlow->UseColor(true);
    m_pWordGlow->SetColor(0.0f, 0.0f, 0.0f, 1.0f);

    m_pOzoneWord[0]->Init(MeshManager::Instance().GetBoardMesh(1, 769, 168, 122,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[0]->SetPosition(428.0f - 325, 27.0f, 0.0f);
    m_OzoneWordData[0].SetPosition(m_pOzoneWord[0]->GetPosition());

    m_pOzoneWord[1]->Init(MeshManager::Instance().GetBoardMesh(170, 769, 168, 122,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[1]->SetPosition(428.0f - 160, 30.0f, 0.0f);
    m_OzoneWordData[1].SetPosition(m_pOzoneWord[1]->GetPosition());

    m_pOzoneWord[2]->Init(MeshManager::Instance().GetBoardMesh(339, 769, 168, 122,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[2]->SetPosition(428.0f, 30.0f, 0.0f);
    m_OzoneWordData[2].SetPosition(m_pOzoneWord[2]->GetPosition());

    m_pOzoneWord[3]->Init(MeshManager::Instance().GetBoardMesh(508, 769, 138, 122,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[3]->SetPosition(596.0f + 20, 30.0f, 0.0f);
    m_OzoneWordData[3].SetPosition(m_pOzoneWord[3]->GetPosition());

    m_pOzoneWord[4]->Init(MeshManager::Instance().GetBoardMesh(649, 769, 124, 122,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[4]->SetPosition(596.0f + 190, 27.0f, 0.0f);
    m_OzoneWordData[4].SetPosition(m_pOzoneWord[4]->GetPosition());

#else

    m_pBackground->Init(MeshManager::Instance().GetBoardMesh(1, 75, 480, 246,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_NORMAL);
    m_pBackground->SetPosition(0.0f, 74.0f, -90.0f);
    m_pBackgroundTop->Init(MeshManager::Instance().GetBoardMesh(480, 74, 1, 1, 15, 75,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_NORMAL);
    m_pBackgroundTop->SetPosition(0.0f, 0.0f, -90.0f);

    m_pShadowLeft->Init(MeshManager::Instance().GetBoardMesh(67, 52, 1, 68, 511, 459,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pShadowLeft->SetPosition(0.0f, 0.0f, -80.0f);

    m_pShadowRight->Init(MeshManager::Instance().GetBoardMesh(67, 52, 68, 1, 511, 459,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pShadowRight->SetPosition(480.0f - 67, 0.0f, -80.0f);

    m_pWordGlow->Init(MeshManager::Instance().GetBoardMesh(374, 0, 100, 75,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_ADDITIVE);
    m_pWordGlow->SetPosition(190.0f, 3.0f, 10.0f);
    m_pWordGlow->UseColor(true);
    m_pWordGlow->SetColor(0.0f, 0.0f, 0.0f, 1.0f);

    m_pOzoneWord[0]->Init(MeshManager::Instance().GetBoardMesh(16, 1, 77, 73,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[0]->SetPosition(200.0f - 150, 5.0f, 0.0f);
    m_OzoneWordData[0].SetPosition(m_pOzoneWord[0]->GetPosition());

    m_pOzoneWord[1]->Init(MeshManager::Instance().GetBoardMesh(93, 0, 68, 75,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[1]->SetPosition(200.0f - 65, 5.0f, 0.0f);
    m_OzoneWordData[1].SetPosition(m_pOzoneWord[1]->GetPosition());

    m_pOzoneWord[2]->Init(MeshManager::Instance().GetBoardMesh(161, 0, 80, 75,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[2]->SetPosition(200.0f, 5.0f, 0.0f);
    m_OzoneWordData[2].SetPosition(m_pOzoneWord[2]->GetPosition());

    m_pOzoneWord[3]->Init(MeshManager::Instance().GetBoardMesh(241, 0, 68, 75,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[3]->SetPosition(240.0f + 40, 5.0f, 0.0f);
    m_OzoneWordData[3].SetPosition(m_pOzoneWord[3]->GetPosition());

    m_pOzoneWord[4]->Init(MeshManager::Instance().GetBoardMesh(309, 1, 60, 73,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pOzoneWord[4]->SetPosition(240.0f + 113, 5.0f, 0.0f);
    m_OzoneWordData[4].SetPosition(m_pOzoneWord[4]->GetPosition());

#endif

#ifndef GEARDOME_PLATFORM_IPAD
    m_pRenderableLowLayer2D->GetRenderObjectList().push_back(m_pShadowLeft);
    m_pRenderableLowLayer2D->GetRenderObjectList().push_back(m_pShadowRight);
    m_pRenderableLowLayer2D->GetRenderObjectList().push_back(m_pBackgroundTop);
#endif
    m_pRenderableLowLayer2D->GetRenderObjectList().push_back(m_pBackground);
    m_pRenderableHighLayer2D->GetRenderObjectList().push_back(m_pWordGlow);

    m_pRenderableLowLayer2D->Set3D(false);
    m_pRenderableLowLayer2D->SetLayer(0);

    m_pRenderableHighLayer2D->Set3D(false);
    m_pRenderableHighLayer2D->SetLayer(600);

    m_pCubeSmall->renderObject.Init(MeshManager::Instance().GetMeshFromFile("menu/gfx/wire_cube"),
            TextureManager::Instance().GetTexture("menu/gfx/wire_cube", true), RENDER_OBJECT_NORMAL);
    m_pCubeSmall->renderObject.SetCustomCamera(m_pCamera3DCubeSmall);

    m_pRenderableMidLayer3DCubeSmall->GetRenderObjectList().push_back(&m_pCubeSmall->renderObject);
    m_pRenderableMidLayer3DCubeSmall->Set3D(true);
    m_pRenderableMidLayer3DCubeSmall->SetLayer(510);

    m_pCamera3DCubeSmall->SetTargeting(true);
    m_pCamera3DCubeSmall->SetFov(48.0f);
    m_pCamera3DCubeSmall->SetFarPlane(400.0f);
    m_pCamera3DCubeSmall->SetNearPlane(100.0f);
    m_pCamera3DCubeSmall->SetMode(true);
    m_pCamera3DCubeSmall->SetPosition(0.0f, 0.0f, 280.0f);

    
    m_bWantsToChangeSubMenu = false;
    InitPointer(m_pNextSubMenuState);

    m_pMainTimer = new Timer();
    m_pFader = new Fader();
    m_pTextFont = new TextFont();

    m_pFader->SetLayer(600);
    m_pFader->StartFade(0.0f, 0.0f, 0.0f, true, 0.5f, 90.0f);

    m_pTextFont->Init("fonts/menu_01_font", "fonts/menu_01_font", 600);

    SubMenuMainState::Instance().Init(m_pTextFont, m_pFader);
    SubMenuCreditsState::Instance().Init(m_pTextFont, m_pFader);
#ifdef OZONE_LITE
    SubMenuFullVersionState::Instance().Init(m_pTextFont, m_pFader);
#else
    SubMenuCustomLevelsState::Instance().Init(m_pTextFont, m_pFader);
#endif
    SubMenuHighScoresState::Instance().Init(m_pTextFont, m_pFader);
    SubMenuLevelSelectionState::Instance().Init(m_pTextFont, m_pFader);
    SubMenuSaveSelectionState::Instance().Init(m_pTextFont, m_pFader);
    SubMenuEpisodeSelectionState::Instance().Init(m_pTextFont, m_pFader);
    SubMenuHelpState::Instance().Init(m_pTextFont, m_pFader);

    bool changeMusic = false;

    if (m_CurrentSelection.episode >= 0 && m_CurrentSelection.level >= 0)
    {
        Episode* pEpisode = SubMenuEpisodeSelectionState::Instance().GetEpisode(m_CurrentSelection.episode);

        if (m_CurrentSelection.customLevel)
        {
            SetSubMenu(&SubMenuCustomLevelsState::Instance());
            changeMusic = true;
        }
        else
        {
            if (m_CurrentSelection.finished)
            {
                m_CurrentSelection.finished = false;

                ///--- boss y final del tuto
                if ((m_CurrentSelection.level == 11) || ((m_CurrentSelection.level == 5) && (m_CurrentSelection.episode == 0)))
                {
                    ///--- sacamos creditos al finalizar space
                    if (m_CurrentSelection.episode == 4)
                    {
                        SubMenuCreditsState::Instance().SetEndOfGame();
                        SetSubMenu(&SubMenuCreditsState::Instance());
                    }
                    else
                    {
#ifndef OZONE_PRE_RELEASE
                        ///--- se tiene que desbloquear nuevo episodio
                        if (!m_CurrentSelection.previouslyCompleted)
                        {
                            SubMenuEpisodeSelectionState::Instance().SetUnlockEpisode(m_CurrentSelection.episode + 1);
                        }
    #endif
                        SetSubMenu(&SubMenuEpisodeSelectionState::Instance());
                    }

                    changeMusic = true;
                }
                else
                {
#ifdef OZONE_LITE
                    ///--- boss y final del tuto
                    if ((m_CurrentSelection.level == 3) && (m_CurrentSelection.episode == 1))
                    {
                        SetSubMenu(&SubMenuFullVersionState::Instance());
                        changeMusic = true;
                    }
                    else
                    {
#endif

                        SubMenuLevelSelectionState::Instance().PrepareEpisode(pEpisode, m_CurrentSelection.episode);
                        SubMenuLevelSelectionState::Instance().PrepareLevelForImmediateLoading(pEpisode, m_CurrentSelection.level + 1, false);
                        GameManager::Instance().ChangeState(&LevelGameState::Instance());
                        m_pCurrentSubMenuState = &SubMenuLevelSelectionState::Instance();
                        SubMenuLevelSelectionState::Instance().SetGoingToLevel();
                        m_CurrentSelection.level++;
                        m_pFader->Pause(true);

#ifdef OZONE_LITE
                    }
#endif
                }
            }
            else
            {
                changeMusic = true;
                SubMenuLevelSelectionState::Instance().PrepareEpisode(pEpisode, m_CurrentSelection.episode);
                SetSubMenu(&SubMenuLevelSelectionState::Instance());
            }
        }
    }
    else
    {
        m_pCurrentSubMenuState = &SubMenuMainState::Instance();
    }

    if (changeMusic)
    {
        AudioManager::Instance().StopMusic(Audio::Instance().GetCurrentMusic());
        AudioManager::Instance().UnloadMusic(Audio::Instance().GetCurrentMusic());
        Audio::Instance().SetMusic(kMUSIC_MENU, AudioManager::Instance().LoadMusic("menu/sounds/music_s"));
        AudioManager::Instance().SetMusicLoops(Audio::Instance().GetMusic(kMUSIC_MENU), 9999);
        AudioManager::Instance().PlayMusic(Audio::Instance().GetMusic(kMUSIC_MENU));
        Audio::Instance().SetCurrentMusic(Audio::Instance().GetMusic(kMUSIC_MENU));
    }

    Renderer::Instance().EnableClearColor(true);

    m_pMainTimer->Start();

    Log("+++ MenuGameState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void MenuGameState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ MenuGameState::Cleanup ...\n");

        SubMenuMainState::Instance().Cleanup();
        SubMenuAwardsState::Instance().Cleanup();
        SubMenuCreditsState::Instance().Cleanup();
        SubMenuFullVersionState::Instance().Cleanup();
        SubMenuHighScoresState::Instance().Cleanup();
        SubMenuLevelSelectionState::Instance().Cleanup();
        SubMenuOptionsState::Instance().Cleanup();
        SubMenuSaveSelectionState::Instance().Cleanup();
        SubMenuEpisodeSelectionState::Instance().Cleanup();
        SubMenuHelpState::Instance().Cleanup();

        InitPointer(m_pCurrentSubMenuState);

        MeshManager::Instance().UnloadAll();
        TextureManager::Instance().UnloadAll();
        InputManager::Instance().ClearRegionEvents();
        InterpolatorManager::Instance().DeleteAll();

        Renderer::Instance().ClearLayers();

        SafeDelete(m_pMainTimer);
        SafeDelete(m_pFader);
        SafeDelete(m_pTextFont);

        SafeDelete(m_pCamera3DCubeSmall);
        SafeDelete(m_pCubeSmall);
        SafeDelete(m_pRenderableMidLayer3DCubeSmall);
        SafeDelete(m_pCamera2D);
        SafeDelete(m_pRenderableLowLayer2D);
        SafeDelete(m_pRenderableHighLayer2D);
        SafeDelete(m_pBackground);
        SafeDelete(m_pBackgroundTop);
        SafeDelete(m_pShadowRight);
        SafeDelete(m_pShadowLeft);

        SafeDelete(m_pWordGlow);

        for (int i = 0; i < 5; i++)
        {

            SafeDelete(m_pOzoneWord[i]);
        }

        m_bWantsToChangeSubMenu = false;
        InitPointer(m_pNextSubMenuState);

        m_bNeedCleanup = false;

        Log("+++ MenuGameState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void MenuGameState::Pause(void)
{

    Log("+++ MenuGameState::Pause ...\n");

    Log("+++ MenuGameState::Pause correcto\n");
}

//////////////////////////
//////////////////////////

void MenuGameState::Resume(void)
{

    Log("+++ MenuGameState::Resume ...\n");

    Log("+++ MenuGameState::Resume correcto\n");
}

//////////////////////////
//////////////////////////

void MenuGameState::Update(void)
{
    m_pMainTimer->Update();

    InterpolatorManager::Instance().Update(m_pMainTimer->GetDeltaTime());
    InputManager::Instance().Update();

    m_pTextFont->Begin();

    m_pFader->Update(m_pMainTimer->GetDeltaTime());

    UpdateWord();
    UpdateCube();

    Renderer::Instance().Add(m_pRenderableMidLayer3DCubeSmall);
    Renderer::Instance().Add(m_pRenderableLowLayer2D);
    Renderer::Instance().Add(m_pRenderableHighLayer2D);

    if (m_bWantsToChangeSubMenu)
    {
        Log("+++ MenuGameState::Update cambiando de submenu...\n");

        m_bWantsToChangeSubMenu = false;
        m_pCurrentSubMenuState = m_pNextSubMenuState;
        m_pNextSubMenuState = NULL;

        m_pCurrentSubMenuState->Reset();
    }

    switch (m_pCurrentSubMenuState->GetState())
    {
        case SUB_MENU_LOADING:
        {
            m_pCurrentSubMenuState->UpdateLoading();
            break;
        }
        case SUB_MENU_IDLE:
        {
            m_pCurrentSubMenuState->Update();
            break;
        }
        case SUB_MENU_CLOSING:
        {
            m_pCurrentSubMenuState->UpdateClosing();

            break;
        }
    }

    m_pTextFont->End();

    //Renderer::Instance().Render();

    /*
    if (m_pCurrentSubMenuState->IsFinishing())
    {
        GameManager::Instance().ChangeState(&LevelGameState::Instance());
    }
     */
}

//////////////////////////
//////////////////////////

void MenuGameState::UpdateCube(void)
{
    float deltaTime = m_pMainTimer->GetDeltaTime();

    MATRIX matTrans;

    if (GameManager::Instance().IsHomeRight())
    {
        MatrixTranslation(matTrans, 0.75f, 0.0f, 0.0f);
    }
    else
    {
        MatrixTranslation(matTrans, -0.75f, 0.0f, 0.0f);
    }

    m_pCamera3DCubeSmall->SetAbsoluteTransform(matTrans);

    MATRIX scaleSmall;

    MatrixScaling(scaleSmall, 0.26f, 0.26f, 0.26f);

    /// cube small

    Vec3 rot = m_pCubeSmall->GetAngularSpeed();

    rot.y -= 0.21f * deltaTime;
    rot.x -= 0.25f * deltaTime;
    rot.z += 0.30f * deltaTime;

    m_pCubeSmall->SetAngularSpeed(rot);

    MatrixRotationX(m_pCubeSmall->renderObject.GetTransform(), rot.x);
    MATRIX mRotY, mRotZ;
    MatrixRotationY(mRotY, rot.y);
    MatrixRotationZ(mRotZ, rot.z);
    MatrixMultiply(m_pCubeSmall->renderObject.GetTransform(), m_pCubeSmall->renderObject.GetTransform(), mRotY);
    MatrixMultiply(m_pCubeSmall->renderObject.GetTransform(), m_pCubeSmall->renderObject.GetTransform(), mRotZ);
    MatrixMultiply(m_pCubeSmall->renderObject.GetTransform(), m_pCubeSmall->renderObject.GetTransform(), scaleSmall);
}

//////////////////////////
//////////////////////////

void MenuGameState::UpdateWord(void)
{

    float time = m_pMainTimer->GetActualTime() * 0.8f;

#ifdef GEARDOME_PLATFORM_IPAD
    float offset = fast_sin(time) * 20.0f;
#else
    float offset = fast_sin(time) * 10.0f;
#endif

    Vec3 pos = m_OzoneWordData[0].GetPosition();
    pos.x += offset;
    pos.y += offset * 0.2f;
    m_pOzoneWord[0]->SetPosition(pos);

    pos = m_OzoneWordData[4].GetPosition();
    pos.x -= offset;
    pos.y += offset * 0.15f;
    m_pOzoneWord[4]->SetPosition(pos);

    offset = fast_sin(time) * 6.0f;

    pos = m_OzoneWordData[1].GetPosition();
    pos.x += offset;
    m_pOzoneWord[1]->SetPosition(pos);

    pos = m_OzoneWordData[3].GetPosition();
    pos.x -= offset;
    m_pOzoneWord[3]->SetPosition(pos);

    float glowAlpha = (fast_sin(time) + 1.0f) / 2.0f;

    m_pWordGlow->SetColor(glowAlpha, glowAlpha, glowAlpha, 1.0f);

}

//////////////////////////
//////////////////////////

void MenuGameState::SetSubMenu(SubMenuState* submenu)
{
    Log("+++ MenuGameState::SetSubMenu ...\n");

    m_bWantsToChangeSubMenu = true;
    m_pNextSubMenuState = submenu;

    Log("+++ MenuGameState::SetSubMenu correcto\n");
}
