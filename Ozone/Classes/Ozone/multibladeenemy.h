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
 * File:   multibladeenemy.h
 * Author: nacho
 *
 * Created on 22 de agosto de 2009, 0:40
 */

#pragma once
#ifndef _MULTIBLADEENEMY_H
#define	_MULTIBLADEENEMY_H

#include "enemy.h"

#define MULTIBLADE_ENEMY_ROTATION_RATE (150.0f)

class MultiBladeEnemy : public Enemy
{

private:

    bool m_bReverse;

    static btCollisionShape* m_pCrossHorizontalShape;
    static btCollisionShape* m_pCrossVerticalShape;
    static btCompoundShape* m_pCrossCompoundShape;

public:

    MultiBladeEnemy(void);
    ~MultiBladeEnemy();

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
};

#endif	/* _MULTIBLADEENEMY_H */

