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
 * File:   movingwallenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de agosto de 2009, 0:42
 */

#include "movingwallenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "scene.h"

btCollisionShape* MovingWallEnemy::m_pHorizontalShape = NULL;
btCompoundShape* MovingWallEnemy::m_pCompoundShape = NULL;

MovingWallEnemy::MovingWallEnemy(bool reverse) : Enemy()
{
    m_bReverse = reverse;

    if (m_pHorizontalShape == NULL)
    {
        btScalar mass = 10.0f;
        btVector3 inertia(0, 0, 0);
        m_pHorizontalShape = new btBoxShape(btVector3(0.85f, 0.4f, 0.1f));
        m_pHorizontalShape->setMargin(0.01f);
        m_pHorizontalShape->calculateLocalInertia(mass, inertia);
    }

    if (m_pCompoundShape == NULL)
    {
        btTransform transform;
        transform.setIdentity();
        transform.setOrigin(btVector3(0.75f, 0.0f, 0.0f));
        m_pCompoundShape = new btCompoundShape();
        m_pCompoundShape->addChildShape(transform, m_pHorizontalShape);
    }
}

//////////////////////////
//////////////////////////

MovingWallEnemy::~MovingWallEnemy()
{
    SafeDelete(m_pCompoundShape);
    SafeDelete(m_pHorizontalShape);
}

//////////////////////////
//////////////////////////

void MovingWallEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{

    if (rotation > 1)
        m_bReverse = true;

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/15_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_NORMAL);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_RenderObjectList.push_back(&m_MainRenderObject);

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

void MovingWallEnemy::Update(Timer* timer)
{
    float rot = fmod(timer->GetActualTime() * MAT_ToRadians(WALL_ENEMY_ROTATION_RATE), TWOPIf);

    MatrixRotationY(m_mtxRotation, m_bReverse ? -rot : rot);
    m_MainRenderObject.SetTransform(m_mtxRotation);
    m_MainRenderObject.SetPosition(m_vPosition);
}

//////////////////////////
//////////////////////////

void MovingWallEnemy::getWorldTransform(btTransform &worldTransform) const
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

void MovingWallEnemy::setWorldTransform(const btTransform &worldTransform)
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

void MovingWallEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer * timer)
{
    if (thePlayer->GetAmmo(STEEL_AMMO) > 0.0f)
    {
        m_pTheScene->GetCamera3D()->AddNoise(0.2f * impulse, timer);
    }
}

