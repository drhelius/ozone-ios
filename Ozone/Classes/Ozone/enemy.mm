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
 * File:   enemy.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:27
 */

#include "enemy.h"

btCollisionShape* Enemy::m_pEnemyShape = NULL;

Enemy::Enemy(void) : NPC()
{
    if (m_pEnemyShape == NULL)
    {
        btScalar mass = 1.0f;
        btVector3 inertia(0, 0, 0);
        m_pEnemyShape = new btSphereShape(0.3f);
        m_pEnemyShape->calculateLocalInertia(mass, inertia);
    }

    m_fAffectedByElectricityTime = 0.0f;
}

Enemy::~Enemy()
{
    SafeDelete(m_pEnemyShape);
}


