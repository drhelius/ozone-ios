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
 *  SubMenuSaveSelectionState.cpp
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "SubMenuSaveSelectionState.h"
#include "menugamestate.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "SubMenuEpisodeSelectionState.h"
#include "audio.h"
#include "SaveManager.h"
#include "gamemanager.h"

//////////////////////////
//////////////////////////

SubMenuSaveSelectionState::SubMenuSaveSelectionState(void) : SubMenuState()
{
    Log("+++ SubMenuSaveSelectionState::SubMenuSaveSelectionState ...\n");

    InitPointer(m_pTextFont);

    InitPointer(m_pInputCallbackBack);
    InitPointer(m_pInputCallbackSlot);
    InitPointer(m_pInputCallbackDelete);
    InitPointer(m_pUICallbackName);
    InitPointer(m_pUICallbackDelete);

    InitPointer(m_pRenderableMidLayer2D);

    for (int i = 0; i < 3; i++)
    {
        InitPointer(m_SaveSlots[i].pRO);
        InitPointer(m_SaveSlots[i].pROdelete);
        m_SaveSlots[i].fAlpha = 0.0f;
        m_SaveSlots[i].used = false;
    }

    InitPointer(m_pBackButton);
    InitPointer(m_pMenuBar);

    InitPointer(m_pMenuOpacityInterpolator);
    InitPointer(m_pSelectionInterpolator);

    m_bShowingAlert = false;
    m_bEnteringName = false;
    m_bNeedCleanup = false;
    m_fMenuOpacity = 0.0f;
    m_bWantToClose = false;
    m_bWantToShowAlert = false;
    m_fSelectionOpacity = 1.0f;
    m_iSelection = -1;
    m_iClearSelection = -1;

    Log("+++ SubMenuSaveSelectionState::SubMenuSaveSelectionState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuSaveSelectionState::~SubMenuSaveSelectionState(void)
{
    Log("+++ SubMenuSaveSelectionState::~SubMenuSaveSelectionState ...\n");

    Cleanup();

    Log("+++ SubMenuSaveSelectionState::~SubMenuSaveSelectionState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::Reset(void)
{
    Log("+++ SubMenuSaveSelectionState::Reset ...\n");

    InputManager::Instance().ClearRegionEvents();

    m_bShowingAlert = false;
    m_bEnteringName = false;
    m_bFinishing = false;
    m_CurrentState = SUB_MENU_LOADING;
    m_fMenuOpacity = 0.0f;
    m_pChangingToMenu = NULL;
    m_bWantToClose = false;
    m_bWantToShowAlert = false;
    m_fSelectionOpacity = 1.0f;
    m_iSelection = -1;
    m_iClearSelection = -1;

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 70.0f, 200.0f, 70.0f, m_pInputCallbackBack);
#else
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 35.0f, 100.0f, 35.0f, m_pInputCallbackBack);
#endif

    for (int i = 0; i < 3; i++)
    {

#ifdef GEARDOME_PLATFORM_IPAD
        InputManager::Instance().AddRectRegionEvent(3.0f + (i * 338.0f), 310.0f, 343.0f, 283.0f, m_pInputCallbackSlot, i);
        InputManager::Instance().AddRectRegionEvent(106.0f + (i * 338.0f), 310.0f + 300.0f, 136.0f, 39.0f, m_pInputCallbackDelete, i);
#else
        InputManager::Instance().AddRectRegionEvent(17.0f + (i * 154.0f), 120.0f, 137.0f, 137.0f, m_pInputCallbackSlot, i);
        InputManager::Instance().AddRectRegionEvent(17.0f + (i * 154.0f), 120.0f + 137.0f, 137.0f, 35.0f, m_pInputCallbackDelete, i);
#endif

        stSaveSlot* pSlot = SaveManager::Instance().GetSlot(i);

        m_SaveSlots[i].used = pSlot->used;

        if (m_SaveSlots[i].used)
        {
            strcpy(m_SaveSlots[i].name, pSlot->name);

            struct tm* timeinfo;
            timeinfo = localtime(&pSlot->date);
            strftime(m_SaveSlots[i].date, 30, "%Y/%m/%d %H:%M", timeinfo);
/*
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeStyle : NSDateFormatterShortStyle];
            [dateFormatter setDateStyle : NSDateFormatterShortStyle];

            NSDate *date = [NSDate dateWithTimeIntervalSince1970 : pSlot->date];

            NSLocale *currentLocale = [NSLocale currentLocale];

            [dateFormatter setLocale : currentLocale];

            NSString *strDate = [dateFormatter stringFromDate : date];
            strcpy(m_SaveSlots[i].date, [strDate cStringUsingEncoding : 1]);

            [dateFormatter release];
*/
            sprintf(m_SaveSlots[i].score, "Score: %d", pSlot->score);

            int currentEpisode = 0;
            int currentLevel = 0;

            for (int episode = 0; episode < MAX_EPISODE_SLOTS; episode++)
            {
                for (int level = 0; level < (episode == 0 ? 6 : MAX_LEVELS_PER_EPISODE); level++)
                {
                    if (!pSlot->level_complete[episode][level])
                    {
                        break;
                    }

                    currentLevel = level + 1;
                    currentEpisode = episode;

                    if (currentLevel >= (episode == 0 ? 6 : MAX_LEVELS_PER_EPISODE))
                    {
                        currentLevel = 0;
                        currentEpisode = episode + 1;
                    }
                }
            }

            sprintf(m_SaveSlots[i].level, "Level %d", currentLevel + 1);

            switch (currentEpisode)
            {
                case 0:
                {
                    sprintf(m_SaveSlots[i].title, "Tutorial - %d", currentLevel + 1);
                    break;
                }
                case 1:
                {
                    sprintf(m_SaveSlots[i].title, "Earth - %d", currentLevel + 1);
                    break;
                }
                case 2:
                {
                    sprintf(m_SaveSlots[i].title, "Vulcan - %d", currentLevel + 1);
                    break;
                }
                case 3:
                {
                    sprintf(m_SaveSlots[i].title, "Ocean - %d", currentLevel + 1);
                    break;
                }
                case 4:
                {
                    sprintf(m_SaveSlots[i].title, "Space - %d", currentLevel + 1);
                    break;
                }
            }
        }
    }

    ResetInterpolatorOpacity();

    Log("+++ SubMenuSaveSelectionState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::ResetInterpolatorOpacity(void)
{
    m_pMenuOpacityInterpolator->Continue();
    m_pMenuOpacityInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pMenuOpacityInterpolator, false);
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::Init(TextFont* pTextFont, Fader* pFader)
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

    Mesh* pMeshSquare = MeshManager::Instance().GetBoardMesh(0, 0, 343, 283,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pMeshDelete = MeshManager::Instance().GetBoardMesh(1, 284, 136, 39,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());

    for (int i = 0; i < 3; i++)
    {
        m_SaveSlots[i].pRO = new RenderObject();
        m_SaveSlots[i].pRO->Init(pMeshSquare, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_SaveSlots[i].pRO->SetPosition(3.0f + (i * 338.0f), 310.0f, 0.0f);
        m_SaveSlots[i].pRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_SaveSlots[i].pRO);

        m_SaveSlots[i].pROdelete = new RenderObject();
        m_SaveSlots[i].pROdelete->Init(pMeshDelete, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_SaveSlots[i].pROdelete->SetPosition(106.0f + (i * 338.0f), 310.0f + 300.0f, 0.0f);
        m_SaveSlots[i].pROdelete->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_SaveSlots[i].pROdelete);
    }
#else

    Mesh* pMeshSquare = MeshManager::Instance().GetBoardMesh(0, 0, 149, 137,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());
    Mesh* pMeshDelete = MeshManager::Instance().GetBoardMesh(0, 138, 126, 29,
            pTexMenu02->GetWidth(), pTexMenu02->GetHeight());

    for (int i = 0; i < 3; i++)
    {
        m_SaveSlots[i].pRO = new RenderObject();
        m_SaveSlots[i].pRO->Init(pMeshSquare, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_SaveSlots[i].pRO->SetPosition(11.0f + (i * 154.0f), 120.0f, 0.0f);
        m_SaveSlots[i].pRO->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_SaveSlots[i].pRO);

        m_SaveSlots[i].pROdelete = new RenderObject();
        m_SaveSlots[i].pROdelete->Init(pMeshDelete, pTexMenu02, RENDER_OBJECT_TRANSPARENT);
        m_SaveSlots[i].pROdelete->SetPosition(21.0f + (i * 154.0f), 120.0f + 137.0f, 0.0f);
        m_SaveSlots[i].pROdelete->UseColor(true);
        m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_SaveSlots[i].pROdelete);
    }
#endif    

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

    m_pInputCallbackBack = new InputCallback<SubMenuSaveSelectionState > (this, &SubMenuSaveSelectionState::InputCallbackBack);
    m_pInputCallbackSlot = new InputCallback<SubMenuSaveSelectionState > (this, &SubMenuSaveSelectionState::InputCallbackSlot);
    m_pInputCallbackDelete = new InputCallback<SubMenuSaveSelectionState > (this, &SubMenuSaveSelectionState::InputCallbackDelete);

    m_pUICallbackName = new UICallback<SubMenuSaveSelectionState > (this, &SubMenuSaveSelectionState::UICallbackName);
    m_pUICallbackDelete = new UICallback<SubMenuSaveSelectionState > (this, &SubMenuSaveSelectionState::UICallbackDelete);

    m_pMenuOpacityInterpolator = new LinearInterpolator(&m_fMenuOpacity, 0.0f, 1.0f, 0.3f);
    m_pSelectionInterpolator = new CosineInterpolator(&m_fSelectionOpacity, 1.0f, 0.0f, 0.25f, true, 0.5f);

    m_pMenuOpacityInterpolator->Pause();

    Log("+++ SubMenuSaveSelectionState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {

        Log("+++ SubMenuSaveSelectionState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);
        SafeDelete(m_pInputCallbackSlot);
        SafeDelete(m_pInputCallbackDelete);
        SafeDelete(m_pUICallbackName);
        SafeDelete(m_pUICallbackDelete);

        SafeDelete(m_pRenderableMidLayer2D);

        for (int i = 0; i < 3; i++)
        {
            SafeDelete(m_SaveSlots[i].pRO);
            SafeDelete(m_SaveSlots[i].pROdelete);
        }

        SafeDelete(m_pBackButton);
        SafeDelete(m_pMenuBar);

        SafeDelete(m_pMenuOpacityInterpolator);
        SafeDelete(m_pSelectionInterpolator);

        InputManager::Instance().ClearRegionEvents();

        m_bNeedCleanup = false;

        Log("+++ SubMenuSaveSelectionState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::UpdateLoading(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        m_CurrentState = SUB_MENU_IDLE;
    }
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::UpdateClosing(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        MenuGameState::Instance().SetSubMenu(m_pChangingToMenu);
    }
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::Update(void)
{
    Renderer::Instance().Add(m_pRenderableMidLayer2D);

    float menuOpacity = (m_CurrentState == SUB_MENU_CLOSING) ? (1.0f - m_fMenuOpacity) : m_fMenuOpacity;

    COLOR cFont = {0.99f, 0.46f, 0.28f, menuOpacity};


#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("Select Save Slot", 20.0f, 200.0f, 0.0f, cFont);
#else
    m_pTextFont->Add("Select Save Slot", 10.0f, 86.0f, 0.0f, cFont);
#endif

    //// EMPTY



    m_pMenuBar->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    for (int i = 0; i < 3; i++)
    {
        float opacity = menuOpacity;

        if (m_iSelection == i)
        {
            opacity = MAT_Min(opacity, m_fSelectionOpacity);
        }

        m_SaveSlots[i].pRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
        m_SaveSlots[i].pROdelete->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

        m_SaveSlots[i].pROdelete->Activate(m_SaveSlots[i].used);

#ifdef GEARDOME_PLATFORM_IPAD
        //m_SaveSlots[i].pRO->SetPosition(22.0f + (i * 330.0f), 310.0f, 0.0f);
        if (m_SaveSlots[i].used)
        {
            COLOR cFont1 = {1.0f, 1.0f, 1.0f, opacity};
            COLOR cFontName = {0.49f, 0.93f, 0.97f, opacity};
            m_pTextFont->Add(m_SaveSlots[i].name, 173.0f + (i * 338.0f), 320.0f, 0.0f, cFontName, true);
            m_pTextFont->Add(m_SaveSlots[i].date, 173.0f + (i * 338.0f), 390.0f, 0.0f, cFont1, true);
            m_pTextFont->Add(m_SaveSlots[i].title, 173.0f + (i * 338.0f), 470.0f, 0.0f, cFont1, true);
            m_pTextFont->Add(m_SaveSlots[i].score, 173.0f + (i * 338.0f), 520.0f, 0.0f, cFont1, true);
        }
        else
        {
            COLOR cFontEmpty = {1.0f, 1.0f, 1.0f, opacity};
            m_pTextFont->Add("EMPTY", 173.0f + (i * 338.0f), 360.0f, 0.0f, cFontEmpty, true);
        }
#else
        if (m_SaveSlots[i].used)
        {
            COLOR cFont1 = {1.0f, 1.0f, 1.0f, opacity};
            COLOR cFontName = {0.49f, 0.93f, 0.97f, opacity};
            m_pTextFont->Add(m_SaveSlots[i].name, 85.0f + (i * 154.0f), 130.0f, 0.0f, cFontName, true);
            m_pTextFont->Add(m_SaveSlots[i].date, 85.0f + (i * 154.0f), 152.0f, 0.0f, cFont1, true);
            m_pTextFont->Add(m_SaveSlots[i].title, 85.0f + (i * 154.0f), 196.0f, 0.0f, cFont1, true);
            m_pTextFont->Add(m_SaveSlots[i].score, 85.0f + (i * 154.0f), 218.0f, 0.0f, cFont1, true);
        }
        else
        {
            COLOR cFontEmpty = {1.0f, 1.0f, 1.0f, opacity};
            m_pTextFont->Add("EMPTY", 85.0f + (i * 154.0f), 148.0f, 0.0f, cFontEmpty, true);
        }
#endif
    }

    m_pBackButton->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    COLOR cFontBack = {1.0f, 1.0f, 1.0f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("BACK", 40.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBack);
#else
    m_pTextFont->Add("BACK", 20.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBack);
#endif

    if (m_bWantToShowAlert && m_pSelectionInterpolator->IsFinished())
    {
        m_bWantToShowAlert = false;
        //UIManager::Instance().RaiseEvent(UI_EVENT_ENTERNAME, m_pUICallbackName);
    }

    if (m_bWantToClose && !m_bEnteringName && m_pSelectionInterpolator->IsFinished())
    {
        m_bWantToClose = false;
        m_CurrentState = SUB_MENU_CLOSING;
        ResetInterpolatorOpacity();
        m_fMenuOpacity = 0.0f;
        m_pChangingToMenu = &SubMenuEpisodeSelectionState::Instance();
    }
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::InputCallbackBack(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bWantToClose)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_BACK));

        Log("--------- input BACK\n");
        m_CurrentState = SUB_MENU_CLOSING;
        ResetInterpolatorOpacity();
        m_fMenuOpacity = 0.0f;
        m_pChangingToMenu = &SubMenuMainState::Instance();
    }
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::InputCallbackSlot(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bWantToClose && !m_bShowingAlert)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_SELECTION));

        m_bWantToClose = true;

        m_pSelectionInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false);

        m_iSelection = id;

        if (!m_SaveSlots[m_iSelection].used)
        {
            m_bWantToShowAlert = true;
            m_bEnteringName = true;
            UIManager::Instance().RaiseEvent(UI_EVENT_ENTERNAME, m_pUICallbackName);
        }
        else
        {
            SaveManager::Instance().SetCurrentSlot(m_iSelection);
        }
    }
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::InputCallbackDelete(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bWantToClose && !m_bShowingAlert)
    {
        if (m_SaveSlots[id].used)
        {
            m_bShowingAlert = true;
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_SELECTION));
            m_iClearSelection = id;
            UIManager::Instance().RaiseEvent(UI_EVENT_DELETESAVESLOT, m_pUICallbackDelete);
        }
    }
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::UICallbackName(int button, const char* szName)
{
    Log("--------- UICallbackName %d %s\n", button, szName);

    ///--- ok
    if ((button == 1) && (strlen(szName) > 0))
    {
        m_bEnteringName = false;
        SaveManager::Instance().SetCurrentSlot(m_iSelection);
        SaveManager::Instance().UseSlot(m_iSelection);
        SaveManager::Instance().SetName(szName);
        SaveManager::Instance().SetCurrentSlot(m_iSelection);
    }
    else
    {
        m_bWantToClose = false;
        m_bEnteringName = false;
        m_iSelection = -1;
    }
}

//////////////////////////
//////////////////////////

void SubMenuSaveSelectionState::UICallbackDelete(int button, const char* text)
{
    Log("--------- UICallbackDelete %d\n", button);

    m_bShowingAlert = false;

    ///--- ok
    if (button == 1)
    {
        SaveManager::Instance().ClearSlot(m_iClearSelection);
        m_SaveSlots[m_iClearSelection].used = false;
    }
}