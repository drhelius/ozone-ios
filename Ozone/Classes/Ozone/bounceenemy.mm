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
 * File:   bounceenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:31
 */

#include "bounceenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

BounceEnemy::BounceEnemy(void) : Enemy()
{
    m_vDirection = Vec3(0, 0, 0);
    m_fSpeed = 2.0f;
    m_fTimeSinceLastBounce = 0.0f;
}

//////////////////////////
//////////////////////////

void BounceEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/01_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_TRANSPARENT);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(1.0f, this, m_pEnemyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);

    if (rotation == 0)
    {
        m_vDirection.x = 1.0f;
        m_pRigidBody->setLinearFactor(btVector3(1.0f, 0.0f, 0.0f));
    }
    else if (rotation == 1)
    {
        m_vDirection.z = 1.0f;
        m_pRigidBody->setLinearFactor(btVector3(0.0f, 0.0f, 1.0f));
    }
    else if (rotation == 2)
    {
        m_vDirection.x = -1.0f;
        m_pRigidBody->setLinearFactor(btVector3(1.0f, 0.0f, 0.0f));
    }
    else if (rotation == 3)
    {
        m_vDirection.z = -1.0f;
        m_pRigidBody->setLinearFactor(btVector3(0.0f, 0.0f, 1.0f));
    }

    m_vIniPos = m_vPosition;
    m_vIniDir = m_vDirection;
}

//////////////////////////
//////////////////////////

void BounceEnemy::Update(Timer* timer)
{
    m_fTimeSinceLastBounce += timer->GetDeltaTime();

    if (!m_pRigidBody->isActive())
    {
        m_pRigidBody->activate();
    }

    btVector3 vel(m_vDirection.x * m_fSpeed, 0.0f, m_vDirection.z * m_fSpeed);
    m_pRigidBody->setLinearVelocity(vel);

    MatrixRotationY(m_MainRenderObject.GetTransform(), timer->GetActualTime() * -3.0f);
    m_MainRenderObject.SetPosition(m_vPosition);
}

//////////////////////////
//////////////////////////

void BounceEnemy::Reset(void)
{
    m_fTimeSinceLastBounce = 0.0f;
    m_fAffectedByElectricityTime = 0.0f;

    m_vDirection = m_vIniDir;

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

void BounceEnemy::getWorldTransform(btTransform &worldTransform) const
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

void BounceEnemy::setWorldTransform(const btTransform &worldTransform)
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

void BounceEnemy::ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers)
{
    if (theNPC->IsRigid() && (m_fTimeSinceLastBounce > 0.2f))
    {
        m_vDirection *= -1.0f;
        m_fTimeSinceLastBounce = 0.0f;
    }
}

//////////////////////////
//////////////////////////

void BounceEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
    {
        Vec3 dir = m_pThePlayer->GetPosition() - m_vPosition;

        dir.normalize();

        const float speed = 3.0f;
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

void BounceEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    Kill();
}

//////////////////////////
//////////////////////////

void BounceEnemy::ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData)
{
    theShot->Kill();

    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, theShot->GetPosition(), 0.3f, 0.8f, Vec3(0, 0, 0), 6, 0.0f);

    Kill();
}

//////////////////////////
//////////////////////////

void BounceEnemy::Kill(void)
{
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 16, 0.8f);
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);

    Disable();

    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD), m_vPosition);
}

//////////////////////////
//////////////////////////

void BounceEnemy::Enable(void)
{
    Enemy::Enable();
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}

//////////////////////////
//////////////////////////

void BounceEnemy::Disable(void)
{
    Enemy::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

