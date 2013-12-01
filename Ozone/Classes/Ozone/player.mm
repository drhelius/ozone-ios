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
 * File:   player.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:27
 */

#include "player.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "physicsmanager.h"
#include "particlemanager.h"
#include "enemy.h"
#include "gamemanager.h"

Player::Player(void) : PhysicsMoveable(), Renderable()
{
    InitPointer(m_pBallShape);
    InitPointer(m_pGhostObject);
    InitPointer(m_pNukeShape);
    InitPointer(m_pNukeGhostObject);
    InitPointer(m_pNukeInterpolator);
    InitPointer(m_pElectricShape);
    InitPointer(m_pElectricGhostObject);

    m_bActive = false;

    Defaults();
}

//////////////////////////
//////////////////////////

Player::~Player()
{
    SafeDelete(m_pBallShape);

    CollisionInfo* pInfo = (CollisionInfo*) m_pGhostObject->getUserPointer();

    SafeDelete(pInfo);

    m_pGhostObject->setUserPointer(NULL);

    SafeDelete(m_pGhostObject);

    SafeDelete(m_pNukeShape);

    pInfo = (CollisionInfo*) m_pNukeGhostObject->getUserPointer();

    SafeDelete(pInfo);

    SafeDelete(m_pNukeGhostObject);

    SafeDelete(m_pElectricShape);

    pInfo = (CollisionInfo*) m_pElectricGhostObject->getUserPointer();

    SafeDelete(pInfo);

    SafeDelete(m_pElectricGhostObject);

    SafeDelete(m_pNukeInterpolator);
}

//////////////////////////
//////////////////////////

void Player::Init(Vec3 position)
{
    Defaults();

    m_vIniPos = position;

    SetPosition(m_vIniPos);

    m_pNukeInterpolator = new LinearInterpolator(&m_fNukeValue, 0.0f, 1.0f, 0.6f);

    Mesh* pMeshBall1 = MeshManager::Instance().GetMeshFromFile("game/ball/ball_01");
    Mesh* pMeshBall2 = MeshManager::Instance().GetMeshFromFile("game/ball/ball");
    Mesh* pMeshBall2_metal = MeshManager::Instance().GetMeshFromFile("game/ball/ball_m");
    Mesh* pMeshRay = MeshManager::Instance().GetMeshFromFile("game/entities/06_l");

    Texture* pTextureNormal = TextureManager::Instance().GetTexture("game/ball/ball_1", true);
    Texture* pTextureSteel = TextureManager::Instance().GetTexture("game/ball/ball_metal", true);
    Texture* pTextureRay = TextureManager::Instance().GetTexture("game/entities/ene_06_l", true);
    Texture* pTextureHud = TextureManager::Instance().GetTexture("game/hud/hud_01", true);

    m_MainRenderObject.Init(pMeshBall1, pTextureNormal, RENDER_OBJECT_ADDITIVE);
    m_UpperLayer.Init(pMeshBall2, pTextureNormal, RENDER_OBJECT_ADDITIVE);

    m_SteelMainRenderObject.Init(pMeshBall1, pTextureSteel, RENDER_OBJECT_TRANSPARENT);
    m_SteelUpperLayer.Init(pMeshBall2_metal, pTextureSteel, RENDER_OBJECT_TRANSPARENT);

    m_NukeLayer.Init(MeshManager::Instance().GetMeshFromFile("game/ball/wave_01"),
            TextureManager::Instance().GetTexture("game/ball/wave_01", true), RENDER_OBJECT_ADDITIVE);
    m_NukeLayer.UseColor(true);

    m_NukeLayer2.Init(MeshManager::Instance().GetMeshFromFile("game/ball/wave_glow"),
            pTextureHud, RENDER_OBJECT_ADDITIVE);
    m_NukeLayer2.UseColor(true);
    m_NukeLayer2.UseDepthTest(false);


    m_ElectricGlowLayer.Init(MeshManager::Instance().GetMeshFromFile("game/ball/wave_glow"),
            pTextureHud, RENDER_OBJECT_ADDITIVE);
    m_ElectricGlowLayer.UseColor(true);
    m_ElectricGlowLayer.UseDepthTest(false);
    m_ElectricGlowLayer.SetColor(0.2f, 0.0f, 1.0f, 1.0f);

    m_GlowLayer.Init(MeshManager::Instance().GetMeshFromFile("game/ball/ball_glow"),
            pTextureHud, RENDER_OBJECT_ADDITIVE);
    m_GlowLayer.UseDepthTest(false);

    for (int i = 0; i < MAX_INRANGE_ELECTRIC_NPCS; i++)
    {
        m_RayLayer[i].Init(pMeshRay, pTextureRay, RENDER_OBJECT_ADDITIVE);
        m_RayLayer[i].UseTextureMatrix(true);
        m_RayLayer[i].Activate(false);

        m_RenderObjectList.push_back(&m_RayLayer[i]);
    }


    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_UpperLayer);

    m_RenderObjectList.push_back(&m_SteelMainRenderObject);
    m_RenderObjectList.push_back(&m_SteelUpperLayer);

    m_RenderObjectList.push_back(&m_NukeLayer);
    m_RenderObjectList.push_back(&m_NukeLayer2);

    m_RenderObjectList.push_back(&m_ElectricGlowLayer);

    m_RenderObjectList.push_back(&m_GlowLayer);

    m_pBallShape = new btSphereShape(0.1f);

    btScalar mass = 1;
    btVector3 ballInertia(0, 0, 0);
    m_pBallShape->calculateLocalInertia(mass, ballInertia);
    btRigidBody::btRigidBodyConstructionInfo ballRigidBodyCI(mass, this, m_pBallShape, ballInertia);
    ballRigidBodyCI.m_restitution = 0.8f;
    ballRigidBodyCI.m_linearSleepingThreshold = 0.05f;
    m_pRigidBody = new btRigidBody(ballRigidBodyCI);
    m_pRigidBody->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_PLAYER, this));

    m_pGhostObject = new btGhostObject();
    m_pGhostObject->setCollisionShape(m_pBallShape);
    m_pGhostObject->setUserPointer(new CollisionInfo(COL_OBJ_GHOST_PLAYER, this));

    m_pNukeShape = new btSphereShape(0.1f);

    m_pNukeGhostObject = new btGhostObject();
    m_pNukeGhostObject->setCollisionShape(m_pNukeShape);
    m_pNukeGhostObject->setUserPointer(new CollisionInfo(COL_OBJ_GHOST_NUKE, this));


    m_pElectricShape = new btSphereShape(ELECTRIC_RANGE / 10.0f);

    m_pElectricGhostObject = new btGhostObject();
    m_pElectricGhostObject->setCollisionShape(m_pElectricShape);
    m_pElectricGhostObject->setUserPointer(new CollisionInfo(COL_OBJ_GHOST_ELECTRIC, this));
    m_pElectricGhostObject->setCollisionFlags(m_pElectricGhostObject->getCollisionFlags() | btCollisionObject::CF_NO_CONTACT_RESPONSE);

    btTransform tmp;
    this->getWorldTransform(tmp);

    m_pGhostObject->setWorldTransform(tmp);
    m_pNukeGhostObject->setWorldTransform(tmp);
    m_pElectricGhostObject->setWorldTransform(tmp);

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_PLAYER, c_iPlayerCollidesWith);
    PhysicsManager::Instance().GetDynamicsWorld()->addCollisionObject(m_pGhostObject, COL_PLAYER_GHOST, c_iPlayerGhostCollidesWith);
    PhysicsManager::Instance().GetDynamicsWorld()->addCollisionObject(m_pElectricGhostObject, COL_ELECTRIC_GHOST, c_iElectricGhostCollidesWith);

    m_SmokeTimer.Start();

    m_bActive = true;
}

//////////////////////////
//////////////////////////

void Player::Defaults(void)
{
    m_iGemCount = 0;

    m_fAir = PLAYER_MAX_AIR;

    for (int i = 0; i < MAX_TYPE_AMMO; i++)
    {
        m_fAmmo[i] = 0.0f;
    }

    for (int i = 0; i < MAX_TYPE_DOOR_KEY; i++)
    {
        m_bDoorKey[i] = false;
    }

    m_bContactWithAirPump = false;
    m_bIsInContactWithAirPump = false;
    m_bAirSoundActive = false;
    m_bDeflatingSoundActive = false;
    m_bThrusting = false;
    m_bDeflating = false;
    m_bIsDead = false;
    m_bIsLevelCompleted = false;
    m_bIsNukeActive = false;
    m_bAddedGem = false;
    m_bPlayingElectricSound = false;
    m_CurrentWeapon = MAX_TYPE_AMMO;
    m_bIsBossKilled = false;

    m_fCurrentTime = 0.0f;
    m_fLastShootTime = 0.0f;
    m_fNukeValue = 0.0f;

    m_fRayWaitInterval = 0.0f;
    m_fRayWait = 0.0f;
    m_iRayFrame = 0;
    m_bFlashOn = false;
}

//////////////////////////
//////////////////////////

void Player::Reset(void)
{
    m_DieTimer.Stop();
    m_DieTimer.Reset();

    if (m_bIsNukeActive)
    {
        PhysicsManager::Instance().GetDynamicsWorld()->removeCollisionObject(m_pNukeGhostObject);
    }

    if (m_pNukeInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pNukeInterpolator);
    }

    if (m_bIsDead)
    {
        PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_PLAYER, c_iPlayerCollidesWith);
        PhysicsManager::Instance().GetDynamicsWorld()->addCollisionObject(m_pGhostObject, COL_PLAYER_GHOST, c_iPlayerGhostCollidesWith);
    }

    Defaults();

    SetPosition(m_vIniPos);
    MatrixIdentity(m_mtxRotation);

    btTransform trans;
    getWorldTransform(trans);

    m_pRigidBody->setCenterOfMassTransform(trans);
    m_pRigidBody->setInterpolationWorldTransform(trans);
    m_pGhostObject->setWorldTransform(trans);
    m_pNukeGhostObject->setWorldTransform(trans);
    m_pElectricGhostObject->setWorldTransform(trans);
    m_pGhostObject->setInterpolationWorldTransform(trans);
    m_pNukeGhostObject->setInterpolationWorldTransform(trans);
    m_pElectricGhostObject->setInterpolationWorldTransform(trans);
    m_pRigidBody->forceActivationState(ACTIVE_TAG);
    m_pRigidBody->activate();
    m_pRigidBody->setDeactivationTime(0);

    m_pRigidBody->setLinearVelocity(btVector3(0, 0, 0));
    m_pRigidBody->setAngularVelocity(btVector3(0, 0, 0));

    m_SmokeTimer.Start();
}

//////////////////////////
//////////////////////////

void Player::AddNPCToInRangeElectricList(Enemy* pEnemy)
{
    if (pEnemy->AffectedByElectricity())
    {
        m_ElectricInRangeNPCs.push_back(pEnemy);
    }
}

//////////////////////////
//////////////////////////

void Player::Update(const Timer* pTimer)
{
    m_fCurrentTime = pTimer->GetActualTime();
    float dTime = pTimer->GetDeltaTime();

    m_vScale = Vec3(m_fAir, m_fAir, m_fAir);

    float shapeScaleFactor = m_fAir;
    btVector3 shapeScaling(shapeScaleFactor, shapeScaleFactor, shapeScaleFactor);
    m_pBallShape->setLocalScaling(shapeScaling);

    if (m_fAir <= PLAYER_MIN_AIR)
    {
        if (!m_bIsDead)
        {
            m_DieTimer.Start();
            m_bIsDead = true;

            PhysicsManager::Instance().GetDynamicsWorld()->removeCollisionObject(m_pGhostObject);
            PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);

            ParticleManager::Instance().AddExplosion(PARTICLE_GAS, m_vPosition, 0.9f, 1.2f, Vec3(0, 0, 0), 5, 0.0f);

            if (!m_bIsLevelCompleted)
            {
                ParticleManager::Instance().AddExplosion(PARTICLE_GAS, m_vPosition, 3.0f, 1.3f, Vec3(0, 0, 0), 12, 0.9f);
                ParticleManager::Instance().AddExplosion(PARTICLE_GAS, m_vPosition, 1.5f, 1.1f, Vec3(0, 0, 0), 8, 0.2f);
                TriggerVibrationOniPhone();

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_DEAD));
            }

            if (m_bAirSoundActive)
            {
                m_bAirSoundActive = false;
                AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_AIR));
            }

            if (m_bDeflatingSoundActive)
            {
                m_bDeflatingSoundActive = false;
                AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_DEFLATE));
            }

            if (m_bPlayingElectricSound)
            {
                m_bPlayingElectricSound = false;
                AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY_PLAYER));
            }

            if (m_bIsNukeActive)
            {
                InterpolatorManager::Instance().Delete(m_pNukeInterpolator);
                m_bIsNukeActive = false;
                m_fNukeValue = 0.0f;
                m_pNukeInterpolator->Reset();
                PhysicsManager::Instance().GetDynamicsWorld()->removeCollisionObject(m_pNukeGhostObject);
            }
        }

        m_pRigidBody->setLinearVelocity(btVector3(0.0f, 0.0f, 0.0f));

        m_MainRenderObject.Activate(false);
        m_UpperLayer.Activate(false);
        m_SteelMainRenderObject.Activate(false);
        m_SteelUpperLayer.Activate(false);
        m_ElectricGlowLayer.Activate(false);
        m_NukeLayer.Activate(false);
        m_NukeLayer2.Activate(false);
        m_GlowLayer.Activate(false);

        for (int i = 0; i < MAX_INRANGE_ELECTRIC_NPCS; i++)
        {
            m_RayLayer[i].Activate(false);
        }
    }
    else
    {
        if (m_fAmmo[STEEL_AMMO] > 0.0f)
        {
            DropAmmo(STEEL_AMMO, dTime);
            m_MainRenderObject.Activate(false);
            m_UpperLayer.Activate(false);
            m_SteelMainRenderObject.Activate(true);
            m_SteelUpperLayer.Activate(true);

            m_GlowLayer.Activate(false);
        }
        else
        {
            SetAmmo(STEEL_AMMO, 0.0f);
            m_MainRenderObject.Activate(true);
            m_UpperLayer.Activate(true);
            m_SteelMainRenderObject.Activate(false);
            m_SteelUpperLayer.Activate(false);

            m_GlowLayer.Activate(true);
            m_GlowLayer.SetPosition(m_vPosition.x, m_vPosition.y + 15.0f, m_vPosition.z);
        }

        if (m_fAmmo[ELECTRIC_AMMO] > 0.0f)
        {
            DropAmmo(ELECTRIC_AMMO, dTime);
            m_ElectricGlowLayer.Activate(true);
        }
        else
        {
            SetAmmo(ELECTRIC_AMMO, 0.0f);
            m_ElectricGlowLayer.Activate(false);
        }

        m_bIsInContactWithAirPump = m_bContactWithAirPump;
        m_bContactWithAirPump = false;

        ///--- velocidad máxima de la bola
        btVector3 vecPlayerVel = m_pRigidBody->getLinearVelocity();

        float fPlayerVelLength = vecPlayerVel.length();

        if (fPlayerVelLength > PLAYER_MAX_VELOCITY)
        {
            fPlayerVelLength = PLAYER_MAX_VELOCITY;

            vecPlayerVel.normalize();
            vecPlayerVel *= fPlayerVelLength;

            m_pRigidBody->setLinearVelocity(vecPlayerVel);
        }

        MatrixScaling(m_MainRenderObject.GetTransform(), m_vScale.x, m_vScale.y, m_vScale.z);
        MatrixScaling(m_UpperLayer.GetTransform(), m_vScale.x, m_vScale.y, m_vScale.z);
        MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), m_mtxRotation);

        m_SteelMainRenderObject.SetTransform(m_MainRenderObject.GetTransform());
        m_SteelUpperLayer.SetTransform(m_UpperLayer.GetTransform());

        m_MainRenderObject.SetPosition(m_vPosition.x, m_vPosition.y + 10.0f, m_vPosition.z);
        m_UpperLayer.SetPosition(m_vPosition.x, m_vPosition.y + 9.0f, m_vPosition.z);

        m_SteelMainRenderObject.SetPosition(m_vPosition.x, m_vPosition.y + 0.0f, m_vPosition.z);
        m_SteelUpperLayer.SetPosition(m_vPosition.x, m_vPosition.y + 2.0f, m_vPosition.z);

        if (m_bIsNukeActive)
        {
            m_bIsNukeActive = !m_pNukeInterpolator->IsFinished();

            if (m_bIsNukeActive)
            {
                float scalingNuke = m_fNukeValue * 100.0f;
                MatrixScaling(m_NukeLayer.GetTransform(), scalingNuke, scalingNuke, scalingNuke);
                m_NukeLayer.SetPosition(m_vPosition.x, m_vPosition.y + 15.0f, m_vPosition.z);
                m_NukeLayer.SetColor(1.0f, 0.5f, 0.0f, 1.0f - m_fNukeValue);

                const float scalingNukeGlow = 150.0f;
                MatrixScaling(m_NukeLayer2.GetTransform(), scalingNukeGlow, scalingNukeGlow, scalingNukeGlow);
                m_NukeLayer2.SetPosition(m_vPosition.x, m_vPosition.y + 15.0f, m_vPosition.z);
                m_NukeLayer2.SetColor(0.2f, 0.0f, 1.0f, MAT_Max(0.0f, 1.0f - (m_fNukeValue * 1.4f)));

                float shapeNukeScaleFactor = m_fNukeValue * 40.0f;

                btVector3 shapeNukeScaling(shapeNukeScaleFactor, shapeNukeScaleFactor, shapeNukeScaleFactor);
                m_pNukeShape->setLocalScaling(shapeNukeScaling);
            }
            else
            {
                PhysicsManager::Instance().GetDynamicsWorld()->removeCollisionObject(m_pNukeGhostObject);
            }
        }

        const float scalingElectricGlow = 35.0f;
        MatrixScaling(m_ElectricGlowLayer.GetTransform(), scalingElectricGlow, scalingElectricGlow, scalingElectricGlow);
        m_ElectricGlowLayer.SetPosition(m_vPosition.x, m_vPosition.y + 15.0f, m_vPosition.z);

        m_NukeLayer.Activate(m_bIsNukeActive);
        m_NukeLayer2.Activate(m_bIsNukeActive);

        if (m_bThrusting)
        {
            if (!m_bAirSoundActive)
            {
                m_bAirSoundActive = true;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_AIR), m_vPosition);
            }
            else
            {
                AudioManager::Instance().SetEffectPosition(Audio::Instance().GetEffect(kSOUND_PLAYER_AIR), m_vPosition.x, m_vPosition.y, m_vPosition.z);
            }
        }
        else if (m_bAirSoundActive)
        {
            m_bAirSoundActive = false;
            AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_AIR));
        }

        if (m_bDeflating)
        {
            if (!m_bDeflatingSoundActive)
            {
                m_bDeflatingSoundActive = true;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_DEFLATE), m_vPosition);
            }
            else
            {
                AudioManager::Instance().SetEffectPosition(Audio::Instance().GetEffect(kSOUND_PLAYER_DEFLATE), m_vPosition.x, m_vPosition.y, m_vPosition.z);
            }
        }
        else if (m_bDeflatingSoundActive)
        {
            m_bDeflatingSoundActive = false;
            AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_DEFLATE));
        }

        int i = 0;

        if (m_fAmmo[ELECTRIC_AMMO] > 0.0f)
        {

            for (TEnemyListIterator it = m_ElectricInRangeNPCs.begin(); it != m_ElectricInRangeNPCs.end(); it++)
            {
                if (i >= MAX_INRANGE_ELECTRIC_NPCS)
                {
                    break;
                }

                Enemy* pEnemy = (*it);

                pEnemy->AddElectricityTime(dTime);

                if (pEnemy->GetElectricityTime() > 1.0f)
                {
                    pEnemy->Kill();
                    continue;
                }

                Vec3 dir_right(1.0f, 0.0f, 0.0f);
                Vec3 dir_npc = pEnemy->GetRealPosition() - m_vPosition;
                dir_npc.y = 0.0f;
                float length = dir_npc.length();

                dir_npc.normalize();

                float dot = dir_npc.dot(dir_right);
                float lookAtAngle = acosf(dot);

                if (dir_npc.z < 0.0f)
                {
                    lookAtAngle *= -1.0f;
                }

                MATRIX scale, rotY;

                MatrixScaling(scale, length / 160.0f, 1.0f, 1.0f);
                MatrixRotationY(rotY, lookAtAngle + (pTimer->IsRunning() ? MAT_ToRadians(MAT_RandomInt(-15, 16) * 0.1f) : 0.0f));
                MatrixMultiply(m_RayLayer[i].GetTransform(), scale, rotY);
                m_RayLayer[i].SetPosition(m_vPosition);

                m_RayLayer[i].Activate(m_bFlashOn);

                int frame = m_iRayFrame + i;
                frame %= 4;

                MatrixTranslation(m_RayLayer[i].GetTextureTransform(), 0.0f, frame * 0.25f, 0.0f);

                i++;
            }
        }

        if (i > 0)
        {
            if (!m_bPlayingElectricSound)
            {
                m_bPlayingElectricSound = true;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY_PLAYER), m_vPosition);
            }

            if (m_fRayWaitInterval <= 0.0f)
            {
                m_fRayWaitInterval = 0.03f;

                m_bFlashOn = !m_bFlashOn;

                if (!m_bFlashOn && (MAT_RandomInt(0, 12) == 2))
                {
                    m_fRayWaitInterval = MAT_RandomInt(5, 12) * 0.01f;
                }

            }
            else
            {
                m_fRayWaitInterval -= dTime;
            }

            m_fRayWait += dTime;

            if (m_fRayWait >= 0.05f)
            {
                m_fRayWait = 0.0f;
                m_iRayFrame++;
                m_iRayFrame %= 4;
            }
        }
        else
        {
            if (m_bPlayingElectricSound)
            {
                m_bPlayingElectricSound = false;
                AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY_PLAYER));
            }
        }

        for (; i < MAX_INRANGE_ELECTRIC_NPCS; i++)
        {
            m_RayLayer[i].Activate(false);
        }

        if (m_bIsBossKilled)
        {
            btVector3 vecPlayerVel = m_pRigidBody->getLinearVelocity();

            float fPlayerVelLength = vecPlayerVel.length();

            if (fPlayerVelLength > 0.0f)
            {
                fPlayerVelLength -= (PLAYER_BRAKE_RATE * dTime);

                if (fPlayerVelLength < 0.0f)
                    fPlayerVelLength = 0.0f;

                vecPlayerVel.normalize();
                vecPlayerVel *= fPlayerVelLength;

                m_pRigidBody->setLinearVelocity(vecPlayerVel);
            }
        }

        m_bThrusting = false;
        m_bDeflating = false;
    }

    m_ElectricInRangeNPCs.clear();
}

//////////////////////////
//////////////////////////

void Player::getWorldTransform(btTransform &worldTransform) const
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

void Player::setWorldTransform(const btTransform &worldTransform)
{
    btVector3 pos = worldTransform.getOrigin();
    btMatrix3x3 rot = worldTransform.getBasis();

    Vec3 newPos(pos.getX() * PHYSICS_INV_SCALE_FACTOR, pos.getY() * PHYSICS_INV_SCALE_FACTOR,
            pos.getZ() * PHYSICS_INV_SCALE_FACTOR);

    m_vPosition = newPos;
    MAT_btMatrix3x3_to_MATRIX(rot, m_mtxRotation);

    m_pGhostObject->setWorldTransform(worldTransform);
    m_pNukeGhostObject->setWorldTransform(worldTransform);
    m_pElectricGhostObject->setWorldTransform(worldTransform);
}

//////////////////////////
//////////////////////////

float Player::Deflate(float damage, bool sound)
{
    if (!m_bIsDead)
    {
        m_bDeflating = sound;
        m_fAir -= damage;
        m_fAir = MAT_Max(m_fAir, PLAYER_MIN_AIR);
    }
    return m_fAir;
}

//////////////////////////
//////////////////////////

float Player::GetAir(void) const
{
    return m_fAir;
}

//////////////////////////
//////////////////////////

float Player::SetAir(float air)
{
    m_fAir = MAT_Min(air, PLAYER_MAX_AIR);
    m_fAir = MAT_Max(m_fAir, PLAYER_MIN_AIR);
    return m_fAir;
}

//////////////////////////
//////////////////////////

float Player::Inflate(float air)
{
    if (!m_bIsDead)
    {
        m_fAir += air;
        m_fAir = MAT_Min(m_fAir, PLAYER_MAX_AIR);
    }
    return m_fAir;
}

//////////////////////////
//////////////////////////

float Player::SetAmmo(ePlayerAmmo type, float ammo)
{
    m_fAmmo[type] = ammo;
    return m_fAmmo[type];
}

//////////////////////////
//////////////////////////

float Player::AddAmmo(ePlayerAmmo type, float ammo)
{
    m_fAmmo[type] += ammo;
    return m_fAmmo[type];
}

//////////////////////////
//////////////////////////

float Player::DropAmmo(ePlayerAmmo type, float ammo)
{
    m_fAmmo[type] -= ammo;
    return m_fAmmo[type];
}

//////////////////////////
//////////////////////////

float Player::GetAmmo(ePlayerAmmo type) const
{
    return m_fAmmo[type];
}

//////////////////////////
//////////////////////////

void Player::AddDoorKey(ePlayerDoorKeys key)
{
    m_bDoorKey[key] = true;
}

//////////////////////////
//////////////////////////

void Player::DropDoorKey(ePlayerDoorKeys key)
{
    m_bDoorKey[key] = false;
}

//////////////////////////
//////////////////////////

bool Player::GetDoorKey(ePlayerDoorKeys key) const
{
    return m_bDoorKey[key];
}

//////////////////////////
//////////////////////////

void Player::Brake(float dTime)
{
    if (!m_bIsDead)
    {
        btVector3 vecPlayerVel = m_pRigidBody->getLinearVelocity();

        float fPlayerVelLength = vecPlayerVel.length();

        if (fPlayerVelLength > 0.0f)
        {
            fPlayerVelLength -= (PLAYER_BRAKE_RATE * dTime);

            if (fPlayerVelLength < 0.0f)
                fPlayerVelLength = 0.0f;

            vecPlayerVel.normalize();
            vecPlayerVel *= fPlayerVelLength;

            m_pRigidBody->setLinearVelocity(vecPlayerVel);
        }
    }
}

//////////////////////////
//////////////////////////

void Player::Thrust(const Vec3& speed, float dTime)
{
    if (!m_bIsDead)
    {
        m_bThrusting = true;

        if (!m_pRigidBody->isActive())
        {
            m_pRigidBody->activate();
        }

        float finalSpeedX = speed.x * PLAYER_THRUST_RATE;
        float finalSpeedZ = speed.y * PLAYER_THRUST_RATE;

        float smokeRatio = 0.1f;

        if (GameManager::Instance().DeviceType() == GameManager::DEVICE_1ST_GEN)
        {
            smokeRatio = (m_fAmmo[STEEL_AMMO] > 0.0f) ? 0.14f : 0.12f;
        }
        else
        {
            smokeRatio = (m_fAmmo[STEEL_AMMO] > 0.0f) ? 0.1f : 0.08f;
        }

        if (m_SmokeTimer.GetActualTime() > smokeRatio)
        {
            Vec3 normalizedSpeed = speed.normalized();
            Vec3 impulse = (Vec3(-normalizedSpeed.x, 0.0f, -normalizedSpeed.y) * 2.0f);

            btVector3 initialSpeed = m_pRigidBody->getLinearVelocity();

            float rot = MAT_ToRadians(MAT_RandomInt(0, 360));

            if (m_fAmmo[STEEL_AMMO] > 0.0f)
            {
                ParticleManager::Instance().AddParticle(PARTICLE_SMOKE, m_vPosition, impulse * 0.9f, 0.9f, rot, Vec3(initialSpeed.x(), 0.0f, initialSpeed.z()), 1.7f);
            }
            else
            {
                ParticleManager::Instance().AddParticle(PARTICLE_GAS, m_vPosition, impulse, 1.0f, rot, Vec3(initialSpeed.x(), 0.0f, initialSpeed.z()), 1.8f);
            }

            m_SmokeTimer.Start();
        }

        btVector3 finalSpeed = btVector3(finalSpeedX, 0.0f, finalSpeedZ);

        if (finalSpeed.length2() > 16.0f)
        {
            finalSpeed.normalize();
            finalSpeed *= 4.0f;
        }

        if (m_fAmmo[STEEL_AMMO] <= 0.0f)
        {
            m_fAir -= PLAYER_DEFLATE_RATE * dTime;
            m_fAir = MAT_Max(m_fAir, PLAYER_MIN_AIR);

        }
        else
        {
            finalSpeed *= 0.9f;
        }

        m_pRigidBody->applyCentralForce(finalSpeed);
    }
}

//////////////////////////
//////////////////////////

void Player::Shoot(ePlayerAmmo type)
{
    if (!m_bIsDead)
    {
        if ((m_fCurrentTime - m_fLastShootTime) > 0.2f)
        {
            m_fLastShootTime = m_fCurrentTime;

            switch (type)
            {
                case NORMAL_AMMO:
                {
                    if (GetAmmo(NORMAL_AMMO) > 0)
                    {
                        btVector3 playerVel = m_pRigidBody->getLinearVelocity();

                        if (playerVel.x() != 0.0f || playerVel.z() != 0.0f)
                        {
                            DropAmmo(NORMAL_AMMO, 1);

                            Vec3 vPlayerVel = Vec3(playerVel.x(), 0.0f, playerVel.z());
                            Vec3 vImpulse = (vPlayerVel.normalized() * 1.7f);

                            ParticleManager::Instance().AddParticle(PARTICLE_PLAYER_RED, m_vPosition, vImpulse, 4.0f, 0.0f, vPlayerVel);

                            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NORMAL_WEAPON));
                        }
                    }

                    break;
                }
                case NUCLEAR_AMMO:
                {
                    if (!m_bIsNukeActive && GetAmmo(NUCLEAR_AMMO) > 0)
                    {
                        DropAmmo(NUCLEAR_AMMO, 1);

                        m_pNukeInterpolator->Reset();

                        m_fNukeValue = 0.0f;

                        btVector3 shapeNukeScaling(0.0f, 0.0f, 0.0f);
                        m_pNukeShape->setLocalScaling(shapeNukeScaling);

                        PhysicsManager::Instance().GetDynamicsWorld()->addCollisionObject(m_pNukeGhostObject, COL_NUKE_GHOST, c_iNukeGhostCollidesWith);

                        InterpolatorManager::Instance().Add(m_pNukeInterpolator, false);

                        m_bIsNukeActive = true;

                        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NUCLEAR_WEAPON));
                    }

                    break;
                }
            }
        }
    }
}


