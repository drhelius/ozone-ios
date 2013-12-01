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
 *  SubMenuOptionsState.cpp
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "SubMenuOptionsState.h"
#include "menugamestate.h"
#include "submenumainstate.h"

//////////////////////////
//////////////////////////

SubMenuOptionsState::SubMenuOptionsState(void) : SubMenuState()
{
    Log("+++ SubMenuMainState::SubMenuMainState ...\n");

    InitPointer(m_pTextFont);
    InitPointer(m_pInputCallbackBack);

    m_bNeedCleanup = false;

    Log("+++ SubMenuMainState::SubMenuMainState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuOptionsState::~SubMenuOptionsState(void)
{
    Log("+++ SubMenuOptionsState::~SubMenuOptionsState ...\n");

    Cleanup();

    Log("+++ SubMenuOptionsState::~SubMenuOptionsState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuOptionsState::Reset(void)
{
    Log("+++ SubMenuOptionsState::Reset ...\n");

    InputManager::Instance().ClearRegionEvents();

    m_bFinishing = false;
    m_CurrentState = SUB_MENU_LOADING;

    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 100.0f, 100.0f, 100.0f, m_pInputCallbackBack);
  
    Log("+++ SubMenuOptionsState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuOptionsState::Init(TextFont* pTextFont, Fader* pFader)
{
    Log("+++ SubMenuOptionsState::Init ...\n");

    m_bNeedCleanup = true;
    m_pTextFont = pTextFont;
    m_pFader = pFader;

    m_pInputCallbackBack = new InputCallback<SubMenuOptionsState > (this, &SubMenuOptionsState::InputCallbackBack);
    
    //Reset();

    Log("+++ SubMenuOptionsState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuOptionsState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {

        Log("+++ SubMenuOptionsState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);

        InputManager::Instance().ClearRegionEvents();

        m_bNeedCleanup = false;

        Log("+++ SubMenuOptionsState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuOptionsState::UpdateLoading(void)
{

    m_CurrentState = SUB_MENU_IDLE;
}

//////////////////////////
//////////////////////////

void SubMenuOptionsState::UpdateClosing(void)
{
    MenuGameState::Instance().SetSubMenu(&SubMenuMainState::Instance());
}

//////////////////////////
//////////////////////////

void SubMenuOptionsState::Update(void)
{

    COLOR cFont = {1.0f, 1.0f, 1.0f, 1.0f};

    m_pTextFont->Add("OPTIONS", 200.0f, IPHONE_SCREEN_WIDTH / 2.0f, 0.0f, cFont);
    m_pTextFont->Add("BACK", 20.0f, IPHONE_SCREEN_WIDTH - 50.0f, 0.0f, cFont);
}

//////////////////////////
//////////////////////////

void SubMenuOptionsState::InputCallbackBack(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START)
    {
        Log("--------- input BACK\n");
        m_CurrentState = SUB_MENU_CLOSING;
    }
}
