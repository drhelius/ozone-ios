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
 * File:   SubMenuHelpState.mm
 * Author: nacho
 * 
 * Created on 3 de marzo de 2010, 17:42
 */

#include "SubMenuHelpState.h"
#include "menugamestate.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "audio.h"

//////////////////////////
//////////////////////////

SubMenuHelpState::SubMenuHelpState(void) : SubMenuState()
{
    Log("+++ SubMenuHelpState::SubMenuHelpState ...\n");

    InitPointer(m_pTextFont);
    InitPointer(m_pInputCallbackBack);
    InitPointer(m_pInputCallbackArrowLeft);
    InitPointer(m_pInputCallbackArrowRight);
    InitPointer(m_pInputCallbackBack);

    InitPointer(m_pLeftArrow[0]);
    InitPointer(m_pLeftArrow[1]);
    InitPointer(m_pRightArrow[0]);
    InitPointer(m_pRightArrow[1]);

    InitPointer(m_pRenderableMidLayer2D);
    InitPointer(m_pBackground[0]);
    InitPointer(m_pBackground[1]);
    InitPointer(m_pBackButton);

    InitPointer(m_pMenuOpacityInterpolator);
    InitPointer(m_pArrowsSineInterpolator);
    InitPointer(m_pMovementInterpolator);

    m_fMenuOpacity = 0.0f;
    m_fMovementOffset = 0.0f;

    m_bNeedCleanup = false;

    Log("+++ SubMenuHelpState::SubMenuHelpState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuHelpState::~SubMenuHelpState(void)
{
    Log("+++ SubMenuHelpState::~SubMenuHelpState ...\n");

    Cleanup();

    Log("+++ SubMenuHelpState::~SubMenuHelpState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::Reset(void)
{
    Log("+++ SubMenuHelpState::Reset ...\n");

    InputManager::Instance().ClearRegionEvents();

    m_bFinishing = false;
    m_CurrentState = SUB_MENU_LOADING;
    m_fMenuOpacity = 0.0f;
    m_fArrowSineOffset = 0.0f;
    m_iCurrentPage = 0;
    m_fMovementOffset = 0.0f;
    m_pChangingToMenu = NULL;

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 70.0f, 200.0f, 70.0f, m_pInputCallbackBack);

    InputManager::Instance().AddRectRegionEvent(0.0f, 380.0f, 72.0f, 98.0f, m_pInputCallbackArrowLeft);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 72.0f, 380.0f, 72.0f, 98.0f, m_pInputCallbackArrowRight);
#else
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 35.0f, 100.0f, 35.0f, m_pInputCallbackBack);

    InputManager::Instance().AddRectRegionEvent(0.0f, 140.0f, 36.0f, 63.0f, m_pInputCallbackArrowLeft);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 36.0f, 140.0f, 36.0f, 63.0f, m_pInputCallbackArrowRight);
#endif

    ResetInterpolators();

    Log("+++ SubMenuHelpState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::Init(TextFont* pTextFont, Fader* pFader)
{
    Log("+++ SubMenuHelpState::Init ...\n");

    m_bNeedCleanup = true;
    m_pTextFont = pTextFont;
    m_pFader = pFader;

    Texture* pTexMenu01 = TextureManager::Instance().GetTexture("menu/gfx/menu_01");
    Texture* pTexHelp = TextureManager::Instance().GetTexture("menu/gfx/help_01");

    m_pRenderableMidLayer2D = new Renderable();
    m_pRenderableMidLayer2D->Set3D(false);
    m_pRenderableMidLayer2D->SetLayer(600);

#ifdef GEARDOME_PLATFORM_IPAD

    Mesh* pUpArrow = MeshManager::Instance().GetBoardMesh(917, 926, 52, 98,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrow = MeshManager::Instance().GetBoardMesh(971, 926, 52, 98,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pUpArrowLeft = MeshManager::Instance().GetBoardMesh(52, 98, 969, 917, 926, 1024,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrowLeft = MeshManager::Instance().GetBoardMesh(52, 98, 1023, 971, 926, 1024,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
#else

    Mesh* pUpArrow = MeshManager::Instance().GetBoardMesh(157, 458, 29, 51,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrow = MeshManager::Instance().GetBoardMesh(127, 458, 29, 51,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pUpArrowLeft = MeshManager::Instance().GetBoardMesh(29, 51, 186, 157, 509, 458,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrowLeft = MeshManager::Instance().GetBoardMesh(29, 51, 156, 127, 509, 458,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
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
    m_pLeftArrow[1]->Activate(false);

    m_pRightArrow[0]->Init(pDownArrow, pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pRightArrow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 29.0f, 146.0f, 0.0f);
    m_pRightArrow[0]->UseColor(true);
    m_pRightArrow[1]->Init(pUpArrow, pTexMenu01, RENDER_OBJECT_ADDITIVE);
    m_pRightArrow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 29.0f, 146.0f, 2.0f);
    m_pRightArrow[1]->UseColor(true);
    m_pRightArrow[1]->Activate(false);

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

    m_pBackground[0] = new RenderObject();
    m_pBackground[0]->Init(MeshManager::Instance().GetBoardMesh(2, 2, 841, 447,
            pTexHelp->GetWidth(), pTexHelp->GetHeight()), pTexHelp, RENDER_OBJECT_TRANSPARENT);
    m_pBackground[0]->SetPosition(45.0f, 80.0f, 0.0f);
    m_pBackground[0]->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackground[0]);

    m_pBackground[1] = new RenderObject();
    m_pBackground[1]->Init(MeshManager::Instance().GetBoardMesh(2, 450, 841, 447,
            pTexHelp->GetWidth(), pTexHelp->GetHeight()), pTexHelp, RENDER_OBJECT_TRANSPARENT);
    m_pBackground[1]->SetPosition(45.0f, 80.0f, 0.0f);
    m_pBackground[1]->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackground[1]);
#else
    m_pBackButton = new RenderObject();
    m_pBackButton->Init(MeshManager::Instance().GetBoardMesh(23, 74, 510, 487, 1, 75,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pBackButton->GetTransform(), MAT_ToRadians(90.0f));
    m_pBackButton->SetPosition(0.0f, IPHONE_SCREEN_HEIGHT - 163.0f, 0.0f);
    m_pBackButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackButton);

    m_pBackground[0] = new RenderObject();
    m_pBackground[0]->Init(MeshManager::Instance().GetBoardMesh(0, 0, 395, 211,
            pTexHelp->GetWidth(), pTexHelp->GetHeight()), pTexHelp, RENDER_OBJECT_TRANSPARENT);
    m_pBackground[0]->SetPosition(45.0f, 80.0f, 0.0f);
    m_pBackground[0]->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackground[0]);

    m_pBackground[1] = new RenderObject();
    m_pBackground[1]->Init(MeshManager::Instance().GetBoardMesh(0, 212, 395, 211,
            pTexHelp->GetWidth(), pTexHelp->GetHeight()), pTexHelp, RENDER_OBJECT_TRANSPARENT);
    m_pBackground[1]->SetPosition(45.0f, 80.0f, 0.0f);
    m_pBackground[1]->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackground[1]);
#endif

    m_pInputCallbackBack = new InputCallback<SubMenuHelpState > (this, &SubMenuHelpState::InputCallbackBack);
    m_pInputCallbackArrowLeft = new InputCallback<SubMenuHelpState > (this, &SubMenuHelpState::InputCallbackArrowLeft);
    m_pInputCallbackArrowRight = new InputCallback<SubMenuHelpState > (this, &SubMenuHelpState::InputCallbackArrowRight);

    m_pMenuOpacityInterpolator = new LinearInterpolator(&m_fMenuOpacity, 0.0f, 1.0f, 0.3f);
    m_pArrowsSineInterpolator = new SineInterpolator(&m_fArrowSineOffset, 0.0f, 7.f, 2.0f);
    m_pMovementInterpolator = new EaseInterpolator(&m_fMovementOffset, 0.0f, 136.0f, 2.0f, 0.5f, true);

    m_pMenuOpacityInterpolator->Pause();

    m_pArrowsSineInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pArrowsSineInterpolator, false);

    Log("+++ SubMenuHelpState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {

        Log("+++ SubMenuHelpState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);
        SafeDelete(m_pInputCallbackArrowLeft);
        SafeDelete(m_pInputCallbackArrowRight);

        SafeDelete(m_pRenderableMidLayer2D);
        SafeDelete(m_pBackground[0]);
        SafeDelete(m_pBackground[1]);
        SafeDelete(m_pBackButton);

        SafeDelete(m_pLeftArrow[0]);
        SafeDelete(m_pLeftArrow[1]);
        SafeDelete(m_pRightArrow[0]);
        SafeDelete(m_pRightArrow[1]);

        SafeDelete(m_pMenuOpacityInterpolator);
        SafeDelete(m_pMovementInterpolator);
        SafeDelete(m_pArrowsSineInterpolator);

        InputManager::Instance().ClearRegionEvents();

        m_bNeedCleanup = false;

        Log("+++ SubMenuHelpState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::ResetInterpolators(void)
{
    m_pMenuOpacityInterpolator->Continue();
    m_pMenuOpacityInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pMenuOpacityInterpolator, false);
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::UpdateLoading(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        m_CurrentState = SUB_MENU_IDLE;
    }
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::UpdateClosing(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        MenuGameState::Instance().SetSubMenu(m_pChangingToMenu);
    }
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::Update(void)
{
    Renderer::Instance().Add(m_pRenderableMidLayer2D);

    float menuOpacity = (m_CurrentState == SUB_MENU_CLOSING) ? (1.0f - m_fMenuOpacity) : m_fMenuOpacity;

    COLOR cFontPage = {0.99f, 0.46f, 0.28f, menuOpacity};

    char page[6];
    sprintf(page, "%d/2", m_iCurrentPage + 1);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add(page, IPHONE_SCREEN_HEIGHT - 75.0f, 170.0f, -2.0f, cFontPage);
#else
    m_pTextFont->Add(page, IPHONE_SCREEN_HEIGHT - 35.0f, 78.0f, -2.0f, cFontPage);
#endif

    if (m_iCurrentPage == 0)
    {
        m_pLeftArrow[0]->Activate(false);
        m_pLeftArrow[1]->Activate(false);
    }
    else
    {
        m_pLeftArrow[0]->Activate(true);
    }

    if (m_iCurrentPage == (1))
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

    m_pBackButton->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    m_pBackground[0]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pBackground[1]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pBackground[0]->SetPosition(90.0f - (m_fMovementOffset * 2.0f), 210.0f, 0.0f);
    m_pBackground[1]->SetPosition(90.0f - (m_fMovementOffset * 2.0f) + 1000.0f, 210.0f, 0.0f);
#else
    m_pBackground[0]->SetPosition(45.0f - m_fMovementOffset, 80.0f, 0.0f);
    m_pBackground[1]->SetPosition(45.0f - m_fMovementOffset + 500.0f, 80.0f, 0.0f);
#endif

    COLOR cFontBack = {1.0f, 1.0f, 1.0f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("BACK", 40.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBack);
#else
    m_pTextFont->Add("BACK", 20.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBack);
#endif
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::InputCallbackBack(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_BACK));

        Log("--------- input BACK\n");
        m_CurrentState = SUB_MENU_CLOSING;
        ResetInterpolators();
        m_fMenuOpacity = 0.0f;
        m_pChangingToMenu = &SubMenuMainState::Instance();
    }
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::InputCallbackArrowLeft(stInputCallbackParameter parameter, int id)
{
    if (!m_pLeftArrow[1]->IsActive() && parameter.type == PRESS_START && m_iCurrentPage != 0)
    {
        m_pLeftArrow[1]->Activate(true);

        m_iCurrentPage--;

        if (m_iCurrentPage < 0)
            m_iCurrentPage = 0;

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
    }
    else if (parameter.type == PRESS_END)
    {
        m_pLeftArrow[1]->Activate(false);
    }
}

//////////////////////////
//////////////////////////

void SubMenuHelpState::InputCallbackArrowRight(stInputCallbackParameter parameter, int id)
{
    int maxPage = 1;

    if (!m_pRightArrow[1]->IsActive() && parameter.type == PRESS_START && (m_iCurrentPage < maxPage))
    {
        m_pRightArrow[1]->Activate(true);

        m_iCurrentPage++;

        if (m_iCurrentPage > maxPage)
            m_iCurrentPage = maxPage;

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
    }
    else if (parameter.type == PRESS_END)
    {
        m_pRightArrow[1]->Activate(false);
    }
}