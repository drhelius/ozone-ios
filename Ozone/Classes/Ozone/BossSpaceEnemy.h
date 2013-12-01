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
 * File:   BossSpaceEnemy.h
 * Author: nacho
 *
 * Created on 10 de enero de 2010, 23:59
 */

#pragma once
#ifndef _BOSSSPACEENEMY_H
#define	_BOSSSPACEENEMY_H

#include "enemy.h"

#define BOSS_SPACE_HEALTH 45

enum eBossSpaceStates
{

    BOSS_SPACE_START_STATE = 0,
    BOSS_SPACE_CANNON_STATE,
    BOSS_SPACE_SEARCH_STATE,
    BOSS_SPACE_MOVING_STATE,
    BOSS_SPACE_DIE_STATE,
    BOSS_SPACE_STATE_COUNT
};

class BossSpaceEnemy : public Enemy
{

private:

    btCollisionShape* m_pLegShape[4];
    btCollisionShape* m_pSphereBodyShape;
    btCompoundShape* m_pCompoundShape[4];
    btRigidBody* m_pLegsRigidBody[4];

    RenderObject m_LegRenderObject[4];
    RenderObject m_LegGlowRenderObject[4];
    RenderObject m_BladeRenderObject;

    SineInterpolator* m_pMovementInterpolator;
    SinusoidalInterpolator* m_pHitSineInterpolator[4];
    SinusoidalInterpolator* m_pHitSawtoothInterpolator;
    SquareInterpolator* m_pDieInterpolator;
    SinusoidalInterpolator* m_pRotationalInterpolator;
    SinusoidalInterpolator* m_pLegsInterpolator;

    eBossSpaceStates m_CurrentState;

    Vec3 m_vLeakDir;

    Vec3 m_vOriginalPos;

    int m_iSubState;
    int m_iHealth[4];
    
    int m_iCurrentExplo;
    
    float m_fTimeOfLeak;
    float m_fHitGlow[4];
    float m_fHitGlowWave;
    float m_fHitGlowDie;
    float m_fMovement;    
    float m_fLastNukeTime;
    float m_fBladeRotation;
    float m_fRotation;
    float m_fLegsRotation;


    Timer m_BossTimer;

    Vec3 m_PlayerDir;

    float m_fSpeed;

    void UpdateStartState(Timer* timer);
    void UpdateCannonState(Timer* timer);
    void UpdateSearchState(Timer* timer);
    void UpdateMovingState(Timer* timer);
    void UpdateDieState(Timer* timer);
    void Defaults(void);
    void DropParticles(void);

public:

    BossSpaceEnemy(void);
    ~BossSpaceEnemy();

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

#endif	/* _BOSSSPACEENEMY_H */
