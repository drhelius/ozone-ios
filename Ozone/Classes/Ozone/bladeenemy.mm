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
 * File:   bladeenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de agosto de 2009, 0:40
 */

#include "bladeenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

btCollisionShape* BladeEnemy::m_pBladeShape = NULL;

BladeEnemy::BladeEnemy(bool reverse) : Enemy()
{
    m_bReverse = reverse;

    m_fLastTimeSmokeAdded = 0.0f;
    m_fCurrentTime = 0.0f;
    m_fOffsetFront = 0.0f;
    m_fOffsetLateral = 0.0f;

    m_fRunLength = 3 * 80.0f;

    m_State = BLADE_IDLE_OUT_1;

    if (m_pBladeShape == NULL)
    {
        btScalar mass = 1.0f;
        btVector3 inertia(0, 0, 0);
        m_pBladeShape = new btBoxShape(btVector3(0.3f, 0.4f, 0.1f));
        m_pBladeShape->calculateLocalInertia(mass, inertia);
    }
}

//////////////////////////
//////////////////////////

BladeEnemy::~BladeEnemy()
{
    SafeDelete(m_pBladeShape);
}

//////////////////////////
//////////////////////////

void BladeEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    float finalRot = MAT_ToRadians(rotation * 90.0f);

    MATRIX mtxRotY;
    MatrixRotationY(mtxRotY, finalRot);

    m_mtxRotation = mtxRotY;

    Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
    MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, mtxRotY);
    Vec4 vMovingDir4 = Vec4(0.0f, 0.0f, -1.0f, 0.0f);
    MatrixVec4Multiply(vMovingDir4, vMovingDir4, mtxRotY);

    m_vThrowingDir = Vec3(vThrowingDir4.ptr());
    m_vMovingDir = Vec3(vMovingDir4.ptr());

    Texture* pTexture = TextureManager::Instance().GetTexture("game/entities/entities", true);

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/12_ent"),
            pTexture, RENDER_OBJECT_NORMAL);

    m_SlideRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/12a_ent"),
            pTexture, RENDER_OBJECT_NORMAL);

    m_MainRenderObject.SetTransform(mtxRotY);

    if (rotation % 2 != 0)
    {
        m_vPosition += Vec3(80.0f, 0.0f, -80.0f);
    }

    m_vOriginalPosition = m_vPosition;

    m_MainRenderObject.SetPosition(m_vOriginalPosition);

    float scale = ((m_fRunLength / 80.0f) /*+ 0.3f*/);
    MatrixScaling(m_SlideRenderObject.GetTransform(), 1.0f, 1.0f, scale);
    MatrixMultiply(m_SlideRenderObject.GetTransform(), m_SlideRenderObject.GetTransform(), m_MainRenderObject.GetTransform());

    if (m_bReverse)
    {
        m_vPosition += (m_vMovingDir * 15.0f);
        m_vOriginalPosition = m_vPosition;
        m_MainRenderObject.SetPosition(m_vOriginalPosition);
    }
    else
    {
        m_vPosition += (m_vMovingDir * 225.0f);
        m_vOriginalPosition = m_vPosition;
        m_MainRenderObject.SetPosition(m_vOriginalPosition);
    }

    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_SlideRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pBladeShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));
    m_pRigidBody->setCollisionFlags(m_pRigidBody->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
    m_pRigidBody->setActivationState(DISABLE_DEACTIVATION);
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void BladeEnemy::Update(Timer* timer)
{
    float deltaTime = timer->GetDeltaTime();
    m_fCurrentTime += deltaTime;

    switch (m_State)
    {
        case BLADE_IDLE_OUT_1:
        {
            if (m_fCurrentTime >= 0.8f)
            {
                m_State = BLADE_GOING_FRONT;
                m_fCurrentTime = 0.0f;
                m_fOffsetLateral = 0.0f;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_BLADES), m_vOriginalPosition);
            }
            break;
        }
        case BLADE_GOING_FRONT:
        {
            if (m_bReverse)
            {
                m_fOffsetLateral += 400.0f * deltaTime;

                if (m_fOffsetLateral >= 210.0f)
                {
                    m_fOffsetLateral = 210.0f;
                    m_State = BLADE_IDLE_OUT_2;
                    m_fCurrentTime = 0.0f;
                }
            }
            else
            {
                m_fOffsetLateral -= 400.0f * deltaTime;

                if (m_fOffsetLateral <= -210.0f)
                {
                    m_fOffsetLateral = -210.0f;
                    m_State = BLADE_IDLE_OUT_2;
                    m_fCurrentTime = 0.0f;
                }
            }

            m_vPosition = m_vOriginalPosition + (m_vMovingDir * m_fOffsetLateral);
            break;
        }
        case BLADE_IDLE_OUT_2:
        {
            if (m_fCurrentTime >= 0.8f)
            {
                m_State = BLADE_GOING_IN;
                m_fCurrentTime = 0.0f;
            }
            break;
        }
        case BLADE_GOING_IN:
        {
            m_fOffsetFront += 60.0f * deltaTime;

            if (m_fOffsetFront >= 80.0f)
            {
                m_fOffsetFront = 80.0f;
                m_State = BLADE_IDLE_IN;
                m_fCurrentTime = 0.0f;
            }

            m_vPosition = m_vOriginalPosition + (m_vThrowingDir * -m_fOffsetFront) + (m_vMovingDir * m_fOffsetLateral);
            break;
        }
        case BLADE_IDLE_IN:
        {
            if (m_fCurrentTime >= 2.0f)
            {
                m_State = BLADE_GOING_OUT;
                m_fCurrentTime = 0.0f;
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_LANCES), m_vPosition);
            }
            break;
        }
        case BLADE_GOING_OUT:
        {
            m_fOffsetFront -= 400.0f * deltaTime;

            if (m_fOffsetFront <= 0.0f)
            {
                m_fOffsetFront = 0.0f;
                m_State = BLADE_IDLE_OUT_1;
                m_fCurrentTime = 0.0f;
                m_fOffsetLateral = 0.0f;
            }

            m_vPosition = m_vOriginalPosition + (m_vThrowingDir * -m_fOffsetFront);
            break;
        }
    }

    Vec3 finalPos = m_vPosition - (m_vMovingDir * (m_fRunLength * 0.5f));

    m_MainRenderObject.SetPosition(finalPos);
}

//////////////////////////
//////////////////////////

void BladeEnemy::getWorldTransform(btTransform & worldTransform) const
{
    Vec3 pos = m_vPosition - (m_vMovingDir * (m_fRunLength * 0.5f));

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

void BladeEnemy::setWorldTransform(const btTransform & worldTransform)
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

void BladeEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer * timer)
{
    float actualTime = timer->GetActualTime();

    if ((thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f) && ((actualTime - m_fLastTimeSmokeAdded) > 0.2f))
    {
        m_fLastTimeSmokeAdded = actualTime;

        m_pTheScene->GetCamera3D()->AddNoise(0.6f, timer);

        ParticleManager::Instance().AddExplosion(PARTICLE_GAS, thePlayer->GetPosition(), 0.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);

        m_pThePlayer->Deflate(PLAYER_SMALL_ENEMY_HURT);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_PLAYER_HURT), m_vPosition);
    }

    if (thePlayer->GetAmmo(STEEL_AMMO) > 0.0f)
    {
        m_pTheScene->GetCamera3D()->AddNoise(0.1f * impulse, timer);
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_METALIC_HIT), m_vPosition);
    }
}


