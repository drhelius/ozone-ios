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
 * File:   electricenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de agosto de 2009, 0:39
 */

#include "electricenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

//////////////////////////
//////////////////////////

ElectricEnemy::ElectricEnemy(void) : Enemy()
{
    m_fWaitInterval = 0.0f;
    m_fRayWait = 0.0f;
    m_fNukeValue = 0.0f;
    m_iRayFrame = 0;
    m_bFlashOn = false;
    m_bPlayingSound = false;

    InitPointer(m_pNukeInterpolator);
}

//////////////////////////
//////////////////////////

ElectricEnemy::~ElectricEnemy()
{
    SafeDelete(m_pNukeInterpolator);
}

//////////////////////////
//////////////////////////

void ElectricEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_pNukeInterpolator = new LinearInterpolator(&m_fNukeValue, 0.0f, 1.0f, 0.6f);
    m_pNukeInterpolator->Reset();

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/06_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_NORMAL);
    m_MainRenderObject.SetPosition(this->GetPosition());

    m_UpperLayer.Init(MeshManager::Instance().GetMeshFromFile("game/entities/06a_ent"),
            TextureManager::Instance().GetTexture("game/entities/ene_06", true), RENDER_OBJECT_ADDITIVE);
    m_UpperLayer.SetPosition(this->GetPosition());

    m_RayLayer.Init(MeshManager::Instance().GetMeshFromFile("game/entities/06_l"),
            TextureManager::Instance().GetTexture("game/entities/ene_06_l", true), RENDER_OBJECT_ADDITIVE);
    m_RayLayer.SetPosition(this->GetPosition());
    m_RayLayer.UseTextureMatrix(true);

    m_NukeLayer.Init(MeshManager::Instance().GetMeshFromFile("game/ball/wave_01"),
            TextureManager::Instance().GetTexture("game/ball/wave_01", true), RENDER_OBJECT_ADDITIVE);
    m_NukeLayer.UseColor(true);

    m_NukeLayer2.Init(MeshManager::Instance().GetMeshFromFile("game/ball/wave_glow"),
            TextureManager::Instance().GetTexture("game/hud/hud_01", true), RENDER_OBJECT_ADDITIVE);
    m_NukeLayer2.UseColor(true);
    m_NukeLayer2.UseDepthTest(false);
    m_NukeLayer2.SetColor(0.2f, 0.0f, 1.0f, 1.0f);

    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_UpperLayer);
    m_RenderObjectList.push_back(&m_RayLayer);

    m_RenderObjectList.push_back(&m_NukeLayer);
    m_RenderObjectList.push_back(&m_NukeLayer2);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0.0f, this, m_pEnemyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}

//////////////////////////
//////////////////////////

void ElectricEnemy::Update(Timer* timer)
{
    float dTime = timer->GetDeltaTime();

    if (m_fWaitInterval <= 0.0f)
    {
        m_fWaitInterval = 0.03f;

        m_bFlashOn = !m_bFlashOn;

        m_UpperLayer.Activate(m_bFlashOn);
        m_RayLayer.Activate(m_bFlashOn);

        if (m_bFlashOn)
        {
            float rot = MAT_RandomInt(0, 250);

            MatrixRotationY(m_UpperLayer.GetTransform(), MAT_ToRadians(rot));
            m_UpperLayer.SetPosition(this->GetPosition());
        }
        else
        {
            if (MAT_RandomInt(0, 12) == 2)
            {
                m_fWaitInterval = MAT_RandomInt(5, 12) * 0.01f;
            }
        }
    }
    else
    {
        m_fWaitInterval -= dTime;
    }

    Vec3 dir_right(1.0f, 0.0f, 0.0f);
    Vec3 dir_player = m_pThePlayer->GetPosition() - m_vPosition;
    dir_player.y = 0.0f;
    float length = dir_player.length();

    dir_player.normalize();

    float dot = dir_player.dot(dir_right);
    float lookAtAngle = acosf(dot);

    if (dir_player.z < 0.0f)
    {
        lookAtAngle *= -1.0f;
    }

    MATRIX scale, rotY;

    MatrixScaling(scale, length / 160.0f, 1.0f, 1.0f);
    MatrixRotationY(rotY, lookAtAngle + (timer->IsRunning() ? MAT_ToRadians(MAT_RandomInt(-15, 16) * 0.1f) : 0.0f ));
    MatrixMultiply(m_RayLayer.GetTransform(), scale, rotY);
    m_RayLayer.SetPosition(m_vPosition);


    m_fRayWait += dTime;

    if (m_fRayWait >= 0.05f)
    {
        m_fRayWait = 0.0f;
        m_iRayFrame++;
        m_iRayFrame %= 4;
    }

    MatrixTranslation(m_RayLayer.GetTextureTransform(), 0.0f, m_iRayFrame * 0.25f, 0.0f);


    if (length <= 350.0f && !m_pThePlayer->IsDead())
    {
        if (!m_bPlayingSound)
        {
            m_bPlayingSound = true;
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY), m_vPosition);
        }

        if (m_pThePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
        {
            m_pThePlayer->GetRigidBody()->applyCentralForce(btVector3(-ELECTRIC_ENEMY_FORCE * dir_player.x,
                    0.0f, -ELECTRIC_ENEMY_FORCE * dir_player.z));
        }
    }
    else
    {
        if (m_bPlayingSound)
        {
            m_bPlayingSound = false;
            AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY));
        }

        m_RayLayer.Activate(false);
    }

    bool bIsNukeActive = !m_pNukeInterpolator->IsFinished();

    if (bIsNukeActive)
    {
        float scalingNuke = m_fNukeValue * 100.0f;
        MatrixScaling(m_NukeLayer.GetTransform(), scalingNuke, scalingNuke, scalingNuke);
        m_NukeLayer.SetPosition(m_vPosition.x, m_vPosition.y + 15.0f, m_vPosition.z);
        m_NukeLayer.SetColor(0.2f, 0.0f, 1.0f, 1.0f - m_fNukeValue);

        const float scalingNukeGlow = 150.0f;
        MatrixScaling(m_NukeLayer2.GetTransform(), scalingNukeGlow, scalingNukeGlow, scalingNukeGlow);
        m_NukeLayer2.SetPosition(m_vPosition.x, m_vPosition.y + 15.0f, m_vPosition.z);
    }

    m_NukeLayer.Activate(bIsNukeActive);

}

//////////////////////////
//////////////////////////

void ElectricEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
{
    if (thePlayer->GetAmmo(STEEL_AMMO) <= 0.0f)
    {
        Vec3 dir = m_pThePlayer->GetPosition() - m_vPosition;

        dir.normalize();

        const float speed = 6.5f;
        dir *= speed;

        btVector3 impulseVec(dir.x, dir.y, dir.z);

        if (!m_pThePlayer->GetRigidBody()->isActive())
        {
            m_pThePlayer->GetRigidBody()->activate();
        }

        m_pThePlayer->GetRigidBody()->applyCentralImpulse(impulseVec);
        m_pThePlayer->Deflate(PLAYER_VERY_SMALL_ENEMY_HURT);
    }
    else
    {
        if (m_bPlayingSound)
        {
            m_bPlayingSound = false;
            AudioManager::Instance().StopEffect(Audio::Instance().GetEffect(kSOUND_ELECTRICITY));
        }

        Disable();
        ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 2.8f, 0.9f, Vec3(0, 0, 0), 16, 0.8f);
        ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);
    }

    m_pTheScene->GetCamera3D()->AddNoise(1.3f, timer);

    m_pNukeInterpolator->Reset();
    m_fNukeValue = 0.0f;
    InterpolatorManager::Instance().Add(m_pNukeInterpolator, false, timer);

    //ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 2.8f, 0.9f, Vec3(0, 0, 0), 16, 0.8f);
    //ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);

    //Disable();

    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD), m_vPosition);
}

//////////////////////////
//////////////////////////

void ElectricEnemy::Enable(void)
{
    Enemy::Enable();
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}

//////////////////////////
//////////////////////////

void ElectricEnemy::Disable(void)
{
    Enemy::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

//////////////////////////
//////////////////////////

void ElectricEnemy::Reset(void)
{
    if (!m_bEnable)
    {
        Enable();
    }
}