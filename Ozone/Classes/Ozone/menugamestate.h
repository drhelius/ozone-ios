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
 * File:   menugamestate.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 21:01
 */

#pragma once
#ifndef _MENUGAMESTATE_H
#define	_MENUGAMESTATE_H

#include "singleton.h"
#include "gamestate.h"
#include "timer.h"
#include "fader.h"
#include "submenustate.h"
#include "textfont.h"
#include "moveable.h"
#include "renderable.h"
#include "renderobject.h"
#include "camera.h"
#include "menuitem.h"

struct stCurrentEpisodeAndLevel
{

    int episode;
    int level;
    bool finished;
    bool previouslyCompleted;
    bool customLevel;
};

class MenuGameState : public GameState, public Singleton<MenuGameState>
{

    ////friend class Singleton<MenuGameState>;

private:


    Timer* m_pMainTimer;
    Fader* m_pFader;
    TextFont* m_pTextFont;

    stCurrentEpisodeAndLevel m_CurrentSelection;

    SubMenuState* m_pCurrentSubMenuState;

    bool m_bWantsToChangeSubMenu;
    SubMenuState* m_pNextSubMenuState;


    Camera* m_pCamera2D;
    Camera* m_pCamera3DCubeSmall;
    Renderable* m_pRenderableLowLayer2D;
    Renderable* m_pRenderableMidLayer3DCubeSmall;
    Renderable* m_pRenderableHighLayer2D;

    RenderObject* m_pBackground;
    RenderObject* m_pBackgroundTop;

    RenderObject* m_pShadowLeft;
    RenderObject* m_pShadowRight;

    RenderObject* m_pOzoneWord[5];
    Moveable m_OzoneWordData[5];

    RenderObject* m_pWordGlow;

    //RenderObject* m_pUpperBar;

    MenuItem* m_pCubeSmall;

    void UpdateCube(void);
    void UpdateWord(void);

public:

    MenuGameState(void);
    ~MenuGameState();

    void Init(void);
    void Cleanup(void);

    void Pause(void);
    void Resume(void);

    void Update(void);

    void SetSubMenu(SubMenuState*);

    void SetCurrentSelection(stCurrentEpisodeAndLevel currentSelection)
    {
        m_CurrentSelection = currentSelection;
    };

    stCurrentEpisodeAndLevel GetCurrentSelection(void) const
    {
        return m_CurrentSelection;
    };

};

#endif	/* _MENUGAMESTATE_H */

