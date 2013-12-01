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
 * File:   BossSpaceEnemy.mm
 * Author: nacho
 * 
 * Created on 10 de enero de 2010, 23:59
 */

#include "BossSpaceEnemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

//////////////////////////
//////////////////////////

BossSpaceEnemy::BossSpaceEnemy(void) : Enemy()
{
    InitPointer(m_pMovementInterpolator);
    InitPointer(m_pHitSawtoothInterpolator);
    InitPointer(m_pDieInterpolator);
    InitPointer(m_pRotationalInterpolator);
    InitPointer(m_pLegsInterpolator);

    for (int i = 0; i < 4; i++)
    {
        InitPointer(m_pLegShape[i]);
        InitPointer(m_pLegsRigidBody[i]);
        InitPointer(m_pCompoundShape[i]);
        InitPointer(m_pHitSineInterpolator[i]);
    }

    InitPointer(m_pSphereBodyShape);

    Defaults();
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::Defaults(void)
{
    for (int i = 0; i < 4; i++)
    {
        m_iHealth[i] = BOSS_SPACE_HEALTH;
        m_fHitGlow[i] = 0.0f;
    }

    m_fRotation = 0.0f;
    m_fTimeOfLeak = 0.0f;
    m_fMovement = 0.0f;
    m_iSubState = 0;
    m_fHitGlowWave = 0.0f;
    m_fHitGlowDie = 0.0f;
    m_iCurrentExplo = 0;
    m_fLastNukeTime = 0.0f;
    m_fBladeRotation = 0.0f;
    m_fLegsRotation = 0.0f;

    m_CurrentState = BOSS_SPACE_START_STATE;
}

//////////////////////////
//////////////////////////

BossSpaceEnemy::~BossSpaceEnemy()
{
    SafeDelete(m_pMovementInterpolator);
    SafeDelete(m_pHitSawtoothInterpolator);
    SafeDelete(m_pDieInterpolator);
    SafeDelete(m_pRotationalInterpolator);
    SafeDelete(m_pLegsInterpolator);

    for (int i = 0; i < 4; i++)
    {
        if (IsValidPointer(m_pLegsRigidBody[i]))
        {
            CollisionInfo* pInfo = (CollisionInfo*) m_pLegsRigidBody[i]->getUserPointer();
            SafeDelete(pInfo);
        }

        SafeDelete(m_pLegShape[i]);
        SafeDelete(m_pLegsRigidBody[i]);
        SafeDelete(m_pCompoundShape[i]);
        SafeDelete(m_pHitSineInterpolator[i]);
    }

    SafeDelete(m_pSphereBodyShape);
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_pMovementInterpolator = new SineInterpolator(&m_fMovement, -0.45f, 0.45f, 3.0f);
    for (int i = 0; i < 4; i++)
    {
        m_pHitSineInterpolator[i] = new SinusoidalInterpolator(&m_fHitGlow[i], 0.0f, 1.0f, 0.075f, false, 0.15f);
    }
    m_pHitSawtoothInterpolator = new SinusoidalInterpolator(&m_fHitGlowWave, 0.0f, 1.0f, 0.075f, false, 0.60f);
    m_pDieInterpolator = new SquareInterpolator(&m_fHitGlowDie, 0.0f, 1.0f, 0.2f);
    m_pRotationalInterpolator = new SinusoidalInterpolator(&m_fRotation, 0.0f, 360.0f, 3.0f, false, 6.0f);
    m_pLegsInterpolator = new SinusoidalInterpolator(&m_fLegsRotation, 0.0f, 152.0f, 5.0f, false, 5.0f);

    InterpolatorManager::Instance().Add(m_pMovementInterpolator, false, m_pTheScene->GetGameTimer());

    Texture* pTexture = TextureManager::Instance().GetTexture("game/entities/boss_space", true);

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_space"),
            pTexture, RENDER_OBJECT_NORMAL);
    m_MainRenderObject.SetPosition(m_vPosition);
    m_MainRenderObject.UseColor(true);

    for (int i = 0; i < 4; i++)
    {
        m_LegRenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_space_canon"),
                pTexture, RENDER_OBJECT_NORMAL);
        MatrixRotationY(m_LegRenderObject[i].GetTransform(), MAT_ToRadians(90.0f * i));
        m_LegRenderObject[i].SetPosition(m_vPosition);
        m_LegRenderObject[i].UseColor(true);

        m_LegGlowRenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_space_canon_glass"),
                pTexture, RENDER_OBJECT_ADDITIVE);
        MatrixRotationY(m_LegGlowRenderObject[i].GetTransform(), MAT_ToRadians(90.0f * i));
        m_LegGlowRenderObject[i].SetPosition(m_vPosition);
        m_LegGlowRenderObject[i].UseColor(true);


        m_RenderObjectList.push_back(&m_LegRenderObject[i]);
        m_RenderObjectList.push_back(&m_LegGlowRenderObject[i]);
    }

    m_BladeRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_space_blade"),
            pTexture, RENDER_OBJECT_TRANSPARENT);
    m_BladeRenderObject.SetPosition(m_vPosition);
    m_BladeRenderObject.UseColor(true);

    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_BladeRenderObject);

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

    m_pSphereBodyShape = new btSphereShape(1.1f);
    m_pSphereBodyShape->setMargin(0.01f);
    m_pSphereBodyShape->calculateLocalInertia(mass, inertia);

    m_pLegShape[1] = new btBoxShape(btVector3(1.4f, 1.5f, 0.15f));
    m_pLegShape[1]->setMargin(0.01f);
    m_pLegShape[1]->calculateLocalInertia(mass, inertia);
    m_pCompoundShape[1] = new btCompoundShape();
    transform.setOrigin(btVector3(0.7f, 0.0f, 0.0f));
    m_pCompoundShape[1]->addChildShape(transform, m_pLegShape[1]);

    m_pLegShape[2] = new btBoxShape(btVector3(0.15f, 1.5f, 1.4f));
    m_pLegShape[2]->setMargin(0.01f);
    m_pLegShape[2]->calculateLocalInertia(mass, inertia);
    m_pCompoundShape[2] = new btCompoundShape();
    transform.setOrigin(btVector3(0.0f, 0.0f, 0.7f));
    m_pCompoundShape[2]->addChildShape(transform, m_pLegShape[2]);

    m_pLegShape[3] = new btBoxShape(btVector3(1.4f, 1.5f, 0.15f));
    m_pLegShape[3]->setMargin(0.01f);
    m_pLegShape[3]->calculateLocalInertia(mass, inertia);
    m_pCompoundShape[3] = new btCompoundShape();
    transform.setOrigin(btVector3(-0.7f, 0.0f, 0.0f));
    m_pCompoundShape[3]->addChildShape(transform, m_pLegShape[3]);

    m_pLegShape[0] = new btBoxShape(btVector3(0.15f, 1.5f, 1.4f));
    m_pLegShape[0]->setMargin(0.01f);
    m_pLegShape[0]->calculateLocalInertia(mass, inertia);
    m_pCompoundShape[0] = new btCompoundShape();
    transform.setOrigin(btVector3(0.0f, 0.0f, -0.7f));
    m_pCompoundShape[0]->addChildShape(transform, m_pLegShape[0]);

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

    DropParticles();
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::Reset(void)
{
    for (int i = 0; i < 4; i++)
    {
        if (m_iHealth[i] == 0)
        {
            PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pLegsRigidBody[i], COL_RIGIDS, c_iRigidsCollidesWith);
        }
    }

    Defaults();

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

    DropParticles();
}


//////////////////////////
//////////////////////////

void BossSpaceEnemy::DropParticles(void)
{

    int angle = 360 / 12;

    for (int i = 0; i < 360; i += angle)
    {
        float angleRad = MAT_ToRadians(i);

        MATRIX mtxRot;
        MatrixRotationY(mtxRot, angleRad);

        Vec4 vPos4 = Vec4(170.0f, 0.0f, 0.0f, 0.0f);
        MatrixVec4Multiply(vPos4, vPos4, mtxRot);

        Vec3 vPos = (Vec3(vPos4.ptr())) + m_vPosition;
        vPos.y = 0.0f;

        ParticleManager::Instance().AddParticle(PARTICLE_BOSS_SPACE, vPos, Vec3(0, 0, 0), 0.0f, MAT_ToRadians(MAT_RandomInt(0, 360)), Vec3(0, 0, 0));
    }
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::Update(Timer * timer)
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
        if (health <= 0 && m_CurrentState != BOSS_SPACE_DIE_STATE)
        {
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
            m_CurrentState = BOSS_SPACE_DIE_STATE;
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
        if (m_CurrentState != BOSS_SPACE_DIE_STATE && deadLegs > 0)
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

                ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 0.8f, 1.5f, rot, Vec3(0, 0, 0), 1.9f, 1.0f, 1.0f, 1.0f);

                if (deadLegs > 1)
                {
                    rot = MAT_ToRadians(MAT_RandomInt(0, 360));
                    angle = MAT_ToRadians(MAT_RandomInt(0, 360));

                    vLeakDir4 = Vec4(m_vLeakDir, 1.0f);
                    MatrixRotationY(matrot, angle);

                    MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

                    ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 1.2f, 1.4f, rot, Vec3(0, 0, 0), 1.8f, 1.0f, 1.0f, 1.0f);

                    if (deadLegs > 2)
                    {
                        rot = MAT_ToRadians(MAT_RandomInt(0, 360));
                        angle = MAT_ToRadians(MAT_RandomInt(0, 360));

                        vLeakDir4 = Vec4(m_vLeakDir, 1.0f);

                        MatrixRotationY(matrot, angle);
                        MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

                        ParticleManager::Instance().AddParticle(PARTICLE_ENEMY, m_vPosition, Vec3(vLeakDir4.ptr()).normalized() * 1.6f, 1.4f, rot, Vec3(0, 0, 0), 1.7f, 1.0f, 1.0f, 1.0f);
                    }
                }
            }
        }

        switch (m_CurrentState)
        {
            case BOSS_SPACE_START_STATE:
            {
                UpdateStartState(timer);
                break;
            }
            case BOSS_SPACE_CANNON_STATE:
            {
                UpdateCannonState(timer);
                break;
            }
            case BOSS_SPACE_SEARCH_STATE:
            {
                UpdateSearchState(timer);
                break;
            }
            case BOSS_SPACE_MOVING_STATE:
            {
                UpdateMovingState(timer);
                break;
            }
            case BOSS_SPACE_DIE_STATE:
            {
                UpdateDieState(timer);
                break;
            }
        }

        m_vPosition.y += m_fMovement;

    }

    float colorHitDie = 1.0f - m_fHitGlowDie;

    m_fBladeRotation += 360.0f * timer->GetDeltaTime();
    m_fBladeRotation = MAT_NormalizarAngulo360(m_fBladeRotation);


    MatrixRotationY(m_mtxRotation, MAT_ToRadians(m_fRotation));

    m_MainRenderObject.SetTransform(m_mtxRotation);
    m_MainRenderObject.SetPosition(m_vPosition);
    m_MainRenderObject.SetColor(1.0f, colorHitDie, colorHitDie, 1.0f);

    MatrixRotationY(m_BladeRenderObject.GetTransform(), MAT_ToRadians(m_fBladeRotation));
    m_BladeRenderObject.SetPosition(m_vPosition);
    m_BladeRenderObject.SetColor(1.0f, colorHitDie, colorHitDie, 1.0f);

    for (int i = 0; i < 4; i++)
    {
        if (m_iHealth[i] > 0)
        {
            m_LegRenderObject[i].Activate(true);
            m_LegGlowRenderObject[i].Activate(true);

            MATRIX rot, matrotleg;
            MatrixRotationY(rot, MAT_ToRadians((90.0f * i) + m_fRotation));
            MatrixRotationX(matrotleg, -MAT_ToRadians(m_fLegsRotation));

            Vec4 vOffestDir4 = Vec4(0.0f, 0.0f, -1.0f, 1.0f);
            MatrixVec4Multiply(vOffestDir4, vOffestDir4, rot);

            float legScale = MAT_Min(MAT_Max(0.5f, (1.0f - (m_fLegsRotation / 152.0f))), 1.0f);

            m_pLegShape[i]->setLocalScaling(btVector3(legScale, legScale, legScale));

            float colorHit = 1.0f - m_fHitGlow[i];
            colorHit = MAT_Min(colorHit, 1.0f - m_fHitGlowWave);

            Vec3 newPos = m_vPosition + (Vec3(vOffestDir4.ptr()) * 130.74f);
            newPos.y += 10.0f;

            MatrixMultiply(m_LegRenderObject[i].GetTransform(), matrotleg, rot);
            m_LegRenderObject[i].SetPosition(newPos);
            m_LegRenderObject[i].SetColor(1.0f, colorHit, colorHit, 1.0f);

            MatrixMultiply(m_LegGlowRenderObject[i].GetTransform(), matrotleg, rot);
            m_LegGlowRenderObject[i].SetPosition(newPos);
            m_LegGlowRenderObject[i].SetColor(1.0f, colorHit, colorHit, 1.0f);
        }
        else
        {
            m_LegRenderObject[i].Activate(false);
            m_LegGlowRenderObject[i].Activate(false);
        }
    }
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::UpdateStartState(Timer * timer)
{

    Vec3 dirToPlayer = m_pThePlayer->GetPosition() - m_vPosition;
    float lengthToPlayer = dirToPlayer.length();

    if (lengthToPlayer < 330.0f)
    {
        m_CurrentState = BOSS_SPACE_CANNON_STATE;
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));

        m_pRotationalInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pRotationalInterpolator, false, m_pTheScene->GetGameTimer());

        m_BossTimer.Start();
    }
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::UpdateSearchState(Timer* timer)
{
    switch (m_iSubState)
    {
            ///--- rotando
        case 0:
        {
            if (m_pRotationalInterpolator->IsFinished())
            {
                m_fRotation = 0.0f;
                m_iSubState = 1;
                m_iCurrentExplo = 0;
                m_BossTimer.Start();
            }
            break;
        }
            ///--- disparando
        case 1:
        {
            if (m_iCurrentExplo >= 15)
            {
                m_iCurrentExplo = 0;
                m_CurrentState = BOSS_SPACE_MOVING_STATE;
                m_iSubState = 0;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));

                m_pLegsInterpolator->Reset();
                m_pLegsInterpolator->Redefine(0.0f, 152.0f, 5.0f, false, 5.0f);
                InterpolatorManager::Instance().Add(m_pLegsInterpolator, false, m_pTheScene->GetGameTimer());

                m_BossTimer.Start();
            }
            else if (m_BossTimer.GetActualTime() > 0.5f)
            {
                for (int i = 0; i < 4; i++)
                {
                    if (m_iHealth[i] > 0.0f)
                    {
                        Vec4 vThrowingPos4_1 = Vec4(150.0f, 20.0f, 0.0f, 0.0f);
                        MATRIX rotFire;
                        float rotation = MAT_ToRadians((i * 90.0f) - 90.0f);
                        MatrixRotationY(rotFire, rotation);
                        MatrixVec4Multiply(vThrowingPos4_1, vThrowingPos4_1, rotFire);

                        Vec3 finalPos = Vec3(vThrowingPos4_1.ptr()) + Vec3(m_vPosition.x, 0.0f, m_vPosition.z);

                        Vec3 dirToPlayer = m_pThePlayer->GetPosition() - finalPos;
                        dirToPlayer.normalize();
                        dirToPlayer *= 2.5f;

                        ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, finalPos, dirToPlayer, 2.0f, MAT_angleUnsignedVec2D(Vec2(1, 0), Vec2(dirToPlayer.x, dirToPlayer.z)), Vec3(0, 0, 0), 1.2f);
                    }
                }

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INLINE_THROWING), m_vPosition);

                m_iCurrentExplo++;

                m_BossTimer.Start();
            }
            break;
        }
    }
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::UpdateMovingState(Timer * timer)
{


    float dTime = timer->GetDeltaTime();

    switch (m_iSubState)
    {
            ///--- parpadeando
        case 0:
        {
            if (m_pLegsInterpolator->IsFinished())
            {
                m_iSubState = 1;
                m_iCurrentExplo = 0;
                m_fSpeed = 0.0f;
                m_BossTimer.Start();
                m_PlayerDir = m_pThePlayer->GetPosition() - Vec3(m_vPosition.x, 0.0f, m_vPosition.z);
                m_PlayerDir.normalize();
            }
            break;
        }
        case 1:
        {
            float pointX = 0.0f;
            float pointZ = 0.0f;

            if (m_PlayerDir.x < 0.0f)
            {
                pointX = 1110.0f;
            }
            else
            {
                pointX = 630.0f;
            }

            if (m_PlayerDir.z < 0.0f)
            {
                pointZ = 970.0f;
            }
            else
            {
                pointZ = 490.0f;
            }

            Vec3 point(pointX, 0.0f, pointZ);

            Vec3 movementDir = Vec3(m_vPosition.x, 0.0f, m_vPosition.z) - point;
            movementDir.normalize();

            m_fSpeed += 300.0f * dTime;

            Vec3 force = (m_fSpeed * dTime * movementDir);

            if (m_vPosition.x >= 1010.0f || m_vPosition.x <= 730.0f)
            {
                force.x = 0.0f;
            }

            if (m_vPosition.z >= 870.0f || m_vPosition.z <= 590.0f)
            {
                force.z = 0.0f;
            }

            if (force.x != 0.0f && force.z != 0.0f)
            {
                m_vPosition += force;
            }
            else
            {
                m_iSubState = 2;
                m_fSpeed = 50.0f;
                m_pTheScene->GetCamera3D()->AddNoise(1.6f, timer);
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_METALIC_BOUNCE));
                m_BossTimer.Start();
            }
            break;
        }
        case 2:
        {
            if (m_BossTimer.GetActualTime() > 3.0f)
            {
                Vec3 len = m_vOriginalPos - m_vPosition;
                float length = len.length();
                len.normalize();

                if (length > 1.0f)
                {
                    Vec3 force = (m_fSpeed * dTime * len);
                    m_vPosition += force;
                }
                else
                {
                    m_vPosition = m_vOriginalPos;
                    m_iSubState = 3;
                    m_pLegsInterpolator->Reset();
                    m_pLegsInterpolator->Redefine(152.0f, 0.0f, 5.0f, false, 5.0f);
                    InterpolatorManager::Instance().Add(m_pLegsInterpolator, false, m_pTheScene->GetGameTimer());
                    m_BossTimer.Start();
                }
            }
            break;
        }
        case 3:
        {
            if (m_pLegsInterpolator->IsFinished())
            {
                m_iCurrentExplo = 0;
                m_CurrentState = BOSS_SPACE_CANNON_STATE;
                m_iSubState = 0;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));

                m_pRotationalInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pRotationalInterpolator, false, m_pTheScene->GetGameTimer());

                m_BossTimer.Start();
            }
            break;
        }
    }
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::UpdateCannonState(Timer * timer)
{
    switch (m_iSubState)
    {
            ///--- rotando
        case 0:
        {
            if (m_pRotationalInterpolator->IsFinished())
            {
                m_fRotation = 0.0f;
                m_iSubState = 1;
                m_iCurrentExplo = 0;
                m_BossTimer.Start();
            }
            break;
        }
            ///--- disparando
        case 1:
        {
            if (m_iCurrentExplo >= 30)
            {
                m_iCurrentExplo = 0;
                m_CurrentState = BOSS_SPACE_SEARCH_STATE;
                m_iSubState = 0;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));
                m_pRotationalInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pRotationalInterpolator, false, m_pTheScene->GetGameTimer());
                m_BossTimer.Start();
            }
            else if (m_BossTimer.GetActualTime() > 0.35f)
            {
                for (int i = 0; i < 4; i++)
                {
                    if (m_iHealth[i] > 0.0f)
                    {
                        Vec4 vThrowingDir4_1 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
                        Vec4 vThrowingDir4_2 = Vec4(0.0f, 0.0f, 1.0f, 0.0f);
                        Vec4 vThrowingDir4_3 = Vec4(0.0f, 0.0f, -1.0f, 0.0f);
                        Vec4 vThrowingPos4_1 = Vec4(180.0f, 20.0f, 0.0f, 0.0f);
                        Vec4 vThrowingPos4_2 = Vec4(150.0f, 20.0f, 0.0f, 0.0f);
                        Vec4 vThrowingPos4_3 = Vec4(150.0f, 20.0f, 0.0f, 0.0f);
                        MATRIX rotFire;
                        float rotation = MAT_ToRadians((i * 90.0f) - 90.0f);
                        MatrixRotationY(rotFire, rotation);
                        MatrixVec4Multiply(vThrowingDir4_1, vThrowingDir4_1, rotFire);
                        MatrixVec4Multiply(vThrowingDir4_2, vThrowingDir4_2, rotFire);
                        MatrixVec4Multiply(vThrowingDir4_3, vThrowingDir4_3, rotFire);
                        MatrixVec4Multiply(vThrowingPos4_1, vThrowingPos4_1, rotFire);
                        MatrixVec4Multiply(vThrowingPos4_2, vThrowingPos4_2, rotFire);
                        MatrixVec4Multiply(vThrowingPos4_3, vThrowingPos4_3, rotFire);

                        Vec3 impulse_1 = (Vec3(vThrowingDir4_1.ptr()) * 2.5f);
                        Vec3 impulse_2 = (Vec3(vThrowingDir4_2.ptr()) * 2.5f);
                        Vec3 impulse_3 = (Vec3(vThrowingDir4_3.ptr()) * 2.5f);

                        ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, Vec3(vThrowingPos4_1.ptr()) + m_vPosition, impulse_1, 2.0f, rotation, Vec3(0, 0, 0), 1.2f);
                        ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, Vec3(vThrowingPos4_2.ptr()) + m_vPosition, impulse_2, 2.0f, rotation + MAT_ToRadians(90.0f), Vec3(0, 0, 0), 1.2f);
                        ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, Vec3(vThrowingPos4_3.ptr()) + m_vPosition, impulse_3, 2.0f, rotation - MAT_ToRadians(90.0f), Vec3(0, 0, 0), 1.2f);
                    }
                }

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INLINE_THROWING), m_vPosition);

                m_iCurrentExplo++;

                m_BossTimer.Start();
            }
            break;
        }
    }
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::UpdateDieState(Timer * timer)
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
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 2.0f, 1.9f, Vec3(0, 0, 0), MAT_RandomInt(5, 12), 0.6f);
                ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.5f, 2.5f, Vec3(0, 0, 0), MAT_RandomInt(3, 8), 1.0f);

            }

            if (m_iCurrentExplo > 12)
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

void BossSpaceEnemy::getWorldTransform(btTransform & worldTransform) const
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

void BossSpaceEnemy::setWorldTransform(const btTransform & worldTransform)
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

void BossSpaceEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer * timer)
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

        if (BOSS_SPACE_DIE_STATE != m_CurrentState)
            m_pThePlayer->Deflate(PLAYER_BIG_ENEMY_HURT);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
    }

    m_pTheScene->GetCamera3D()->AddNoise(1.5f, timer);
}

//////////////////////////
//////////////////////////

void BossSpaceEnemy::ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData)
{
    if (m_CurrentState == BOSS_SPACE_CANNON_STATE || m_CurrentState == BOSS_SPACE_SEARCH_STATE)
    {
        int leg = additionalData;

        if (leg < 5)
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

//////////////////////////
//////////////////////////

void BossSpaceEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    if (m_CurrentState == BOSS_SPACE_CANNON_STATE || m_CurrentState == BOSS_SPACE_SEARCH_STATE)
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

void BossSpaceEnemy::Enable(void)
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

void BossSpaceEnemy::Disable(void)
{
    Enemy::Disable();

    for (int i = 0; i < 4; i++)
    {
        PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pLegsRigidBody[i]);
    }

    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}
