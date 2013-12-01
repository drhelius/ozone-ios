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
 * File:   particle.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:54
 */

#include "particle.h"

btSphereShape* Particle::m_pParticleShape = NULL;
btVector3 Particle::m_vParticleShapeInertia = btVector3(0, 0, 0);

Particle::Particle(void) : NPC()
{
    m_bDead = false;
    m_bUseColor = false;

    m_Color.r = 1.0f;
    m_Color.g = 1.0f;
    m_Color.b = 1.0f;
    m_Color.a = 1.0f;

    if (m_pParticleShape == NULL)
    {
        btScalar mass = 1.0f;
        m_pParticleShape = new btSphereShape(0.1f);
        m_pParticleShape->calculateLocalInertia(mass, m_vParticleShapeInertia);
    }
}

Particle::~Particle()
{
    SafeDelete(m_pParticleShape);
}