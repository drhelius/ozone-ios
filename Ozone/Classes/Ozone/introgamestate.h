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
 * File:   introgamestate.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 21:01
 */

#pragma once
#ifndef _INTROGAMESTATE_H
#define	_INTROGAMESTATE_H

#include "singleton.h"
#include "gamemanager.h"
#include "gamestate.h"
#include "camera.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "fader.h"
#include "inputmanager.h"

class IntroGameState : public GameState, public Singleton<IntroGameState>
{

    ////friend class Singleton<IntroGameState>;

private:

    InputCallback<IntroGameState>* m_pInputCallbackAny;

    bool m_bFinished;
    bool m_bLogo;
    bool m_bSkipping;
    bool m_bNeedsSkipping;
    Camera* m_pCamera3D;
    Camera* m_pCamera2D;
    Timer* m_pMainTimer;
    Fader* m_pFader;

    Renderable* m_pRenderable;

    RenderObject* m_pRoGeardomeText;
    RenderObject* m_pRoGearBig;
    RenderObject* m_pRoGearSmall;

    RenderObject* m_pRoEarphoneLogo;
    RenderObject* m_pRoEarphoneBG;
    RenderObject* m_pRoEarphoneDetail;  

    void UpdateLogo(void);
    void UpdateEarPhones(void);

public:

    IntroGameState(void);
    ~IntroGameState();

    void Init(void);
    void Cleanup(void);

    void Pause(void);
    void Resume(void);

    void Update(void);

    void InputCallbackAny(stInputCallbackParameter parameter, int id);
};

#endif	/* _INTROGAMESTATE_H */

