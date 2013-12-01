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
 *  SubMenuFullVersionState.cpp
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "SubMenuFullVersionState.h"
#include "menugamestate.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "interpolatormanager.h"

//////////////////////////
//////////////////////////

SubMenuFullVersionState::SubMenuFullVersionState(void) : SubMenuState()
{
    Log("+++ SubMenuFullVersionState::SubMenuFullVersionState ...\n");

    InitPointer(m_pTextFont);
    InitPointer(m_pInputCallbackBack);
    InitPointer(m_pRenderableHighLayer2D);

#ifdef GEARDOME_PLATFORM_IPAD
    int count = 4;
#else
    int count = 5;
#endif

    for (int i = 0; i < count; i++)
    {
        InitPointer(m_pBackgrounds[i]);
    }

    m_iCurrentPage = 0;
    m_fTrans = 0.0f;

    m_bNeedCleanup = false;

    Log("+++ SubMenuFullVersionState::SubMenuFullVersionState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuFullVersionState::~SubMenuFullVersionState(void)
{
    Log("+++ SubMenuFullVersionState::~SubMenuFullVersionState ...\n");

    Cleanup();

    Log("+++ SubMenuFullVersionState::~SubMenuFullVersionState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuFullVersionState::Reset(void)
{
    Log("+++ SubMenuFullVersionState::Reset ...\n");

    InputManager::Instance().ClearRegionEvents();

    m_bFinishing = false;
    m_CurrentState = SUB_MENU_LOADING;

    InputManager::Instance().AddRectRegionEvent(0.0f, 0.0f, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH, m_pInputCallbackBack);

    m_iCurrentPage = 0;
    m_fTrans = 0.0f;

    InterpolatorManager::Instance().Add(new LinearInterpolator(&m_fTrans, 0.0f, 1.0f, 0.7f), true);

    Log("+++ SubMenuFullVersionState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuFullVersionState::Init(TextFont* pTextFont, Fader* pFader)
{
    Log("+++ SubMenuFullVersionState::Init ...\n");

    m_bNeedCleanup = true;
    m_pTextFont = pTextFont;
    m_pFader = pFader;

    m_pInputCallbackBack = new InputCallback<SubMenuFullVersionState > (this, &SubMenuFullVersionState::InputCallbackBack);

    m_pRenderableHighLayer2D = new Renderable();
    m_pRenderableHighLayer2D->Set3D(false);
    m_pRenderableHighLayer2D->SetLayer(600);

#ifdef GEARDOME_PLATFORM_IPAD
    int count = 4;
#else
    int count = 5;
#endif

    for (int i = 0; i < count; i++)
    {
        char texture[100];
        sprintf(texture, "menu/gfx/0%d", i + 1);

        Texture* pTex = TextureManager::Instance().GetTexture(texture);

        m_pBackgrounds[i] = new RenderObject();

#ifdef GEARDOME_PLATFORM_IPAD
        m_pBackgrounds[i]->Init(MeshManager::Instance().GetBoardMesh(0, 0, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH,
                pTex->GetWidth(), pTex->GetHeight()), pTex, RENDER_OBJECT_TRANSPARENT);
#else
        m_pBackgrounds[i]->Init(MeshManager::Instance().GetBoardMesh(0, 0, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH,
                pTex->GetWidth(), pTex->GetHeight()), pTex, RENDER_OBJECT_TRANSPARENT);
#endif
        m_pBackgrounds[i]->SetPosition(0.0f, 0.0f, 25.0f);
        m_pBackgrounds[i]->UseColor(true);

        m_pRenderableHighLayer2D->GetRenderObjectList().push_back(m_pBackgrounds[i]);
    }

    //Reset();

    Log("+++ SubMenuFullVersionState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuFullVersionState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {

        Log("+++ SubMenuFullVersionState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);
        SafeDelete(m_pRenderableHighLayer2D);

#ifdef GEARDOME_PLATFORM_IPAD
    int count = 4;
#else
    int count = 5;
#endif

        for (int i = 0; i < count; i++)
        {
            SafeDelete(m_pBackgrounds[i]);
        }

        InputManager::Instance().ClearRegionEvents();

        m_bNeedCleanup = false;

        Log("+++ SubMenuFullVersionState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuFullVersionState::UpdateLoading(void)
{
    if (m_fTrans >= 1.0f)
    {
        m_CurrentState = SUB_MENU_IDLE;
    }

    Update();
}

//////////////////////////
//////////////////////////

void SubMenuFullVersionState::UpdateClosing(void)
{
    MenuGameState::Instance().SetSubMenu(&SubMenuMainState::Instance());
}

//////////////////////////
//////////////////////////

void SubMenuFullVersionState::Update(void)
{
    Renderer::Instance().Add(m_pRenderableHighLayer2D);

#ifdef GEARDOME_PLATFORM_IPAD
    int count = 4;
#else
    int count = 5;
#endif

    for (int i = 0; i < count; i++)
    {
        m_pBackgrounds[i]->SetColor(1.0f, 1.0f, 1.0f, m_fTrans);
        m_pBackgrounds[i]->Activate(i == m_iCurrentPage);
    }
}

//////////////////////////
//////////////////////////

void SubMenuFullVersionState::InputCallbackBack(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_END)
    {
        Log("--------- input BACK\n");
        //m_CurrentState = SUB_MENU_CLOSING;

        m_iCurrentPage++;

#ifdef GEARDOME_PLATFORM_IPAD
        if (m_iCurrentPage > 3)
        {
            m_iCurrentPage = 3;
            [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://itunes.ozonehd.com"]];
        }
#else
        if (m_iCurrentPage > 4)
        {
            m_iCurrentPage = 4;
            [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://ozone.itunes.geardome.com"]];
        }
#endif
    }
}
