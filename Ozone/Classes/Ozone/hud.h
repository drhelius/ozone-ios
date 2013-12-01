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
 * File:   hud.h
 * Author: nacho
 *
 * Created on 20 de agosto de 2009, 21:54
 */

#pragma once
#ifndef _HUD_H
#define	_HUD_H

#include "defines.h"
#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "player.h"

#define BUTTON_GLOW_DISMISS_RATE 3.0f

class Hud
{

    enum eInputButtons
    {

        INPUT_BUTTON_BRAKE,
        INPUT_BUTTON_DEFLATE,
        INPUT_BUTTON_FIRE,
        INPUT_BUTTON_MENU,
        INPUT_BUTTON_NUCLEAR,
        MAX_INPUT_BUTTON
    };


private:

    Player* m_pThePlayer;

    bool m_bNeedCleanup;

    Renderable* m_pRenderableHud;
    RenderObject* m_pHudController;
    RenderObject* m_pHudFireButtonNormal;
    RenderObject* m_pHudFireButtonElectric;
    RenderObject* m_pHudFireButtonNuclear;
    RenderObject* m_pHudFireButtonSteel;
    RenderObject* m_pHudBrakeButton;
    RenderObject* m_pHudDeflateButton;
    RenderObject* m_pHudGemCounter;
    RenderObject* m_pHudMenuButton;
    RenderObject* m_pHudGemOverlay;
    RenderObject* m_pHudGemGlow;

    RenderObject* m_pHudPowerBlue[24];
    RenderObject* m_pHudPowerRedGlow[5];
    RenderObject* m_pHudPowerRed[5];
    RenderObject* m_pHudPowerGray[24];

    RenderObject* m_pHudButtonGlow[5];

    float m_fHudButtonGlow[5];
    float m_fHudPowerAlpha;
    float m_fHudGemGlowAlpha;

    float m_fNuclearScale;
    float m_fNormalScale;
    float m_fElectricScale;


    SineInterpolator* m_pHudPowerAlphaInterpolator;
    LinearInterpolator* m_pGemGlowInterpolator;
    SpringInterpolator* m_pNuclearScaleInterpolator;
    SpringInterpolator* m_pElectricScaleInterpolator;
    SpringInterpolator* m_pNormalScaleInterpolator;

public:
    Hud();
    ~Hud();

    void Init(Player* pPlayer);
    void Cleanup(void);

    void Update(Timer* pTimer, bool* pInputState, Vec3& vecController);

    void Reset(void);
};

#endif	/* _HUD_H */

