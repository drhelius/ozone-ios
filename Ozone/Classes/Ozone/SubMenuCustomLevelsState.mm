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
 *  SubMenuCustomLevelsState.cpp
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include <sys/types.h>
#include <sys/stat.h>
#include "gamemanager.h"
#include "levelgamestate.h"
#include "SubMenuCustomLevelsState.h"
#include "SubMenuMainState.h"
#include "menugamestate.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "audio.h"
#include "SaveManager.h"
#include "submenuepisodeselectionstate.h"


//////////////////////////
//////////////////////////

NSInteger lastModifiedSort(id path1, id path2, void* context)
{
    return [[path1 objectForKey:@"lastModDate"] compare:
            [path2 objectForKey:@"lastModDate"]];
}


//////////////////////////
//////////////////////////

SubMenuCustomLevelsState::SubMenuCustomLevelsState(void) : SubMenuState()
{
    Log("+++ SubMenuCustomLevelsState::SubMenuCustomLevelsState ...\n");

    InitPointer(m_pTextFont);
    InitPointer(m_pInputCallbackBack);
    InitPointer(m_pInputCallbackArrowLeft);
    InitPointer(m_pInputCallbackArrowRight);
    InitPointer(m_pInputCallbackAnySlot);
    InitPointer(m_pInputCallbackAnySlotDelete);    
    InitPointer(m_pInputCallbackDownload);
    InitPointer(m_pUICallbackDownload);
    InitPointer(m_pUICallbackDownloadCompleted);
    InitPointer(m_pUICallbackLevelDelete);

    InitPointer(m_pRenderableMidLayer2D);
    InitPointer(m_pBackButton);
    InitPointer(m_pDownloadButton);
    InitPointer(m_pMenuBar);

    InitPointer(m_pMenuOpacityInterpolator);
    InitPointer(m_pArrowsSineInterpolator);
    InitPointer(m_pMovementInterpolator);
    InitPointer(m_pSelectionInterpolator);

    InitPointer(m_pLeftArrow[0]);
    InitPointer(m_pLeftArrow[1]);
    InitPointer(m_pRightArrow[0]);
    InitPointer(m_pRightArrow[1]);

    for (int i = 0; i < MAX_LEVEL_SLOTS; i++)
    {

        m_LevelSlots[i].enabled = false;
        m_LevelSlots[i].completed = false;
        m_LevelSlots[i].locked = false;
        InitPointer(m_LevelSlots[i].pNormalRO);
        InitPointer(m_LevelSlots[i].pCompletedRO);
        InitPointer(m_LevelSlots[i].pBossRO);
        InitPointer(m_LevelSlots[i].pLockRO);
        InitPointer(m_LevelSlots[i].pBossCompletedRO);
    }

    m_bDownloadingLevel = false;
    m_bNeedCleanup = false;
    m_bWantToClose = false;
    m_bGoingToLevel = false;
    m_fMenuOpacity = 0.0f;
    m_fMovementOffset = 0.0f;
    m_fSelectionOpacity = 1.0f;
    m_iSelection = -1;
    m_iDeletedSlot = 0;

    Log("+++ SubMenuCustomLevelsState::SubMenuCustomLevelsState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuCustomLevelsState::~SubMenuCustomLevelsState(void)
{

    Log("+++ SubMenuCustomLevelsState::~SubMenuCustomLevelsState ...\n");

    Cleanup();

    Log("+++ SubMenuCustomLevelsState::~SubMenuCustomLevelsState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::Reset(void)
{

    Log("+++ SubMenuCustomLevelsState::Reset ...\n");

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
    m_iDeletedSlot = 0;

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

        InputManager::Instance().AddCircleRegionEvent(222.0f + (290.0f * column), 382.0f + (170.0f * row), 58, m_pInputCallbackAnySlot, i);
        InputManager::Instance().AddRectRegionEvent(267.0f + (290.0f * column), 430.0f + (170.0f * row), 35, 35, m_pInputCallbackAnySlotDelete, i);
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

        InputManager::Instance().AddCircleRegionEvent(104.0f + (136.0f * column), 165.0f + (75.0f * row), 30, m_pInputCallbackAnySlot, i);
        InputManager::Instance().AddRectRegionEvent(127.0f + (136.0f * column), 190.0f + (75.0f * row), 25, 25, m_pInputCallbackAnySlotDelete, i);
    }
#endif

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 280.0f, IPHONE_SCREEN_WIDTH - 70.0f, 200.0f, 70.0f, m_pInputCallbackDownload);
#else
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 150.0f, IPHONE_SCREEN_WIDTH - 35.0f, 150.0f, 35.0f, m_pInputCallbackDownload);
#endif

    ResetInterpolators();

    ReloadLevelsFromFolders();

    Log("+++ SubMenuCustomLevelsState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::ResetInterpolators(void)
{

    m_pMenuOpacityInterpolator->Continue();
    m_pMenuOpacityInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pMenuOpacityInterpolator, false);
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::Init(TextFont* pTextFont, Fader* pFader)
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

    Mesh* pMeshLock = MeshManager::Instance().GetBoardMesh(258, 327, 36, 36,
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

    Mesh* pMeshLock = MeshManager::Instance().GetBoardMesh(1, 168, 29, 26,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
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

#endif

    for (int i = 0; i < MAX_LEVEL_SLOTS; i++)
    {
        m_LevelSlots[i].pNormalRO->Activate(false);
        m_LevelSlots[i].pBossRO->Activate(false);
        m_LevelSlots[i].pLockRO->Activate(false);
        m_LevelSlots[i].pBossCompletedRO->Activate(false);
        m_LevelSlots[i].pCompletedRO->Activate(false);
    }

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


    m_pDownloadButton = new RenderObject();
    m_pDownloadButton->Init(MeshManager::Instance().GetBoardMesh(176, 49, 769, 593, 893, 942,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pDownloadButton->SetPosition(IPHONE_SCREEN_HEIGHT - 176, IPHONE_SCREEN_WIDTH - 60.0f, 0.0f);
    m_pDownloadButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pDownloadButton);

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


    m_pDownloadButton = new RenderObject();
    m_pDownloadButton->Init(MeshManager::Instance().GetBoardMesh(23, 74, 487, 510, 1, 75,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pDownloadButton->GetTransform(), MAT_ToRadians(-90.0f));
    m_pDownloadButton->SetPosition(IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH - 25.0f, 0.0f);
    m_pDownloadButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pDownloadButton);


    m_pMenuBar = new RenderObject();
    m_pMenuBar->Init(MeshManager::Instance().GetBoardMesh(27, 236, 512, 485, 329, 93,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pMenuBar->GetTransform(), MAT_ToRadians(90.0f));
    m_pMenuBar->SetPosition(0.0f, 115.0f, 0.0f);
    m_pMenuBar->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pMenuBar);
#endif

    m_pInputCallbackBack = new InputCallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::InputCallbackBack);
    m_pInputCallbackArrowLeft = new InputCallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::InputCallbackArrowLeft);
    m_pInputCallbackArrowRight = new InputCallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::InputCallbackArrowRight);
    m_pInputCallbackAnySlot = new InputCallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::InputCallbackAnySlot);
    m_pInputCallbackAnySlotDelete = new InputCallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::InputCallbackAnySlotDelete);
    m_pInputCallbackDownload = new InputCallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::InputCallbackDownload);
    m_pUICallbackDownload = new UICallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::UICallbackDownload);
    m_pUICallbackDownloadCompleted = new UICallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::UICallbackDownloadCompleted);
    m_pUICallbackLevelDelete = new UICallback<SubMenuCustomLevelsState > (this, &SubMenuCustomLevelsState::UICallbackLevelDelete);

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

void SubMenuCustomLevelsState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {

        Log("+++ SubMenuCustomLevelsState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);
        SafeDelete(m_pInputCallbackArrowLeft);
        SafeDelete(m_pInputCallbackArrowRight);
        SafeDelete(m_pInputCallbackAnySlot);
        SafeDelete(m_pInputCallbackAnySlotDelete); 
        SafeDelete(m_pInputCallbackDownload);
        SafeDelete(m_pUICallbackDownload);
        SafeDelete(m_pUICallbackDownloadCompleted);
        SafeDelete(m_pUICallbackLevelDelete);

        SafeDelete(m_pRenderableMidLayer2D);

        SafeDelete(m_pBackButton);
        SafeDelete(m_pDownloadButton);
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

        Log("+++ SubMenuCustomLevelsState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::UpdateLoading(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {

        m_CurrentState = SUB_MENU_IDLE;
    }
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::UpdateClosing(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {

        MenuGameState::Instance().SetSubMenu(&SubMenuMainState::Instance());
    }
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::Update(void)
{
    Renderer::Instance().Add(m_pRenderableMidLayer2D);

    float menuOpacity = (m_CurrentState == SUB_MENU_CLOSING) ? (1.0f - m_fMenuOpacity) : m_fMenuOpacity;

    COLOR cFont = {0.99f, 0.46f, 0.28f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("Select Your Level", 20.0f, 200.0f, 0.0f, cFont);
#else
    m_pTextFont->Add("Select Your Level", 10.0f, 86.0f, 0.0f, cFont);
#endif

    m_pMenuBar->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);


    m_pBackButton->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    COLOR cFontBlue = {1.0f, 1.0f, 1.0f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("BACK", 40.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBlue);
    m_pTextFont->Add("Upload Level", IPHONE_SCREEN_HEIGHT - 280.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBlue);
#else
    m_pTextFont->Add("BACK", 20.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBlue);
    m_pTextFont->Add("Upload Level", IPHONE_SCREEN_HEIGHT - 125.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBlue);
#endif



    int column = 0;
    int row = 0;
    int page = 0;

    for (int i = 0; i < MAX_LEVEL_SLOTS; i++)
    {
        m_LevelSlots[i].pNormalRO->Activate(false);
        m_LevelSlots[i].pBossRO->Activate(false);
        m_LevelSlots[i].pLockRO->Activate(false);
        m_LevelSlots[i].pBossCompletedRO->Activate(false);
        m_LevelSlots[i].pCompletedRO->Activate(false);

        if (m_LevelSlots[i].enabled)
        {
            m_LevelSlots[i].pNormalRO->Activate(true);
            m_LevelSlots[i].pLockRO->Activate(true);

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

#ifdef GEARDOME_PLATFORM_IPAD
            m_LevelSlots[i].pNormalRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pBossRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pLockRO->SetPosition(posX + 95, posY + 95, 2.0f);
            m_LevelSlots[i].pCompletedRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pBossCompletedRO->SetPosition(posX, posY, 0.0f);
#else
            m_LevelSlots[i].pNormalRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pBossRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pLockRO->SetPosition(posX + 43, posY + 43, 2.0f);
            m_LevelSlots[i].pCompletedRO->SetPosition(posX, posY, 0.0f);
            m_LevelSlots[i].pBossCompletedRO->SetPosition(posX, posY, 0.0f);
#endif

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
    if ((m_iActiveSlots == 0) || (m_iCurrentPage == ((m_iActiveSlots / 6) - ((m_iActiveSlots % 6) == 0 ? 1 : 0))))
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

void SubMenuCustomLevelsState::InputCallbackBack(stInputCallbackParameter parameter, int inputID)
{
    if (!m_bDownloadingLevel && m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bWantToClose)
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

void SubMenuCustomLevelsState::InputCallbackArrowLeft(stInputCallbackParameter parameter, int inputID)
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

void SubMenuCustomLevelsState::InputCallbackArrowRight(stInputCallbackParameter parameter, int inputID)
{
    int maxPage = ((m_iActiveSlots / 6) - ((m_iActiveSlots % 6) == 0 ? 1 : 0));

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

void SubMenuCustomLevelsState::InputCallbackAnySlot(stInputCallbackParameter parameter, int inputID)
{
    int i = inputID + (6 * m_iCurrentPage);

    if (!m_bDownloadingLevel && (parameter.type == PRESS_START) && (i < m_iActiveSlots) && !m_bWantToClose)
    {
        m_iSelection = i;

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_SELECTION));

        m_bWantToClose = true;

        m_pSelectionInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false);

        PrepareLevelForImmediateLoading(m_iSelection);
    }
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::InputCallbackAnySlotDelete(stInputCallbackParameter parameter, int inputID)
{
    int i = inputID + (6 * m_iCurrentPage);

    if (!m_bDownloadingLevel && (parameter.type == PRESS_START) && (i < m_iActiveSlots) && !m_bWantToClose)
    {
        m_iDeletedSlot = i;
        UIManager::Instance().RaiseEvent(UI_EVENT_LEVELDELETE, m_pUICallbackLevelDelete);
    }
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::UICallbackLevelDelete(int button, const char* szName)
{
    if (button == 1)
    {
       NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

        if ([paths count] == 1) {

            NSString *levelPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"levels"];

            NSError* error = nil;

            NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:levelPath
                                                                                 error:&error];
            if(error == nil)
            {
                NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[files count]];
                for(NSString* path in files)
                {
                    struct tm* date;                    // create a time structure
                    struct stat attrib;                 // create a file attribute structure
                    char fullPath[256];

                    sprintf(fullPath, "%s/%s", [levelPath cStringUsingEncoding : 1], [path cStringUsingEncoding : 1]);

                    stat(fullPath, &attrib);   // get the attributes of afile.txt

                    date = gmtime(&(attrib.st_mtime));  // Get the last modified time and put it into the time structure

                    NSDateComponents *comps = [[NSDateComponents alloc] init];
                    [comps setSecond:   date->tm_sec];
                    [comps setMinute:   date->tm_min];
                    [comps setHour:     date->tm_hour];
                    [comps setDay:      date->tm_mday];
                    [comps setMonth:    date->tm_mon + 1];
                    [comps setYear:     date->tm_year + 1900];

                    NSCalendar *cal = [NSCalendar currentCalendar];
                    NSDate *modificationDate = [[cal dateFromComponents:comps] addTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];

                    [comps release];

                    [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys: path, @"path", modificationDate, @"lastModDate", nil]];
                }

                NSArray* sortedFiles = [filesAndProperties sortedArrayUsingFunction:&lastModifiedSort
                                                               context:nil];

                int a = 0;
                for(NSDictionary* dic in sortedFiles)
                {
                    if (a == m_iDeletedSlot)
                    {
                        char fullPath[256];

                        sprintf(fullPath, "%s/%s", [levelPath cStringUsingEncoding : 1], [[dic objectForKey:@"path"] cStringUsingEncoding : 1]);

                        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithCString : fullPath encoding : [NSString defaultCStringEncoding]] error:NULL];

                        ReloadLevelsFromFolders();

                        break;
                    }
                    a++;
                }
            }
        }
    }
    else
    {

    }
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::UICallbackDownload(int button, const char* szName)
{
    if (button == 1)
    {
        char szFinalCode[256];
        UTIL_ToUpper(szName, szFinalCode);

        GameManager::Instance().SetDownloadCode(szFinalCode);
        UIManager::Instance().RaiseEvent(UI_EVENT_LEVELDOWNLOAD, m_pUICallbackDownloadCompleted);
    }
    else
    {
        m_bDownloadingLevel = false;
    }
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::UICallbackDownloadCompleted(int button, const char* szName)
{
    ReloadLevelsFromFolders();
    m_bDownloadingLevel = false;
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::PrepareLevelForImmediateLoading(int level)
{

    const char* path = m_LevelPathList[level].c_str();
    
    FILE* pFile = fopen(path, "r");

    if (pFile == NULL)
    {
        Log("@@@ SubMenuCustomLevelsState::PrepareLevelForImmediateLoading Imposible abrir el nivel: %s\n", path);
        return;
    }

    int offset;
    int gemCount;
    char episode_s[30];
    u8 len;

    fseek(pFile, -5, SEEK_END);
    fread(&offset, sizeof (int), 1, pFile);

    fseek(pFile, -9, SEEK_END);
    fread(&gemCount, sizeof (int), 1, pFile);

    fseek(pFile, -offset - 1, SEEK_END);
    fread(&len, sizeof (u8), 1, pFile);
    fread(&episode_s, sizeof (char), len, pFile);
    episode_s[len] = 0;

    fclose(pFile);

    int episode_i = 0;

    if (strcmp(episode_s, "00_tutorial") == 0)
    {
        episode_i = 0;
    }
    else if (strcmp(episode_s, "01_earth") == 0)
    {
        episode_i = 1;
    }
    else if (strcmp(episode_s, "02_vulcan") == 0)
    {
        episode_i = 2;
    }
    else if (strcmp(episode_s, "03_ocean") == 0)
    {
        episode_i = 3;
    }
    else if (strcmp(episode_s, "04_space") == 0)
    {
        episode_i = 4;
    }

    Episode* episode = SubMenuEpisodeSelectionState::Instance().GetEpisode(episode_i);

    stCurrentEpisodeAndLevel state = MenuGameState::Instance().GetCurrentSelection();
    state.level = m_iSelection;
    state.episode = episode_i;
    state.customLevel = true;
    MenuGameState::Instance().SetCurrentSelection(state);
        
    LevelGameState::Instance().PrepareLevelForLoading(path, episode->GetFolder().c_str(), level, true, true);
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::InputCallbackDownload(stInputCallbackParameter parameter, int inputID)
{
    if (!m_bDownloadingLevel && m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bWantToClose)
    {
        Log("--------- input download\n");
        m_bDownloadingLevel = true;
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_SELECTION));
        UIManager::Instance().RaiseEvent(UI_EVENT_ASKLEVELDOWNLOAD, m_pUICallbackDownload);
    }
}

//////////////////////////
//////////////////////////

void SubMenuCustomLevelsState::ReloadLevelsFromFolders(void)
{
    m_LevelPathList.clear();

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    if ([paths count] == 1) {             

        NSString *levelPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"levels"];

        NSError* error = nil;

        NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:levelPath
                                                                             error:&error];
        if(error == nil)
        {
            NSMutableArray* filesAndProperties = [NSMutableArray arrayWithCapacity:[files count]];
            for(NSString* path in files)
            {
                struct tm* date;                    // create a time structure
                struct stat attrib;                 // create a file attribute structure
                char fullPath[256];

                sprintf(fullPath, "%s/%s", [levelPath cStringUsingEncoding : 1], [path cStringUsingEncoding : 1]);

                stat(fullPath, &attrib);   // get the attributes of afile.txt

                date = gmtime(&(attrib.st_mtime));  // Get the last modified time and put it into the time structure

                NSDateComponents *comps = [[NSDateComponents alloc] init];
                [comps setSecond:   date->tm_sec];
                [comps setMinute:   date->tm_min];
                [comps setHour:     date->tm_hour];
                [comps setDay:      date->tm_mday];
                [comps setMonth:    date->tm_mon + 1];
                [comps setYear:     date->tm_year + 1900];

                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDate *modificationDate = [[cal dateFromComponents:comps] addTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];

                [comps release];

                [filesAndProperties addObject:[NSDictionary dictionaryWithObjectsAndKeys: path, @"path", modificationDate, @"lastModDate", nil]];
            }

            NSArray* sortedFiles = [filesAndProperties sortedArrayUsingFunction:&lastModifiedSort
                                                           context:nil];

            for(NSDictionary* dic in sortedFiles)
            {
                char fullPath[256];

                sprintf(fullPath, "%s/%s", [levelPath cStringUsingEncoding : 1], [[dic objectForKey:@"path"] cStringUsingEncoding : 1]);

                m_LevelPathList.push_back(fullPath);
            }
        }
        
        m_iActiveSlots =m_LevelPathList.size();

        if (m_iActiveSlots > 30)
        {
            m_iActiveSlots = 30;
        }

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
    }
}