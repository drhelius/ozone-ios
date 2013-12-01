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
 * File:   exitplace.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:38
 */

#include "exitplace.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "scene.h"

ExitPlace::ExitPlace(void) : Place() { }

//////////////////////////
//////////////////////////

void ExitPlace::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_bLevelCompleted = false;
    m_fScaleCompleted = 1.0f;

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/items/02_item"),
            TextureManager::Instance().GetTexture("game/items/items", true), RENDER_OBJECT_ADDITIVE);

    this->SetPositionY(this->GetPositionY() - 30.0f);

    m_MainRenderObject.SetPosition(this->GetPosition());
    m_MainRenderObject.SetCullMode(RENDER_OBJECT_CULL_DISABLED);
    m_RenderObjectList.push_back(&m_MainRenderObject);

    m_OuterGlow.Init(MeshManager::Instance().GetMeshFromFile("game/items/02a_item"),
            TextureManager::Instance().GetTexture("game/items/items", true), RENDER_OBJECT_ADDITIVE);
    m_OuterGlow.SetPosition(this->GetPosition());
    m_OuterGlow.SetCullMode(RENDER_OBJECT_CULL_DISABLED);
    m_RenderObjectList.push_back(&m_OuterGlow);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pPlaceShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_PLACES, c_iPlacesCollidesWith);
}

//////////////////////////
//////////////////////////

void ExitPlace::Update(Timer* timer)
{
    if (m_bLevelCompleted)
    {
        MATRIX scale, trans;

        float dTime = timer->GetDeltaTime();

        if (m_fScaleCompleted < 37.0f)
            m_fScaleCompleted += 17.0f * dTime;

        MatrixScaling(scale, 1.0f, m_fScaleCompleted, 1.0f);
        MatrixRotationY(m_MainRenderObject.GetTransform(), timer->GetActualTime() / 1.3f);
        MatrixRotationY(m_OuterGlow.GetTransform(), -timer->GetActualTime() / 1.3f);
        MatrixTranslation(trans, m_vPosition.x, m_vPosition.y, m_vPosition.z);

        MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), scale);
        MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), trans);

        MatrixMultiply(m_OuterGlow.GetTransform(), m_OuterGlow.GetTransform(), scale);
        MatrixMultiply(m_OuterGlow.GetTransform(), m_OuterGlow.GetTransform(), trans);
    }
    else
    {
        MatrixRotationY(m_MainRenderObject.GetTransform(), timer->GetActualTime() / 1.3f);
        m_MainRenderObject.SetPosition(m_vPosition);

        MatrixRotationY(m_OuterGlow.GetTransform(), -timer->GetActualTime() / 1.3f);
        m_OuterGlow.SetPosition(m_vPosition);
    }
}

//////////////////////////
//////////////////////////

void ExitPlace::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (!thePlayer->IsDead() && !m_bLevelCompleted)
    {
        int gems = thePlayer->GetGemCounter();
        int totalGems = m_pTheScene->GetGemCount();

        if ((totalGems - gems) <= 0)
        {
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_LEVEL_END));
            m_bLevelCompleted = true;
            m_pTheScene->SetLevelCompleted(true);
            thePlayer->SetLevelCompleted(true);
            thePlayer->SetAir(0.0f);            
        }
    }
}
