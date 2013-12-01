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
 * File:   interpolators.h
 * Author: nacho
 *
 * Created on 3 de agosto de 2009, 17:20
 */

#pragma once
#ifndef _INTERPOLATORS_H
#define	_INTERPOLATORS_H

#include "defines.h"

//////////////////////////
//////////////////////////

class Interpolator
{

protected:

    bool m_bActive;

    bool m_bInversed;

    bool m_bFinished;

    bool m_bCanKill;
    bool m_bPaused;

    float m_fDuration;
    float m_fElapsedTime;

    float* m_pTargetValue;

public:

    Interpolator(float* pTarget, bool inversed, float duration)
    {
        m_bInversed = inversed;
        m_pTargetValue = pTarget;
        m_fDuration = duration;
        m_bCanKill = false;
        m_bPaused = false;
        m_bActive = false;
        m_fElapsedTime = 0.0f;
    };

    virtual ~Interpolator()
    {
    };

    virtual void Tick(void) = 0;

    void Update(float fdTime)
    {
        m_bActive = true;

        if (m_bPaused)
            return;

        m_fElapsedTime += fdTime;

        if (m_fDuration > 0.0f)
        {
            m_fElapsedTime = MAT_Min(m_fElapsedTime, m_fDuration);
        }

        Tick();

        if ((m_fDuration > 0.0f) && (m_fElapsedTime >= m_fDuration))
        {
            Kill();
        }
    };

    void Pause(void)
    {
        m_bPaused = true;
    };

    void Continue(void)
    {
        m_bPaused = false;
    };

    void Kill(void)
    {
        m_bCanKill = true;
        m_bActive = false;
    };

    void Reset(void)
    {
        m_bCanKill = false;
        m_bActive = false;
        m_fElapsedTime = 0.0f;        
    };

    bool CanKill(void) const
    {
        return m_bCanKill;
    };

    bool IsFinished(void) const
    {
        return m_bCanKill;
    };

    bool IsActive(void) const
    {
        return m_bActive;
    };

    void SetDuration(float value)
    {
        m_fDuration = value;
    };
};

//////////////////////////
//////////////////////////

class LinearInterpolator : public Interpolator
{

private:

    float m_fStartValue;
    float m_fEndValue;

public:

    LinearInterpolator(float* pTarget, float startValue, float endValue, float duration) : Interpolator(pTarget, false, duration)
    {
        m_fStartValue = startValue;
        m_fEndValue = endValue;

        Log("+++ LinearInterpolator::LinearInterpolator creado\n");
    };

    void Redefine(float startValue, float endValue, float duration)
    {
        m_fStartValue = startValue;
        m_fEndValue = endValue;

        m_fDuration = duration;
        m_bCanKill = false;
        m_fElapsedTime = 0.0f;
    };

    virtual void Tick(void)
    {
        float x = MAT_Clampf(m_fElapsedTime / m_fDuration, 0.0f, 1.0f);

        float y = x;

        (*m_pTargetValue) = m_fStartValue + (y * (m_fEndValue - m_fStartValue));
    };
};

//////////////////////////
//////////////////////////

class QuadraticInterpolator : public Interpolator
{

private:

    float m_fStartValue;
    float m_fMidValue;
    float m_fEndValue;

public:

    QuadraticInterpolator(float* pTarget, float startValue, float midValue, float endValue, float duration) : Interpolator(pTarget, false, duration)
    {
        m_fStartValue = startValue;
        m_fMidValue = midValue;
        m_fEndValue = endValue;

        Log("+++ QuadraticInterpolator::QuadraticInterpolator creado\n");
    };

    virtual void Tick(void)
    {
        float b = MAT_Clampf(m_fElapsedTime / m_fDuration, 0.0f, 1.0f);

        float a = 1.0f - b;

        (*m_pTargetValue) = (m_fStartValue * a * a) + (m_fMidValue * 2.0f * a * b) + (m_fEndValue * b * b);
    };
};

//////////////////////////
//////////////////////////

class CubicInterpolator : public Interpolator
{

private:

    float m_fStartValue;
    float m_fMidValue1;
    float m_fMidValue2;
    float m_fEndValue;

public:

    CubicInterpolator(float* pTarget, float startValue, float midValue1, float midValue2, float endValue, float duration) : Interpolator(pTarget, false, duration)
    {
        m_fStartValue = startValue;
        m_fMidValue1 = midValue1;
        m_fMidValue2 = midValue2;
        m_fEndValue = endValue;

        Log("+++ CubicInterpolator::CubicInterpolator creado\n");
    };

    virtual void Tick(void)
    {
        float b = MAT_Clampf(m_fElapsedTime / m_fDuration, 0.0f, 1.0f);

        float a = 1.0f - b;

        float a2 = a * a;
        float b2 = b * b;

        (*m_pTargetValue) = (m_fStartValue * a * a2) + (m_fMidValue1 * .0f * a2 * b) + (m_fMidValue2 * 3.0f * a * b2) + (m_fEndValue * b * b2);
    };
};

//////////////////////////
//////////////////////////

class SquareInterpolator : public Interpolator
{

private:

    float m_fMinValue;
    float m_fMaxValue;
    float m_fTimeInterval;

public:

    SquareInterpolator(float* pTarget, float minValue, float maxValue, float timeInterval, bool inversed = false, float duration = 0) : Interpolator(pTarget, inversed, duration)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;

        Log("+++ SquareInterpolator::SquareInterpolator creado\n");
    };

    void Redefine(float minValue, float maxValue, float timeInterval, bool inversed = false, float duration = 0)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;

        m_bInversed = inversed;
        m_fDuration = duration;
        m_bCanKill = false;
        m_fElapsedTime = 0.0f;
    };

    virtual void Tick(void)
    {
        float x = m_fElapsedTime / m_fTimeInterval;

        float y = x - floorf(x);

        if (m_bInversed)
            y = 1.0f - y;

        if (y < 0.5f)
        {
            (*m_pTargetValue) = m_fMinValue;
        }
        else
        {
            (*m_pTargetValue) = m_fMaxValue;
        }
    };
};

//////////////////////////
//////////////////////////

class SawtoothInterpolator : public Interpolator
{

private:

    float m_fMinValue;
    float m_fMaxValue;
    float m_fTimeInterval;

public:

    SawtoothInterpolator(float* pTarget, float minValue, float maxValue, float timeInterval, bool inversed = false, float duration = 0) : Interpolator(pTarget, inversed, duration)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;

        Log("+++ SawtoothInterpolator::SawtoothInterpolator creado\n");
    };

    virtual void Tick(void)
    {
        float x = m_fElapsedTime / m_fTimeInterval;

        float y = x - floorf(x);

        if (m_bInversed)
            y = 1.0f - y;

        (*m_pTargetValue) = m_fMinValue + (y * (m_fMaxValue - m_fMinValue));
    };
};


//////////////////////////
//////////////////////////

class TriangleInterpolator : public Interpolator
{

private:

    float m_fMinValue;
    float m_fMaxValue;
    float m_fTimeInterval;

public:

    TriangleInterpolator(float* pTarget, float minValue, float maxValue, float timeInterval, bool inversed = false, float duration = 0) : Interpolator(pTarget, inversed, duration)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;

        Log("+++ TriangleInterpolator::TriangleInterpolator creado\n");
    };

    virtual void Tick(void)
    {
        float x = m_fElapsedTime / m_fTimeInterval;

        float y = x - floorf(x);

        if (m_bInversed)
        {
            if (y < 0.5f)
            {
                (*m_pTargetValue) = m_fMaxValue - ((y * 2.0f) * (m_fMaxValue - m_fMinValue));
            }
            else
            {
                (*m_pTargetValue) = m_fMinValue + (((y - 0.5f) * 2.0f) * (m_fMaxValue - m_fMinValue));
            }
        }
        else
        {
            if (y < 0.5f)
            {
                (*m_pTargetValue) = m_fMinValue + ((y * 2.0f) * (m_fMaxValue - m_fMinValue));
            }
            else
            {
                (*m_pTargetValue) = m_fMaxValue - ((y - 0.5f) * 2.0f) * (m_fMaxValue - m_fMinValue);
            }
        }
    };
};

//////////////////////////
//////////////////////////

class CosineInterpolator : public Interpolator
{

private:

    float m_fMinValue;
    float m_fMaxValue;
    float m_fTimeInterval;

public:

    CosineInterpolator(float* pTarget, float minValue, float maxValue, float timeInterval, bool inversed = false, float duration = 0) : Interpolator(pTarget, inversed, duration)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;

        Log("+++ CosineInterpolator::CosineInterpolator creado\n");
    };

    virtual void Tick(void)
    {
        float x = m_fElapsedTime / m_fTimeInterval;

        float y = ((fast_cos(x * TWOPIf)) + 1.0f) / 2.0f;

        if (m_bInversed)
            y = 1.0f - y;

        (*m_pTargetValue) = m_fMinValue + (y * (m_fMaxValue - m_fMinValue));
    };
};

//////////////////////////
//////////////////////////

class SineInterpolator : public Interpolator
{

private:

    float m_fMinValue;
    float m_fMaxValue;
    float m_fTimeInterval;

public:

    SineInterpolator(float* pTarget, float minValue, float maxValue, float timeInterval, bool inversed = false, float duration = 0) : Interpolator(pTarget, inversed, duration)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;

        Log("+++ SineInterpolator::SineInterpolator creado\n");
    };

    virtual void Tick(void)
    {
        float x = m_fElapsedTime / m_fTimeInterval;

        float y = ((fast_sin(x * TWOPIf)) + 1.0f) / 2.0f;

        if (m_bInversed)
            y = 1.0f - y;

        (*m_pTargetValue) = m_fMinValue + (y * (m_fMaxValue - m_fMinValue));
    };
};


//////////////////////////
//////////////////////////

class SinusoidalInterpolator : public Interpolator
{

private:

    float m_fMinValue;
    float m_fMaxValue;
    float m_fTimeInterval;

public:

    SinusoidalInterpolator(float* pTarget, float minValue, float maxValue, float timeInterval, bool inversed = false, float duration = 0) : Interpolator(pTarget, inversed, duration)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;

        Log("+++ SinusoidalInterpolator::SinusoidalInterpolator creado\n");
    };

    void SetMinValue(float value)
    {
        m_fMinValue = value;
    };

    void SetMaxValue(float value)
    {
        m_fMaxValue = value;
    };

    void SetTimeInterval(float value)
    {
        m_fTimeInterval = value;
    };

    void Redefine(float minValue, float maxValue, float timeInterval, bool inversed = false, float duration = 0)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;

        m_bInversed = inversed;
        m_fDuration = duration;
        m_bCanKill = false;
        m_fElapsedTime = 0.0f;
    };

    virtual void Tick(void)
    {
        float x = m_fElapsedTime / m_fTimeInterval;

        float y = -((fast_cos(x * PIf)) / 2.0f) + 0.5f;

        if (m_bInversed)
            y = -y + 1.0f;

        (*m_pTargetValue) = m_fMinValue + (y * (m_fMaxValue - m_fMinValue));
    };
};

//////////////////////////
//////////////////////////

class SpringInterpolator : public Interpolator
{

private:

    float m_fMinValue;
    float m_fMaxValue;
    float m_fTimeInterval;
    float m_fCosFactor;
    float m_fExpFactor;
    float m_fAmplitude;

public:

    SpringInterpolator(float* pTarget, float minValue, float maxValue, float cosFactor, float expFactor, float amplitude, float timeInterval, bool inversed = false, float duration = 0) : Interpolator(pTarget, inversed, duration)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fTimeInterval = timeInterval;
        m_fCosFactor = cosFactor;
        m_fExpFactor = expFactor;
        m_fAmplitude = amplitude;

        Log("+++ SpringInterpolator::SpringInterpolator creado\n");
    };

    virtual void Tick(void)
    {
        float x = m_fElapsedTime / m_fTimeInterval;

        float y = m_fAmplitude - (fast_cos(x * m_fCosFactor * PIf) * expf(-x * m_fExpFactor) * m_fAmplitude);

        if (m_bInversed)
            y = m_fAmplitude - y;

        (*m_pTargetValue) = m_fMinValue + (y * (m_fMaxValue - m_fMinValue));
    };
};

//////////////////////////
//////////////////////////

class EaseInterpolator : public Interpolator
{

private:

    float m_fMinValue;
    float m_fMaxValue;
    float m_fPower;

public:

    EaseInterpolator(float* pTarget, float minValue, float maxValue, float power, float duration, bool inversed = false) : Interpolator(pTarget, inversed, duration)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fPower = power;

        Log("+++ EaseInterpolator::EaseInterpolator creado\n");
    };

    void SetMinValue(float value)
    {
        m_fMinValue = value;
    };

    void SetMaxValue(float value)
    {
        m_fMaxValue = value;
    };

    void SetPower(float value)
    {
        m_fPower = value;
    };

    void Redefine(float minValue, float maxValue, float power, float duration, bool inversed = false)
    {
        m_fMinValue = minValue;
        m_fMaxValue = maxValue;
        m_fPower = power;

        m_bInversed = inversed;
        m_fDuration = duration;
        m_bCanKill = false;
        m_fElapsedTime = 0.0f;
    };

    virtual void Tick(void)
    {
        float x = MAT_Clampf(m_fElapsedTime / m_fDuration, 0.0f, 1.0f);

        float y = 0.0f;

        if (m_bInversed)
        {
            y = powf(1.0f - x, m_fPower);
        }
        else
        {
            y = powf(x, m_fPower);
        }

        (*m_pTargetValue) = m_fMinValue + (y * (m_fMaxValue - m_fMinValue));
    };
};

#endif	/* _INTERPOLATORS_H */

