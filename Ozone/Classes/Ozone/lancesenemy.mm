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
 * File:   lancesenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de agosto de 2009, 0:40
 */

#include "lancesenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

LancesEnemy::LancesEnemy(void) : Enemy()
{
    m_fLastTimeSmokeAdded = 0.0f;

    m_State = LANCES_IDLE_OUT;

    m_fCurrentTime = 0.0f;
    m_fOffset = 0.0f;
}

//////////////////////////
//////////////////////////

void LancesEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    float finalRot = MAT_ToRadians(rotation * 90.0f);

    MATRIX mtxRotY;
    MatrixRotationY(mtxRotY, finalRot);

    Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
    MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, mtxRotY);
    m_vThrowingDir = Vec3(vThrowingDir4.ptr());

    Texture* pTexture = TextureManager::Instance().GetTexture("game/entities/entities", true);

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/11_ent"),
            pTexture, RENDER_OBJECT_NORMAL);

    m_HolesRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/11a_ent"),
            pTexture, RENDER_OBJECT_TRANSPARENT);

    MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), mtxRotY);

    m_vOriginalPosition = this->GetPosition();

    m_MainRenderObject.SetPosition(m_vOriginalPosition);

    m_HolesRenderObject.SetTransform(m_MainRenderObject.GetTransform());

    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_HolesRenderObject);


    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pEnemyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));
    m_pRigidBody->setCollisionFlags(m_pRigidBody->getCollisionFlags() | btCollisionObject::CF_KINEMATIC_OBJECT);
    m_pRigidBody->setActivationState(DISABLE_DEACTIVATION);
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void LancesEnemy::Update(Timer* timer)
{
    float deltaTime = timer->GetDeltaTime();
    m_fCurrentTime += deltaTime;

    switch (m_State)
    {
        case LANCES_IDLE_OUT:
        {
            if (m_fCurrentTime >= 1.0f)
            {
                m_State = LANCES_GOING_IN;
                m_fCurrentTime = 0.0f;
                m_fOffset = 0.0f;
            }
            break;
        }
        case LANCES_GOING_IN:
        {
            m_fOffset += 25.0f * deltaTime;

            if (m_fOffset >= 80.0f)
            {
                m_fOffset = 80.0f;
                m_State = LANCES_IDLE_IN;
                m_fCurrentTime = 0.0f;
            }

            m_vPosition = m_vOriginalPosition + (m_vThrowingDir * -m_fOffset);

            break;
        }
        case LANCES_IDLE_IN:
        {
            if (m_fCurrentTime >= 2.5f)
            {
                m_State = LANCES_GOING_OUT;
                m_fCurrentTime = 0.0f;

                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_LANCES), m_vPosition);
            }
            break;
        }
        case LANCES_GOING_OUT:
        {
            m_fOffset -= 400.0f * deltaTime;

            if (m_fOffset <= 0.0f)
            {
                m_fOffset = 0.0f;
                m_State = LANCES_IDLE_OUT;
                m_fCurrentTime = 0.0f;
            }

            m_vPosition = m_vOriginalPosition + (m_vThrowingDir * -m_fOffset);
            break;
        }
    }

    m_MainRenderObject.SetPosition(m_vPosition);
}

//////////////////////////
//////////////////////////

void LancesEnemy::getWorldTransform(btTransform &worldTransform) const
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

void LancesEnemy::setWorldTransform(const btTransform &worldTransform)
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

void LancesEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
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


