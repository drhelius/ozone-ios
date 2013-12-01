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
 * File:   InGameMenuMain.mm
 * Author: nacho
 * 
 * Created on 17 de febrero de 2010, 16:53
 */

#include "InGameMenuMain.h"
#include "renderer.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "audio.h"

//////////////////////////
//////////////////////////

InGameMenuMain::InGameMenuMain(Timer* pTimer) : InGameMenu()
{
    m_pTimer = pTimer;

    InitPointer(m_pInputCallbackContinue);
    InitPointer(m_pInputCallbackRestart);
    InitPointer(m_pInputCallbackMainMenu);
    InitPointer(m_pInputResponseContinue);
    InitPointer(m_pInputResponseRestart);
    InitPointer(m_pInputResponseMainMenu);
}

//////////////////////////
//////////////////////////

InGameMenuMain::~InGameMenuMain()
{
    SafeDelete(m_pInputCallbackContinue);
    SafeDelete(m_pInputCallbackRestart);
    SafeDelete(m_pInputCallbackMainMenu);
}

//////////////////////////
//////////////////////////

void InGameMenuMain::Init(float width, float height)
{
    InGameMenu::Init(width, height);

    Texture* pTexHud = TextureManager::Instance().GetTexture("game/hud/hud_02");

#ifdef GEARDOME_PLATFORM_IPAD
    m_ContinueRO.Init(MeshManager::Instance().GetBoardMesh(0, 144, 192, 46,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_ContinueRO.UseColor(true);

    m_RestartRO.Init(MeshManager::Instance().GetBoardMesh(0, 192, 170, 46,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_RestartRO.UseColor(true);

    m_MainMenuRO.Init(MeshManager::Instance().GetBoardMesh(0, 96, 220, 46,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_MainMenuRO.UseColor(true);
#else
    m_ContinueRO.Init(MeshManager::Instance().GetBoardMesh(0, 72, 96, 23,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_ContinueRO.UseColor(true);

    m_RestartRO.Init(MeshManager::Instance().GetBoardMesh(0, 96, 85, 23,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_RestartRO.UseColor(true);

    m_MainMenuRO.Init(MeshManager::Instance().GetBoardMesh(0, 48, 110, 23,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_MainMenuRO.UseColor(true);
#endif

    m_Renderable.GetRenderObjectList().push_back(&m_ContinueRO);
    m_Renderable.GetRenderObjectList().push_back(&m_RestartRO);
    m_Renderable.GetRenderObjectList().push_back(&m_MainMenuRO);

    m_pInputCallbackContinue = new InputCallback<InGameMenuMain > (this, &InGameMenuMain::InputContinue);
    m_pInputCallbackRestart = new InputCallback<InGameMenuMain > (this, &InGameMenuMain::InputRestart);
    m_pInputCallbackMainMenu = new InputCallback<InGameMenuMain > (this, &InGameMenuMain::InputMainMenu);
}

//////////////////////////
//////////////////////////

void InGameMenuMain::Update(void)
{
    if (m_bActive)
    {
        float centerX = IPHONE_SCREEN_HEIGHT / 2.0f;
        float centerY = IPHONE_SCREEN_WIDTH / 2.0f;

#ifdef GEARDOME_PLATFORM_IPAD
        m_ContinueRO.SetPosition(centerX - 96.0f - (m_fMotion * 2.0f), centerY - 22.0f - 100.0f, 1.0f);
        m_RestartRO.SetPosition(centerX - 84.0f + (m_fMotion * 2.0f), centerY - 22.0f, 1.0f);
        m_MainMenuRO.SetPosition(centerX - 110.0f - (m_fMotion * 2.0f), centerY - 22.0f + 100.0f, 1.0f);
#else
        m_ContinueRO.SetPosition(centerX - 48.0f - m_fMotion, centerY - 11.0f - 50.0f, 1.0f);
        m_RestartRO.SetPosition(centerX - 42.0f + m_fMotion, centerY - 11.0f, 1.0f);
        m_MainMenuRO.SetPosition(centerX - 55.0f - m_fMotion, centerY - 11.0f + 50.0f, 1.0f);
#endif

        m_ContinueRO.SetColor(1.0f, 1.0f, 1.0f, (m_iSelection == 1) ? MAT_Min(m_fAlpha, m_fSelectionOpacity) : m_fAlpha);
        m_RestartRO.SetColor(1.0f, 1.0f, 1.0f, (m_iSelection == 2) ? MAT_Min(m_fAlpha, m_fSelectionOpacity) : m_fAlpha);
        m_MainMenuRO.SetColor(1.0f, 1.0f, 1.0f, (m_iSelection == 3) ? MAT_Min(m_fAlpha, m_fSelectionOpacity) : m_fAlpha);

        switch (m_iSelection)
        {
            case 1:
            {
                if (m_pSelectionInterpolator->IsFinished())
                {
                    m_iSelection = -1;

                    if (IsValidPointer(m_pInputResponseContinue))
                    {
                        stInputCallbackParameter parameter;
                        parameter.type = PRESS_START;
                        m_pInputResponseContinue->Execute(parameter, 0);
                    }
                }
                break;
            }
            case 2:
            {
                if (m_pSelectionInterpolator->IsFinished())
                {
                    m_iSelection = -1;

                    if (IsValidPointer(m_pInputResponseRestart))
                    {
                        stInputCallbackParameter parameter;
                        parameter.type = PRESS_START;
                        m_pInputResponseRestart->Execute(parameter, 0);
                    }
                }
                break;
            }
            case 3:
            {
                if (m_pSelectionInterpolator->IsFinished())
                {
                    m_iSelection = -1;

                    if (IsValidPointer(m_pInputResponseMainMenu))
                    {
                        stInputCallbackParameter parameter;
                        parameter.type = PRESS_START;
                        m_pInputResponseMainMenu->Execute(parameter, 0);
                    }
                }
                break;
            }
        }
    }

    InGameMenu::Update();
}

//////////////////////////
//////////////////////////

void InGameMenuMain::Show(void)
{
    InGameMenu::Show();

    float centerX = IPHONE_SCREEN_HEIGHT / 2.0f;
    float centerY = IPHONE_SCREEN_WIDTH / 2.0f;

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(centerX - 150.0f, centerY - 38.0f - 100.0f, 300.0f, 76.0f, m_pInputCallbackContinue);
    InputManager::Instance().AddRectRegionEvent(centerX - 150.0f, centerY - 38.0f, 300.0f, 76.0f, m_pInputCallbackRestart);
    InputManager::Instance().AddRectRegionEvent(centerX - 150.0f, centerY - 38.0f + 100.0f, 300.0f, 76.0f, m_pInputCallbackMainMenu);
#else
    InputManager::Instance().AddRectRegionEvent(centerX - 75.0f, centerY - 19.0f - 50.0f, 150.0f, 38.0f, m_pInputCallbackContinue);
    InputManager::Instance().AddRectRegionEvent(centerX - 75.0f, centerY - 19.0f, 150.0f, 38.0f, m_pInputCallbackRestart);
    InputManager::Instance().AddRectRegionEvent(centerX - 75.0f, centerY - 19.0f + 50.0f, 150.0f, 38.0f, m_pInputCallbackMainMenu);
#endif

}

//////////////////////////
//////////////////////////

void InGameMenuMain::InputContinue(stInputCallbackParameter parameter, int id)
{
    if (parameter.type == PRESS_START && m_iSelection == 0)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INGAME_MENU_SELECTION));

        m_pSelectionInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false, m_pTimer);

        m_iSelection = 1;
    }
}

//////////////////////////
//////////////////////////

void InGameMenuMain::InputRestart(stInputCallbackParameter parameter, int id)
{
    if (parameter.type == PRESS_START && m_iSelection == 0)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INGAME_MENU_SELECTION));

        m_pSelectionInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false, m_pTimer);

        m_iSelection = 2;
    }
}

//////////////////////////
//////////////////////////

void InGameMenuMain::InputMainMenu(stInputCallbackParameter parameter, int id)
{
    if (parameter.type == PRESS_START && m_iSelection == 0)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INGAME_MENU_SELECTION));

        m_pSelectionInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false, m_pTimer);

        m_iSelection = 3;
    }
}