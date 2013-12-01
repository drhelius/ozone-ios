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
 * File:   particlemanager.cpp
 * Author: nacho
 * 
 * Created on 21 de septiembre de 2009, 22:43
 */

#include "scene.h"
#include "particlemanager.h"
#include "inlinethrowingenemyshotparticle.h"
#include "playerredshotparticle.h"
#include "searchthrowingenemyshotparticle.h"
#include "smokeparticle.h"
#include "spittingenemyshotparticle.h"
#include "gasparticle.h"
#include "itemparticle.h"
#include "enemyparticle.h"
#include "BossSpaceShotParticle.h"
#include "gamemanager.h"

//////////////////////////
//////////////////////////

ParticleManager::ParticleManager(void)
{
    Log("+++ ParticleManager::ParticleManager ...\n");

    m_bNeedCleanup = false;

    for (int i = 0; i < MAX_PARTICLE_TYPE; i++)
    {
        InitPointer(m_pParticleArray[i]);

        m_iArraySize[i] = 0;
        m_iFreeSlot[i] = 0;
        m_iFirstUsed[i] = -1;
    }

    Log("+++ ParticleManager::ParticleManager correcto\n");
}

//////////////////////////
//////////////////////////

ParticleManager::~ParticleManager()
{
    Log("+++ ParticleManager::~ParticleManager ...\n");

    Cleanup();

    Log("+++ ParticleManager::~ParticleManager destruido\n");
}

//////////////////////////
//////////////////////////

void ParticleManager::InitParticleArray(eParticleType type, int count, int& IDcounter)
{
    Log("+++ ParticleManager::InitParticleArray type=%d count=%d ...\n", type, count);

    m_iArraySize[type] = count;

    m_pParticleArray[type] = new stParticleNode[count];

    for (int i = 0; i < count; i++)
    {
        switch (type)
        {
            case PARTICLE_INLINE_THROWING_ENEMY:
            {
                m_pParticleArray[type][i].pParticle = new InlineThrowingEnemyShotParticle();
                break;
            }
            case PARTICLE_PLAYER_RED:
            {
                m_pParticleArray[type][i].pParticle = new PlayerRedShotParticle();
                break;
            }
            case PARTICLE_SEARCH_THROWING_ENEMY:
            {
                m_pParticleArray[type][i].pParticle = new SearchThrowingEnemyShotParticle();
                break;
            }
            case PARTICLE_SMOKE:
            {
                m_pParticleArray[type][i].pParticle = new SmokeParticle();
                break;
            }
            case PARTICLE_SPITTING_ENEMY:
            {
                m_pParticleArray[type][i].pParticle = new SpittingEnemyShotParticle();
                break;
            }
            case PARTICLE_GAS:
            {
                m_pParticleArray[type][i].pParticle = new GasParticle();
                break;
            }
            case PARTICLE_ITEM:
            {
                m_pParticleArray[type][i].pParticle = new ItemParticle();
                break;
            }
            case PARTICLE_ENEMY:
            {
                m_pParticleArray[type][i].pParticle = new EnemyParticle();
                break;
            }
            case PARTICLE_BOSS_SPACE:
            {
                m_pParticleArray[type][i].pParticle = new BossSpaceShotParticle();
                break;
            }
        }

        m_pParticleArray[type][i].pParticle->SetID(IDcounter);
        m_pParticleArray[type][i].pParticle->Init();
        IDcounter++;
    }

    Clear(type);

    m_bNeedCleanup = true;

    Log("+++ ParticleManager::InitParticleArray correcto\n");
}

//////////////////////////
//////////////////////////

void ParticleManager::ClearAll(void)
{
    for (int i = 0; i < MAX_PARTICLE_TYPE; i++)
    {
        Clear((eParticleType) i);
    }
}

//////////////////////////
//////////////////////////

void ParticleManager::Clear(eParticleType type)
{
    for (int i = 0; i < m_iArraySize[type]; i++)
    {
        m_pParticleArray[type][i].pParticle->Disable();
        m_pParticleArray[type][i].next = i + 1;
        m_pParticleArray[type][i].nextUsed = -1;
        m_pParticleArray[type][i].prevUsed = -1;
    }

    m_pParticleArray[type][m_iArraySize[type] - 1].next = -1;

    m_iFreeSlot[type] = 0;
    m_iFirstUsed[type] = -1;
}

//////////////////////////
//////////////////////////

void ParticleManager::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ ParticleManager::Cleanup ...\n");

        for (int i = 0; i < MAX_PARTICLE_TYPE; i++)
        {
            for (int h = 0; h < m_iArraySize[i]; h++)
            {
                SafeDelete(m_pParticleArray[i][h].pParticle);
            }

            SafeDeleteArray(m_pParticleArray[i]);
        }

        m_bNeedCleanup = false;

        Log("+++ ParticleManager::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void ParticleManager::Update(Timer* timer, Scene* pScene)
{
    for (int type = 0; type < MAX_PARTICLE_TYPE; type++)
    {
        int i = m_iFirstUsed[type];

        while (i >= 0)
        {
            if (m_pParticleArray[type][i].pParticle->IsDead())
            {
                m_pParticleArray[type][i].pParticle->Disable();

                int next = m_pParticleArray[type][i].nextUsed;
                int prev = m_pParticleArray[type][i].prevUsed;

                if (prev >= 0)
                {
                    m_pParticleArray[type][prev].nextUsed = next;
                }

                if (next >= 0)
                {
                    m_pParticleArray[type][next].prevUsed = prev;
                }

                if (i == m_iFirstUsed[type])
                {
                    m_iFirstUsed[type] = prev;
                }

                m_pParticleArray[type][i].next = m_iFreeSlot[type];
                m_iFreeSlot[type] = i;
            }
            else
            {
                m_pParticleArray[type][i].pParticle->Update(timer);

                pScene->AddNPCToProperSector(m_pParticleArray[type][i].pParticle, 0);
            }

            i = m_pParticleArray[type][i].prevUsed;
        }
    }
}

//////////////////////////
//////////////////////////

void ParticleManager::AddParticle(eParticleType type, const Vec3& vecPos, const Vec3& vecImpulse, float timeToLive, float rotationY, const Vec3& initialSpeed, float scale, float r, float g, float b)
{
    int freeIndex = m_iFreeSlot[type];

    if (freeIndex < 0)
    {
        return;
    }

    if ((r + g + b) < 3.0f)
    {
        COLOR color;
        color.r = r;
        color.g = g;
        color.b = b;
        color.a = 1.0f;
        m_pParticleArray[type][freeIndex].pParticle->SetColor(color);
        m_pParticleArray[type][freeIndex].pParticle->UseColor(true);
    }
    else
    {
        m_pParticleArray[type][freeIndex].pParticle->UseColor(false);
    }

    m_pParticleArray[type][freeIndex].pParticle->SetPosition(vecPos);
    m_pParticleArray[type][freeIndex].pParticle->Enable();

    if (type == PARTICLE_GAS || type == PARTICLE_ENEMY || type == PARTICLE_SMOKE || type == PARTICLE_ITEM)
    {
        m_pParticleArray[type][freeIndex].pParticle->SetDir((initialSpeed + vecImpulse) * PHYSICS_INV_SCALE_FACTOR);
    }
    else
    {
        m_pParticleArray[type][freeIndex].pParticle->GetRigidBody()->setLinearVelocity(btVector3(initialSpeed.x, initialSpeed.y, initialSpeed.z));
        m_pParticleArray[type][freeIndex].pParticle->GetRigidBody()->applyCentralImpulse(btVector3(vecImpulse.x, vecImpulse.y, vecImpulse.z));
    }

    m_pParticleArray[type][freeIndex].pParticle->SetTimeToLive(timeToLive);
    m_pParticleArray[type][freeIndex].pParticle->SetRotationY(rotationY);
    m_pParticleArray[type][freeIndex].pParticle->SetScale(scale, scale, scale);

    m_pParticleArray[type][freeIndex].prevUsed = m_iFirstUsed[type];
    m_pParticleArray[type][freeIndex].nextUsed = -1;

    int prev = m_pParticleArray[type][freeIndex].prevUsed;

    if (prev >= 0)
    {
        m_pParticleArray[type][prev].nextUsed = freeIndex;
    }

    m_iFirstUsed[type] = freeIndex;

    m_iFreeSlot[type] = m_pParticleArray[type][freeIndex].next;
}

//////////////////////////
//////////////////////////

void ParticleManager::AddExplosion(eParticleType type, const Vec3& vecPos, float impulse, float timeToLive, const Vec3& initialSpeed, int rays, float scale, float r, float g, float b)
{
    if (GameManager::Instance().DeviceType() == GameManager::DEVICE_1ST_GEN)
    {
        if (rays > 5)
        {
            rays = MAT_Max(5, rays / 2);
        }
    }

    if (rays > 0)
    {
        int angle = 360 / rays;

        for (int i = 0; i < 360; i += angle)
        {
            float angleRad = MAT_ToRadians(i);

            MATRIX mtxRot;
            MatrixRotationY(mtxRot, angleRad);

            Vec4 vDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
            MatrixVec4Multiply(vDir4, vDir4, mtxRot);

            Vec3 vImpulse = (Vec3(vDir4.ptr()) * impulse);

            AddParticle(type, vecPos, vImpulse, timeToLive, MAT_ToRadians(MAT_RandomInt(0, 360)), initialSpeed, scale, r, g, b);
        }
    }
}


