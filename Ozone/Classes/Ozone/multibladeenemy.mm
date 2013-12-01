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
 * File:   multibladeenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de agosto de 2009, 0:40
 */

#include "multibladeenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

btCollisionShape* MultiBladeEnemy::m_pCrossHorizontalShape = NULL;
btCollisionShape* MultiBladeEnemy::m_pCrossVerticalShape = NULL;
btCompoundShape* MultiBladeEnemy::m_pCrossCompoundShape = NULL;

MultiBladeEnemy::MultiBladeEnemy(void) : Enemy()
{
    if (m_pCrossHorizontalShape == NULL)
    {
        btScalar mass = 10.0f;
        btVector3 inertia(0, 0, 0);
        m_pCrossHorizontalShape = new btBoxShape(btVector3(1.1f, 0.4f, 0.1f));
        m_pCrossHorizontalShape->setMargin(0.01f);
        m_pCrossHorizontalShape->calculateLocalInertia(mass, inertia);
    }

    if (m_pCrossVerticalShape == NULL)
    {
        btScalar mass = 10.0f;
        btVector3 inertia(0, 0, 0);
        m_pCrossVerticalShape = new btBoxShape(btVector3(0.1f, 0.4f, 1.1f));
        m_pCrossVerticalShape->setMargin(0.01f);
        m_pCrossVerticalShape->calculateLocalInertia(mass, inertia);
    }

    if (m_pCrossCompoundShape == NULL)
    {
        btTransform transform;
        transform.setIdentity();
        m_pCrossCompoundShape = new btCompoundShape();

        m_pCrossCompoundShape->addChildShape(transform, m_pCrossHorizontalShape);
        m_pCrossCompoundShape->addChildShape(transform, m_pCrossVerticalShape);
    }
}

//////////////////////////
//////////////////////////

MultiBladeEnemy::~MultiBladeEnemy()
{
    SafeDelete(m_pCrossCompoundShape);
    SafeDelete(m_pCrossHorizontalShape);
    SafeDelete(m_pCrossVerticalShape);
}

//////////////////////////
//////////////////////////

void MultiBladeEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_bReverse = false;

    if (rotation > 1)
        m_bReverse = true;

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/07_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_NORMAL);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pCrossCompoundShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setAngularFactor(btVector3(0.0f, 1.0f, 0.0f));
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));
    m_pRigidBody->setCollisionFlags(m_pRigidBody->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
    m_pRigidBody->setActivationState(DISABLE_DEACTIVATION);
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void MultiBladeEnemy::Update(Timer* timer)
{
    float rot = fmod(timer->GetActualTime() * MAT_ToRadians(MULTIBLADE_ENEMY_ROTATION_RATE), TWOPIf);

    MatrixRotationY(m_mtxRotation, m_bReverse ? -rot : rot);

    m_MainRenderObject.SetTransform(m_mtxRotation);
    m_MainRenderObject.SetPosition(m_vPosition);
}

//////////////////////////
//////////////////////////

void MultiBladeEnemy::getWorldTransform(btTransform &worldTransform) const
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

void MultiBladeEnemy::setWorldTransform(const btTransform &worldTransform)
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

void MultiBladeEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (thePlayer->GetAmmo(STEEL_AMMO) > 0.0f)
    {
        m_pTheScene->GetCamera3D()->AddNoise(0.1f * impulse, timer);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_METALIC_HIT), m_vPosition);
    }
    else
    {
        m_pTheScene->GetCamera3D()->AddNoise(0.8f, timer);

        ParticleManager::Instance().AddExplosion(PARTICLE_GAS, thePlayer->GetPosition(), 1.8f, 0.9f, Vec3(0, 0, 0), 16, 0.8f);
        ParticleManager::Instance().AddExplosion(PARTICLE_GAS, thePlayer->GetPosition(), 0.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);

        m_pThePlayer->Deflate(PLAYER_VERY_BIG_ENEMY_HURT);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_HURT), m_vPosition);
    }
}

