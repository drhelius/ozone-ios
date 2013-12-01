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
 *  SubMenuLevelSelectionState.h
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _SUBMENULEVELSELECTIONSTATE_H
#define	_SUBMENULEVELSELECTIONSTATE_H

#include "submenustate.h"
#include "singleton.h"
#include "episode.h"
#include "inputmanager.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"
#include "UIManager.h"

#define MAX_LEVEL_SLOTS 30

class SubMenuLevelSelectionState : public SubMenuState, public Singleton<SubMenuLevelSelectionState>
{

    ////friend class Singleton<SubMenuLevelSelectionState>;

    struct stLevelSlot
    {

        bool enabled;
        RenderObject* pLockRO;
        RenderObject* pNormalRO;
        RenderObject* pCompletedRO;
        RenderObject* pBossRO;
        RenderObject* pBossCompletedRO;
        float fAlpha;
        bool locked;
        bool completed;
    };

private:

    InputCallback<SubMenuLevelSelectionState>* m_pInputCallbackBack;
    InputCallback<SubMenuLevelSelectionState>* m_pInputCallbackArrowLeft;
    InputCallback<SubMenuLevelSelectionState>* m_pInputCallbackArrowRight;

    InputCallback<SubMenuLevelSelectionState>* m_pInputCallbackAnySlot;

    UICallback<SubMenuLevelSelectionState>* m_pUICallbackItunes;

    Renderable* m_pRenderableMidLayer2D;

    RenderObject* m_pBackButton;
    RenderObject* m_pMenuBar;

    RenderObject* m_pLeftArrow[2];
    RenderObject* m_pRightArrow[2];

    float m_fMenuOpacity;
    LinearInterpolator* m_pMenuOpacityInterpolator;
    SineInterpolator* m_pArrowsSineInterpolator;
    CosineInterpolator* m_pSelectionInterpolator;
    EaseInterpolator* m_pMovementInterpolator;

    float m_fMovementOffset;
    float m_fSelectionOpacity;
    bool m_bWantToClose;
    bool m_bGoingToLevel;

    int m_iSelection;
    float m_fArrowSineOffset;

    Timer m_LocalTimer;

    stLevelSlot m_LevelSlots[MAX_LEVEL_SLOTS];

    int m_iCurrentPage;
    int m_iActiveSlots;

    Episode* m_pEpisode;
    int m_iEpisode;

public:

    SubMenuLevelSelectionState(void);
    ~SubMenuLevelSelectionState(void);

    void Init(TextFont* pTextFont, Fader* pFader);
    void Cleanup(void);
    void Reset(void);

    void ResetInterpolators(void);

    void UpdateLoading(void);
    void UpdateClosing(void);
    void Update(void);

    void PrepareEpisode(Episode* episode, int episodeIndex);
    void PrepareLevelForImmediateLoading(Episode* episode, int level, bool changeMusic);

    void SetGoingToLevel(void)
    {
        m_bGoingToLevel = true;
    };

    void InputCallbackBack(stInputCallbackParameter parameter, int inputID);
    void InputCallbackArrowLeft(stInputCallbackParameter parameter, int inputID);
    void InputCallbackArrowRight(stInputCallbackParameter parameter, int inputID);
    void InputCallbackAnySlot(stInputCallbackParameter parameter, int inputID);
    void UICallbackItunes(int button, const char* szName);
};

#endif	/* _SUBMENULEVELSELECTIONSTATE_H */