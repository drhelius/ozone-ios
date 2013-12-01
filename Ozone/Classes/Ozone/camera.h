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

/********************************************************************/
/********************************************************************/
/*								Camera.h							*/
/*																    */
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
#pragma once
#ifndef _CAMERA_H
#define	_CAMERA_H

#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include "defines.h"
#include "timer.h"

class Camera
{

public:
    Camera(void);
    ~Camera(void);

    void AddNoise(float duration, Timer* timer);

    void Update(void);
    void SetMode(bool bPerspective);
    void GoForward(float speed, float deltaTime);
    void GoStrafe(float speed, float deltaTime);
    void GoUp(float speed, float deltaTime);

    float GetFarPlane(void) const
    {
        return m_fFarPlane;
    }

    void SetFarPlane(float val)
    {
        m_fFarPlane = val;
    }

    float GetNearPlane(void) const
    {
        return m_fNearPlane;
    }

    void SetNearPlane(float val)
    {
        m_fNearPlane = val;
    }

    void SetAbsoluteTransform(MATRIX &val)
    {
        m_matAbsoluteTransform = val;
    }

    MATRIX& GetAbsoluteTransform(void) 
    {
        return m_matAbsoluteTransform;
    }

    void SetTarget(Vec3 &val)
    {
        m_vTarget = val;
    }

    Vec3 GetTarget(void) const
    {
        return m_vTarget;
    }

    Vec3 GetPosition(void) const
    {
        return m_vPosition;
    }

    void SetPosition(Vec3 &val)
    {
        m_vPosition = val;
    }

    void SetPosition(float x, float y, float z)
    {
        m_vPosition.x = x;
        m_vPosition.y = y;
        m_vPosition.z = z;

    }

    Vec3 GetRight(void) const
    {
        return m_vRight;
    }

    void SetRight(Vec3 &val)
    {
        m_vRight = val;
    }

    Vec3 GetUp(void) const
    {
        return m_vUp;
    }

    void SetUp(Vec3 &val)
    {
        m_vUp = val;
    }

    Vec3 GetLook(void) const
    {
        return m_vLook;
    }

    void SetLook(Vec3 &val)
    {
        m_vLook = val;
    }

    float GetFov(void) const
    {
        return m_fFov;
    }

    void SetFov(float val)
    {
        m_fFov = val;
    }

    float GetYaw(void) const
    {
        return m_fYaw;
    }

    void SetYaw(float val)
    {
        m_fYaw = val;
    }

    float GetPitch(void) const
    {
        return m_fPitch;
    }

    void SetPitch(float val)
    {
        m_fPitch = val;
    }

    float GetRoll(void) const
    {
        return m_fRoll;
    }

    void SetRoll(float val)
    {
        m_fRoll = val;
    }

    bool GetRotate90(void) const
    {
        return m_bRatate90;
    }

    void SetRotate90(bool rotate90)
    {
        m_bRatate90 = rotate90;
    }

    bool IsTargeting(void) const
    {
        return m_bTargeting;
    }

    void SetTargeting(bool targeting)
    {
        m_bTargeting = targeting;
    }

private:

    float m_fNoiseDuration;
    float m_fNoiseStart;
    Timer* m_pNoiseTimer;

    bool m_bRatate90;
    bool m_bTargeting;

    float m_fFov;

    float m_fPitch;
    float m_fYaw;
    float m_fRoll;

    float m_fNearPlane;
    float m_fFarPlane;

    Vec3 m_vPosition;
    Vec3 m_vTarget;
    Vec3 m_vRight;
    Vec3 m_vUp;
    Vec3 m_vLook;

    MATRIX m_matView;
    MATRIX m_matProjection;
    MATRIX m_matAbsoluteTransform;

    bool m_bPerspective;
};

#endif	/* _CAMERA_H */

//////////////////////////////////////////////////////////////////////

/********************************************************************/
/********************************************************************/
/*							End Camera.h							*/
/*																    */
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////



