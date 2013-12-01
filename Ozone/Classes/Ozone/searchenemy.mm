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
 * File:   searchenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:32
 */

#include "searchenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "player.h"
#include "scene.h"

//////////////////////////
//////////////////////////

SearchEnemy::SearchEnemy(void) : Enemy()
{
    InitPointer(m_pFadeInInterpolator);
    InitPointer(m_pFadeOutInterpolator);

    m_fUpperLayerOpacity = 0.0f;

    m_State = SEARCH_ENEMY_IDLE;
}

//////////////////////////
//////////////////////////

SearchEnemy::~SearchEnemy()
{
    SafeDelete(m_pFadeInInterpolator);
    SafeDelete(m_pFadeOutInterpolator);
}

//////////////////////////
//////////////////////////

void SearchEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_vIniPos = m_vPosition;

    m_pFadeInInterpolator = new SquareInterpolator(&m_fUpperLayerOpacity, 0.0f, 1.0f, 0.25f, true, 0.25f);
    m_pFadeOutInterpolator = new LinearInterpolator(&m_fUpperLayerOpacity, 1.0f, 0.0f, 0.5f);

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/04_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_TRANSPARENT);
    m_MainRenderObject.SetPosition(this->GetPosition());


    m_UpperLayer.Init(MeshManager::Instance().GetMeshFromFile("game/entities/04a_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_ADDITIVE);
    m_UpperLayer.UseColor(true);
    m_UpperLayer.SetPosition(GetPositionX(), GetPositionY() + 1.0f, GetPositionZ());

    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_UpperLayer);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(1.0f, this, m_pEnemyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));
    m_pRigidBody->setDamping(0.6f, 0.0f);

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}

//////////////////////////
//////////////////////////

void SearchEnemy::Reset(void)
{
    m_fUpperLayerOpacity = 0.0f;
    m_fAffectedByElectricityTime = 0.0f;

    m_State = SEARCH_ENEMY_IDLE;

    if (m_pFadeInInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pFadeInInterpolator);
    }

    if (m_pFadeOutInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pFadeOutInterpolator);
    }
        
    SetPosition(m_vIniPos);
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

void SearchEnemy::Update(Timer* timer)
{
    Vec3 dir = m_pThePlayer->GetPosition() - m_vPosition;

    switch (m_State)
    {
        case SEARCH_ENEMY_IDLE:
        {
            if (dir.length() <= 250.0f && !m_pThePlayer->IsDead())
            {
                m_State = SEARCH_ENEMY_START_SEARCHING;

                m_pFadeInInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pFadeInInterpolator, false, timer);

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_SEARCH_ENEMY_ACTIVATE), m_vPosition);
            }
            break;
        }
        case SEARCH_ENEMY_START_SEARCHING:
        {
            if (dir.length() > 250.0f || m_pThePlayer->IsDead())
            {
                m_State = SEARCH_ENEMY_STOP_SEARCHING;

                InterpolatorManager::Instance().Delete(m_pFadeInInterpolator);
                m_pFadeOutInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pFadeOutInterpolator, false, timer);
            }
            else if (m_pFadeInInterpolator->IsFinished())
            {
                m_State = SEARCH_ENEMY_SEARCHING;
            }

            break;
        }
        case SEARCH_ENEMY_SEARCHING:
        {
            if (dir.length() > 250.0f || m_pThePlayer->IsDead())
            {
                m_State = SEARCH_ENEMY_STOP_SEARCHING;

                m_pFadeOutInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pFadeOutInterpolator, false, timer);
            }
            break;
        }
        case SEARCH_ENEMY_STOP_SEARCHING:
        {
            if (dir.length() <= 250.0f && !m_pThePlayer->IsDead())
            {
                m_State = SEARCH_ENEMY_START_SEARCHING;

                InterpolatorManager::Instance().Delete(m_pFadeOutInterpolator);
                m_pFadeInInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pFadeInInterpolator, false, timer);
            }
            else if (m_pFadeOutInterpolator->IsFinished())
            {
                m_State = SEARCH_ENEMY_IDLE;
            }
            break;
        }
    }

    if (dir.length() <= 250.0f && !m_pThePlayer->IsDead())
    {
        dir.normalize();

        const float speed = 2.8f;
        dir *= speed;

        btVector3 force(dir.x, dir.y, dir.z);

        m_pRigidBody->activate();
        m_pRigidBody->applyCentralForce(force);

        btVector3 vel = m_pRigidBody->getLinearVelocity();

        float fvelLength = vel.length();

        if (fvelLength > PLAYER_MAX_VELOCITY)
        {
            fvelLength = PLAYER_MAX_VELOCITY;

            vel.normalize();
            vel *= fvelLength;

            m_pRigidBody->setLinearVelocity(vel);
        }

        Vec3 dir_up(0.0f, 0.0f, -1.0f);
        Vec3 dir_vel(vel.getX(), 0.0f, vel.getZ());

        dir_vel.normalize();

        float dot = dir_vel.dot(dir_up);
        float lookAtAngle = acosf(dot);

        if (dir_vel.x < 0.0f)
        {
            lookAtAngle *= -1.0f;
        }

        MatrixRotationY(m_UpperLayer.GetTransform(), lookAtAngle);
    }

    MatrixRotationY(m_MainRenderObject.GetTransform(), timer->GetActualTime() * -3.0f);
    m_MainRenderObject.SetPosition(m_vPosition);

    m_UpperLayer.SetPosition(m_vPosition);
    m_UpperLayer.SetColor(1.0f, 1.0f, 1.0f, m_fUpperLayerOpacity);
}

//////////////////////////
//////////////////////////

void SearchEnemy::getWorldTransform(btTransform &worldTransform) const
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

void SearchEnemy::setWorldTransform(const btTransform &worldTransform)
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

void SearchEnemy::ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers) { }

//////////////////////////
//////////////////////////

void SearchEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
    {
        Vec3 dir = m_pThePlayer->GetPosition() - m_vPosition;

        dir.normalize();

        const float speed = 2.0f;
        dir *= speed;

        btVector3 impulseVec(dir.x, dir.y, dir.z);

        if (!m_pThePlayer->GetRigidBody()->isActive())
        {
            m_pThePlayer->GetRigidBody()->activate();
        }

        m_pThePlayer->GetRigidBody()->applyCentralImpulse(impulseVec);
        m_pThePlayer->Deflate(PLAYER_BIG_ENEMY_HURT);
    }

    m_pTheScene->GetCamera3D()->AddNoise(0.8f, timer);

    Kill();
}

//////////////////////////
//////////////////////////

void SearchEnemy::ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData)
{
    theShot->Kill();

    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, theShot->GetPosition(), 0.3f, 0.8f, Vec3(0, 0, 0), 6, 0.0f);

    Kill();
}

//////////////////////////
//////////////////////////

void SearchEnemy::Kill(void)
{
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 16, 0.8f);
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);

    Disable();

    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD), m_vPosition);
}

//////////////////////////
//////////////////////////

void SearchEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 16, 0.8f);
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);

    Disable();

    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD), m_vPosition);
}

//////////////////////////
//////////////////////////

void SearchEnemy::Enable(void)
{
    Enemy::Enable();
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}

//////////////////////////
//////////////////////////

void SearchEnemy::Disable(void)
{
    Enemy::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}
