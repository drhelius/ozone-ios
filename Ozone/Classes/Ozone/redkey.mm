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
 * File:   redkey.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 0:51
 */

#include "redkey.h"
#include "meshmanager.h"
#include "texturemanager.h"

RedKey::RedKey(void) : Key()
{
    m_fFadeOut = 0.0f;
    InitPointer(m_pFadeInterpolator);
}

//////////////////////////
//////////////////////////

RedKey::~RedKey()
{
    SafeDelete(m_pFadeInterpolator);
}

//////////////////////////
//////////////////////////

void RedKey::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_fFadeOut = 0.0f;
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/items/08_item"),
            TextureManager::Instance().GetTexture("game/items/items", true), RENDER_OBJECT_ADDITIVE);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_MainRenderObject.UseColor(true);
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pKeyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);

    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ITEMS, c_iItemsCollidesWith);

    m_pFadeInterpolator = new LinearInterpolator(&m_fFadeOut, 0.0f, 1.0f, 0.13f);
}

//////////////////////////
//////////////////////////

void RedKey::Update(Timer* timer)
{
    if (m_bEnable)
    {
        MatrixRotationZ(m_MainRenderObject.GetTransform(), timer->GetActualTime() / 1.2f);
        m_MainRenderObject.SetPosition(this->GetPosition());

        if (m_fFadeOut < 1.0f)
        {
            m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f - m_fFadeOut);
        }
        else
        {
            Disable();
        }
    }
}

//////////////////////////
//////////////////////////

void RedKey::Reset(void)
{
    if (!m_bEnable)
    {
        Enable();
    }

    m_fFadeOut = 0.0f;

    m_pRigidBody->forceActivationState(ACTIVE_TAG);
    m_pRigidBody->activate();
    m_pRigidBody->setDeactivationTime(0);

    m_pRigidBody->setLinearVelocity(btVector3(0, 0, 0));
    m_pRigidBody->setAngularVelocity(btVector3(0, 0, 0));

    if (!m_pFadeInterpolator->IsFinished())
    {
        InterpolatorManager::Instance().Delete(m_pFadeInterpolator);
    }
}

//////////////////////////
//////////////////////////

void RedKey::Enable(void)
{
    Key::Enable();

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ITEMS, c_iItemsCollidesWith);
}

//////////////////////////
//////////////////////////

void RedKey::Disable(void)
{
    Key::Disable();

    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

//////////////////////////
//////////////////////////

void RedKey::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (m_fFadeOut == 0.0f)
    {
        m_pFadeInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pFadeInterpolator, false, timer);

        thePlayer->AddDoorKey(RED_DOOR_KEY);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_COLLECT_KEY), m_vPosition);
    }
}

