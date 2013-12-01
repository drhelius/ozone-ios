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
 * File:   greengem.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:37
 */

#include "greengem.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "interpolatormanager.h"
#include "particlemanager.h"

GreenGem::GreenGem(void) : Gem()
{
    m_fFadeOut = 0.0f;
    m_fStartRotation = MAT_ToRadians(MAT_RandomInt(0, 360));

    InitPointer(m_pFadeInterpolator);
}

//////////////////////////
//////////////////////////

GreenGem::~GreenGem()
{
    SafeDelete(m_pFadeInterpolator);
}

//////////////////////////
//////////////////////////

void GreenGem::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/items/05_item"),
            TextureManager::Instance().GetTexture("game/items/items", true), RENDER_OBJECT_TRANSPARENT);
    m_MainRenderObject.SetPosition(this->GetPosition());
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

void GreenGem::Update(Timer* timer)
{
    if (m_bEnable)
    {
        MatrixRotationZ(m_MainRenderObject.GetTransform(), fmod((timer->GetActualTime() * 2.3f) + m_fStartRotation, TWOPIf));
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

void GreenGem::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (m_fFadeOut == 0.0f)
    {
        if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
        {
            thePlayer->SetAir(PLAYER_MAX_AIR);
        }

        m_pFadeInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pFadeInterpolator, false, timer);

        ParticleManager::Instance().AddExplosion(PARTICLE_GAS, thePlayer->GetPosition(), 0.9f, 1.1f, Vec3(0, 0, 0), 10, 0.2f);
        ParticleManager::Instance().AddExplosion(PARTICLE_ITEM, m_vPosition, 0.8f, 1.0f, Vec3(0, 0, 0), 8, 0.2f, 1.0f, 0.47f, 1.0f);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_COLLECT_ITEM), m_vPosition);
    }
}

//////////////////////////
//////////////////////////

void GreenGem::Enable(void)
{
    Gem::Enable();

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ITEMS, c_iItemsCollidesWith);
}

//////////////////////////
//////////////////////////

void GreenGem::Disable(void)
{
    Gem::Disable();

    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}


//////////////////////////
//////////////////////////

void GreenGem::Reset(void)
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

