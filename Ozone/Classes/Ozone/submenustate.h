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
 *  submenustate.h
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _SUBMENUSTATE_H
#define	_SUBMENUSTATE_H

enum eSubMenuState
{

    SUB_MENU_CLOSING,
    SUB_MENU_LOADING,
    SUB_MENU_IDLE
};

class TextFont;
class Fader;

class SubMenuState
{

protected:

    eSubMenuState m_CurrentState;
    bool m_bNeedCleanup;
    bool m_bFinishing;
    TextFont* m_pTextFont;
    Fader* m_pFader;

public:

    SubMenuState(void)
    {
        m_CurrentState = SUB_MENU_LOADING;
        m_bNeedCleanup = false;
        m_bFinishing = false;
        m_pTextFont = 0;
        m_pFader = 0;
    };

    virtual ~SubMenuState(void) { };

    virtual void Init(TextFont* pTextFont, Fader* pFader) = 0;
    virtual void Cleanup(void) = 0;

    virtual void UpdateLoading(void) = 0;
    virtual void UpdateClosing(void) = 0;
    virtual void Update(void) = 0;

    virtual void Reset(void) = 0;

    eSubMenuState GetState(void)
    {
        return m_CurrentState;
    };

    void SetState(eSubMenuState state)
    {
        m_CurrentState = state;
    };

    bool IsFinishing(void)
    {
        return m_bFinishing;
    }

};

#endif	/* _SUBMENUSTATE_H */

