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
 * File:   BossVulcanEnemy.h
 * Author: nacho
 *
 * Created on 10 de enero de 2010, 23:58
 */

#pragma once
#ifndef _BOSSVULCANENEMY_H
#define	_BOSSVULCANENEMY_H

#include "enemy.h"
#include "interpolatormanager.h"

#define BOSS_VULCAN_HEALTH 30
#define BOSS_VULCAN_ACC_SPEED 50.0f
#define BOSS_VULCAN_MAX_SPEED 1100.0f
#define BOSS_VULCAN_SPEED_INC 60.0f
#define BOSS_VULCAN_MAX_OFFSET 320.0f
#define BOSS_VULCAN_CANNON_SPEED 13.0f
#define BOSS_VULCAN_LEGS_SPEED 20.0f
#define BOSS_VULCAN_LEGS_LENGTH 30.0f

enum eBossVulcanStates
{

    BOSS_VULCAN_START_STATE = 0,
    BOSS_VULCAN_CANNON_STATE,
    BOSS_VULCAN_MOVING_STATE,
    BOSS_VULCAN_DIE_STATE,
    BOSS_VULCAN_STATE_COUNT
};

class BossVulcanEnemy : public Enemy
{

private:    

    btCollisionShape* m_pShortLegShape[4];
    btCollisionShape* m_pSphereBodyShape;
    btCompoundShape* m_pCompoundShape[4];
    btRigidBody* m_pLegsRigidBody[4];

    RenderObject m_LongLegRenderObject[4];
    RenderObject m_ShortLegRenderObject[4];
    RenderObject m_LegF3RenderObject[4];
    RenderObject m_CannonF2RenderObject;
    RenderObject m_FlashRenderObject;
    RenderObject m_CannonRenderObject;

    SineInterpolator* m_pMovementInterpolator;
    SinusoidalInterpolator* m_pHitSineInterpolator[4];
    SinusoidalInterpolator* m_pHitSawtoothInterpolator;
    SquareInterpolator* m_pDieInterpolator;
    LinearInterpolator* m_pFlashInterpolator;
    SinusoidalInterpolator* m_pCannonGlowInterpolator;
    SinusoidalInterpolator* m_pLegsGlowInterpolator;

    eBossVulcanStates m_CurrentState;

    Vec3 m_vLeakDir;

    Vec3 m_vOriginalPos;

    int m_iSubState;
    int m_iHealth[4];
    int m_iCorner;
    int m_iRotCount;
    int m_iCurrentExplo;

    Vec3 m_vCornerDir[4];

    float m_fFlashGlow;
    float m_fTimeOfLeak;
    float m_fHitGlow[4];
    float m_fHitGlowWave;
    float m_fHitGlowDie;
    float m_fMovement;
    float m_fSpeed;
    float m_fOffset;
    float m_fCannonRot;
    float m_fCannonRotOffset;
    float m_fLegsOffset;
    float m_fLastNukeTime;
    float m_fCannonGlowAlpha;
    float m_fLegsGlowAlpha;

    Timer m_BossTimer;

    void UpdateStartState(Timer* timer);
    void UpdateCannonState(Timer* timer);
    void UpdateMovingState(Timer* timer);
    void UpdateDieState(Timer* timer);
    void Defaults(void);

public:

    BossVulcanEnemy(void);
    ~BossVulcanEnemy();

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

#endif	/* _BOSSVULCANENEMY_H */

