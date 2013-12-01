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
 *  SubMenuCreditsState.h
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _SUBMENUCREDITSSTATE_H
#define	_SUBMENUCREDITSSTATE_H

#include "submenustate.h"
#include "singleton.h"
#include "inputmanager.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"
#include "UIManager.h"

class SubMenuCreditsState : public SubMenuState, public Singleton<SubMenuCreditsState>
{

////    friend class Singleton<SubMenuCreditsState>;

private:

    InputCallback<SubMenuCreditsState>* m_pInputCallbackBack;
    UICallback<SubMenuCreditsState>* m_pUICallbackScore;

    Renderable* m_pRenderableMidLayer2D;

    RenderObject* m_pBackground;
    RenderObject* m_pBackButton;

    SubMenuState* m_pChangingToMenu;

    float m_fMenuOpacity;

    LinearInterpolator* m_pMenuOpacityInterpolator;

    bool m_bEndOfGame;

public:

    SubMenuCreditsState(void);
    ~SubMenuCreditsState(void);

    void Init(TextFont* pTextFont, Fader* pFader);
    void Cleanup(void);
    void Reset(void);

    void ResetInterpolators(void);

    void UpdateLoading(void);
    void UpdateClosing(void);
    void Update(void);

    void SetEndOfGame(void)
    {
        m_bEndOfGame = true;
    };

    void InputCallbackBack(stInputCallbackParameter parameter, int id);

    void UICallbackScore(int button, const char* szName);

};

#endif	/* _SUBMENUCREDITSSTATE_H */