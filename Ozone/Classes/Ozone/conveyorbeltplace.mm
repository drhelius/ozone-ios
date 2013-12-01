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
 * File:   conveyorbeltplace.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 0:14
 */

#include "conveyorbeltplace.h"
#include "meshmanager.h"
#include "texturemanager.h"

bool ConveyorBeltPlace::m_bSoundActive = false;
int ConveyorBeltPlace::m_iContactingWithPlayer = 0;

//////////////////////////
//////////////////////////

ConveyorBeltPlace::ConveyorBeltPlace(void) : Place()
{
    m_iContactingWithPlayer = 0;
    m_bSoundActive = false;
}

//////////////////////////
//////////////////////////

void ConveyorBeltPlace::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    float finalRot = MAT_ToRadians(rotation * 90.0f);

    m_vecForceDir = btVector3(CONVEYOR_BELT_FORCE, 0.0f, 0.0f);

    m_vecForceDir = m_vecForceDir.rotate(btVector3(0.0f, 1.0f, 0.0f), -finalRot);

    MATRIX mtxRotY;
    MatrixRotationY(mtxRotY, finalRot);

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/items/07_item"),
            TextureManager::Instance().GetTexture("game/items/07_item", true), RENDER_OBJECT_ADDITIVE);

    m_MainRenderObject.UseTextureMatrix(true);

    MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), mtxRotY);

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

void ConveyorBeltPlace::Update(Timer* timer)
{
    float time = timer->GetActualTime();
    float offset = time - ((int) time);
    MatrixTranslation(m_MainRenderObject.GetTextureTransform(), (offset * -2.0f), 0.0f, 0.0f);

    if (m_iContactingWithPlayer > 0)
    {
        if (!m_bSoundActive)
        {
            m_bSoundActive = true;
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_CONVEYOR_BELT), m_vPosition);
        }
    }
    else
    {
        if (m_bSoundActive)
        {
            m_bSoundActive = false;
            AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_CONVEYOR_BELT));
        }
    }
}

//////////////////////////
//////////////////////////

void ConveyorBeltPlace::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (!thePlayer->IsDead())
    {
        if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
        {
            thePlayer->GetRigidBody()->applyCentralForce(m_vecForceDir);
            m_iContactingWithPlayer++;
        }
    }
}


