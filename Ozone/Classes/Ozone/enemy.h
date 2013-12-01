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
 * File:   enemy.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:27
 */

#pragma once
#ifndef _ENEMY_H
#define	_ENEMY_H

#include "npc.h"

class Enemy : public NPC
{

protected:

    static btCollisionShape* m_pEnemyShape;
    float m_fAffectedByElectricityTime;


public:

    Enemy(void);
    ~Enemy();

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript) = 0;

    virtual void Kill(void) { };

    virtual bool AffectedByElectricity(void)
    {
        return false;
    };

    void AddElectricityTime(float dTime)
    {
        m_fAffectedByElectricityTime += dTime;
    };

    float GetElectricityTime(void) const
    {
        return m_fAffectedByElectricityTime;
    };

    virtual const Vec3& GetRealPosition(void) const
    {
        return m_vPosition;
    };
};

#endif	/* _ENEMY_H */

