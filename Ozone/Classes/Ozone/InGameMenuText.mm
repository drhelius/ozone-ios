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
 * File:   InGameMenuText.mm
 * Author: nacho
 * 
 * Created on 27 de febrero de 2010, 18:29
 */

#include "InGameMenuText.h"
#include "renderer.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "tutorial_texts.h"
#include "audio.h"

//////////////////////////
//////////////////////////

InGameMenuText::InGameMenuText(Timer* pTimer) : InGameMenu()
{
    m_pTimer = pTimer;
    m_iCurrentTutorialPopUp = 0;
    m_bShowLogo = false;

    InitPointer(m_pInputCallbackOK);
    InitPointer(m_pInputResponseOK);
    InitPointer(m_pTextFont);
}

//////////////////////////
//////////////////////////

InGameMenuText::~InGameMenuText()
{
    SafeDelete(m_pInputCallbackOK);
    SafeDelete(m_pTextFont);
}

//////////////////////////
//////////////////////////

void InGameMenuText::Init(float width, float height)
{
    InGameMenu::Init(width, height);

    Texture* pTexHud = TextureManager::Instance().GetTexture("game/hud/hud_02");

#ifdef GEARDOME_PLATFORM_IPAD
    m_OKRO.Init(MeshManager::Instance().GetBoardMesh(0, 0, 94, 46,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
#else
    m_OKRO.Init(MeshManager::Instance().GetBoardMesh(0, 0, 47, 23,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
#endif

    m_OKRO.UseColor(true);

    m_Renderable.GetRenderObjectList().push_back(&m_OKRO);

    m_pInputCallbackOK = new InputCallback<InGameMenuText > (this, &InGameMenuText::InputOK);

    m_pTextFont = new TextFont();
    m_pTextFont->Init("game/fonts/game_01_font", "game/fonts/game_01_font", 600);
}

//////////////////////////
//////////////////////////

void InGameMenuText::Update(void)
{
    if (m_bActive)
    {
        m_pTextFont->Begin();

        float centerX = IPHONE_SCREEN_HEIGHT / 2.0f;
        float centerY = IPHONE_SCREEN_WIDTH / 2.0f;

#ifdef GEARDOME_PLATFORM_IPAD
        m_OKRO.SetPosition(centerX - 80.0f + (m_fMotion * 4.0f) + (m_fWidth / 2.0f), centerY + (m_fHeight / 2.0f) - 30.0f, 1.0f);
#else
        m_OKRO.SetPosition(centerX - 23.0f + (m_fMotion * 2.0f), centerY + (m_fHeight / 2.0f) - 10.0f, 1.0f);
#endif


        m_OKRO.SetColor(1.0f, 1.0f, 1.0f, (m_iSelection == 1) ? MAT_Min(m_fAlpha, m_fSelectionOpacity) : m_fAlpha);

        if (m_iSelection == 1)
        {
            if (m_pSelectionInterpolator->IsFinished())
            {
                m_iSelection = -1;

                if (IsValidPointer(m_pInputResponseOK))
                {
                    stInputCallbackParameter parameter;
                    parameter.type = PRESS_START;
                    m_pInputResponseOK->Execute(parameter, 0);
                }
            }
        }

        COLOR cFont = {1.0f, 1.0f, 1.0f, m_fAlpha};

#ifdef GEARDOME_PLATFORM_IPAD
        m_pTextFont->Add(str_tutorial[m_iCurrentTutorialPopUp], 160.0f, centerY - (m_fHeight / 2.0f) - 5.0f, 1.0f, cFont);
#else
        m_pTextFont->Add(str_tutorial[m_iCurrentTutorialPopUp], 80.0f, centerY - (m_fHeight / 2.0f) - 5.0f, 1.0f, cFont);
#endif

        m_pTextFont->End();
    }

    InGameMenu::Update();
}

//////////////////////////
//////////////////////////

void InGameMenuText::Show(void)
{
    InGameMenu::Show();

    float centerX = IPHONE_SCREEN_HEIGHT / 2.0f;
    float centerY = IPHONE_SCREEN_WIDTH / 2.0f;

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(centerX - 100.0f + (m_fWidth / 2.0f), centerY + (m_fHeight / 2.0f) - 40.0f, 120.0f, 70.0f, m_pInputCallbackOK);
#else
    InputManager::Instance().AddRectRegionEvent(centerX - 50.0f, centerY + (m_fHeight / 2.0f) - 30.0f, 100.0f, 63.0f, m_pInputCallbackOK);
#endif
}

//////////////////////////
//////////////////////////

void InGameMenuText::InputOK(stInputCallbackParameter parameter, int id)
{
    if (parameter.type == PRESS_START && m_iSelection == 0)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INGAME_MENU_SELECTION));

        m_pSelectionInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false, m_pTimer);

        m_iSelection = 1;
    }
}

