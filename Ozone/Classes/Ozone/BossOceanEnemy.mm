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
 * File:   BossOceanEnemy.mm
 * Author: nacho
 * 
 * Created on 10 de enero de 2010, 23:58
 */

#include "BossOceanEnemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"
#include "gamemanager.h"

BossOceanEnemy::BossOceanEnemy(void) : Enemy()
{
    InitPointer(m_pMovementInterpolator);
    InitPointer(m_pHitSineInterpolator);
    InitPointer(m_pHitSawtoothInterpolator);
    InitPointer(m_pDieInterpolator);
    InitPointer(m_pCannonInterpolator);
    InitPointer(m_pTravelInterpolator);

    InitPointer(m_pSphereBodyShape);

    Defaults();
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::Defaults(void)
{
    m_iHealth = BOSS_OCEAN_HEALTH;
    m_fTimeOfLeak = 0.0f;
    m_fHitGlow = 0.0f;
    m_fLastActionTime = 0.0f;
    m_iSubState = 0;
    m_iCurrentCannon = 0;
    m_fLastNukeTime = 0.0f;
    m_vRingRotation = Vec3(0, 0, 0);
    m_fCannonRotation = 0.0f;
    m_fTravelOffset = 0.0f;
    m_CurrentState = BOSS_OCEAN_START_STATE;
}

//////////////////////////
//////////////////////////

BossOceanEnemy::~BossOceanEnemy()
{
    SafeDelete(m_pMovementInterpolator);
    SafeDelete(m_pHitSineInterpolator);
    SafeDelete(m_pHitSawtoothInterpolator);
    SafeDelete(m_pDieInterpolator);
    SafeDelete(m_pCannonInterpolator);
    SafeDelete(m_pTravelInterpolator);

    SafeDelete(m_pSphereBodyShape);
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_vIniPos = m_vPosition;

    m_pMovementInterpolator = new SineInterpolator(&m_fMovement, -0.45f, 0.45f, 3.0f);
    m_pHitSineInterpolator = new SinusoidalInterpolator(&m_fHitGlow, 0.0f, 1.0f, 0.075f, false, 0.15f);
    m_pHitSawtoothInterpolator = new SinusoidalInterpolator(&m_fHitGlow, 0.0f, 1.0f, 0.075f, false, 0.60f);
    m_pDieInterpolator = new SquareInterpolator(&m_fHitGlow, 0.0f, 1.0f, 0.2f);
    m_pCannonInterpolator = new SinusoidalInterpolator(&m_fCannonRotation, 0.0f, 45.0f, 2.0f, false, 2.0f);
    m_pTravelInterpolator = new SinusoidalInterpolator(&m_fTravelOffset, 0.0f, 440.0f, 4.0f, false, 4.0f);

    InterpolatorManager::Instance().Add(m_pMovementInterpolator, false, m_pTheScene->GetGameTimer());

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_ocean"),
            TextureManager::Instance().GetTexture("game/entities/boss_ocean", true), RENDER_OBJECT_NORMAL);
    m_MainRenderObject.SetPosition(m_vPosition);
    m_MainRenderObject.UseColor(true);


    m_RingRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_ocean_ring"),
            TextureManager::Instance().GetTexture("game/entities/boss_ocean", true), RENDER_OBJECT_ADDITIVE);
    m_RingRenderObject.SetPosition(m_vPosition);
    m_RingRenderObject.UseColor(true);
    m_RenderObjectList.push_back(&m_RingRenderObject);

    m_CannonRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_ocean_canon"),
            TextureManager::Instance().GetTexture("game/entities/boss_ocean", true), RENDER_OBJECT_NORMAL);
    m_CannonRenderObject.SetPosition(m_vPosition);
    m_CannonRenderObject.UseColor(true);


    m_RenderObjectList.push_back(&m_CannonRenderObject);

    for (int i = 0; i < 4; i++)
    {
        m_LegsRenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_ocean_leg"),
                TextureManager::Instance().GetTexture("game/entities/boss_ocean", true), RENDER_OBJECT_NORMAL);
        MatrixRotationY(m_LegsRenderObject[i].GetTransform(), MAT_ToRadians((90.0f * i)));
        m_LegsRenderObject[i].SetPosition(m_vPosition);
        m_LegsRenderObject[i].UseColor(true);

        m_RenderObjectList.push_back(&m_LegsRenderObject[i]);
    }

    Vec4 vLeakDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);

    MATRIX matrot;
    MatrixRotationY(matrot, MAT_RandomInt(0, 360));
    MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

    m_vLeakDir = Vec3(vLeakDir4.ptr());
    m_vLeakDir.normalize();

    btScalar mass = 20.0f;
    btVector3 inertia(0, 0, 0);

    m_pSphereBodyShape = new btSphereShape(1.0f);
    m_pSphereBodyShape->setMargin(0.01f);
    m_pSphereBodyShape->calculateLocalInertia(mass, inertia);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pSphereBodyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));
    m_pRigidBody->setCollisionFlags(m_pRigidBody->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
    m_pRigidBody->setActivationState(DISABLE_DEACTIVATION);

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::Reset(void)
{
    Defaults();

    if (m_pHitSineInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pHitSineInterpolator);
        m_pHitSineInterpolator->Reset();
    }

    if (m_pHitSawtoothInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pHitSawtoothInterpolator);
        m_pHitSawtoothInterpolator->Reset();
    }

    if (m_pDieInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pDieInterpolator);
        m_pDieInterpolator->Reset();
    }

    SetPosition(m_vIniPos);

    btTransform trans;
    getWorldTransform(trans);

    m_pRigidBody->setCenterOfMassTransform(trans);
    m_pRigidBody->setInterpolationWorldTransform(trans);
    m_pRigidBody->forceActivationState(ACTIVE_TAG);
    m_pRigidBody->activate();
    m_pRigidBody->setDeactivationTime(0);

    m_pRigidBody->setLinearVelocity(btVector3(0, 0, 0));
    m_pRigidBody->setAngularVelocity(btVector3(0, 0, 0));

    if (!m_bEnable)
    {
        Enable();
    }
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::Update(Timer* timer)
{
    if (timer->IsRunning())
    {
        if (m_iHealth <= 0 && m_CurrentState != BOSS_OCEAN_DIE_STATE)
        {
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
            m_CurrentState = BOSS_OCEAN_DIE_STATE;
            m_iSubState = 0;
            m_BossTimer.Start();
            InterpolatorManager::Instance().Delete(m_pHitSineInterpolator);
            InterpolatorManager::Instance().Delete(m_pHitSawtoothInterpolator);
            InterpolatorManager::Instance().Add(m_pDieInterpolator, false, timer);
        }

        if (m_CurrentState != BOSS_OCEAN_DIE_STATE && m_iHealth < 65)
        {
            m_fTimeOfLeak += timer->GetDeltaTime();

            float wait = 0.0f;

            if (GameManager::Instance().DeviceType() == GameManager::DEVICE_1ST_GEN)
            {
                wait = 0.14f;
            }
            else
            {
                wait = 0.08f;
            }

            if (m_fTimeOfLeak > wait)
            {
                m_fTimeOfLeak = 0.0f;

                float rot = MAT_ToRadians(MAT_RandomInt(0, 360));
                float angle = MAT_ToRadians(MAT_RandomInt(0, 360));

                Vec4 vLeakDir4 = Vec4(m_vLeakDir, 1.0f);

                MATRIX matrot;
                MatrixRotationY(matrot, angle);
                MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

                ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 1.1f, 1.5f, rot, Vec3(0, 0, 0), 1.9f);

                if (m_iHealth < 45)
                {
                    rot = MAT_ToRadians(MAT_RandomInt(0, 360));
                    angle = MAT_ToRadians(MAT_RandomInt(0, 360));

                    vLeakDir4 = Vec4(m_vLeakDir, 1.0f);
                    MatrixRotationY(matrot, angle);
                    MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

                    ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 1.4f, 1.4f, rot, Vec3(0, 0, 0), 1.8f);

                    if (m_iHealth < 25)
                    {
                        rot = MAT_ToRadians(MAT_RandomInt(0, 360));
                        angle = MAT_ToRadians(MAT_RandomInt(0, 360));

                        vLeakDir4 = Vec4(m_vLeakDir, 1.0f);

                        MatrixRotationY(matrot, angle);
                        MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

                        ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 1.8f, 1.4f, rot, Vec3(0, 0, 0), 1.7f);
                    }
                }
            }
        }

        switch (m_CurrentState)
        {
            case BOSS_OCEAN_START_STATE:
            {
                UpdateStartState(timer);
                break;
            }
            case BOSS_OCEAN_CANNON_CENTER_STATE:
            {
                UpdateCannonCenterState(timer);
                break;
            }
            case BOSS_OCEAN_CANNON_SIDES_STATE:
            {
                UpdateCannonSidesState(timer);
                break;
            }
            case BOSS_OCEAN_DIE_STATE:
            {
                UpdateDieState(timer);
                break;
            }
        }

        m_vPosition.y += m_fMovement;
    }

    m_MainRenderObject.SetPosition(m_vPosition);
    float colorHit = 1.0f - MAT_Min(m_fHitGlow, 0.75f);
    m_MainRenderObject.SetColor(1.0f, colorHit, colorHit, 1.0f);

    m_vRingRotation.y -= 0.21f * timer->GetDeltaTime();
    m_vRingRotation.x -= 0.25f * timer->GetDeltaTime();
    m_vRingRotation.z += 0.30f * timer->GetDeltaTime();

    MatrixRotationX(m_RingRenderObject.GetTransform(), m_vRingRotation.x);
    MATRIX mRotY, mRotZ, scaleSmall;
    MatrixRotationY(mRotY, m_vRingRotation.y);
    MatrixRotationZ(mRotZ, m_vRingRotation.z);
    MatrixScaling(scaleSmall, 0.8f, 0.8f, 0.8f);
    MatrixMultiply(m_RingRenderObject.GetTransform(), m_RingRenderObject.GetTransform(), mRotY);
    MatrixMultiply(m_RingRenderObject.GetTransform(), m_RingRenderObject.GetTransform(), mRotZ);
    MatrixMultiply(m_RingRenderObject.GetTransform(), m_RingRenderObject.GetTransform(), scaleSmall);

    m_RingRenderObject.SetPosition(m_vPosition);
    m_RingRenderObject.SetColor(1.0f, colorHit, colorHit, 1.0f);

    MatrixRotationY(m_CannonRenderObject.GetTransform(), MAT_ToRadians(m_fCannonRotation));
    m_CannonRenderObject.SetPosition(Vec3(m_vPosition.x, m_vPosition.y - 30.0f, m_vPosition.z));
    m_CannonRenderObject.SetColor(1.0f, colorHit, colorHit, 1.0f);

    for (int i = 0; i < 4; i++)
    {
        float angle = MAT_ToRadians((90.0f * i) + 45.0f);

        Vec4 vBladeDir4 = Vec4(0.0f, 0.0f, 0.0f, 0.0f);

        MatrixRotationY(m_mtxRotation, angle);
        MatrixVec4Multiply(vBladeDir4, vBladeDir4, m_mtxRotation);

        m_LegsRenderObject[i].SetTransform(m_mtxRotation);
        m_LegsRenderObject[i].SetPosition(Vec3(vBladeDir4.ptr()) + Vec3(m_vPosition.x, m_vPosition.y - 30.0f, m_vPosition.z));
        m_LegsRenderObject[i].SetColor(1.0f, colorHit, colorHit, 1.0f);
    }
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::UpdateStartState(Timer* timer)
{

    Vec3 dirToPlayer = m_pThePlayer->GetPosition() - m_vPosition;
    float lengthToPlayer = dirToPlayer.length();

    if (lengthToPlayer < 350.0f)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));

        m_CurrentState = BOSS_OCEAN_CANNON_CENTER_STATE;

        m_BossTimer.Start();
    }
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::UpdateCannonCenterState(Timer* timer)
{

    switch (m_iSubState)
    {
            ///--- disparnado diagonal
        case 0:
        {
            if (m_iCurrentCannon >= 10)
            {
                m_iCurrentCannon = 0;
                m_iSubState = 1;
                m_pCannonInterpolator->Reset();
                m_pCannonInterpolator->Redefine(0.0f, 45.0f, 2.0f, false, 2.0f);
                InterpolatorManager::Instance().Add(m_pCannonInterpolator, false, m_pTheScene->GetGameTimer());
                m_BossTimer.Start();
            }
            else if (m_BossTimer.GetActualTime() > 0.35f)
            {
                for (int i = 0; i < 4; i++)
                {
                    Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
                    Vec4 vThrowingPos4 = Vec4(20.0f, 0.0f, 0.0f, 0.0f);

                    MATRIX rotFire;
                    float rotation = MAT_ToRadians((i * 90.0f) + 45.0f);
                    MatrixRotationY(rotFire, rotation);
                    MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, rotFire);
                    MatrixVec4Multiply(vThrowingPos4, vThrowingPos4, rotFire);

                    Vec3 impulse_1 = (Vec3(vThrowingDir4.ptr()) * 2.5f);

                    ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, Vec3(vThrowingPos4.ptr()) + m_vPosition, impulse_1, 2.0f, rotation, Vec3(0, 0, 0), 1.2f);
                }

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INLINE_THROWING), m_vPosition);

                m_iCurrentCannon++;

                m_BossTimer.Start();
            }
            break;
        }
            ///--- girando
        case 1:
        {
            if (m_pCannonInterpolator->IsFinished())
            {
                m_iSubState = 2;
                m_iCurrentCannon = 0;
                m_BossTimer.Start();
            }
            break;
        }
            ///--- disparnado en cruz
        case 2:
        {
            if (m_iCurrentCannon >= 10)
            {
                m_iCurrentCannon = 0;
                m_CurrentState = BOSS_OCEAN_CANNON_SIDES_STATE;
                m_iSubState = 0;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));
                m_PlayerDir = m_pThePlayer->GetPosition() - Vec3(m_vPosition.x, 0.0f, m_vPosition.z);
                m_PlayerDir.normalize();

                m_pTravelInterpolator->Reset();
                m_pTravelInterpolator->Redefine(0.0f, 440.0f, 4.0f, false, 4.0f);
                InterpolatorManager::Instance().Add(m_pTravelInterpolator, false, m_pTheScene->GetGameTimer());

                m_BossTimer.Start();
            }
            else if (m_BossTimer.GetActualTime() > 0.35f)
            {
                for (int i = 0; i < 4; i++)
                {
                    Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
                    Vec4 vThrowingPos4 = Vec4(20.0f, 0.0f, 0.0f, 0.0f);

                    MATRIX rotFire;
                    float rotation = MAT_ToRadians(i * 90.0);
                    MatrixRotationY(rotFire, rotation);
                    MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, rotFire);
                    MatrixVec4Multiply(vThrowingPos4, vThrowingPos4, rotFire);

                    Vec3 impulse_1 = (Vec3(vThrowingDir4.ptr()) * 2.5f);

                    ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, Vec3(vThrowingPos4.ptr()) + m_vPosition, impulse_1, 2.0f, rotation, Vec3(0, 0, 0), 1.2f);
                }

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INLINE_THROWING), m_vPosition);

                m_iCurrentCannon++;

                m_BossTimer.Start();
            }
            break;
        }
    }
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::UpdateCannonSidesState(Timer* timer)
{
    Vec3 finalDir(0, 0, 0);

    if (MAT_abs(m_PlayerDir.x) >= MAT_abs(m_PlayerDir.z))
    {
        if (m_PlayerDir.x > 0)
        {
            finalDir = Vec3(1.0f, 0.0f, 0.0f);
        }
        else
        {
            finalDir = Vec3(-1.0f, 0.0f, 0.0f);
        }
    }
    else
    {
        if (m_PlayerDir.z > 0)
        {
            finalDir = Vec3(0.0f, 0.0f, 1.0f);
        }
        else
        {
            finalDir = Vec3(0.0f, 0.0f, -1.0f);
        }
    }

    m_vPosition.x = m_vIniPos.x + (finalDir.x * m_fTravelOffset);
    m_vPosition.z = m_vIniPos.z + (finalDir.z * m_fTravelOffset);

    switch (m_iSubState)
    {
        case 0:
        {
            if (m_pTravelInterpolator->IsFinished())
            {
                m_iSubState = 1;
                m_iCurrentCannon = 0;
                m_BossTimer.Start();
            }
            break;
        }
        case 1:
        {
            if (m_iCurrentCannon >= 20)
            {
                m_iCurrentCannon = 0;
                m_iSubState = 2;
                m_pCannonInterpolator->Reset();
                m_pTravelInterpolator->Reset();
                m_pCannonInterpolator->Redefine(45.0f, 0.0f, 2.0f, false, 2.0f);
                m_pTravelInterpolator->Redefine(440.0f, 0.0f, 4.0f, false, 4.0f);
                InterpolatorManager::Instance().Add(m_pCannonInterpolator, false, m_pTheScene->GetGameTimer());
                InterpolatorManager::Instance().Add(m_pTravelInterpolator, false, m_pTheScene->GetGameTimer());
                m_BossTimer.Start();
            }
            else if (m_BossTimer.GetActualTime() > 0.35f)
            {
                for (int i = 0; i < 4; i++)
                {
                    Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
                    Vec4 vThrowingPos4 = Vec4(20.0f, 0.0f, 0.0f, 0.0f);

                    MATRIX rotFire;
                    float rotation = MAT_ToRadians(i * 90.0f);
                    MatrixRotationY(rotFire, rotation);
                    MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, rotFire);
                    MatrixVec4Multiply(vThrowingPos4, vThrowingPos4, rotFire);

                    Vec3 impulse_1 = (Vec3(vThrowingDir4.ptr()) * 2.5f);

                    ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, Vec3(vThrowingPos4.ptr()) + m_vPosition, impulse_1, 2.0f, rotation, Vec3(0, 0, 0), 1.2f);
                }

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INLINE_THROWING), m_vPosition);

                m_iCurrentCannon++;

                m_BossTimer.Start();
            }
            break;
        }
        case 2:
        {
            if (m_pTravelInterpolator->IsFinished())
            {
                m_iCurrentCannon = 0;
                m_CurrentState = BOSS_OCEAN_CANNON_CENTER_STATE;
                m_iSubState = 0;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));
                m_BossTimer.Start();
            }
            break;
        }
    }
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::UpdateDieState(Timer* timer)
{

    switch (m_iSubState)
    {
            ///--- parpadeando
        case 0:
        {
            if (m_BossTimer.GetActualTime() > 2.0f)
            {
                m_iSubState = 1;
                m_iCurrentCannon = 0;
                m_BossTimer.Start();

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY), m_vPosition);
            }
            break;
        }
        case 1:
        {
            if (m_BossTimer.GetActualTime() > 0.45f && m_iCurrentCannon < 13)
            {
                m_BossTimer.Start();
                m_iCurrentCannon++;
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 2.0f, 1.9f, Vec3(0, 0, 0), MAT_RandomInt(5, 12), 0.6f);
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.5f, 2.5f, Vec3(0, 0, 0), MAT_RandomInt(3, 8), 1.0f);

            }

            if (m_iCurrentCannon > 12)
            {

                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 4.0f, 2.0f, Vec3(0, 0, 0), 14, 2.0f);
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.6f, 3.0f, Vec3(0, 0, 0), 9, 0.8f);
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.6f, 2.0f, Vec3(0, 0, 0), 5, 0.7f);

                m_pTheScene->GetCamera3D()->AddNoise(2.0f, timer);
                m_pTheScene->SetLevelCompleted(true);
                m_pThePlayer->SetLevelCompleted(true);
                m_pThePlayer->BossKilled();

                AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY));
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_DEAD));

                Disable();
            }
            break;
        }
    }
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::getWorldTransform(btTransform &worldTransform) const
{
    Vec3 pos = m_vPosition;

    btVector3 newPos(pos.x * PHYSICS_SCALE_FACTOR, pos.y * PHYSICS_SCALE_FACTOR,
            pos.z * PHYSICS_SCALE_FACTOR);

    btMatrix3x3 rot;
    MAT_MATRIX_to_btMatrix3x3(m_mtxRotation, rot);

    worldTransform.setIdentity();
    worldTransform.setOrigin(newPos);
    worldTransform.setBasis(rot);
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::setWorldTransform(const btTransform &worldTransform)
{
    btVector3 pos = worldTransform.getOrigin();
    btMatrix3x3 rot = worldTransform.getBasis();

    Vec3 newPos(pos.getX() * PHYSICS_INV_SCALE_FACTOR, pos.getY() * PHYSICS_INV_SCALE_FACTOR,
            pos.getZ() * PHYSICS_INV_SCALE_FACTOR);

    m_vPosition = newPos;
    MAT_btMatrix3x3_to_MATRIX(rot, m_mtxRotation);
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
    {
        Vec3 dir = m_pThePlayer->GetPosition() - m_vPosition;

        dir.normalize();

        const float speed = 1.3f;
        dir *= speed;

        btVector3 impulseVec(dir.x, dir.y, dir.z);

        if (!m_pThePlayer->GetRigidBody()->isActive())
        {
            m_pThePlayer->GetRigidBody()->activate();
        }

        m_pThePlayer->GetRigidBody()->applyCentralImpulse(impulseVec);

        if (BOSS_OCEAN_DIE_STATE != m_CurrentState)
            m_pThePlayer->Deflate(PLAYER_BIG_ENEMY_HURT);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
    }

    m_pTheScene->GetCamera3D()->AddNoise(1.0f, timer);
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData)
{
    if (m_CurrentState == BOSS_OCEAN_CANNON_CENTER_STATE)
    {
        theShot->Kill();

        m_iHealth--;

        if (!m_pHitSawtoothInterpolator->IsActive() && !m_pHitSineInterpolator->IsActive())
        {

            m_pHitSineInterpolator->Reset();
            InterpolatorManager::Instance().Add(m_pHitSineInterpolator, false, timer);
        }

        ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, theShot->GetPosition(), 0.3f, 0.8f, Vec3(0, 0, 0), 6, 0.0f);
        ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_HURT));
    }
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    if (m_CurrentState == BOSS_OCEAN_CANNON_CENTER_STATE)
    {
        float actualTime = timer->GetActualTime();

        if (actualTime - m_fLastNukeTime > 0.5f)
        {
            m_fLastNukeTime = actualTime;

            m_iHealth -= 8;

            if (!m_pHitSawtoothInterpolator->IsActive() && !m_pHitSineInterpolator->IsActive())
            {

                m_pHitSawtoothInterpolator->Reset();

                InterpolatorManager::Instance().Add(m_pHitSawtoothInterpolator, false, timer);
            }

            ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_HURT));
        }
    }
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::Enable(void)
{
    Enemy::Enable();
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void BossOceanEnemy::Disable(void)
{
    Enemy::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}
