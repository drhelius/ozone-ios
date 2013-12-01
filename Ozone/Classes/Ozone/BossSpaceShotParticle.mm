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
 * File:   BossSpaceShotParticle.mm
 * Author: nacho
 * 
 * Created on 22 de marzo de 2010, 16:24
 */

#include "BossSpaceShotParticle.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

BossSpaceShotParticle::BossSpaceShotParticle(void) : Particle() { }

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::Init(void)
{
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/boss_space_mine"),
            TextureManager::Instance().GetTexture("game/entities/boss_space", true), RENDER_OBJECT_ADDITIVE);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_MainRenderObject.UseColor(true);
    m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(1.0f, this, m_pParticleShape, btVector3(0, 0, 0));
    rigidBodyCI.m_linearSleepingThreshold = 0.1f;
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));
}

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::Update(Timer* timer)
{
    if (!m_bDead)
    {
        if (!m_pRigidBody->isActive())
        {
            m_pRigidBody->activate();
        }

        Vec3 dir = m_vPosition -Vec3(870.0f, 0.0f, 730.0f);

        if (dir.length() > 170.0f)
        {
            Vec3 len = dir.normalized() * 170.0f;
            Vec3 newPos = Vec3(870.0f, 0.0f, 730.0f) + len;

            Vec3 translatePos = newPos - m_vPosition;
            m_vPosition = newPos;

            btVector3 btTranslatePos(translatePos.x * PHYSICS_SCALE_FACTOR, 0.0f, translatePos.z * PHYSICS_SCALE_FACTOR);

            m_pRigidBody->translate(btTranslatePos);

            dir = m_vPosition - Vec3(870.0f, 0.0f, 730.0f);
        }

        dir.normalize();

        const float speed = 1.2f;
        dir *= speed;

        btVector3 force(dir.z, 0.0f, -dir.x);


        m_pRigidBody->setLinearVelocity(force);



        MatrixRotationY(m_MainRenderObject.GetTransform(), m_fRotationY);
        m_MainRenderObject.SetPosition(m_vPosition);
    }
}

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::getWorldTransform(btTransform &worldTransform) const
{
    Vec3 pos = m_vPosition;

    btVector3 newPos(pos.x * PHYSICS_SCALE_FACTOR, pos.y * PHYSICS_SCALE_FACTOR,
            pos.z * PHYSICS_SCALE_FACTOR);

    worldTransform.setIdentity();
    worldTransform.setOrigin(newPos);
}

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::setWorldTransform(const btTransform &worldTransform)
{
    btVector3 pos = worldTransform.getOrigin();

    Vec3 newPos(pos.getX() * PHYSICS_INV_SCALE_FACTOR, pos.getY() * PHYSICS_INV_SCALE_FACTOR,
            pos.getZ() * PHYSICS_INV_SCALE_FACTOR);

    m_vPosition = newPos;
}

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers)
{
    m_bDead = true;
}

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.3f, 0.8f, Vec3(0, 0, 0), 6, 0.0f);

    m_bDead = true;
}

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    m_bDead = true;

    if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
    {
        Vec3 dir = m_pThePlayer->GetPosition() - m_vPosition;

        dir.normalize();

        const float speed = 1.0f;
        dir *= speed;

        btVector3 impulseVec(dir.x, dir.y, dir.z);

        if (!m_pThePlayer->GetRigidBody()->isActive())
        {
            m_pThePlayer->GetRigidBody()->activate();
        }

        m_pThePlayer->GetRigidBody()->applyCentralImpulse(impulseVec);
        m_pTheScene->GetCamera3D()->AddNoise(0.3f, timer);

        m_pThePlayer->Deflate(PLAYER_VERY_SMALL_ENEMY_HURT);
    }

    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_HURT), m_vPosition);

    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.3f, 0.8f, Vec3(0, 0, 0), 6, 0.0f);
}

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::Enable(void)
{
    Particle::Enable();
    if (m_bUseColor)
    {
        m_MainRenderObject.SetColor(m_Color.r, m_Color.g, m_Color.b, 1.0f);
    }
    else
    {
        m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);
    }
    m_pRigidBody->setMotionState(this);
    m_pRigidBody->clearForces();
    m_pRigidBody->setLinearVelocity(btVector3(0.0f, 0.0f, 0.0f));
    m_pRigidBody->setAngularVelocity(btVector3(0.0f, 0.0f, 0.0f));
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_BAD_SHOTS, c_iBadShotsCollidesWith);
}

//////////////////////////
//////////////////////////

void BossSpaceShotParticle::Disable(void)
{
    Particle::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}
