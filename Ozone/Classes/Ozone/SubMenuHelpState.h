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
 * File:   SubMenuHelpState.h
 * Author: nacho
 *
 * Created on 3 de marzo de 2010, 17:42
 */

#ifndef _SUBMENUHELPSTATE_H
#define	_SUBMENUHELPSTATE_H

#include "submenustate.h"
#include "singleton.h"
#include "inputmanager.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"

class SubMenuHelpState : public SubMenuState, public Singleton<SubMenuHelpState>
{

    ////    friend class Singleton<SubMenuCreditsState>;

private:

    InputCallback<SubMenuHelpState>* m_pInputCallbackBack;
    InputCallback<SubMenuHelpState>* m_pInputCallbackArrowLeft;
    InputCallback<SubMenuHelpState>* m_pInputCallbackArrowRight;

    Renderable* m_pRenderableMidLayer2D;

    RenderObject* m_pBackground[2];
    RenderObject* m_pBackButton;

    RenderObject* m_pLeftArrow[2];
    RenderObject* m_pRightArrow[2];

    SubMenuState* m_pChangingToMenu;

    float m_fMenuOpacity;
    float m_fArrowSineOffset;
    float m_fMovementOffset;

    int m_iCurrentPage;

    LinearInterpolator* m_pMenuOpacityInterpolator;
    SineInterpolator* m_pArrowsSineInterpolator;
    EaseInterpolator* m_pMovementInterpolator;

public:

    SubMenuHelpState(void);
    ~SubMenuHelpState(void);

    void Init(TextFont* pTextFont, Fader* pFader);
    void Cleanup(void);
    void Reset(void);

    void ResetInterpolators(void);

    void UpdateLoading(void);
    void UpdateClosing(void);
    void Update(void);

    void InputCallbackBack(stInputCallbackParameter parameter, int id);
    void InputCallbackArrowLeft(stInputCallbackParameter parameter, int id);
    void InputCallbackArrowRight(stInputCallbackParameter parameter, int id);

};

#endif	/* _SUBMENUHELPSTATE_H */

