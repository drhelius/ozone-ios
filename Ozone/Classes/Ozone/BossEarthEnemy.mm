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
 * File:   BossEarthEnemy.mm
 * Author: nacho
 * 
 * Created on 10 de enero de 2010, 23:57
 */

#include "BossEarthEnemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"
#include "gamemanager.h"

BossEarthEnemy::BossEarthEnemy(void) : Enemy()
{
    InitPointer(m_pGlowInterpolator);
    InitPointer(m_pMovementInterpolator);
    InitPointer(m_pHitSineInterpolator);
    InitPointer(m_pHitSawtoothInterpolator);
    InitPointer(m_pDieInterpolator);

    for (int i = 0; i < 4; i++)
    {
        InitPointer(m_pFlashInterpolator[4]);
    }

    InitPointer(m_pCrossBladesHorizontalShape);
    InitPointer(m_pCrossBladesVerticalShape);
    InitPointer(m_pCrossCannonHorizontalShape);
    InitPointer(m_pCrossCannonVerticalShape);
    InitPointer(m_pSphereBodyShape);
    InitPointer(m_pCompoundShape);

    Defaults();
}

//////////////////////////
//////////////////////////

void BossEarthEnemy::Defaults(void)
{
    for (int i = 0; i < 4; i++)
    {
        m_fflashGlow[i] = 0.0f;
    }

    m_iHealth = BOSS_EARTH_HEALTH;
    m_fGlowAlpha = 0.0f;
    m_fAngularVel = 0.0f;
    m_fAngularRot = 0.0f;
    m_fTimeOfLeak = 0.0f;
    m_fHitGlow = 0.0f;
    m_fLastActionTime = 0.0f;
    m_fBladeOffset = BOSS_EARTH_BLADE_LENGTH;
    m_iSubState = 0;
    m_iCurrentCannon = 0;
    m_fLastNukeTime = 0.0f;
    m_CurrentState = BOSS_EARTH_START_STATE;
}

//////////////////////////
//////////////////////////

BossEarthEnemy::~BossEarthEnemy()
{
    SafeDelete(m_pGlowInterpolator);
    SafeDelete(m_pMovementInterpolator);
    SafeDelete(m_pHitSineInterpolator);
    SafeDelete(m_pHitSawtoothInterpolator);
    SafeDelete(m_pDieInterpolator);

    for (int i = 0; i < 4; i++)
    {
        SafeDelete(m_pFlashInterpolator[4]);
    }

    SafeDelete(m_pCrossBladesHorizontalShape);
    SafeDelete(m_pCrossBladesVerticalShape);
    SafeDelete(m_pCrossCannonHorizontalShape);
    SafeDelete(m_pCrossCannonVerticalShape);
    SafeDelete(m_pSphereBodyShape);
    SafeDelete(m_pCompoundShape);
}

//////////////////////////
//////////////////////////

void BossEarthEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_vIniPos = m_vPosition;

    m_pGlowInterpolator = new SinusoidalInterpolator(&m_fGlowAlpha, 0.0f, 1.0f, 1.0f, true);
    m_pMovementInterpolator = new SineInterpolator(&m_fMovement, -0.45f, 0.45f, 3.0f);
    m_pHitSineInterpolator = new SinusoidalInterpolator(&m_fHitGlow, 0.0f, 1.0f, 0.075f, false, 0.15f);
    m_pHitSawtoothInterpolator = new SinusoidalInterpolator(&m_fHitGlow, 0.0f, 1.0f, 0.075f, false, 0.60f);
    m_pDieInterpolator = new SquareInterpolator(&m_fHitGlow, 0.0f, 1.0f, 0.2f);

    InterpolatorManager::Instance().Add(m_pGlowInterpolator, false, m_pTheScene->GetGameTimer());
    InterpolatorManager::Instance().Add(m_pMovementInterpolator, false, m_pTheScene->GetGameTimer());

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_earth"),
            TextureManager::Instance().GetTexture("game/entities/boss_earth", true), RENDER_OBJECT_NORMAL);
    m_MainRenderObject.SetPosition(m_vPosition);
    m_MainRenderObject.UseColor(true);

    for (int i = 0; i < 4; i++)
    {
        m_BladeRenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_earth_blade"),
                TextureManager::Instance().GetTexture("game/entities/boss_earth", true), RENDER_OBJECT_NORMAL);
        MatrixRotationY(m_BladeRenderObject[i].GetTransform(), MAT_ToRadians(45.0f + (90.0f * i)));
        m_BladeRenderObject[i].SetPosition(m_vPosition);

        m_CannonRenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_earth_canon"),
                TextureManager::Instance().GetTexture("game/entities/boss_earth", true), RENDER_OBJECT_NORMAL);
        MatrixRotationY(m_CannonRenderObject[i].GetTransform(), MAT_ToRadians(45.0f + (90.0f * i)));
        m_CannonRenderObject[i].SetPosition(m_vPosition);
        m_CannonRenderObject[i].UseColor(true);

        m_FlashRenderObject[i].Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_earth_glow2"),
                TextureManager::Instance().GetTexture("game/entities/boss_earth", true), RENDER_OBJECT_ADDITIVE);
        MatrixRotationY(m_CannonRenderObject[i].GetTransform(), MAT_ToRadians(45.0f + (90.0f * i)));
        m_FlashRenderObject[i].SetPosition(m_vPosition);
        m_FlashRenderObject[i].UseColor(true);

        m_RenderObjectList.push_back(&m_BladeRenderObject[i]);
        m_RenderObjectList.push_back(&m_CannonRenderObject[i]);
        m_RenderObjectList.push_back(&m_FlashRenderObject[i]);


        m_pFlashInterpolator[i] = new LinearInterpolator(&m_fflashGlow[i], 1.0f, 0.0f, 0.15f);
    }

    m_GlowRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_earth_glow"),
            TextureManager::Instance().GetTexture("game/entities/boss_earth", true), RENDER_OBJECT_ADDITIVE);
    m_GlowRenderObject.SetPosition(m_vPosition);
    m_GlowRenderObject.UseColor(true);

    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_GlowRenderObject);


    Vec4 vLeakDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);

    MATRIX matrot;
    MatrixRotationY(matrot, MAT_RandomInt(0, 360));
    MatrixVec4Multiply(vLeakDir4, vLeakDir4, matrot);

    m_vLeakDir = Vec3(vLeakDir4.ptr());
    m_vLeakDir.normalize();

    btScalar mass = 20.0f;
    btVector3 inertia(0, 0, 0);

    m_pCrossBladesHorizontalShape = new btBoxShape(btVector3(2.55f, 1.5f, 0.1f));
    m_pCrossBladesHorizontalShape->setMargin(0.01f);
    m_pCrossBladesHorizontalShape->calculateLocalInertia(mass, inertia);
    m_pCrossBladesVerticalShape = new btBoxShape(btVector3(0.1f, 1.5f, 2.55f));
    m_pCrossBladesVerticalShape->setMargin(0.01f);
    m_pCrossBladesVerticalShape->calculateLocalInertia(mass, inertia);

    m_pCrossCannonHorizontalShape = new btBoxShape(btVector3(1.2f, 1.5f, 0.25f));
    m_pCrossCannonHorizontalShape->setMargin(0.01f);
    m_pCrossCannonHorizontalShape->calculateLocalInertia(mass, inertia);
    m_pCrossCannonVerticalShape = new btBoxShape(btVector3(0.25f, 1.5f, 1.2f));
    m_pCrossCannonVerticalShape->setMargin(0.01f);
    m_pCrossCannonVerticalShape->calculateLocalInertia(mass, inertia);

    m_pSphereBodyShape = new btSphereShape(0.8f);
    m_pSphereBodyShape->setMargin(0.01f);
    m_pSphereBodyShape->calculateLocalInertia(mass, inertia);

    btTransform transform;
    transform.setIdentity();
    m_pCompoundShape = new btCompoundShape();

    m_pCompoundShape->addChildShape(transform, m_pCrossBladesHorizontalShape);
    m_pCompoundShape->addChildShape(transform, m_pCrossBladesVerticalShape);
    m_pCompoundShape->addChildShape(transform, m_pCrossCannonHorizontalShape);
    m_pCompoundShape->addChildShape(transform, m_pCrossCannonVerticalShape);
    m_pCompoundShape->addChildShape(transform, m_pSphereBodyShape);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pCompoundShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));
    m_pRigidBody->setCollisionFlags(m_pRigidBody->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
    m_pRigidBody->setActivationState(DISABLE_DEACTIVATION);

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void BossEarthEnemy::Reset(void)
{
    Defaults();

    m_GlowRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);

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

void BossEarthEnemy::Update(Timer* timer)
{
    if (timer->IsRunning())
    {
        if (m_iHealth <= 0 && m_CurrentState != BOSS_EARTH_DIE_STATE)
        {
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
            m_CurrentState = BOSS_EARTH_DIE_STATE;
            m_iSubState = 0;
            m_BossTimer.Start();
            InterpolatorManager::Instance().Delete(m_pGlowInterpolator);
            InterpolatorManager::Instance().Delete(m_pHitSineInterpolator);
            InterpolatorManager::Instance().Delete(m_pHitSawtoothInterpolator);
            InterpolatorManager::Instance().Add(m_pDieInterpolator, false, timer);
        }

        if (m_CurrentState != BOSS_EARTH_DIE_STATE && m_iHealth < 65)
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
            case BOSS_EARTH_START_STATE:
            {
                UpdateStartState(timer);
                break;
            }
            case BOSS_EARTH_CANNON_STATE:
            {
                UpdateCannonState(timer);
                break;
            }
            case BOSS_EARTH_BLADES_STATE:
            {
                UpdateBladesState(timer);
                break;
            }
            case BOSS_EARTH_DIE_STATE:
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

    float scaleRatio = m_fBladeOffset / BOSS_EARTH_BLADE_LENGTH;
    float scale = 4.5f - (scaleRatio * 3.5f);
    float bladeScale = MAT_Min(MAT_Max(0.5f, (1.0f - scaleRatio) + 0.2f), 1.0f);

    btVector3 shapeScaling(bladeScale, bladeScale, bladeScale);
    m_pCrossBladesHorizontalShape->setLocalScaling(shapeScaling);
    m_pCrossBladesVerticalShape->setLocalScaling(shapeScaling);

    for (int i = 0; i < 4; i++)
    {
        float angle = MAT_ToRadians(45.0f + (90.0f * i) + m_fAngularRot);

        Vec4 vBladeDir4 = Vec4(-m_fBladeOffset, 0.0f, 0.0f, 0.0f);

        MatrixRotationY(m_mtxRotation, angle);
        MatrixVec4Multiply(vBladeDir4, vBladeDir4, m_mtxRotation);

        m_BladeRenderObject[i].SetTransform(m_mtxRotation);
        m_BladeRenderObject[i].SetPosition(Vec3(vBladeDir4.ptr()) + m_vPosition);

        m_CannonRenderObject[i].SetTransform(m_mtxRotation);
        m_CannonRenderObject[i].SetPosition(m_vPosition);
        float colorHit = MAT_Min(m_fHitGlow, 0.75f);
        m_CannonRenderObject[i].SetColor(1.0f, 1.0f - colorHit, 1.0f - colorHit, 1.0f);

        m_FlashRenderObject[i].SetTransform(m_mtxRotation);
        m_FlashRenderObject[i].SetPosition(m_vPosition);
        m_FlashRenderObject[i].SetColor(1.0f, 1.0f, 1.0f, m_fflashGlow[i]);

        MatrixScaling(m_GlowRenderObject.GetTransform(), scale, 1.0f, scale / 2.5f);
        m_GlowRenderObject.SetPosition(m_vPosition);
    }
}

//////////////////////////
//////////////////////////

void BossEarthEnemy::UpdateStartState(Timer* timer)
{

    Vec3 dirToPlayer = m_pThePlayer->GetPosition() - m_vPosition;
    float lengthToPlayer = dirToPlayer.length();

    if (lengthToPlayer < 320.0f)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));

        m_pGlowInterpolator->Reset();
        m_CurrentState = BOSS_EARTH_CANNON_STATE;

        m_BossTimer.Start();
    }
}

//////////////////////////
//////////////////////////

void BossEarthEnemy::UpdateCannonState(Timer* timer)
{
    m_GlowRenderObject.SetColor(1.0f, 1.0f, 1.0f, m_fGlowAlpha);

    float fActualTime = m_BossTimer.GetActualTime();

    if (fActualTime < 8.0f)
    {
        if (fActualTime - m_fLastActionTime > 0.2f)
        {
            m_fLastActionTime = fActualTime;

            int i = m_iCurrentCannon;
            m_iCurrentCannon++;
            m_iCurrentCannon %= 4;

            Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
            Vec4 vThrowingPos4_1 = Vec4(110.0f, 0.0f, -10.0f, 0.0f);
            Vec4 vThrowingPos4_2 = Vec4(110.0f, 0.0f, 10.0f, 0.0f);
            MATRIX rotFire;
            float rotation = MAT_ToRadians((i * 90.0f) + 45.0f + m_fAngularRot);
            MatrixRotationY(rotFire, rotation);
            MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, rotFire);
            MatrixVec4Multiply(vThrowingPos4_1, vThrowingPos4_1, rotFire);
            MatrixVec4Multiply(vThrowingPos4_2, vThrowingPos4_2, rotFire);

            Vec3 impulse = (Vec3(vThrowingDir4.ptr()) * 2.5f);

            ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, Vec3(vThrowingPos4_1.ptr()) + m_vPosition, impulse, 2.0f, rotation, Vec3(0, 0, 0));
            ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, Vec3(vThrowingPos4_2.ptr()) + m_vPosition, impulse, 2.0f, rotation, Vec3(0, 0, 0));

            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INLINE_THROWING), m_vPosition);
            
            m_pFlashInterpolator[i]->Reset();
            InterpolatorManager::Instance().Add(m_pFlashInterpolator[i], false, timer);
        }
    }

    if (fActualTime > 9.0f)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));

        m_fLastActionTime = 0.0f;
        m_CurrentState = BOSS_EARTH_BLADES_STATE;
        m_BossTimer.Start();
        m_iSubState = 0;
    }
}

//////////////////////////
//////////////////////////

void BossEarthEnemy::UpdateBladesState(Timer* timer)
{

    float dTime = timer->GetDeltaTime();

    m_GlowRenderObject.SetColor(1.0f, 1.0f, 1.0f, m_fGlowAlpha);

    switch (m_iSubState)
    {
            ///--- sacando las cuchillas
        case 0:
        {
            if (m_fBladeOffset > 0.0f)
            {
                m_fBladeOffset -= (BOSS_EARTH_BLADE_VEL + (BOSS_EARTH_HEALTH - m_iHealth)) * dTime;
            }
            else
            {
                m_fBladeOffset = 0.0f;
                m_iSubState = -1;
                m_BossTimer.Start();
            }
            break;
        }
            ///---- esperando
        case -1:
        {
            if (m_BossTimer.GetActualTime() > 1.0f)
            {
                m_iSubState = 1;
                m_BossTimer.Start();
            }
            break;
        }
            ////---- empezando a girar
        case 1:
        {
            if (m_fAngularVel < (MAX_BOSS_EARTH_ANGULAR_VEL + (BOSS_EARTH_HEALTH - m_iHealth)))
            {
                m_fAngularVel += BOSS_EARTH_ANGULAR_ACCEL * dTime;
            }
            else
            {
                m_fAngularVel = MAX_BOSS_EARTH_ANGULAR_VEL + (BOSS_EARTH_HEALTH - m_iHealth);
                m_iSubState = 2;
                m_BossTimer.Start();
            }

            m_fAngularRot += m_fAngularVel * dTime;
            break;
        }
            ////---- girando
        case 2:
        {
            m_fAngularRot += m_fAngularVel * dTime;

            if (m_BossTimer.GetActualTime() > 4.0f)
            {
                m_iSubState = 3;
                m_BossTimer.Start();
            }
            break;
        }
            ///----- terminando de girar
        case 3:
        {
            if (m_fAngularVel > 0.0f)
            {
                m_fAngularVel -= BOSS_EARTH_ANGULAR_ACCEL * dTime;
            }
            else
            {
                m_fAngularVel = 0.0f;
                m_iSubState = -3;
                m_BossTimer.Start();
            }

            m_fAngularRot += m_fAngularVel * dTime;
            break;
        }
            ///---- esperando
        case -3:
        {
            if (m_BossTimer.GetActualTime() > 1.0f)
            {
                m_iSubState = 4;
                m_BossTimer.Start();
            }
            break;
        }
            ///--- escondiendo las cuchillas
        case 4:
        {
            if (m_fBladeOffset < BOSS_EARTH_BLADE_LENGTH)
            {
                m_fBladeOffset += (BOSS_EARTH_BLADE_VEL + (BOSS_EARTH_HEALTH - m_iHealth)) * dTime;
            }
            else
            {
                m_fBladeOffset = BOSS_EARTH_BLADE_LENGTH;
                m_iSubState = -4;

                m_BossTimer.Start();

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BOSS_STATE));
            }
            break;
        }
            ///---- esperando
        case -4:
        {
            if (m_BossTimer.GetActualTime() > 1.0f)
            {

                m_CurrentState = BOSS_EARTH_CANNON_STATE;
                m_iSubState = 0;
                m_BossTimer.Start();
            }
            break;
        }
    }


}

//////////////////////////
//////////////////////////

void BossEarthEnemy::UpdateDieState(Timer* timer)
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

void BossEarthEnemy::getWorldTransform(btTransform &worldTransform) const
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

void BossEarthEnemy::setWorldTransform(const btTransform &worldTransform)
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

void BossEarthEnemy::ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers) { }

//////////////////////////
//////////////////////////

void BossEarthEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
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

        if (BOSS_EARTH_DIE_STATE != m_CurrentState)
            m_pThePlayer->Deflate(PLAYER_BIG_ENEMY_HURT);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD));
    }

    m_pTheScene->GetCamera3D()->AddNoise(1.0f, timer);
}

//////////////////////////
//////////////////////////

void BossEarthEnemy::ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData)
{
    if (m_CurrentState == BOSS_EARTH_CANNON_STATE)
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

void BossEarthEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    if (m_CurrentState == BOSS_EARTH_CANNON_STATE)
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

void BossEarthEnemy::Enable(void)
{
    Enemy::Enable();
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void BossEarthEnemy::Disable(void)
{
    Enemy::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

