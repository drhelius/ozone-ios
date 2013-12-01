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
 * File:   movingwallenemy.h
 * Author: nacho
 *
 * Created on 22 de agosto de 2009, 0:42
 */

#pragma once
#ifndef _MOVINGWALLENEMY_H
#define	_MOVINGWALLENEMY_H

#include "enemy.h"

#define WALL_ENEMY_ROTATION_RATE (70.0f)

class MovingWallEnemy : public Enemy
{

private:

    static btCollisionShape* m_pHorizontalShape;
    static btCompoundShape* m_pCompoundShape;

    bool m_bReverse;

public:

    MovingWallEnemy(bool reverse);
    ~MovingWallEnemy();

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
};

#endif	/* _MOVINGWALLENEMY_H */

