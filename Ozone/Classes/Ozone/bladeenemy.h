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
 * File:   bladeenemy.h
 * Author: nacho
 *
 * Created on 22 de agosto de 2009, 0:40
 */

#pragma once
#ifndef _BLADEENEMY_H
#define	_BLADEENEMY_H

#include "enemy.h"

enum eBladeState
{

    BLADE_IDLE_OUT_1,
    BLADE_GOING_FRONT,
    BLADE_IDLE_OUT_2,
    BLADE_GOING_IN,
    BLADE_IDLE_IN,
    BLADE_GOING_OUT
};

class BladeEnemy : public Enemy
{

private:

    static btCollisionShape* m_pBladeShape;

    eBladeState m_State;

    Vec3 m_vThrowingDir;
    Vec3 m_vMovingDir;
    Vec3 m_vOriginalPosition;

    float m_fLastTimeSmokeAdded;
    float m_fCurrentTime;
    float m_fOffsetFront;
    float m_fOffsetLateral;

    bool m_bReverse;

    RenderObject m_SlideRenderObject;

    float m_fRunLength;

public:

    BladeEnemy(bool reverse);
    ~BladeEnemy();

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);

    eBladeState GetState(void) const
    {
        return m_State;
    };
/*
    virtual void ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers)
    {
        ContactWithBlade(this, impulse, timer);
    };
*/
};

#endif	/* _BLADEENEMY_H */

