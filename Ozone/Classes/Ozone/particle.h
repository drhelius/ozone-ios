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
 * File:   particle.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:54
 */

#pragma once
#ifndef _PARTICLE_H
#define	_PARTICLE_H

#include "npc.h"

class Particle : public NPC
{

protected:

    Vec3 m_vDir;

    bool m_bDead;
    float m_fTimeToLive;
    float m_fRotationY;

    static btSphereShape* m_pParticleShape;
    static btVector3 m_vParticleShapeInertia;

    COLOR m_Color;
    bool m_bUseColor;

public:

    Particle(void);
    ~Particle();

    virtual void Init(void) = 0;

    float GetTimeToLive(void) const
    {
        return m_fTimeToLive;
    };

    void SetTimeToLive(const float ttl)
    {
        m_fTimeToLive = ttl;
    };

    float GetRotationY(void) const
    {
        return m_fRotationY;
    };

    void SetRotationY(const float radians)
    {
        m_fRotationY = radians;
    };

    bool IsDead(void) const
    {
        return m_bDead;
    };

    void Kill(void)
    {
        m_bDead = true;
    };

    virtual void Enable(void)
    {
        NPC::Enable();

        m_bDead = false;
    };

    void UseColor(bool enable)
    {
        m_bUseColor = enable;
    }

    void SetColor(const COLOR& color)
    {
        m_Color = color;
    };


    COLOR GetColor(void) const
    {
        return m_Color;
    };

    const Vec3& GetDir(void) const
    {
        return m_vDir;
    };

    void SetDir(const Vec3& dir)
    {
        m_vDir = dir;
    };
};

#endif	/* _PARTICLE_H */

