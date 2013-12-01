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
 * File:   bluegem.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:37
 */

#include "bluegem.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"

bool BlueGem::m_bAlternateSound = false;

BlueGem::BlueGem(void) : Gem()
{
    m_fFadeOut = 0.0f;
    m_fRotationOffset = 0.0f;
    m_bAlternateSound = false;

    InitPointer(m_pFadeInterpolator);
}

//////////////////////////
//////////////////////////

BlueGem::~BlueGem()
{
    CollisionInfo* pInfo = (CollisionInfo*) m_pRigidBody->getUserPointer();

    SafeDelete(pInfo);

    m_pRigidBody->setUserPointer(NULL);

    SafeDelete(m_pFadeInterpolator);
}

//////////////////////////
//////////////////////////

void BlueGem::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_fRotationOffset = MAT_RandomInt(0, 200) / 100.0f;
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/items/03_item"),
            TextureManager::Instance().GetTexture("game/items/items", true), RENDER_OBJECT_ADDITIVE);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_MainRenderObject.SetCullMode(RENDER_OBJECT_CULL_DISABLED);
    m_MainRenderObject.UseColor(true);
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo gemRigidBodyCI(0, this, m_pGemShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(gemRigidBodyCI);

    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ITEMS, c_iItemsCollidesWith);

    m_pFadeInterpolator = new LinearInterpolator(&m_fFadeOut, 0.0f, 1.0f, 0.3f);
}

//////////////////////////
//////////////////////////

void BlueGem::Enable(void)
{
    Gem::Enable();

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ITEMS, c_iItemsCollidesWith);
}

//////////////////////////
//////////////////////////

void BlueGem::Disable(void)
{
    Gem::Disable();

    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

//////////////////////////
//////////////////////////

void BlueGem::Reset(void)
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

void BlueGem::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (m_fFadeOut == 0.0f)
    {
        thePlayer->AddGem();

        m_bAlternateSound = !m_bAlternateSound;

        if (m_bAlternateSound)
        {
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_YELLOW_GEM_1), m_vPosition);
        }
        else
        {
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_YELLOW_GEM_2), m_vPosition);
        }

        m_pFadeInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pFadeInterpolator, false, timer);
        ParticleManager::Instance().AddExplosion(PARTICLE_ITEM, m_vPosition, 0.8f, 1.0f, Vec3(0, 0, 0), 8, 0.2f, 0.95f, 0.82f, 0.38f);
    }
}

//////////////////////////
//////////////////////////

void BlueGem::Update(Timer* timer)
{
    if (m_bEnable)
    {
        float rot = (timer->GetActualTime() / 4.0f) + m_fRotationOffset;
        MATRIX matRotY, matRotZ;
        MatrixRotationY(matRotY, rot);
        MatrixRotationZ(matRotZ, rot);
        MatrixMultiply(m_MainRenderObject.GetTransform(), matRotZ, matRotY);
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



