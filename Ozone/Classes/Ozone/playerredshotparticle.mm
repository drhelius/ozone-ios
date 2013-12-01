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
 * File:   playerredshotparticle.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:54
 */

#include "playerredshotparticle.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

PlayerRedShotParticle::PlayerRedShotParticle(void) : Particle()
{
}

//////////////////////////
//////////////////////////

void PlayerRedShotParticle::Init(void)
{
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/ball/disparo"),
            TextureManager::Instance().GetTexture("game/ball/disparo", true), RENDER_OBJECT_ADDITIVE);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_MainRenderObject.UseColor(true);
    m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(1.0f, this, m_pParticleShape, m_vParticleShapeInertia);
    rigidBodyCI.m_restitution = 0.8f;
    rigidBodyCI.m_linearSleepingThreshold = 0.05f;
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setLinearFactor(btVector3(1.0f, 0.0f, 1.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));
}

//////////////////////////
//////////////////////////

void PlayerRedShotParticle::Update(Timer* timer)
{
    if (!m_bDead)
    {
        m_fTimeToLive -= timer->GetDeltaTime();

        m_fTimeToLive = MAT_Max(0.0f, m_fTimeToLive);

        if (m_fTimeToLive <= 0.5f)
        {
            m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, m_fTimeToLive * 2.0f);
        }

        if (m_fTimeToLive <= 0.0f)
        {
            m_bDead = true;
        }
        else
        {
            if (!m_pRigidBody->isActive())
            {
                m_pRigidBody->activate();
            }

            m_MainRenderObject.SetTransform(m_mtxRotation);
            m_MainRenderObject.SetPosition(m_vPosition);
        }
    }
}

//////////////////////////
//////////////////////////

void PlayerRedShotParticle::getWorldTransform(btTransform &worldTransform) const
{
    Vec3 pos = m_vPosition;

    btVector3 newPos(pos.x * PHYSICS_SCALE_FACTOR, pos.y * PHYSICS_SCALE_FACTOR,
            pos.z * PHYSICS_SCALE_FACTOR);

    btMatrix3x3 rot;
    MAT_MATRIX_to_btMatrix3x3(m_mtxRotation, rot);

    worldTransform.setIdentity();
    worldTransform.setOrigin(newPos);
    //worldTransform.setBasis(rot);
}

//////////////////////////
//////////////////////////

void PlayerRedShotParticle::setWorldTransform(const btTransform &worldTransform)
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

void PlayerRedShotParticle::ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers)
{    
    theNPC->ContactWithPlayerShot(this, impulse, timer, additionalDataOthers);
}

//////////////////////////
//////////////////////////

void PlayerRedShotParticle::Enable(void)
{
    Particle::Enable();
    m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);
    m_pRigidBody->setMotionState(this);
    m_pRigidBody->clearForces();
    m_pRigidBody->setLinearVelocity(btVector3(0.0f, 0.0f, 0.0f));
    m_pRigidBody->setAngularVelocity(btVector3(0.0f, 0.0f, 0.0f));
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_GOOD_SHOTS, c_iGoodShotsCollidesWith);
}

//////////////////////////
//////////////////////////

void PlayerRedShotParticle::Disable(void)
{
    Particle::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}



