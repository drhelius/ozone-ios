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
 * File:   BossOceanEnemy.h
 * Author: nacho
 *
 * Created on 10 de enero de 2010, 23:58
 */

#pragma once
#ifndef _BOSSOCEANENEMY_H
#define	_BOSSOCEANENEMY_H

#include "enemy.h"
#include "interpolatormanager.h"

#define BOSS_OCEAN_HEALTH 130

enum eBossOceanStates
{

    BOSS_OCEAN_START_STATE = 0,
    BOSS_OCEAN_CANNON_CENTER_STATE,
    BOSS_OCEAN_CANNON_SIDES_STATE,
    BOSS_OCEAN_DIE_STATE,
    BOSS_OCEAN_STATE_COUNT
};

class BossOceanEnemy : public Enemy
{

private:

    RenderObject m_RingRenderObject;
    RenderObject m_LegsRenderObject[4];
    RenderObject m_CannonRenderObject;

    Vec3 m_vIniPos;

    btCollisionShape* m_pSphereBodyShape;
    SineInterpolator* m_pMovementInterpolator;
    SinusoidalInterpolator* m_pHitSineInterpolator;
    SinusoidalInterpolator* m_pHitSawtoothInterpolator;
    SquareInterpolator* m_pDieInterpolator;
    SinusoidalInterpolator* m_pCannonInterpolator;
    SinusoidalInterpolator* m_pTravelInterpolator;

    Vec3 m_vLeakDir;
    Vec3 m_vRingRotation;
    Vec3 m_PlayerDir;

    float m_fTravelOffset;
    float m_fCannonRotation;
    float m_fHitGlow;
    float m_fTimeOfLeak;
    float m_fLastActionTime;
    float m_fMovement;
    float m_fLastNukeTime;

    eBossOceanStates m_CurrentState;

    int m_iSubState;

    int m_iCurrentCannon;

    int m_iHealth;

    Timer m_BossTimer;

    void UpdateStartState(Timer* timer);
    void UpdateCannonSidesState(Timer* timer);
    void UpdateCannonCenterState(Timer* timer);
    void UpdateDieState(Timer* timer);
    void Defaults(void);

public:

    BossOceanEnemy(void);
    ~BossOceanEnemy();

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    virtual void Enable(void);
    virtual void Disable(void);
    virtual void Reset(void);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
    virtual void ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData);
    virtual void ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData);
};

#endif	/* _BOSSOCEANENEMY_H */

