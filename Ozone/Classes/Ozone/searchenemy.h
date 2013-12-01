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
 * File:   searchenemy.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:32
 */

#pragma once
#ifndef _SEARCHENEMY_H
#define	_SEARCHENEMY_H

#include "enemy.h"
#include "interpolatormanager.h"

class SearchEnemy : public Enemy
{

    enum eSearchEnemyStates
    {

        SEARCH_ENEMY_IDLE,
        SEARCH_ENEMY_START_SEARCHING,
        SEARCH_ENEMY_SEARCHING,
        SEARCH_ENEMY_STOP_SEARCHING
    };

private:

    Vec3 m_vIniPos;

    SquareInterpolator* m_pFadeInInterpolator;
    LinearInterpolator* m_pFadeOutInterpolator;

    float m_fUpperLayerOpacity;

    eSearchEnemyStates m_State;

    RenderObject m_UpperLayer;

public:

    SearchEnemy(void);
    virtual ~SearchEnemy();

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);

    virtual void Update(Timer* timer);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    virtual void ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers);

    virtual void Enable(void);
    virtual void Disable(void);
    virtual void Reset(void);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
    virtual void ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData);
    virtual void ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData);

    virtual void Kill(void);

    virtual bool AffectedByElectricity(void)
    {
        return true;
    };

};

#endif	/* _SEARCHENEMY_H */

