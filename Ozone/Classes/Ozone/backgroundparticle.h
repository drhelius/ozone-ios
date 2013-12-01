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
 * File:   backgroundparticle.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 0:03
 */

#pragma once
#ifndef _BACKGROUNDPARTICLE_H
#define	_BACKGROUNDPARTICLE_H

#include "particle.h"

class BackgroundParticle : public Particle
{
private:

    int m_iType;

    Vec3 m_vDir;

    float m_fLinearVel;
    float m_fAngularVel;

    float m_fRotation;

    float m_fMaxX;
    float m_fMaxY;

public:

    BackgroundParticle(int type, float maxX, float maxY);

    virtual void Init(void) {};
    void Init(char* szDepthPath);
    virtual void Update(Timer* timer);
};

#endif	/* _BACKGROUNDPARTICLE_H */

