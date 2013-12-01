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
 * File:   BossEarthEnemy.h
 * Author: nacho
 *
 * Created on 10 de enero de 2010, 23:57
 */

#pragma once
#ifndef _BOSSEARTHENEMY_H
#define	_BOSSEARTHENEMY_H

#include "enemy.h"
#include "interpolatormanager.h"

#define MAX_BOSS_EARTH_ANGULAR_VEL 190.0f
#define BOSS_EARTH_ANGULAR_ACCEL 27.0f
#define BOSS_EARTH_BLADE_VEL 45.0f
#define BOSS_EARTH_BLADE_LENGTH 150.0f
#define BOSS_EARTH_HEALTH 90

enum eBossEarthStates
{

    BOSS_EARTH_START_STATE = 0,
    BOSS_EARTH_CANNON_STATE,
    BOSS_EARTH_BLADES_STATE,
    BOSS_EARTH_DIE_STATE,
    BOSS_EARTH_STATE_COUNT
};

class BossEarthEnemy : public Enemy
{

private:

    Vec3 m_vIniPos;

    btCollisionShape* m_pCrossBladesHorizontalShape;
    btCollisionShape* m_pCrossBladesVerticalShape;
    btCollisionShape* m_pCrossCannonHorizontalShape;
    btCollisionShape* m_pCrossCannonVerticalShape;
    btCollisionShape* m_pSphereBodyShape;

    btCompoundShape* m_pCompoundShape;

    RenderObject m_BladeRenderObject[4];
    RenderObject m_CannonRenderObject[4];
    RenderObject m_FlashRenderObject[4];
    RenderObject m_GlowRenderObject;

    LinearInterpolator* m_pFlashInterpolator[4];

    SinusoidalInterpolator* m_pGlowInterpolator;
    SineInterpolator* m_pMovementInterpolator;
    SinusoidalInterpolator* m_pHitSineInterpolator;
    SinusoidalInterpolator* m_pHitSawtoothInterpolator;
    SquareInterpolator* m_pDieInterpolator;

    Vec3 m_vLeakDir;

    float m_fflashGlow[4];

    float m_fHitGlow;
    float m_fTimeOfLeak;
    float m_fGlowAlpha;
    float m_fAngularVel;
    float m_fAngularRot;
    float m_fLastActionTime;
    float m_fBladeOffset;
    float m_fMovement;
    float m_fLastNukeTime;

    eBossEarthStates m_CurrentState;

    int m_iSubState;

    int m_iCurrentCannon;

    int m_iHealth;

    Timer m_BossTimer;

    void UpdateStartState(Timer* timer);
    void UpdateCannonState(Timer* timer);
    void UpdateBladesState(Timer* timer);
    void UpdateDieState(Timer* timer);
    void Defaults(void);

public:

    BossEarthEnemy(void);
    ~BossEarthEnemy();

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
};

#endif	/* _BOSSEARTHENEMY_H */

