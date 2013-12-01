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
 * File:   BossVulcanEnemy.mm
 * Author: nacho
 * 
 * Created on 10 de enero de 2010, 23:58
 */

#include "BossVulcanEnemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"
#include "gamemanager.h"

BossVulcanEnemy::BossVulcanEnemy(void) : Enemy()
{
    InitPointer(m_pMovementInterpolator);

    InitPointer(m_pHitSawtoothInterpolator);
    InitPointer(m_pDieInterpolator);
    InitPointer(m_pFlashInterpolator);
    InitPointer(m_pCannonGlowInterpolator);
    InitPointer(m_pLegsGlowInterpolator);

    for (int i = 0; i < 4; i++)
    {
        InitPointer(m_pShortLegShape[i]);
        InitPointer(m_pLegsRigidBody[i]);
        InitPointer(m_pCompoundShape[i]);
        InitPointer(m_pHitSineInterpolator[i]);
    }

    InitPointer(m_pSphereBodyShape);

    Defaults();
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::Defaults(void)
{
    for (int i = 0; i < 4; i++)
    {
        m_iHealth[i] = BOSS_VULCAN_HEALTH;
        m_fHitGlow[i] = 0.0f;
    }

    m_fFlashGlow = 0.0f;
    m_fTimeOfLeak = 0.0f;
    m_fMovement = 0.0f;
    m_iSubState = 0;
    m_iCorner = 0;
    m_fSpeed = 0.0f;
    m_fOffset = 0.0f;
    m_iRotCount = 0;
    m_fCannonRot = 0.0f;
    m_fCannonRotOffset = 0.0f;
    m_fLegsOffset = 0.0f;
    m_fHitGlowWave = 0.0f;
    m_fHitGlowDie = 0.0f;
    m_iCurrentExplo = 0;
    m_fLastNukeTime = 0.0f;
    m_fCannonGlowAlpha = 0.0f;
    m_fLegsGlowAlpha = 0.0f;

    m_vCornerDir[0] = Vec3(1.0f, 0.0f, 0.0f);
    m_vCornerDir[1] = Vec3(0.0f, 0.0f, 1.0f);
    m_vCornerDir[2] = Vec3(-1.0f, 0.0f, 0.0f);
    m_vCornerDir[3] = Vec3(0.0f, 0.0f, -1.0f);


    m_CurrentState = BOSS_VULCAN_START_STATE;
}

//////////////////////////
//////////////////////////

BossVulcanEnemy::~BossVulcanEnemy()
{
    SafeDelete(m_pMovementInterpolator);
    SafeDelete(m_pHitSawtoothInterpolator);
    SafeDelete(m_pDieInterpolator);
    SafeDelete(m_pFlashInterpolator);
    SafeDelete(m_pCannonGlowInterpolator);
    SafeDelete(m_pLegsGlowInterpolator);

    for (int i = 0; i < 4; i++)
    {
        if (IsValidPointer(m_pLegsRigidBody[i]))
        {
            CollisionInfo* pInfo = (CollisionInfo*) m_pLegsRigidBody[i]->getUserPointer();
            SafeDelete(pInfo);
        }
        
        SafeDelete(m_pShortLegShape[i]);
        SafeDelete(m_pLegsRigidBody[i]);
        SafeDelete(m_pCompoundShape[i]);
        SafeDelete(m_pHitSineInterpolator[i]);
    }

    SafeDelete(m_pSphereBodyShape);
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_vPosition.y -= 20.0f;

    m_pFlashInterpolator = new LinearInterpolator(&m_fFlashGlow, 1.0f, 0.0f, 0.15f);
    m_pMovementInterpolator = new SineInterpolator(&m_fMovement, -0.45f, 0.45f, 3.0f);
    for (int i = 0; i < 4; i++)
    {
        m_pHitSineInterpolator[i] = new SinusoidalInterpolator(&m_fHitGlow[i], 0.0f, 1.0f, 0.075f, false, 0.15f);
    }
    m_pHitSawtoothInterpolator = new SinusoidalInterpolator(&m_fHitGlowWave, 0.0f, 1.0f, 0.075f, false, 0.60f);
    m_pDieInterpolator = new SquareInterpolator(&m_fHitGlowDie, 0.0f, 1.0f, 0.2f);
    m_pCannonGlowInterpolator = new SinusoidalInterpolator(&m_fCannonGlowAlpha, 0.0f, 1.0f, 1.0f, true);
    m_pLegsGlowInterpolator = new SinusoidalInterpolator(&m_fLegsGlowAlpha, 0.0f, 1.0f, 0.25f, true);

    InterpolatorManager::Instance().Add(m_pMovementInterpolator, false, m_pTheScene->GetGameTimer());
    InterpolatorManager::Instance().Add(m_pCannonGlowInterpolator, false, m_pTheScene->GetGameTimer());

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_vulcan"),
            TextureManager::Instance().GetTexture("game/entities/boss_vulcan", true), RENDER_OBJECT_NORMAL);
    m_MainRenderObject.SetPosition(m_vPosition);
    m_MainRenderObject.UseColor(true);

    for (int i = 0; i < 4; i++)
    {
        m_LongLegRenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_vulcan_leg2"),
                TextureManager::Instance().GetTexture("game/entities/boss_vulcan", true), RENDER_OBJECT_NORMAL);
        MatrixRotationY(m_LongLegRenderObject[i].GetTransform(), MAT_ToRadians(90.0f * i));
        m_LongLegRenderObject[i].SetPosition(m_vPosition);
        m_LongLegRenderObject[i].UseColor(true);

        m_ShortLegRenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_vulcan_leg1"),
                TextureManager::Instance().GetTexture("game/entities/boss_vulcan", true), RENDER_OBJECT_NORMAL);
        MatrixRotationY(m_ShortLegRenderObject[i].GetTransform(), MAT_ToRadians(90.0f * i));
        m_ShortLegRenderObject[i].SetPosition(m_vPosition);
        m_ShortLegRenderObject[i].UseColor(true);

        m_LegF3RenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_vulcan_canon_f3"),
                TextureManager::Instance().GetTexture("game/entities/boss_vulcan", true), RENDER_OBJECT_ADDITIVE);
        MatrixRotationY(m_LegF3RenderObject[i].GetTransform(), MAT_ToRadians(90.0f * i));
        m_LegF3RenderObject[i].SetPosition(m_vPosition);
        m_LegF3RenderObject[i].UseColor(true);

        m_RenderObjectList.push_back(&m_LongLegRenderObject[i]);
        m_RenderObjectList.push_back(&m_ShortLegRenderObject[i]);
        m_RenderObjectList.push_back(&m_LegF3RenderObject[i]);
    }

    m_CannonRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_vulcan_canon"),
            TextureManager::Instance().GetTexture("game/entities/boss_vulcan", true), RENDER_OBJECT_NORMAL);
    m_CannonRenderObject.SetPosition(m_vPosition);
    m_CannonRenderObject.UseColor(true);

    m_CannonF2RenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_vulcan_canon_f2"),
            TextureManager::Instance().GetTexture("game/entities/boss_vulcan", true), RENDER_OBJECT_ADDITIVE);
    m_CannonF2RenderObject.SetPosition(m_vPosition);
    m_CannonF2RenderObject.UseColor(true);

    m_FlashRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_vulcan_canon_f"),
            TextureManager::Instance().GetTexture("game/entities/boss_vulcan", true), RENDER_OBJECT_ADDITIVE);
    m_FlashRenderObject.SetPosition(m_vPosition);
    m_FlashRenderObject.UseColor(true);

    m_RenderObjectList.push_back(&m_CannonRenderObject);
    m_RenderObjectList.push_back(&m_CannonF2RenderObject);
    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_FlashRenderObject);


    Vec4 vLeakDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);

    MATRIX matrot;
    MatrixRotationY(matrot, MAT_RandomInt(0, 360));
    MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

    m_vLeakDir = Vec3(vLeakDir4.ptr());
    m_vLeakDir.normalize();


    btScalar mass = 20.0f;
    btVector3 inertia(0, 0, 0);
    btTransform transform;
    transform.setIdentity();

    m_pSphereBodyShape = new btSphereShape(0.8f);
    m_pSphereBodyShape->setMargin(0.01f);
    m_pSphereBodyShape->calculateLocalInertia(mass, inertia);

    m_pShortLegShape[0] = new btBoxShape(btVector3(0.9f, 1.5f, 0.15f));
    m_pShortLegShape[0]->setMargin(0.01f);
    m_pShortLegShape[0]->calculateLocalInertia(mass, inertia);
    m_pCompoundShape[0] = new btCompoundShape();
    transform.setOrigin(btVector3(0.7f, 0.0f, 0.0f));
    m_pCompoundShape[0]->addChildShape(transform, m_pShortLegShape[0]);

    m_pShortLegShape[1] = new btBoxShape(btVector3(0.15f, 1.5f, 0.9f));
    m_pShortLegShape[1]->setMargin(0.01f);
    m_pShortLegShape[1]->calculateLocalInertia(mass, inertia);
    m_pCompoundShape[1] = new btCompoundShape();
    transform.setOrigin(btVector3(0.0f, 0.0f, 0.7f));
    m_pCompoundShape[1]->addChildShape(transform, m_pShortLegShape[1]);

    m_pShortLegShape[2] = new btBoxShape(btVector3(0.9f, 1.5f, 0.15f));
    m_pShortLegShape[2]->setMargin(0.01f);
    m_pShortLegShape[2]->calculateLocalInertia(mass, inertia);
    m_pCompoundShape[2] = new btCompoundShape();
    transform.setOrigin(btVector3(-0.7f, 0.0f, 0.0f));
    m_pCompoundShape[2]->addChildShape(transform, m_pShortLegShape[2]);

    m_pShortLegShape[3] = new btBoxShape(btVector3(0.15f, 1.5f, 0.9f));
    m_pShortLegShape[3]->setMargin(0.01f);
    m_pShortLegShape[3]->calculateLocalInertia(mass, inertia);
    m_pCompoundShape[3] = new btCompoundShape();
    transform.setOrigin(btVector3(0.0f, 0.0f, -0.7f));
    m_pCompoundShape[3]->addChildShape(transform, m_pShortLegShape[3]);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pSphereBodyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this, 5));
    m_pRigidBody->setCollisionFlags(m_pRigidBody->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
    m_pRigidBody->setActivationState(DISABLE_DEACTIVATION);
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);

    for (int i = 0; i < 4; i++)
    {
        btRigidBody::btRigidBodyConstructionInfo rigidBodyCIleg(0, this, m_pCompoundShape[i], btVector3(0, 0, 0));
        m_pLegsRigidBody[i] = new btRigidBody(rigidBodyCIleg);
        m_pLegsRigidBody[i]->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
        m_pLegsRigidBody[i]->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this, i));
        m_pLegsRigidBody[i]->setCollisionFlags(m_pLegsRigidBody[i]->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
        m_pLegsRigidBody[i]->setActivationState(DISABLE_DEACTIVATION);

        PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pLegsRigidBody[i], COL_RIGIDS, c_iRigidsCollidesWith);
    }

    m_vOriginalPos = m_vPosition;
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::Reset(void)
{

    for (int i = 0; i < 4; i++)
    {
        if (m_iHealth[i] == 0)
        {
            PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pLegsRigidBody[i], COL_RIGIDS, c_iRigidsCollidesWith);
        }
    }

    Defaults();

    if (m_pFlashInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pFlashInterpolator);
    }

    if (m_pLegsGlowInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pLegsGlowInterpolator);
    }

    for (int i = 0; i < 4; i++)
    {
        if (m_pHitSineInterpolator[i]->IsActive())
        {
            InterpolatorManager::Instance().Delete(m_pHitSineInterpolator[i]);
        }
    }

    if (m_pHitSawtoothInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pHitSawtoothInterpolator);
    }

    if (m_pDieInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pDieInterpolator);
    }

    SetPosition(m_vOriginalPos);
    MatrixIdentity(m_mtxRotation);

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

void BossVulcanEnemy::Update(Timer * timer)
{
    if (timer->IsRunning())
    {
        int health = m_iHealth[0] + m_iHealth[1] + m_iHealth[2] + m_iHealth[3];

        int deadLegs = 0;

        for (int i = 0; i < 4; i++)
        {
            if (m_iHealth[i] <= 0)
            {
                deadLegs++;
            }
        }

        ///--- mirar a ver si ha muerto
        if (health <= 0 && m_CurrentState != BOSS_VULCAN_DIE_STATE)
        {
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
            m_CurrentState = BOSS_VULCAN_DIE_STATE;
            m_iSubState = 0;
            m_iCurrentExplo = 0;
            m_BossTimer.Start();
            for (int i = 0; i < 4; i++)
            {
                InterpolatorManager::Instance().Delete(m_pHitSineInterpolator[i]);
            }
            InterpolatorManager::Instance().Delete(m_pHitSawtoothInterpolator);
            InterpolatorManager::Instance().Add(m_pDieInterpolator, false, timer);
        }

        ///--- mirar a ver si esta muriendo y poner humo
        if (m_CurrentState != BOSS_VULCAN_DIE_STATE && deadLegs > 0)
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

                ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 0.8f, 1.5f, rot, Vec3(0, 0, 0), 1.9f, 1.0f, 0.7f, 0.7f);

                if (deadLegs > 1)
                {
                    rot = MAT_ToRadians(MAT_RandomInt(0, 360));
                    angle = MAT_ToRadians(MAT_RandomInt(0, 360));

                    vLeakDir4 = Vec4(m_vLeakDir, 1.0f);
                    MatrixRotationY(matrot, angle);
                    MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

                    ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 1.2f, 1.4f, rot, Vec3(0, 0, 0), 1.8f, 1.0f, 0.7f, 0.7f);

                    if (deadLegs > 2)
                    {
                        rot = MAT_ToRadians(MAT_RandomInt(0, 360));
                        angle = MAT_ToRadians(MAT_RandomInt(0, 360));

                        vLeakDir4 = Vec4(m_vLeakDir, 1.0f);

                        MatrixRotationY(matrot, angle);
                        MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

                        ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 1.6f, 1.4f, rot, Vec3(0, 0, 0), 1.7f, 1.0f, 0.7f, 0.7f);
                    }
                }
            }
        }

        switch (m_CurrentState)
        {
            case BOSS_VULCAN_START_STATE:
            {
                UpdateStartState(timer);
                break;
            }
            case BOSS_VULCAN_CANNON_STATE:
            {
                UpdateCannonState(timer);
                break;
            }
            case BOSS_VULCAN_MOVING_STATE:
            {
                UpdateMovingState(timer);
                break;
            }
            case BOSS_VULCAN_DIE_STATE:
            {
                UpdateDieState(timer);
                break;
            }
        }

        m_vPosition.y += m_fMovement;

    }

    float colorHitDie = 1.0f - m_fHitGlowDie;

    m_MainRenderObject.SetPosition(m_vPosition);
    m_MainRenderObject.SetColor(1.0f, colorHitDie, colorHitDie, 1.0f);

    MatrixRotationY(m_CannonRenderObject.GetTransform(), MAT_ToRadians(m_fCannonRot + 90.0f));

    m_CannonRenderObject.SetPosition(m_vPosition);
    m_CannonRenderObject.SetColor(1.0f, colorHitDie, colorHitDie, 1.0f);

    m_CannonF2RenderObject.SetTransform(m_CannonRenderObject.GetTransform());
    m_CannonF2RenderObject.SetColor(1.0f, 1.0f, 1.0f, m_fCannonGlowAlpha);

    m_FlashRenderObject.SetTransform(m_CannonRenderObject.GetTransform());
    m_FlashRenderObject.SetColor(1.0f, 1.0f, 1.0f, m_fFlashGlow);

    for (int i = 0; i < 4; i++)
    {
        if (m_iHealth[i] > 0)
        {
            m_LongLegRenderObject[i].Activate(true);
            m_ShortLegRenderObject[i].Activate(true);
            m_LegF3RenderObject[i].Activate(true);

            MATRIX rot;
            MatrixRotationY(rot, MAT_ToRadians(90.0f * i));

            Vec4 vOffestDir4 = Vec4(1.0f, 0.0f, 0.0f, 1.0f);
            MatrixVec4Multiply(vOffestDir4, vOffestDir4, rot);

            float visible = 0.0f;
            if ((i < (m_iCorner + 2)) && (i >= m_iCorner))
                visible = 1.0f;

            if (m_iCorner == 3 && i == 0)
                visible = 1.0f;

            if (visible != 0.0f)
            {
                if (i % 2 == 0)
                {
                    m_pShortLegShape[i]->setLocalScaling(btVector3(0.5f + (m_fLegsOffset / 30.0f), 1.0f, 1.0f));
                }
                else
                {
                    m_pShortLegShape[i]->setLocalScaling(btVector3(1.0f, 1.0f, 0.5f + (m_fLegsOffset / 30.0f)));
                }
            }
            else
            {
                if (i % 2 == 0)
                {
                    m_pShortLegShape[i]->setLocalScaling(btVector3(0.5f, 1.0f, 1.0f));
                }
                else
                {
                    m_pShortLegShape[i]->setLocalScaling(btVector3(1.0f, 1.0f, 0.5f));
                }
            }

            float colorHit = 1.0f - m_fHitGlow[i];
            colorHit = MAT_Min(colorHit, 1.0f - m_fHitGlowWave);

            m_LongLegRenderObject[i].SetTransform(rot);
            m_LongLegRenderObject[i].SetPosition(m_vPosition + (Vec3(vOffestDir4.ptr()) * m_fLegsOffset * 1.6f * visible));
            m_LongLegRenderObject[i].SetColor(1.0f, colorHit, colorHit, 1.0f);

            m_ShortLegRenderObject[i].SetTransform(rot);
            m_ShortLegRenderObject[i].SetPosition(m_vPosition + (Vec3(vOffestDir4.ptr()) * m_fLegsOffset * 1.1f * visible));
            m_ShortLegRenderObject[i].SetColor(1.0f, colorHit, colorHit, 1.0f);

            MATRIX scale;
            float glowScale = 1.0f + (m_fLegsOffset / (BOSS_VULCAN_LEGS_LENGTH * 2.0f));
            if (i % 2 == 0)
            {
                MatrixScaling(scale, 1.0f, glowScale, glowScale);
            }
            else
            {
                MatrixScaling(scale, glowScale, glowScale, 1.0f);
            }
            MatrixMultiply(m_LegF3RenderObject[i].GetTransform(), rot, scale);
            m_LegF3RenderObject[i].SetPosition(m_vPosition + (Vec3(vOffestDir4.ptr()) * m_fLegsOffset * 1.6f * visible));
            m_LegF3RenderObject[i].SetColor(1.0f, 1.0f, 1.0f, m_fLegsGlowAlpha * visible);
        }
        else
        {
            m_ShortLegRenderObject[i].Activate(false);
            m_LongLegRenderObject[i].Activate(false);
            m_LegF3RenderObject[i].Activate(false);
        }
    }
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::UpdateStartState(Timer * timer)
{

    Vec3 dirToPlayer = m_pThePlayer->GetPosition() - m_vPosition;
    float lengthToPlayer = dirToPlayer.length();

    if (lengthToPlayer < 300.0f)
    {
        m_CurrentState = BOSS_VULCAN_MOVING_STATE;
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));
        m_BossTimer.Start();
    }
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::UpdateMovingState(Timer * timer)
{

    float dTime = timer->GetDeltaTime();

    m_fSpeed += BOSS_VULCAN_ACC_SPEED * dTime;
    m_fSpeed = MAT_Min(BOSS_VULCAN_MAX_SPEED, m_fSpeed);

    float dOffset = m_fSpeed * dTime;
    m_fOffset += dOffset;

    m_vPosition += (dOffset * m_vCornerDir[m_iCorner]);

    m_vPosition.x = MAT_Min(m_vOriginalPos.x + BOSS_VULCAN_MAX_OFFSET, m_vPosition.x);
    m_vPosition.x = MAT_Max(m_vOriginalPos.x, m_vPosition.x);
    m_vPosition.z = MAT_Min(m_vOriginalPos.z + BOSS_VULCAN_MAX_OFFSET, m_vPosition.z);
    m_vPosition.z = MAT_Max(m_vOriginalPos.z, m_vPosition.z);

    if (m_fOffset > BOSS_VULCAN_MAX_OFFSET)
    {
        m_fOffset = 0.0f;
        m_iCorner++;
        m_iCorner %= 4;
        m_iRotCount++;

        if (m_iRotCount >= 21)
        {
            m_iRotCount = 0;
            m_fSpeed = 0.0f;
            m_CurrentState = BOSS_VULCAN_CANNON_STATE;
            m_pTheScene->GetCamera3D()->AddNoise(1.6f, timer);
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_METALIC_BOUNCE));
            m_pLegsGlowInterpolator->Reset();
            InterpolatorManager::Instance().Add(m_pLegsGlowInterpolator, false, timer);
            m_BossTimer.Start();
        }
        else
        {
            m_pTheScene->GetCamera3D()->AddNoise(m_iRotCount / 20.0f, timer);
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_METALIC_BOUNCE));
        }
    }
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::UpdateCannonState(Timer * timer)
{
    float dTime = timer->GetDeltaTime();

    switch (m_iSubState)
    {
            ///--- sacando las patas
        case 0:
        {
            m_fLegsOffset += dTime * BOSS_VULCAN_LEGS_SPEED;

            if (m_fLegsOffset > BOSS_VULCAN_LEGS_LENGTH)
            {
                m_fLegsOffset = BOSS_VULCAN_LEGS_LENGTH;
                m_iSubState = 1;
            }
            break;
        }
            ///--- moviendo el cañon
        case 1:
        {
            float offset = dTime * BOSS_VULCAN_CANNON_SPEED;
            m_fCannonRotOffset += offset;
            m_fCannonRot += offset;

            if (m_fCannonRotOffset > 90.0f)
            {
                m_fCannonRot = 90.0f * m_iCorner;
                m_fCannonRotOffset = 0.0f;
                m_iSubState = 2;
            }
            else if (m_BossTimer.GetActualTime() > 0.35f)
            {
                Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
                Vec4 vThrowingPos4_1 = Vec4(70.0f, 20.0f, -6.0f, 0.0f);
                Vec4 vThrowingPos4_2 = Vec4(70.0f, 20.0f, 6.0f, 0.0f);
                MATRIX rotFire;
                float rotation = MAT_ToRadians(m_fCannonRot + 90.0f);
                MatrixRotationY(rotFire, rotation);
                MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, rotFire);
                MatrixVec4Multiply(vThrowingPos4_1, vThrowingPos4_1, rotFire);
                MatrixVec4Multiply(vThrowingPos4_2, vThrowingPos4_2, rotFire);

                Vec3 impulse = (Vec3(vThrowingDir4.ptr()) * 2.5f);

                ParticleManager::Instance().AddParticle(PARTICLE_INLINE_THROWING_ENEMY, Vec3(vThrowingPos4_1.ptr()) + m_vPosition, impulse, 2.0f, rotation, Vec3(0, 0, 0), 1.2f);
                ParticleManager::Instance().AddParticle(PARTICLE_INLINE_THROWING_ENEMY, Vec3(vThrowingPos4_2.ptr()) + m_vPosition, impulse, 2.0f, rotation, Vec3(0, 0, 0), 1.2f);

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INLINE_THROWING), m_vPosition);

                m_pFlashInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pFlashInterpolator, false, timer);

                m_BossTimer.Start();
            }
            break;
        }
            ///--- metiendo las patas
        case 2:
        {
            m_fLegsOffset -= dTime * BOSS_VULCAN_LEGS_SPEED;

            if (m_fLegsOffset < 0.0f)
            {
                m_fLegsOffset = 0.0f;
                m_iSubState = 0;
                m_CurrentState = BOSS_VULCAN_MOVING_STATE;
                InterpolatorManager::Instance().Delete(m_pLegsGlowInterpolator);
                m_fLegsGlowAlpha = 0.0f;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));
                m_BossTimer.Start();
            }
            break;
        }
    }
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::UpdateDieState(Timer * timer)
{
    switch (m_iSubState)
    {
            ///--- parpadeando
        case 0:
        {
            if (m_BossTimer.GetActualTime() > 2.0f)
            {
                m_iSubState = 1;
                m_iCurrentExplo = 0;
                m_BossTimer.Start();

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY), m_vPosition);
            }
            break;
        }
        case 1:
        {
            if (m_BossTimer.GetActualTime() > 0.45f && m_iCurrentExplo < 13)
            {
                m_BossTimer.Start();
                m_iCurrentExplo++;
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 2.0f, 1.9f, Vec3(0, 0, 0), MAT_RandomInt(5, 12), 0.6f, 1.0f, 0.7f, 0.7f);
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.5f, 2.5f, Vec3(0, 0, 0), MAT_RandomInt(3, 8), 1.0f, 1.0f, 0.7f, 0.7f);

            }

            if (m_iCurrentExplo > 12)
            {

                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 4.0f, 2.0f, Vec3(0, 0, 0), 14, 2.0f, 1.0f, 0.7f, 0.7f);
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.6f, 3.0f, Vec3(0, 0, 0), 9, 0.8f, 1.0f, 0.7f, 0.7f);
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.6f, 2.0f, Vec3(0, 0, 0), 5, 0.7f, 1.0f, 0.7f, 0.7f);

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

void BossVulcanEnemy::getWorldTransform(btTransform & worldTransform) const
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

void BossVulcanEnemy::setWorldTransform(const btTransform & worldTransform)
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

void BossVulcanEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer * timer)
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

        if (BOSS_VULCAN_DIE_STATE != m_CurrentState)
            m_pThePlayer->Deflate(PLAYER_BIG_ENEMY_HURT);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
    }

    m_pTheScene->GetCamera3D()->AddNoise(1.5f, timer);
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData)
{
    if (m_CurrentState == BOSS_VULCAN_CANNON_STATE)
    {
        int leg = additionalData;

        if (leg < 5)
        {
            bool visible = ((leg < (m_iCorner + 2)) && (leg >= m_iCorner));

            if (m_iCorner == 3 && leg == 0)
                visible = true;

            if (visible)
            {
                theShot->Kill();

                m_iHealth[leg]--;

                if (m_iHealth[leg] <= 0)
                {
                    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));

                    m_iHealth[leg] = 0;
                    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pLegsRigidBody[leg]);
                    m_pTheScene->GetCamera3D()->AddNoise(0.8f, timer);

                    switch (leg)
                    {
                        case 0:
                        {
                            ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, Vec3(m_vPosition.x + 100.0f, m_vPosition.y, m_vPosition.z), 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
                            break;
                        }
                        case 1:
                        {
                            ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, Vec3(m_vPosition.x, m_vPosition.y, m_vPosition.z + 100.0f), 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
                            break;
                        }
                        case 2:
                        {
                            ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, Vec3(m_vPosition.x - 100.0f, m_vPosition.y, m_vPosition.z), 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
                            break;
                        }
                        case 3:
                        {
                            ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, Vec3(m_vPosition.x, m_vPosition.y, m_vPosition.z - 100.0f), 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
                            break;
                        }
                    }
                }
                else
                {
                    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_HURT));
                }

                if (!m_pHitSawtoothInterpolator->IsActive() && !m_pHitSineInterpolator[leg]->IsActive())
                {
                    m_pHitSineInterpolator[leg]->Reset();
                    InterpolatorManager::Instance().Add(m_pHitSineInterpolator[leg], false, timer);
                }

                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, theShot->GetPosition(), 0.3f, 0.8f, Vec3(0, 0, 0), 6, 0.0f);
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
            }
        }
    }
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    if (m_CurrentState == BOSS_VULCAN_CANNON_STATE)
    {
        if (additionalData == 5)
        {
            float actualTime = timer->GetActualTime();

            if (actualTime - m_fLastNukeTime > 0.5f)
            {
                m_fLastNukeTime = actualTime;

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_HURT));

                bool legKilled = false;

                for (int i = 0; i < 4; i++)
                {
                    m_iHealth[i] -= 4;

                    if (m_iHealth[i] <= 0)
                    {
                        legKilled = true;

                        m_iHealth[i] = 0;
                        PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pLegsRigidBody[i]);
                        m_pTheScene->GetCamera3D()->AddNoise(0.8f, timer);

                        switch (i)
                        {
                            case 0:
                            {
                                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, Vec3(m_vPosition.x + 100.0f, m_vPosition.y, m_vPosition.z), 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
                                break;
                            }
                            case 1:
                            {
                                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, Vec3(m_vPosition.x, m_vPosition.y, m_vPosition.z + 100.0f), 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
                                break;
                            }
                            case 2:
                            {
                                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, Vec3(m_vPosition.x - 100.0f, m_vPosition.y, m_vPosition.z), 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
                                break;
                            }
                            case 3:
                            {
                                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, Vec3(m_vPosition.x, m_vPosition.y, m_vPosition.z - 100.0f), 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
                                break;
                            }
                        }
                    }
                }

                if (legKilled)
                {
                    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
                }

                if (!m_pHitSawtoothInterpolator->IsActive())
                {
                    m_pHitSawtoothInterpolator->Reset();
                    InterpolatorManager::Instance().Add(m_pHitSawtoothInterpolator, false, timer);
                }

                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 10, 0.8f);
            }
        }
    }
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::Enable(void)
{
    Enemy::Enable();

    for (int i = 0; i < 4; i++)
    {
        PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pLegsRigidBody[i], COL_RIGIDS, c_iRigidsCollidesWith);
    }

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void BossVulcanEnemy::Disable(void)
{
    Enemy::Disable();

    for (int i = 0; i < 4; i++)
    {
        PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pLegsRigidBody[i]);
    }

    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

