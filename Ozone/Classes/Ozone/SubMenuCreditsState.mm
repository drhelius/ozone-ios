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
 *  SubMenuCreditsState.cpp
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "SubMenuCreditsState.h"
#include "menugamestate.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "audio.h"
#include "SaveManager.h"

//////////////////////////
//////////////////////////

SubMenuCreditsState::SubMenuCreditsState(void) : SubMenuState()
{
    Log("+++ SubMenuCreditsState::SubMenuCreditsState ...\n");

    InitPointer(m_pTextFont);
    InitPointer(m_pInputCallbackBack);
    InitPointer(m_pUICallbackScore);

    InitPointer(m_pRenderableMidLayer2D);
    InitPointer(m_pBackground);
    InitPointer(m_pBackButton);

    InitPointer(m_pMenuOpacityInterpolator);

    m_fMenuOpacity = 0.0f;

    m_bNeedCleanup = false;
    m_bEndOfGame = false;

    Log("+++ SubMenuCreditsState::SubMenuCreditsState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuCreditsState::~SubMenuCreditsState(void)
{
    Log("+++ SubMenuCreditsState::~SubMenuCreditsState ...\n");

    Cleanup();

    Log("+++ SubMenuCreditsState::~SubMenuCreditsState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuCreditsState::Reset(void)
{
    Log("+++ SubMenuCreditsState::Reset ...\n");

    InputManager::Instance().ClearRegionEvents();

    if (m_bEndOfGame)
    {
        UIManager::Instance().RaiseEvent(UI_EVENT_ASKSENDSCORE, m_pUICallbackScore);
    }

    m_bFinishing = false;
    m_CurrentState = SUB_MENU_LOADING;
    m_fMenuOpacity = 0.0f;
    m_pChangingToMenu = NULL;

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 70.0f, 200.0f, 70.0f, m_pInputCallbackBack);
#else
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 35.0f, 100.0f, 35.0f, m_pInputCallbackBack);
#endif

    ResetInterpolators();

    Log("+++ SubMenuCreditsState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuCreditsState::Init(TextFont* pTextFont, Fader* pFader)
{
    Log("+++ SubMenuCreditsState::Init ...\n");

    m_bNeedCleanup = true;
    m_pTextFont = pTextFont;
    m_pFader = pFader;

    Texture* pTexMenu01 = TextureManager::Instance().GetTexture("menu/gfx/menu_01");
    Texture* pTexCredits = TextureManager::Instance().GetTexture("menu/gfx/credits");

    m_pRenderableMidLayer2D = new Renderable();
    m_pRenderableMidLayer2D->Set3D(false);
    m_pRenderableMidLayer2D->SetLayer(600);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pBackButton = new RenderObject();
    m_pBackButton->Init(MeshManager::Instance().GetBoardMesh(593, 893, 176, 49,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pBackButton->SetPosition(0.0f, IPHONE_SCREEN_WIDTH - 60.0f, 0.0f);
    m_pBackButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackButton);

    m_pBackground = new RenderObject();
    m_pBackground->Init(MeshManager::Instance().GetBoardMesh(0, 0, 802, 389,
            pTexCredits->GetWidth(), pTexCredits->GetHeight()), pTexCredits, RENDER_OBJECT_TRANSPARENT);
    m_pBackground->SetPosition(110.0f, 250.0f, 0.0f);
    m_pBackground->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackground);
#else
    m_pBackButton = new RenderObject();
    m_pBackButton->Init(MeshManager::Instance().GetBoardMesh(23, 74, 510, 487, 1, 75,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pBackButton->GetTransform(), MAT_ToRadians(90.0f));
    m_pBackButton->SetPosition(0.0f, IPHONE_SCREEN_HEIGHT - 163.0f, 0.0f);
    m_pBackButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackButton);


    m_pBackground = new RenderObject();
    m_pBackground->Init(MeshManager::Instance().GetBoardMesh(0, 0, 449, 235,
            pTexCredits->GetWidth(), pTexCredits->GetHeight()), pTexCredits, RENDER_OBJECT_TRANSPARENT);
    m_pBackground->SetPosition(40.0f, 95.0f, 0.0f);
    m_pBackground->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackground);
#endif

    m_pInputCallbackBack = new InputCallback<SubMenuCreditsState > (this, &SubMenuCreditsState::InputCallbackBack);

    m_pUICallbackScore = new UICallback<SubMenuCreditsState > (this, &SubMenuCreditsState::UICallbackScore);

    m_pMenuOpacityInterpolator = new LinearInterpolator(&m_fMenuOpacity, 0.0f, 1.0f, 0.3f);

    m_pMenuOpacityInterpolator->Pause();

    Log("+++ SubMenuCreditsState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuCreditsState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ SubMenuCreditsState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);
        SafeDelete(m_pUICallbackScore);

        SafeDelete(m_pRenderableMidLayer2D);
        SafeDelete(m_pBackground);
        SafeDelete(m_pBackButton);

        SafeDelete(m_pMenuOpacityInterpolator);

        InputManager::Instance().ClearRegionEvents();

        m_bNeedCleanup = false;

        Log("+++ SubMenuCreditsState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuCreditsState::ResetInterpolators(void)
{
    m_pMenuOpacityInterpolator->Continue();
    m_pMenuOpacityInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pMenuOpacityInterpolator, false);
}

//////////////////////////
//////////////////////////

void SubMenuCreditsState::UpdateLoading(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        m_CurrentState = SUB_MENU_IDLE;
    }
}

//////////////////////////
//////////////////////////

void SubMenuCreditsState::UpdateClosing(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        MenuGameState::Instance().SetSubMenu(m_pChangingToMenu);
    }
}

//////////////////////////
//////////////////////////

void SubMenuCreditsState::Update(void)
{
    Renderer::Instance().Add(m_pRenderableMidLayer2D);

    float menuOpacity = (m_CurrentState == SUB_MENU_CLOSING) ? (1.0f - m_fMenuOpacity) : m_fMenuOpacity;

    m_pBackButton->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pBackground->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    COLOR cFontBack = {1.0f, 1.0f, 1.0f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("BACK", 40.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBack);
#else
    m_pTextFont->Add("BACK", 20.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBack);
#endif
}

//////////////////////////
//////////////////////////

void SubMenuCreditsState::InputCallbackBack(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bEndOfGame)
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

void SubMenuCreditsState::UICallbackScore(int button, const char* szName)
{
    m_bEndOfGame = false;

    if (button == 1)
    {
        UIManager::Instance().RaiseEvent(UI_EVENT_DOSENDSCORE);
    }
    else
    {
        SaveManager::Instance().ClearForUpload();
    }
}