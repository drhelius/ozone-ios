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
 *  SubMenuSaveSelectionState.h
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _SUBMENUSAVESELECTIONSTATE_H
#define	_SUBMENUSAVESELECTIONSTATE_H

#include "submenustate.h"
#include "singleton.h"
#include "inputmanager.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"
#include "UIManager.h"

class SubMenuSaveSelectionState : public SubMenuState, public Singleton<SubMenuSaveSelectionState>
{

    ////friend class Singleton<SubMenuSaveSelectionState>;

    struct stSaveSlotMenu
    {

        RenderObject* pRO;
        RenderObject* pROdelete;
        float fAlpha;
        char level[30];
        char title[30];
        char date[30];
        char score[30];
        char name[30];
        bool used;
    };

private:

    InputCallback<SubMenuSaveSelectionState>* m_pInputCallbackBack;
    InputCallback<SubMenuSaveSelectionState>* m_pInputCallbackSlot;
    InputCallback<SubMenuSaveSelectionState>* m_pInputCallbackDelete;
    UICallback<SubMenuSaveSelectionState>* m_pUICallbackName;
    UICallback<SubMenuSaveSelectionState>* m_pUICallbackDelete;

    Renderable* m_pRenderableMidLayer2D;

    stSaveSlotMenu m_SaveSlots[3];

    RenderObject* m_pBackButton;
    RenderObject* m_pMenuBar;

    float m_fMenuOpacity;
    LinearInterpolator* m_pMenuOpacityInterpolator;
    CosineInterpolator* m_pSelectionInterpolator;

    Timer m_LocalTimer;

    SubMenuState* m_pChangingToMenu;

    float m_fSelectionOpacity;
    bool m_bWantToClose;
    bool m_bWantToShowAlert;
    bool m_bEnteringName;
    bool m_bShowingAlert;

    int m_iSelection;
    int m_iClearSelection;


public:

    SubMenuSaveSelectionState(void);
    ~SubMenuSaveSelectionState(void);

    void Init(TextFont* pTextFont, Fader* pFader);
    void Cleanup(void);
    void Reset(void);

    void ResetInterpolatorOpacity(void);

    void UpdateLoading(void);
    void UpdateClosing(void);
    void Update(void);

    void InputCallbackBack(stInputCallbackParameter parameter, int id);
    void InputCallbackSlot(stInputCallbackParameter parameter, int id);
    void InputCallbackDelete(stInputCallbackParameter parameter, int id);

    void UICallbackName(int button, const char* szName);
    void UICallbackDelete(int button, const char* text);
};

#endif	/* _SUBMENUSAVESELECTIONSTATE_H */
