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
 * File:   inlinethrowingenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:56
 */

#include "inlinethrowingenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

//////////////////////////
//////////////////////////

InlineThrowingEnemy::InlineThrowingEnemy(void) : Enemy()
{
    m_fLastTimeThrown = 0.0f;
    m_fFlashOpacity = 0.0f;
    m_fFinalRotation = 0.0f;

    InitPointer(m_pFlashInterpolator);
}

//////////////////////////
//////////////////////////

InlineThrowingEnemy::~InlineThrowingEnemy()
{
    SafeDelete(m_pFlashInterpolator);
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{

    m_pFlashInterpolator = new LinearInterpolator(&m_fFlashOpacity, 1.0f, 0.0f, 0.15f);

    m_fFinalRotation = MAT_ToRadians(rotation * 90.0f);

    MATRIX mtxRotY;
    MatrixRotationY(mtxRotY, m_fFinalRotation);

    Vec4 vStartThrowingPosition4 = Vec4(-27.0f, 0.0f, 0.0f, 0.0f);
    Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
    MatrixVec4Multiply(vStartThrowingPosition4, vStartThrowingPosition4, mtxRotY);
    MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, mtxRotY);

    m_vStartThrowingPosition = Vec3(vStartThrowingPosition4.ptr());
    m_vStartThrowingPosition += this->GetPosition();
    m_vThrowingDir = Vec3(vThrowingDir4.ptr());

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/02_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_NORMAL);
    MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), mtxRotY);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_RenderObjectList.push_back(&m_MainRenderObject);


    m_FlashRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/02a_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_ADDITIVE);
    MatrixMultiply(m_FlashRenderObject.GetTransform(), m_FlashRenderObject.GetTransform(), mtxRotY);
    m_FlashRenderObject.SetPosition(this->GetPosition());
    m_FlashRenderObject.UseColor(true);
    m_RenderObjectList.push_back(&m_FlashRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pEnemyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::Update(Timer* timer)
{
    float actualTime = timer->GetActualTime();
    float timeOffset = actualTime - m_fLastTimeThrown;

    Vec3 dirToPlayer = m_pThePlayer->GetPosition() - m_vPosition;
    float lengthToPlayerSqr = dirToPlayer.lenSqr();

    if (lengthToPlayerSqr < (600.0f * 600.0f) && timeOffset >= INLINE_THROWING_ENEMY_CADENCY)
    {
        m_fLastTimeThrown = actualTime;

        Vec3 impulse = (m_vThrowingDir * 2.0f);

        ParticleManager::Instance().AddParticle(PARTICLE_INLINE_THROWING_ENEMY, m_vStartThrowingPosition, impulse, 2.0f, m_fFinalRotation, Vec3(0, 0, 0));

        m_pFlashInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pFlashInterpolator, false, timer);

        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_INLINE_THROWING), m_vPosition);
    }

    m_FlashRenderObject.SetColor(1.0f, 1.0f, 1.0f, m_fFlashOpacity);
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
    {
        Vec3 dir = m_pThePlayer->GetPosition() - m_vStartThrowingPosition;

        dir.normalize();

        const float speed = 3.0f;
        dir *= speed;

        btVector3 impulseVec(dir.x, dir.y, dir.z);

        if (!m_pThePlayer->GetRigidBody()->isActive())
        {
            m_pThePlayer->GetRigidBody()->activate();
        }

        m_pThePlayer->GetRigidBody()->applyCentralImpulse(impulseVec);
        m_pThePlayer->Deflate(PLAYER_BIG_ENEMY_HURT);
    }

    m_pTheScene->GetCamera3D()->AddNoise(0.8f, timer);

    Kill();
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    Kill();
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData)
{
    theShot->Kill();

    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, theShot->GetPosition(), 0.3f, 0.8f, Vec3(0, 0, 0), 6, 0.0f);

    Kill();
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::Kill(void)
{
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 16, 0.8f);
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);

    Disable();

    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD), m_vPosition);
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::Enable(void)
{
    Enemy::Enable();
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::Disable(void)
{
    Enemy::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::getWorldTransform(btTransform &worldTransform) const
{
    Vec3 pos = m_vStartThrowingPosition;
    pos -= (m_vThrowingDir * 8.0f);

    btVector3 newPos(pos.x * PHYSICS_SCALE_FACTOR, pos.y * PHYSICS_SCALE_FACTOR,
            pos.z * PHYSICS_SCALE_FACTOR);

    worldTransform.setIdentity();
    worldTransform.setOrigin(newPos);
}

//////////////////////////
//////////////////////////

void InlineThrowingEnemy::Reset(void)
{
    m_fLastTimeThrown = 0.0f;
    m_fFlashOpacity = 0.0f;
    m_fAffectedByElectricityTime = 0.0f;

    if (m_pFlashInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pFlashInterpolator);
    }

    if (!m_bEnable)
    {
        Enable();
    }
}