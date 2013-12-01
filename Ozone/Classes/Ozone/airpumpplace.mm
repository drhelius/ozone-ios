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
 * File:   airpumpplace.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 0:06
 */

#include "airpumpplace.h"
#include "meshmanager.h"
#include "texturemanager.h"

bool AirPumpPlace::m_bSoundActive = false;
int AirPumpPlace::m_iContactingWithPlayer = 0;

AirPumpPlace::AirPumpPlace(void) : Place()
{
    m_fRotationSpeed = AIR_PUMP_ROTATION_SPEED_IDLE;
    m_fRotation = 0.0f;
    m_iContactingWithPlayer = 0;
    m_bSoundActive = false;
}

//////////////////////////
//////////////////////////

void AirPumpPlace::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/items/10_item"),
            TextureManager::Instance().GetTexture("game/items/items", true), RENDER_OBJECT_TRANSPARENT);
    this->SetPositionY(this->GetPositionY() - 40.0f);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pPlaceShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);

    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_PLACES, c_iPlacesCollidesWith);
}

//////////////////////////
//////////////////////////

void AirPumpPlace::Update(Timer* timer)
{
    float deltaTime = timer->GetDeltaTime();
    if (m_iContactingWithPlayer > 0)
    {
        if (!m_bSoundActive)
        {
            m_bSoundActive = true;
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_AIR_PUMP));
        }

        m_fRotationSpeed += AIR_PUMP_ROTATION_SPEED_ACCEL * deltaTime;
        m_fRotationSpeed = MAT_Min(m_fRotationSpeed, AIR_PUMP_ROTATION_SPEED_MAX);

        m_pThePlayer->ContactWithAirPump();
        m_pThePlayer->Inflate(AIR_PUMP_INFLATE_RATIO * deltaTime);
    }
    else
    {
        if (m_bSoundActive)
        {
            m_bSoundActive = false;
            AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_AIR_PUMP));
        }

        m_fRotationSpeed -= AIR_PUMP_ROTATION_SPEED_DECCEL * deltaTime;
        m_fRotationSpeed = MAT_Max(m_fRotationSpeed, AIR_PUMP_ROTATION_SPEED_IDLE);
    }

    m_fRotation += m_fRotationSpeed * deltaTime;

    m_fRotation = MAT_NormalizarAngulo360(m_fRotation);

    MatrixRotationY(m_MainRenderObject.GetTransform(), MAT_ToRadians(m_fRotation));
    m_MainRenderObject.SetPosition(this->GetPosition());
}

//////////////////////////
//////////////////////////

void AirPumpPlace::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (!thePlayer->IsDead())
    {
        if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
        {
            m_iContactingWithPlayer++;
        }
    }
}

