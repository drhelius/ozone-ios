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
 * File:   searchthrowingenemy.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:37
 */

#pragma once
#ifndef _SEARCHTHROWINGENEMY_H
#define	_SEARCHTHROWINGENEMY_H

#include "enemy.h"

#define MAX_SEARCH_THROWING_ENEMY_ANGLE (65.0f)
#define SEARCH_THROWING_ENEMY_CADENCY (1.25f)

class SearchThrowingEnemy : public Enemy
{

private:

    float m_fLastTimeThrown;

    Vec3 m_vStartThrowingPosition;

    Vec3 m_vOriginalPosition;
    float m_fRotationRad;
    RenderObject m_CannonRenderObejct;
    u8 m_Rotation;

    float m_fCannonRotation;

public:

    SearchThrowingEnemy(void);

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);

    virtual void Enable(void);
    virtual void Disable(void);
    virtual void Reset(void);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData);
    virtual void ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData);

    virtual void Kill(void);

    virtual bool AffectedByElectricity(void)
    {
        return true;
    };

    virtual const Vec3& GetRealPosition(void) const
    {
        return m_vStartThrowingPosition;
    };
};

#endif	/* _SEARCHTHROWINGENEMY_H */

