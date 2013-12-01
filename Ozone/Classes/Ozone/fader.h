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
 *  Fader.h
 *  PuzzleStar
 *
 *  Created by nacho on 10/11/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#pragma once

#include "defines.h"
#include "renderable.h"

class Fader : public Renderable
{

public:

    Fader(void);
    ~Fader(void);

    void StartFade(float red, float green, float blue, bool fadein, float time, float z, float target = 1.0f, float begin = 0.0f, bool additive = false);

    void Update(float dt);

    void Reset(void);

    bool IsFinished(void)
    {
        return !m_bFadeActive;
    };

    bool IsEnabled(void)
    {
        return m_bEnabled;
    };

    void Enable(bool state)
    {
        m_bEnabled = state;
    };

    float GetAlpha(void) const
    {
        return m_fAlpha;
    }

    bool IsPaused(void) const
    {
        return m_bPaused;
    };

    void Pause(bool pause)
    {
        m_bPaused = pause;
    };


private:

    RenderObject m_RenderObject;

    float m_fRed;
    float m_fGreen;
    float m_fBlue;
    float m_fFadeState;
    float m_fFadeTime;
    bool m_bFadeIn;
    bool m_bFadeActive;
    float m_fTarget;
    float m_fBegin;
    float m_fAlpha;
    bool m_bEnabled;
    bool m_bPaused;


};
