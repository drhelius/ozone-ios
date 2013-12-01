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
 *  SubMenuLevelSelectionState.cpp
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "gamemanager.h"
#include "levelgamestate.h"
#include "SubMenuLevelSelectionState.h"
#include "SubMenuEpisodeSelectionState.h"
#include "menugamestate.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "audio.h"
#include "SaveManager.h"

//////////////////////////
//////////////////////////

SubMenuLevelSelectionState::SubMenuLevelSelectionState(void) : SubMenuState()
{
    Log("+++ SubMenuLevelSelectionState::SubMenuLevelSelectionState ...\n");

    InitPointer(m_pTextFont);
    InitPointer(m_pInputCallbackBack);
    InitPointer(m_pInputCallbackArrowLeft);
    InitPointer(m_pInputCallbackArrowRight);
    InitPointer(m_pInputCallbackAnySlot);
    InitPointer(m_pUICallbackItunes);

    InitPointer(m_pRenderableMidLayer2D);
    InitPointer(m_pBackButton);
    InitPointer(m_pMenuBar);

    InitPointer(m_pMenuOpacityInterpolator);
    InitPointer(m_pArrowsSineInterpolator);
    InitPointer(m_pMovementInterpolator);
    InitPointer(m_pSelectionInterpolator);

    InitPointer(m_pLeftArrow[0]);
    InitPointer(m_pLeftArrow[1]);
    InitPointer(m_pRightArrow[0]);
    InitPointer(m_pRightArrow[1]);

    InitPointer(m_pEpisode);

    for (int i = 0; i < MAX_LEVEL_SLOTS; i++)
    {

        m_LevelSlots[i].enabled = false;
        m_LevelSlots[i].completed = false;
        m_LevelSlots[i].locked = true;
        InitPointer(m_LevelSlots[i].pNormalRO);
        InitPointer(m_LevelSlots[i].pCompletedRO);
        InitPointer(m_LevelSlots[i].pBossRO);
        InitPointer(m_LevelSlots[i].pLockRO);
        InitPointer(m_LevelSlots[i].pBossCompletedRO);
    }

    m_bNeedCleanup = false;
    m_bWantToClose = false;
    m_bGoingToLevel = false;
    m_fMenuOpacity = 0.0f;
    m_fMovementOffset = 0.0f;
    m_fSelectionOpacity = 1.0f;
    m_iSelection = -1;
    m_iEpisode = 0;


    Log("+++ SubMenuLevelSelectionState::SubMenuLevelSelectionState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuLevelSelectionState::~SubMenuLevelSelectionState(void)
{

    Log("+++ SubMenuLevelSelectionState::~SubMenuLevelSelectionState ...\n");

    Cleanup();

    Log("+++ SubMenuLevelSelectionState::~SubMenuLevelSelectionState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::Reset(void)
{

    Log("+++ SubMenuLevelSelectionState::Reset ...\n");

    InputManager::Instance().ClearRegionEvents();

    m_bFinishing = false;
    m_bWantToClose = false;
    m_bGoingToLevel = false;
    m_CurrentState = SUB_MENU_LOADING;
    m_fMenuOpacity = 0.0f;
    m_fArrowSineOffset = 0.0f;
    m_fMovementOffset = 0.0f;
    m_iCurrentPage = 0;
    m_fSelectionOpacity = 1.0f;
    m_iSelection = -1;

    m_pLeftArrow[1]->Activate(false);
    m_pRightArrow[1]->Activate(false);

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 70.0f, 200.0f, 70.0f, m_pInputCallbackBack);

    InputManager::Instance().AddRectRegionEvent(0.0f, 380.0f, 72.0f, 98.0f, m_pInputCallbackArrowLeft);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 72.0f, 380.0f, 72.0f, 98.0f, m_pInputCallbackArrowRight);

    int column = 0;
    int row = 0;

    for (int i = 0; i < 6; i++)
    {
        row = (i / 3) % 2;
        column = i % 3;

        InputManager::Instance().AddRectRegionEvent(140.0f + (290.0f * column), 310.0f + (170.0f * row), 170, 150, m_pInputCallbackAnySlot, i);
    }
#else
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 35.0f, 100.0f, 35.0f, m_pInputCallbackBack);

    InputManager::Instance().AddRectRegionEvent(0.0f, 140.0f, 36.0f, 63.0f, m_pInputCallbackArrowLeft);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 36.0f, 140.0f, 36.0f, 63.0f, m_pInputCallbackArrowRight);

    int column = 0;
    int row = 0;

    for (int i = 0; i < 6; i++)
    {
        row = (i / 3) % 2;
        column = i % 3;

        InputManager::Instance().AddRectRegionEvent(38.0f + (136.0f * column), 135.0f + (75.0f * row), 132, 72, m_pInputCallbackAnySlot, i);
    }
#endif

    ResetInterpolators();

    Log("+++ SubMenuLevelSelectionState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::ResetInterpolators(void)
{

    m_pMenuOpacityInterpolator->Continue();
    m_pMenuOpacityInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pMenuOpacityInterpolator, false);
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::Init(TextFont* pTextFont, Fader* pFader)
{
    Log("+++ SubMenuSaveSelectionState::Init ...\n");

    m_bNeedCleanup = true;
    m_pTextFont = pTextFont;
    m_pFader = pFader;

    m_pRenderableMidLayer2D = new Renderable();
    m_pRenderableMidLayer2D->Set3D(false);
    m_pRenderableMidLayer2D->SetLayer(600);

    Texture* pTexMenu01 = TextureManager::Instance().GetTexture("menu/gfx/menu_01");
    Texture* pTexMenu02 = TextureManager::Instance().GetTexture("menu/gfx/menu_02");


#ifdef GEARDOME_PLATFORM_IPAD

    Mesh* pMeshLock = MeshManager::Instance().GetBoardMesh(1, 327, 127, 127,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pMeshNormal = MeshManager::Instance().GetBoardMesh(130, 327, 127, 127,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pMeshCompleted = MeshManager::Instance().GetBoardMesh(345, 0, 127, 127,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pMeshBoss = MeshManager::Instance().GetBoardMesh(345, 256, 127, 127,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pMeshBossCompleted = MeshManager::Instance().GetBoardMesh(345, 128, 127, 127,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pUpArrow = MeshManager::Instance().GetBoardMesh(917, 926, 52, 98,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrow = MeshManager::Instance().GetBoardMesh(971, 926, 52, 98,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pUpArrowLeft = MeshManager::Instance().GetBoardMesh(52, 98, 969, 917, 926, 1024,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrowLeft = MeshManager::Instance().GetBoardMesh(52, 98, 1023, 971, 926, 1024,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());

    for (int i = 0; i < MAX_LEVEL_SLOTS; i++)
    {
        m_LevelSlots[i].pNormalRO = new RenderObject();
        m_LevelSlots[i].pNormalRO->Init(pMeshNormal, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pNormalRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pNormalRO);

        m_LevelSlots[i].pLockRO = new RenderObject();
        m_LevelSlots[i].pLockRO->Init(pMeshLock, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pLockRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pLockRO);

        m_LevelSlots[i].pCompletedRO = new RenderObject();
        m_LevelSlots[i].pCompletedRO->Init(pMeshCompleted, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pCompletedRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pCompletedRO);

        m_LevelSlots[i].pBossRO = new RenderObject();
        m_LevelSlots[i].pBossRO->Init(pMeshBoss, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pBossRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pBossRO);

        m_LevelSlots[i].pBossCompletedRO = new RenderObject();
        m_LevelSlots[i].pBossCompletedRO->Init(pMeshBossCompleted, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pBossCompletedRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pBossCompletedRO);
    }

#else

    Mesh* pMeshLock = MeshManager::Instance().GetBoardMesh(247, 424, 64, 64,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pMeshNormal = MeshManager::Instance().GetBoardMesh(312, 424, 64, 64,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pMeshCompleted = MeshManager::Instance().GetBoardMesh(152, 2, 64, 64,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pMeshBoss = MeshManager::Instance().GetBoardMesh(152, 137, 64, 64,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pMeshBossCompleted = MeshManager::Instance().GetBoardMesh(152, 70, 64, 64,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pUpArrow = MeshManager::Instance().GetBoardMesh(157, 458, 29, 51,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrow = MeshManager::Instance().GetBoardMesh(127, 458, 29, 51,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pUpArrowLeft = MeshManager::Instance().GetBoardMesh(29, 51, 186, 157, 509, 458,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrowLeft = MeshManager::Instance().GetBoardMesh(29, 51, 156, 127, 509, 458,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());

    for (int i = 0; i < MAX_LEVEL_SLOTS; i++)
    {
        m_LevelSlots[i].pNormalRO = new RenderObject();
        m_LevelSlots[i].pNormalRO->Init(pMeshNormal, pTexMenu01, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pNormalRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pNormalRO);

        m_LevelSlots[i].pLockRO = new RenderObject();
        m_LevelSlots[i].pLockRO->Init(pMeshLock, pTexMenu01, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pLockRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pLockRO);

        m_LevelSlots[i].pCompletedRO = new RenderObject();
        m_LevelSlots[i].pCompletedRO->Init(pMeshCompleted, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pCompletedRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pCompletedRO);

        m_LevelSlots[i].pBossRO = new RenderObject();
        m_LevelSlots[i].pBossRO->Init(pMeshBoss, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pBossRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pBossRO);

        m_LevelSlots[i].pBossCompletedRO = new RenderObject();
        m_LevelSlots[i].pBossCompletedRO->Init(pMeshBossCompleted, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_LevelSlots[i].pBossCompletedRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_LevelSlots[i].pBossCompletedRO);
    }

#endif

    m_pLeftArrow[0] = new RenderObject();
    m_pLeftArrow[1] = new RenderObject();
    m_pRightArrow[0] = new RenderObject();
    m_pRightArrow[1] = new RenderObject();

    m_pLeftArrow[0]->Init(pDownArrowLeft, pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pLeftArrow[0]->SetPosition(0.0f, 146.0f, 0.0f);
    m_pLeftArrow[0]->UseColor(true);
    m_pLeftArrow[1]->Init(pUpArrowLeft, pTexMenu01, RENDER_OBJECT_ADDITIVE);
    m_pLeftArrow[1]->SetPosition(0.0f, 146.0f, 2.0f);
    m_pLeftArrow[1]->UseColor(true);

    m_pRightArrow[0]->Init(pDownArrow, pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pRightArrow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 29.0f, 146.0f, 0.0f);
    m_pRightArrow[0]->UseColor(true);
    m_pRightArrow[1]->Init(pUpArrow, pTexMenu01, RENDER_OBJECT_ADDITIVE);
    m_pRightArrow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 29.0f, 146.0f, 2.0f);
    m_pRightArrow[1]->UseColor(true);

    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pLeftArrow[0]);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pLeftArrow[1]);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pRightArrow[0]);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pRightArrow[1]);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pBackButton = new RenderObject();
    m_pBackButton->Init(MeshManager::Instance().GetBoardMesh(593, 893, 176, 49,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pBackButton->SetPosition(0.0f, IPHONE_SCREEN_WIDTH - 60.0f, 0.0f);
    m_pBackButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackButton);

    m_pMenuBar = new RenderObject();
    m_pMenuBar->Init(MeshManager::Instance().GetBoardMesh(0, 966, 524, 46,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pMenuBar->SetPosition(0.0f, 210.0f, 0.0f);
    m_pMenuBar->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pMenuBar);
#else
    m_pBackButton = new RenderObject();
    m_pBackButton->Init(MeshManager::Instance().GetBoardMesh(23, 74, 510, 487, 1, 75,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pBackButton->GetTransform(), MAT_ToRadians(90.0f));
    m_pBackButton->SetPosition(0.0f, IPHONE_SCREEN_HEIGHT - 163.0f, 0.0f);
    m_pBackButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackButton);

    m_pMenuBar = new RenderObject();
    m_pMenuBar->Init(MeshManager::Instance().GetBoardMesh(27, 236, 512, 485, 329, 93,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pMenuBar->GetTransform(), MAT_ToRadians(90.0f));
    m_pMenuBar->SetPosition(0.0f, 115.0f, 0.0f);
    m_pMenuBar->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pMenuBar);
#endif

    m_pInputCallbackBack = new InputCallback<SubMenuLevelSelectionState > (this, &SubMenuLevelSelectionState::InputCallbackBack);
    m_pInputCallbackArrowLeft = new InputCallback<SubMenuLevelSelectionState > (this, &SubMenuLevelSelectionState::InputCallbackArrowLeft);
    m_pInputCallbackArrowRight = new InputCallback<SubMenuLevelSelectionState > (this, &SubMenuLevelSelectionState::InputCallbackArrowRight);
    m_pInputCallbackAnySlot = new InputCallback<SubMenuLevelSelectionState > (this, &SubMenuLevelSelectionState::InputCallbackAnySlot);
    m_pUICallbackItunes = new UICallback<SubMenuLevelSelectionState > (this, &SubMenuLevelSelectionState::UICallbackItunes);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pMovementInterpolator = new EaseInterpolator(&m_fMovementOffset, 0.0f, 300.0f, 2.0f, 0.5f, true);
    m_pArrowsSineInterpolator = new SineInterpolator(&m_fArrowSineOffset, 0.0f, 7.0f, 3.0f);
#else
    m_pMovementInterpolator = new EaseInterpolator(&m_fMovementOffset, 0.0f, 136.0f, 2.0f, 0.5f, true);
    m_pArrowsSineInterpolator = new SineInterpolator(&m_fArrowSineOffset, 0.0f, 7.0f, 2.0f);
#endif

    m_pMenuOpacityInterpolator = new LinearInterpolator(&m_fMenuOpacity, 0.0f, 1.0f, 0.3f);
    m_pSelectionInterpolator = new CosineInterpolator(&m_fSelectionOpacity, 1.0f, 0.0f, 0.25f, true, 0.5f);

    m_pMenuOpacityInterpolator->Pause();

    m_pArrowsSineInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pArrowsSineInterpolator, false);

    Log("+++ SubMenuSaveSelectionState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {

        Log("+++ SubMenuLevelSelectionState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);
        SafeDelete(m_pInputCallbackArrowLeft);
        SafeDelete(m_pInputCallbackArrowRight);
        SafeDelete(m_pInputCallbackAnySlot);
        SafeDelete(m_pUICallbackItunes);

        SafeDelete(m_pRenderableMidLayer2D);

        SafeDelete(m_pBackButton);
        SafeDelete(m_pMenuBar);

        SafeDelete(m_pMenuOpacityInterpolator);
        SafeDelete(m_pArrowsSineInterpolator);
        SafeDelete(m_pMovementInterpolator);
        SafeDelete(m_pSelectionInterpolator);

        SafeDelete(m_pLeftArrow[0]);
        SafeDelete(m_pLeftArrow[1]);
        SafeDelete(m_pRightArrow[0]);
        SafeDelete(m_pRightArrow[1]);

        for (int i = 0; i < MAX_LEVEL_SLOTS; i++)
        {

            SafeDelete(m_LevelSlots[i].pNormalRO);
            SafeDelete(m_LevelSlots[i].pCompletedRO);
            SafeDelete(m_LevelSlots[i].pBossRO);
            SafeDelete(m_LevelSlots[i].pLockRO);
            SafeDelete(m_LevelSlots[i].pBossCompletedRO);
        }

        InputManager::Instance().ClearRegionEvents();

        m_bNeedCleanup = false;

        Log("+++ SubMenuLevelSelectionState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::UpdateLoading(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {

        m_CurrentState = SUB_MENU_IDLE;
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::UpdateClosing(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {

        MenuGameState::Instance().SetSubMenu(&SubMenuEpisodeSelectionState::Instance());
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::Update(void)
{
    Renderer::Instance().Add(m_pRenderableMidLayer2D);

    float menuOpacity = (m_CurrentState == SUB_MENU_CLOSING) ? (1.0f - m_fMenuOpacity) : m_fMenuOpacity;

    COLOR cFont = {0.99f, 0.46f, 0.28f, menuOpacity};

    char strEpisode[50];
    sprintf(strEpisode, "%s - Select Level", m_pEpisode->GetName().c_str());

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add(strEpisode, 20.0f, 200.0f, 0.0f, cFont);
#else
    m_pTextFont->Add(strEpisode, 10.0f, 86.0f, 0.0f, cFont);
#endif

    m_pMenuBar->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);


    m_pBackButton->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    COLOR cFontBlue = {1.0f, 1.0f, 1.0f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("BACK", 40.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBlue);
#else
    m_pTextFont->Add("BACK", 20.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBlue);
#endif

    int column = 0;
    int row = 0;
    int page = 0;

    for (int i = 0; i < MAX_LEVEL_SLOTS; i++)
    {
        if (m_LevelSlots[i].enabled)
        {
            bool isCompleted = SaveManager::Instance().IsLevelCompleted(m_iEpisode, i);
            bool isUnlocked = ((i == 0) ? true : SaveManager::Instance().IsLevelCompleted(m_iEpisode, i - 1));

            if (GameManager::Instance().GetCheatPlayAllLevels())
            {
                isUnlocked = true;
            }

#ifdef OZONE_LITE
            if ((m_iEpisode >= 1) && (i > 3))
            {
                isUnlocked = false;
            }
#endif

            bool isBoss = (i == 11);

            m_LevelSlots[i].pNormalRO->Activate(false);
            m_LevelSlots[i].pBossRO->Activate(false);
            m_LevelSlots[i].pLockRO->Activate(false);
            m_LevelSlots[i].pBossCompletedRO->Activate(false);
            m_LevelSlots[i].pCompletedRO->Activate(false);

#ifndef OZONE_PRE_RELEASE
            if (isUnlocked)
            {
                if (isCompleted)
                {
                    if (isBoss)
                    {
                        m_LevelSlots[i].pBossCompletedRO->Activate(true);
                    }
                    else
                    {
                        m_LevelSlots[i].pCompletedRO->Activate(true);
                    }
                }
                else
                {
                    if (isBoss)
                    {
                        m_LevelSlots[i].pBossRO->Activate(true);
                    }
                    else
                    {
                        m_LevelSlots[i].pNormalRO->Activate(true);
                    }
                }
            }
            else
            {
                m_LevelSlots[i].pLockRO->Activate(true);
            }
#else
            if (isBoss)
            {
                m_LevelSlots[i].pBossCompletedRO->Activate(true);
            }
            else
            {
                m_LevelSlots[i].pCompletedRO->Activate(true);
            }
#endif

            row = (i / 3) % 2;
            column = i % 3;
            page = i / 6;

#ifdef GEARDOME_PLATFORM_IPAD
            float posX = (-m_fMovementOffset) + 90.0f + (290.0f * column) + (1000.0f * page) + 70.0f;
            float opacity = 1.0f;

            if (posX > 700.0f)
            {
                opacity = MAT_Min(1.0f - MAT_Clampf((posX - 700.0f) / 300.0f, 0.0f, 1.0f), menuOpacity);
            }
            else if (posX < 140.0f)
            {
                opacity = MAT_Min(1.0f - MAT_Clampf((180.0f - posX) / 300.0f, 0.0f, 1.0f), menuOpacity);
            }
            else
            {
                opacity = menuOpacity;
            }

            if (m_iSelection == i)
            {
                opacity = MAT_Min(opacity, m_fSelectionOpacity);
            }

            m_LevelSlots[i].pNormalRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_LevelSlots[i].pLockRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_LevelSlots[i].pCompletedRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_LevelSlots[i].pBossRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_LevelSlots[i].pBossCompletedRO->SetColor(1.0f, 1.0f, 1.0f, opacity);

            float posY = 320.0f + (170.0f * row);
#else
            float posX = (-m_fMovementOffset) + 38.0f + (136.0f * column) + (500.0f * page) + 35.0f;
            float opacity = 1.0f;

            if (posX > 358.0f)
            {
                opacity = MAT_Min(1.0f - MAT_Clampf((posX - 308.0f) / 150.0f, 0.0f, 1.0f), menuOpacity);
            }
            else if (posX < 70.0f)
            {
                opacity = MAT_Min(1.0f - MAT_Clampf((90.0f - posX) / 150.0f, 0.0f, 1.0f), menuOpacity);
            }
            else
            {
                opacity = menuOpacity;
            }

            if (m_iSelection == i)
            {
                opacity = MAT_Min(opacity, m_fSelectionOpacity);
            }

            m_LevelSlots[i].pNormalRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_LevelSlots[i].pLockRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_LevelSlots[i].pCompletedRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_LevelSlots[i].pBossRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_LevelSlots[i].pBossCompletedRO->SetColor(1.0f, 1.0f, 1.0f, opacity);

            float posY = 135.0f + (75.0f * row);
#endif

            m_LevelSlots[i].pNormalRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pBossRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pLockRO->SetPosition(posX, posY, 2.0f);
            m_LevelSlots[i].pCompletedRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pBossCompletedRO->SetPosition(posX, posY, 0.0f);

            char number[4];

            if (i < 9)
            {
                sprintf(number, "0%i", i + 1);
            }
            else
            {

                sprintf(number, "%i", i + 1);
            }

            COLOR cFontBlueText = {1.0f, 1.0f, 1.0f, opacity};

#ifndef OZONE_PRE_RELEASE
            if (!isUnlocked)
            {
                cFontBlueText.a = MAT_Min(opacity, 0.50f);
            }
#endif

#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFont->Add(number, posX - 35.0f, posY - 15.0f, 0.0f, cFontBlueText);
#else
            m_pTextFont->Add(number, posX - 14.0f, posY - 5.0f, 0.0f, cFontBlueText);
#endif
        }
    }

    if (m_iCurrentPage == 0)
    {
        m_pLeftArrow[0]->Activate(false);
        m_pLeftArrow[1]->Activate(false);
    }
    else
    {
        m_pLeftArrow[0]->Activate(true);
    }
    if (m_iCurrentPage == ((m_iActiveSlots / 6) - 1))
    {
        m_pRightArrow[0]->Activate(false);
        m_pRightArrow[1]->Activate(false);
    }
    else
    {
        m_pRightArrow[0]->Activate(true);
    }

    m_pLeftArrow[0]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pLeftArrow[1]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pRightArrow[0]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pRightArrow[1]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pLeftArrow[0]->SetPosition(4.0f + (m_fArrowSineOffset * 4.0f), 380.0f, 0.0f);
    m_pLeftArrow[1]->SetPosition(4.0f + (m_fArrowSineOffset * 4.0f), 380.0f, 2.0f);
    m_pRightArrow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 62.0f - (m_fArrowSineOffset * 4.0f), 380.0f, 0.0f);
    m_pRightArrow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 62.0f - (m_fArrowSineOffset * 4.0f), 380.0f, 2.0f);
#else
    m_pLeftArrow[0]->SetPosition(2.0f + m_fArrowSineOffset, 146.0f, 0.0f);
    m_pLeftArrow[1]->SetPosition(2.0f + m_fArrowSineOffset, 146.0f, 2.0f);
    m_pRightArrow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 31.0f - m_fArrowSineOffset, 146.0f, 0.0f);
    m_pRightArrow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 31.0f - m_fArrowSineOffset, 146.0f, 2.0f);
#endif

    if (m_bWantToClose && m_pSelectionInterpolator->IsFinished())
    {
        m_bWantToClose = false;

        m_pFader->StartFade(0.0f, 0.0f, 0.0f, false, 0.5f, 90.0f);

        m_bGoingToLevel = true;
    }

    if (m_bGoingToLevel)
    {
        COLOR cFontWhite = {0.99f, 0.46f, 0.28f, m_pFader->GetAlpha()};
        m_pTextFont->Add("Loading...", 20.0f, 10.0f, 95.0f, cFontWhite);

        if (m_pFader->IsFinished())
        {
            m_bGoingToLevel = false;
            GameManager::Instance().ChangeState(&LevelGameState::Instance());
        }
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::InputCallbackBack(stInputCallbackParameter parameter, int inputID)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bWantToClose)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_BACK));

        Log("--------- input BACK\n");
        m_CurrentState = SUB_MENU_CLOSING;
        ResetInterpolators();
        m_fMenuOpacity = 0.0f;
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::InputCallbackArrowLeft(stInputCallbackParameter parameter, int inputID)
{
    if (parameter.type == PRESS_START && m_iCurrentPage != 0 && !m_bWantToClose)
    {
        m_pLeftArrow[1]->Activate(true);

        m_iCurrentPage--;

        if (m_iCurrentPage < 0)
            m_iCurrentPage = 0;

#ifdef GEARDOME_PLATFORM_IPAD
        if (m_pMovementInterpolator->IsActive())
        {
            m_pMovementInterpolator->Redefine(m_iCurrentPage * 1000.0f, m_fMovementOffset, 2.0f, 0.8f, true);
        }
        else
        {
            m_pMovementInterpolator->Reset();
            m_pMovementInterpolator->Redefine(m_iCurrentPage * 1000.0f, m_fMovementOffset, 2.0f, 0.8f, true);
            InterpolatorManager::Instance().Add(m_pMovementInterpolator, false);
        }
#else
        if (m_pMovementInterpolator->IsActive())
        {
            m_pMovementInterpolator->Redefine(m_iCurrentPage * 500.0f, m_fMovementOffset, 2.0f, 0.8f, true);
        }
        else
        {
            m_pMovementInterpolator->Reset();
            m_pMovementInterpolator->Redefine(m_iCurrentPage * 500.0f, m_fMovementOffset, 2.0f, 0.8f, true);
            InterpolatorManager::Instance().Add(m_pMovementInterpolator, false);
        }
#endif
    }
    else if (parameter.type == PRESS_END)
    {
        m_pLeftArrow[1]->Activate(false);
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::InputCallbackArrowRight(stInputCallbackParameter parameter, int inputID)
{
    int maxPage = (m_iActiveSlots / 6) - 1;

    if (parameter.type == PRESS_START && (m_iCurrentPage < maxPage) && !m_bWantToClose)
    {
        m_pRightArrow[1]->Activate(true);

        m_iCurrentPage++;

        if (m_iCurrentPage > maxPage)
            m_iCurrentPage = maxPage;

#ifdef GEARDOME_PLATFORM_IPAD
        if (m_pMovementInterpolator->IsActive())
        {
            m_pMovementInterpolator->Redefine(m_iCurrentPage * 1000.0f, m_fMovementOffset, 2.0f, 0.8f, true);
        }
        else
        {
            m_pMovementInterpolator->Reset();
            m_pMovementInterpolator->Redefine(m_iCurrentPage * 1000.0f, m_fMovementOffset, 2.0f, 0.8f, true);
            InterpolatorManager::Instance().Add(m_pMovementInterpolator, false);
        }
#else
        if (m_pMovementInterpolator->IsActive())
        {
            m_pMovementInterpolator->Redefine(m_iCurrentPage * 500.0f, m_fMovementOffset, 2.0f, 0.8f, true);
        }
        else
        {
            m_pMovementInterpolator->Reset();
            m_pMovementInterpolator->Redefine(m_iCurrentPage * 500.0f, m_fMovementOffset, 2.0f, 0.8f, true);
            InterpolatorManager::Instance().Add(m_pMovementInterpolator, false);
        }
#endif
    }
    else if (parameter.type == PRESS_END)
    {
        m_pRightArrow[1]->Activate(false);
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::InputCallbackAnySlot(stInputCallbackParameter parameter, int inputID)
{
    if ((parameter.type == PRESS_START) && (inputID < m_iActiveSlots) && !m_bWantToClose)
    {
        int i = inputID + (6 * m_iCurrentPage);

        bool isUnlocked = ((i == 0) ? true : SaveManager::Instance().IsLevelCompleted(m_iEpisode, i - 1));

#ifdef OZONE_LITE
        if ((m_iEpisode >= 1) && (i > 3))
        {
            isUnlocked = false;
        }
#endif

        if (GameManager::Instance().GetCheatPlayAllLevels())
        {
            isUnlocked = true;
        }

#if defined (OZONE_PRE_RELEASE)
        isUnlocked = true;
#endif

        if (isUnlocked)
        {
            m_iSelection = i;

            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_SELECTION));

            m_bWantToClose = true;

            m_pSelectionInterpolator->Reset();
            InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false);

            stCurrentEpisodeAndLevel state = MenuGameState::Instance().GetCurrentSelection();
            state.level = m_iSelection;
            state.customLevel = false;
            MenuGameState::Instance().SetCurrentSelection(state);

            PrepareLevelForImmediateLoading(m_pEpisode, m_iSelection, true);
        }
        #ifdef OZONE_LITE
        else
        {
            UIManager::Instance().RaiseEvent(UI_EVENT_ASKGOTOITUNES, m_pUICallbackItunes);
        }
        #endif
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::UICallbackItunes(int button, const char* szName)
{
    if (button == 1)
    {
#ifdef GEARDOME_PLATFORM_IPAD
        [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://itunes.ozonehd.com"]];
#else
        [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://ozone.itunes.geardome.com"]];
#endif
    }
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::PrepareLevelForImmediateLoading(Episode* episode, int level, bool changeMusic)
{
    std::string path = episode->GetLevelPathList()[level];

    std::string pathWithoutExtension = path.substr(0, path.find(".oil"));

    LevelGameState::Instance().PrepareLevelForLoading(pathWithoutExtension.c_str(), episode->GetFolder().c_str(), level, changeMusic);
}

//////////////////////////
//////////////////////////

void SubMenuLevelSelectionState::PrepareEpisode(Episode* episode, int episodeIndex)
{
    m_iEpisode = episodeIndex;

    m_iActiveSlots = episode->GetLevelPathList().size();

    for (int i = 0; i < m_iActiveSlots; i++)
    {
        m_LevelSlots[i].enabled = true;
    }
    for (int i = m_iActiveSlots; i < MAX_LEVEL_SLOTS; i++)
    {
        m_LevelSlots[i].enabled = false;
        m_LevelSlots[i].pNormalRO->Activate(false);
        m_LevelSlots[i].pBossRO->Activate(false);
        m_LevelSlots[i].pLockRO->Activate(false);
        m_LevelSlots[i].pBossCompletedRO->Activate(false);
        m_LevelSlots[i].pCompletedRO->Activate(false);
    }

    m_pEpisode = episode;
}