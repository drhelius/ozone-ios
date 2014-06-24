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
 * File:   submenumainstate.h
 * Author: nacho
 *
 * Created on 11 de junio de 2009, 23:23
 */

#pragma once
#ifndef _SUBMENUMAINSTATE_H
#define	_SUBMENUMAINSTATE_H

#include "singleton.h"
#include "submenustate.h"
#include "renderable.h"
#include "renderobject.h"
#include "camera.h"
#include "timer.h"
#include "menuitem.h"
#include "inputmanager.h"
#include "UIManager.h"
#include "interpolatormanager.h"

#ifdef OZONE_LITE
#define MENU_ITEMS 4
#else
#define MENU_ITEMS 4
#endif

class SubMenuMainState : public SubMenuState, public Singleton<SubMenuMainState>
{

    ////friend class Singleton<SubMenuMainState>;

private:

    static const char * ms_MenuTexts[];

    bool m_bExiting;
    bool m_bSendingScore;

    SubMenuState* m_pNextSubMenu;

    Timer* m_pMainTimer;

    Camera* m_pCamera3DCubeBig;
    Camera* m_pCamera2D;

    Renderable* m_pRenderableMidLayer3DCubeBig;
    Renderable* m_pRenderableHighLayer2D;

    MenuItem* m_pCubeBig;

    MenuItem* m_pMenuItems[MENU_ITEMS];

    RenderObject* m_pTopButton;

#ifdef OZONE_LITE
    RenderObject* m_pBuyButton;
    RenderObject* m_pBuyButtonGlow;

    SineInterpolator* m_pBuyGlowInterpolator;

    float m_fBuyGlow;
#endif

    InputCallback<SubMenuMainState>* m_pInputCallbackMenu;
    InputCallback<SubMenuMainState>* m_pInputCallbackSend;

    UICallback<SubMenuMainState>* m_pUICallbackScore;
    UICallback<SubMenuMainState>* m_pUICallbackLevelAlert;


public:

    SubMenuMainState(void);
    ~SubMenuMainState(void);

    void Init(TextFont* pTextFont, Fader* pFader);
    void Cleanup(void);

    void UpdateLoading(void);
    void UpdateClosing(void);
    void Update(void);

    void UpdateCube(void);
    void UpdateItems(void);
    void UpdateItemsLoading(void);
    void UpdateItemsClosing(void);

    void Reset(void);

    void InputCallbackMenu(stInputCallbackParameter parameter, int id);
    void InputCallbackSend(stInputCallbackParameter parameter, int id);

    void UICallbackScore(int button, const char* szName);
    void UICallbackLevelAlert(int button, const char* szName);

};

#endif	/* _SUBMENUMAINSTATE_H */

