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
 *  SubMenuCustomLevelsState.h
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _SUBMENUCUSTOMLEVELSSTATE_H
#define	_SUBMENUCUSTOMLEVELSSTATE_H

#include "submenustate.h"
#include "singleton.h"
#include "episode.h"
#include "inputmanager.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"
#include "UIManager.h"
#include <vector>
#include <string>


#define MAX_LEVEL_SLOTS 30

class SubMenuCustomLevelsState : public SubMenuState, public Singleton<SubMenuCustomLevelsState>
{

    ////friend class Singleton<SubMenuCustomLevelsState>;

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

    typedef std::vector<std::string> TStringVector;

    TStringVector m_LevelPathList;

    InputCallback<SubMenuCustomLevelsState>* m_pInputCallbackBack;
    InputCallback<SubMenuCustomLevelsState>* m_pInputCallbackArrowLeft;
    InputCallback<SubMenuCustomLevelsState>* m_pInputCallbackArrowRight;
    InputCallback<SubMenuCustomLevelsState>* m_pInputCallbackDownload;

    InputCallback<SubMenuCustomLevelsState>* m_pInputCallbackAnySlot;
    InputCallback<SubMenuCustomLevelsState>* m_pInputCallbackAnySlotDelete;

    UICallback<SubMenuCustomLevelsState>* m_pUICallbackDownload;
    UICallback<SubMenuCustomLevelsState>* m_pUICallbackDownloadCompleted;
    UICallback<SubMenuCustomLevelsState>* m_pUICallbackLevelDelete;

    Renderable* m_pRenderableMidLayer2D;

    RenderObject* m_pBackButton;
    RenderObject* m_pDownloadButton;
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
    bool m_bDownloadingLevel;

    int m_iSelection;
    float m_fArrowSineOffset;

    Timer m_LocalTimer;

    stLevelSlot m_LevelSlots[MAX_LEVEL_SLOTS];

    int m_iCurrentPage;
    int m_iActiveSlots;
    int m_iDeletedSlot;

public:

    SubMenuCustomLevelsState(void);
    ~SubMenuCustomLevelsState(void);

    void Init(TextFont* pTextFont, Fader* pFader);
    void Cleanup(void);
    void Reset(void);

    void ResetInterpolators(void);

    void UpdateLoading(void);
    void UpdateClosing(void);
    void Update(void);

    void ReloadLevelsFromFolders(void);
    void PrepareLevelForImmediateLoading(int level);

    void InputCallbackBack(stInputCallbackParameter parameter, int inputID);
    void InputCallbackArrowLeft(stInputCallbackParameter parameter, int inputID);
    void InputCallbackArrowRight(stInputCallbackParameter parameter, int inputID);
    void InputCallbackAnySlot(stInputCallbackParameter parameter, int inputID);
    void InputCallbackAnySlotDelete(stInputCallbackParameter parameter, int inputID);
    void InputCallbackDownload(stInputCallbackParameter parameter, int inputID);
    void UICallbackDownload(int button, const char* szName);
    void UICallbackDownloadCompleted(int button, const char* szName);
    void UICallbackLevelDelete(int button, const char* szName);
};

#endif	/* _SUBMENUCUSTOMLEVELSSTATE_H */