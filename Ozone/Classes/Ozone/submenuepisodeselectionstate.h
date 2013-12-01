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
 * File:   submenuepisodeselectionstate.h
 * Author: nacho
 *
 * Created on 8 de septiembre de 2009, 0:40
 */

#pragma once
#ifndef _SUBMENUEPISODESELECTIONSTATE_H
#define	_SUBMENUEPISODESELECTIONSTATE_H

#include <vector>
#include "episode.h"
#include "submenustate.h"
#include "singleton.h"
#include "inputmanager.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"
#include "UIManager.h"

class SubMenuEpisodeSelectionState : public SubMenuState, public Singleton<SubMenuEpisodeSelectionState>
{

    ////friend class Singleton<SubMenuEpisodeSelectionState>;

    struct stEpisodeSlot
    {

        bool enabled;
        RenderObject* pFrameRO;
        RenderObject* pLockRO;
        bool locked;
        bool completed;
    };


private:

    InputCallback<SubMenuEpisodeSelectionState>* m_pInputCallbackBack;
    InputCallback<SubMenuEpisodeSelectionState>* m_pInputCallbackArrowLeft;
    InputCallback<SubMenuEpisodeSelectionState>* m_pInputCallbackArrowRight;
    InputCallback<SubMenuEpisodeSelectionState>* m_pInputCallbackAnySlot;

    UICallback<SubMenuEpisodeSelectionState>* m_pUICallbackScore;
    UICallback<SubMenuEpisodeSelectionState>* m_pUICallbackItunes;

    Renderable* m_pRenderableMidLayer2D;

    stEpisodeSlot m_EpisodeSlots[MAX_EPISODE_SLOTS];

    RenderObject* m_pMenuBar;
    RenderObject* m_pBackButton;
    RenderObject* m_pLeftArrow[2];
    RenderObject* m_pRightArrow[2];

    float m_fMenuOpacity;
    LinearInterpolator* m_pMenuOpacityInterpolator;
    SineInterpolator* m_pArrowsSineInterpolator;
    EaseInterpolator* m_pMovementInterpolator;
    CosineInterpolator* m_pSelectionInterpolator;
    SquareInterpolator* m_pUnlockInterpolator;

    float m_fSelectionOpacity;
    bool m_bWantToClose;

    int m_iSelection;

    float m_fArrowSineOffset;

    float m_fMovementOffset;

    int m_iCurrentPage;
    int m_iActiveSlots;

    Timer m_LocalTimer;

    SubMenuState* m_pChangingToMenu;

    std::vector<Episode*> m_EpisodeVector;

   
    int m_iUnlockEpisode;
    float m_fUnlockAlpha;
    bool m_bUnlockEpisode;
    bool m_bSendingScore;

public:

    SubMenuEpisodeSelectionState(void);
    ~SubMenuEpisodeSelectionState(void);

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
    void InputCallbackAnySlot(stInputCallbackParameter parameter, int id);

    void UICallbackScore(int button, const char* szName);
    void UICallbackItunes(int button, const char* szName);

    Episode* GetEpisode(int episode);

    void SetUnlockEpisode(int episode)
    {
        m_iUnlockEpisode = episode;
        m_bUnlockEpisode = true;
        m_bSendingScore = true;
    };
};

#endif	/* _SUBMENUEPISODESELECTIONSTATE_H */

