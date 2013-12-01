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
 * File:   electricenemy.h
 * Author: nacho
 *
 * Created on 22 de agosto de 2009, 0:39
 */

#pragma once
#ifndef _ELECTRICENEMY_H
#define	_ELECTRICENEMY_H

#include "enemy.h"
#include "interpolatormanager.h"

#define ELECTRIC_ENEMY_FORCE 3.2f

class ElectricEnemy : public Enemy
{

    RenderObject m_UpperLayer;
    RenderObject m_RayLayer;
    float m_fWaitInterval;
    bool m_bFlashOn;
    float m_fRayWait;
    int m_iRayFrame;

    RenderObject m_NukeLayer;
    RenderObject m_NukeLayer2;

    LinearInterpolator* m_pNukeInterpolator;

    float m_fNukeValue;

    bool m_bPlayingSound;

public:
    
    ElectricEnemy(void);
    virtual ~ElectricEnemy();

    virtual void Enable(void);
    virtual void Disable(void);
    virtual void Reset(void);

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);
    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
};

#endif	/* _ELECTRICENEMY_H */

