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
 * File:   moveable.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:59
 */

#pragma once
#ifndef _MOVEABLE_H
#define	_MOVEABLE_H

#include "positionable.h"

class Moveable : public Positionable
{

protected:

    Vec3 m_vSpeed;
    Vec3 m_vAcceleration;
    Vec3 m_vAngularSpeed;
    Vec3 m_vAngularAcceleration;
    Vec3 m_vGravityCenter;

public:
    Moveable(void);

    const Vec3& GetSpeed(void) const
    {
        return m_vSpeed;
    };

    void SetSpeed(const Vec3& speed)
    {
        m_vSpeed = speed;
    };

    const Vec3& GetAcceleration(void) const
    {
        return m_vAcceleration;
    };

    void SetAcceleration(const Vec3& accel)
    {
        m_vAcceleration = accel;
    };

    const Vec3& GetAngularSpeed(void) const
    {
        return m_vAngularSpeed;
    };

    void SetAngularSpeed(const Vec3& angularSpeed)
    {
        m_vAngularSpeed = angularSpeed;
    };

    const Vec3& GetAngularAcceleration(void) const
    {
        return m_vAngularAcceleration;
    };

    void SetAngularAcceleration(const Vec3& angularAccel)
    {
        m_vAngularAcceleration = angularAccel;
    };

    const Vec3& GetGravityCenter(void) const
    {
        return m_vGravityCenter;
    };

    void SetGravityCenter(const Vec3& gravityCenter)
    {
        m_vGravityCenter = gravityCenter;
    };   

    void UpdateMovement(float fdTime);

};

#endif	/* _MOVEABLE_H */

