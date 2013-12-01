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
 * File:   lancesenemy.h
 * Author: nacho
 *
 * Created on 22 de agosto de 2009, 0:40
 */

#pragma once
#ifndef _LANCESENEMY_H
#define	_LANCESENEMY_H

#include "enemy.h"

class LancesEnemy : public Enemy
{

private:

    enum eLancesState
    {
        LANCES_IDLE_OUT,
        LANCES_GOING_IN,
        LANCES_IDLE_IN,
        LANCES_GOING_OUT
    };

    Vec3 m_vThrowingDir;
    Vec3 m_vOriginalPosition;

    eLancesState m_State;

    float m_fCurrentTime;

    float m_fOffset;

    float m_fLastTimeSmokeAdded;

    RenderObject m_HolesRenderObject;

public:

    LancesEnemy(void);
    
    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
};

#endif	/* _LANCESENEMY_H */

