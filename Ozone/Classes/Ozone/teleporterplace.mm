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
 * File:   teleporterplace.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 0:14
 */

#include "teleporterplace.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"

float TeleporterPlace::m_fTimeFromLastTeleport = -1000.0f;

//////////////////////////
//////////////////////////

TeleporterPlace::TeleporterPlace(void) : Place()
{
    m_fTimeFromLastTeleport = -1000.0f;
    
    m_AccumulatedTime = 0.0f;
    m_pPartner = NULL;
    m_iID = -1;

    InitPointer(m_pTeleporterShape);

    btScalar mass = 0.0f;
    btVector3 inertia(0, 0, 0);
    m_pTeleporterShape = new btBoxShape(btVector3(0.11f, 0.44f, 0.11f));
    m_pTeleporterShape->calculateLocalInertia(mass, inertia);
}

//////////////////////////
//////////////////////////

TeleporterPlace::~TeleporterPlace(void)
{
    SafeDelete(m_pTeleporterShape);
}

//////////////////////////
//////////////////////////

void TeleporterPlace::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_iID = rotation;

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/teletransports/teleport"),
            TextureManager::Instance().GetTexture("game/teletransports/teleport", true), RENDER_OBJECT_TRANSPARENT);
    MatrixScaling(m_MainRenderObject.GetTransform(), 1.5f, 1.5f, 1.5f);
    m_MainRenderObject.SetPosition(this->GetPosition());

    m_UpperLayer.Init(MeshManager::Instance().GetMeshFromFile("game/teletransports/teleport"),
            TextureManager::Instance().GetTexture("game/teletransports/teleport", true), RENDER_OBJECT_ADDITIVE);

    MatrixScaling(m_UpperLayer.GetTransform(), 1.0f, 1.0f, 1.0f);
    m_UpperLayer.SetPosition(this->GetPositionX(), this->GetPositionY() + 5.0f, this->GetPositionZ());

    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_UpperLayer);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pTeleporterShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_PLACES, c_iPlacesCollidesWith);
}

//////////////////////////
//////////////////////////

void TeleporterPlace::Update(Timer* timer)
{
    m_AccumulatedTime += timer->GetDeltaTime();

    MATRIX matRot;

    MatrixScaling(m_MainRenderObject.GetTransform(), 1.5f, 1.5f, 1.5f);
    MatrixRotationY(matRot, m_AccumulatedTime / 1.7f);
    MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), matRot);
    m_MainRenderObject.SetPosition(this->GetPosition());

    MatrixScaling(m_UpperLayer.GetTransform(), 1.0f, 1.0f, 1.0f);
    MatrixRotationY(matRot, m_AccumulatedTime * 1.6f);
    MatrixMultiply(m_UpperLayer.GetTransform(), m_UpperLayer.GetTransform(), matRot);
    m_UpperLayer.SetPosition(this->GetPositionX(), this->GetPositionY() + 5.0f, this->GetPositionZ());
}

//////////////////////////
//////////////////////////

void TeleporterPlace::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (!thePlayer->IsDead())
    {

        float currentTime = timer->GetActualTime();

        if ((currentTime - m_fTimeFromLastTeleport) > 3.0f)
        {
            m_fTimeFromLastTeleport = currentTime;

            Vec3 translatePos = m_pPartner->GetPosition() - thePlayer->GetPosition();

            btVector3 btTranslatePos(translatePos.x * PHYSICS_SCALE_FACTOR, 0.0f, translatePos.z * PHYSICS_SCALE_FACTOR);

            thePlayer->GetRigidBody()->translate(btTranslatePos);

            ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_pPartner->GetPosition(), 0.9f, 1.1f, Vec3(0, 0, 0), 10, 0.2f);

            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_TELEPORT), m_pPartner->GetPosition());
        }
    }
}


