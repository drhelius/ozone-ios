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
 * File:   spikegroupenemy.cpp
 * Author: nacho
 * 
 * Created on 9 de abril de 2009, 0:05
 */

#include "spikegroupenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

//////////////////////////
//////////////////////////

SpikeGroupEnemy::SpikeGroupEnemy(void) : Enemy()
{
    m_fLastTimeSmokeAdded = 0.0f;
}

//////////////////////////
//////////////////////////

void SpikeGroupEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/09_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_TRANSPARENT);
    this->SetPositionY(this->GetPositionY() - 25.0f);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pEnemyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void SpikeGroupEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    float actualTime = timer->GetActualTime();

    if ((thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f) && ((actualTime - m_fLastTimeSmokeAdded) > 0.2f))
    {
        m_fLastTimeSmokeAdded = actualTime;
        ParticleManager::Instance().AddExplosion(PARTICLE_GAS, thePlayer->GetPosition(), 0.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);
        m_pThePlayer->Deflate(PLAYER_VERY_SMALL_ENEMY_HURT);
    }

    if (thePlayer->GetAmmo(STEEL_AMMO) > 0.0f)
    {
        if (impulse > 2.5f)
        {
            m_pTheScene->GetCamera3D()->AddNoise(0.8f, timer);

            Kill();
        }
    }
}

//////////////////////////
//////////////////////////

void SpikeGroupEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    Kill();
}

//////////////////////////
//////////////////////////

void SpikeGroupEnemy::Kill(void)
{
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.5f, 1.1f, Vec3(0, 0, 0), 10, 0.5f);

    Disable();

    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD), m_vPosition);
}

//////////////////////////
//////////////////////////

void SpikeGroupEnemy::Enable(void)
{
    Enemy::Enable();

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_RIGIDS, c_iRigidsCollidesWith);
}

//////////////////////////
//////////////////////////

void SpikeGroupEnemy::Disable(void)
{
    Enemy::Disable();

    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

//////////////////////////
//////////////////////////

void SpikeGroupEnemy::Reset(void)
{
    m_fLastTimeSmokeAdded = 0.0f;

    if (!m_bEnable)
    {
        Enable();
    }
}
