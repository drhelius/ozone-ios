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
 *  SubMenuHighScoresState.h
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _SUBMENUHIGHSCORESSTATE_H
#define	_SUBMENUHIGHSCORESSTATE_H

#include "submenustate.h"
#include "singleton.h"
#include "inputmanager.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"
#include "UIManager.h"

class SubMenuHighScoresState : public SubMenuState, public Singleton<SubMenuHighScoresState>
{

    ////friend class Singleton<SubMenuHighScoresState>;

private:

    InputCallback<SubMenuHighScoresState>* m_pInputCallbackBack;
    InputCallback<SubMenuHighScoresState>* m_pInputCallbackTop;
    UICallback<SubMenuHighScoresState>* m_pUICallbackList;
    UICallback<SubMenuHighScoresState>* m_pUICallbackWeb;

    Renderable* m_pRenderableMidLayer2D;

    RenderObject* m_pBackground;
    RenderObject* m_pBackButton;
    RenderObject* m_pMenuBar;
    RenderObject* m_pTopButton;
    RenderObject* m_pTopGlow;

    SubMenuState* m_pChangingToMenu;

    float m_fMenuOpacity;
    float m_fGlowRotation;

    bool m_bShowingList;
    bool m_bWebReceived;

    char m_szScores[10000];

    LinearInterpolator* m_pMenuOpacityInterpolator;

    Timer m_GlowTimer;

public:

    SubMenuHighScoresState(void);
    ~SubMenuHighScoresState(void);

    void Init(TextFont* pTextFont, Fader* pFader);
    void Cleanup(void);
    void Reset(void);

    void ResetInterpolators(void);

    void UpdateLoading(void);
    void UpdateClosing(void);
    void Update(void);

    void InputCallbackBack(stInputCallbackParameter parameter, int id);
    void InputCallbackTop(stInputCallbackParameter parameter, int id);

    void UICallbackList(int button, const char* text);
    void UICallbackWeb(int button, const char* text);

    char* GetScoresString(void)
    {
        return m_szScores;
    };
};

#endif	/* _SUBMENUHIGHSCORESSTATE_H */