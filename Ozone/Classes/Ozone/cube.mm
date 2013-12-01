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
 * File:   cube.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 20:56
 */

#include "renderobject.h"
#include "cube.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "physicsmanager.h"
#include "particlemanager.h"
#include "scene.h"
#include "bladeenemy.h"

btCollisionShape* Cube::m_pCubeShape = NULL;

Cube::Cube(void) : NPC()
{

    InitPointer(m_pDoorGlowInterpolator);

    m_bHasCollision = false;

    m_bRigid = true;

    m_fFadeOut = 0.0f;
    m_fGlowDuration = 1.0f;
    m_fGlowTime = m_fGlowDuration;

    m_bDoorWantsToDissapear = false;

    if (m_pCubeShape == NULL)
    {
        btScalar mass = 0.0f;
        btVector3 inertia(0, 0, 0);
        m_pCubeShape = new btBoxShape(btVector3(0.4f, 0.4f, 0.4f));
        m_pCubeShape->setMargin(0.01f);
        m_pCubeShape->calculateLocalInertia(mass, inertia);
    }
}

//////////////////////////
//////////////////////////

Cube::~Cube()
{
    SafeDelete(m_pCubeShape);
    SafeDelete(m_pDoorGlowInterpolator);
}

//////////////////////////
//////////////////////////

void Cube::Init(stCUBE_CONFIG_FILE& cube_config, const char* szEpisode, int rotation, bool collision)
{
    MatrixRotationY(m_mtxRotation, PIOVERTWOf * rotation);

    m_fFadeOut = 0.0f;

    eRenderObjectType opacity = RENDER_OBJECT_NORMAL;
    m_Door = cube_config.door;
    m_bBreak = cube_config.cube_break;

    m_fGlowDuration = cube_config.fade / 1000.0f;

    if (m_Door != CUBE_DOOR_NO)
    {
        m_GlowRenderObject.Activate(true);
        m_fGlowTime = 0.0f;

        m_pDoorGlowInterpolator = new SquareInterpolator(&m_fGlowTime, 0.0f, 1.0f, 0.2f, false, 0.8f);
    }
    else
    {
        m_fGlowTime = m_fGlowDuration;
    }

    switch (cube_config.opacity)
    {
        case CUBE_OPACITY_NO:
        {
            if (!m_bBreak)
            {
                m_bStaticLevel = true;
            }

            opacity = RENDER_OBJECT_NORMAL;
            break;
        }
        case CUBE_OPACITY_TRANSPARENT:
        {
            opacity = RENDER_OBJECT_TRANSPARENT;
            break;
        }
        case CUBE_OPACITY_ADDITIVE:
        {
            opacity = RENDER_OBJECT_ADDITIVE;
            break;
        }
    }

    if (cube_config.pMesh == NULL)
    {
        char mesh[100];
        sprintf(mesh, "game/episodes/%s/%s/%s", szEpisode, "cubes", cube_config.mesh);
        cube_config.pMesh = MeshManager::Instance().GetMeshFromFile(mesh, !m_bStaticLevel);
    }

    if (cube_config.pTexture == NULL)
    {
        char texture[100];
        sprintf(texture, "game/episodes/%s/%s/%s", szEpisode, "cubes", cube_config.texture);
        cube_config.pTexture = TextureManager::Instance().GetTexture(texture, true);
    }

    if (cube_config.pGlowTexture == NULL)
    {
        char texture[100];

        if (m_Door == CUBE_DOOR_NO)
        {
            sprintf(texture, "game/episodes/%s/%s/%s", szEpisode, "cubes", cube_config.glow_texture);
        }
        else
        {
            strcpy(texture, "game/items/items");
        }

        cube_config.pGlowTexture = TextureManager::Instance().GetTexture(texture, true);
    }

    m_MainRenderObject.Init(cube_config.pMesh, cube_config.pTexture, opacity);
    MatrixRotationY(m_MainRenderObject.GetTransform(), PIOVERTWOf * rotation);
    m_MainRenderObject.SetPosition(this->GetPosition());

    if (m_Door != CUBE_DOOR_NO)
    {
        m_MainRenderObject.UseColor(true);
    }

    if (cube_config.invisible/* || m_bBreak*/)
    {
        m_MainRenderObject.Activate(false);
    }

    if (m_Door == CUBE_DOOR_BLUE)
    {
        m_GlowRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/items/blue_card"), cube_config.pGlowTexture, RENDER_OBJECT_ADDITIVE);
    }
    else if (m_Door == CUBE_DOOR_RED)
    {
        m_GlowRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/items/red_card"), cube_config.pGlowTexture, RENDER_OBJECT_ADDITIVE);
    }
    else
    {
        m_GlowRenderObject.Init(cube_config.pMesh, cube_config.pGlowTexture, RENDER_OBJECT_ADDITIVE);
    }

    m_GlowRenderObject.UseColor(true);

    MatrixRotationY(m_GlowRenderObject.GetTransform(), PIOVERTWOf * rotation);

    if (!m_bStaticLevel)
    {
        MATRIX scale;
        MatrixScaling(scale, 1.01f, 1.01f, 1.01f);
        MatrixMultiply(m_GlowRenderObject.GetTransform(), m_GlowRenderObject.GetTransform(), scale);

        m_RenderObjectList.push_back(&m_MainRenderObject);
    }
    else
    {
        MATRIX scale;
        MatrixScaling(scale, 1.0f / 15.9f, 1.0f / 15.9f, 1.0f / 15.9f);
        MatrixMultiply(m_GlowRenderObject.GetTransform(), m_GlowRenderObject.GetTransform(), scale);
    }


    m_GlowRenderObject.SetPosition(this->GetPosition());
    m_RenderObjectList.push_back(&m_GlowRenderObject);

    m_bHasCollision = collision;

    if (m_bHasCollision)
    {
        btRigidBody::btRigidBodyConstructionInfo cubeRigidBodyCI(0, this, m_pCubeShape, btVector3(0, 0, 0));
        cubeRigidBodyCI.m_restitution = 1.0f - cube_config.friction;
        m_pRigidBody = new btRigidBody(cubeRigidBodyCI);
        m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

        PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_WALLS, c_iWallsCollidesWith);
    }
}

//////////////////////////
//////////////////////////

void Cube::Update(Timer* timer)
{
    if (m_Door == CUBE_DOOR_NO)
    {
        m_fGlowTime += timer->GetDeltaTime();

        if (m_fGlowTime < m_fGlowDuration)
        {
            float alpha = 1.0f - (m_fGlowTime / m_fGlowDuration);
            m_GlowRenderObject.SetColor(alpha, alpha, alpha, 1.0f);
        }
        else
        {
            m_GlowRenderObject.Activate(false);
        }
    }
    else
    {
        if (((m_Door == CUBE_DOOR_RED) && m_pThePlayer->GetDoorKey(RED_DOOR_KEY)) || ((m_Door == CUBE_DOOR_BLUE) && m_pThePlayer->GetDoorKey(BLUE_DOOR_KEY)))
        {
            if (!m_bDoorWantsToDissapear)
            {
                m_bDoorWantsToDissapear = true;
                m_pDoorGlowInterpolator->Redefine(0.0f, 1.0f, 0.2f, false, 0.6f);
                m_pDoorGlowInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pDoorGlowInterpolator, false, timer);
            }

            if (m_pDoorGlowInterpolator->IsFinished())
            {
                if (m_fFadeOut == 0.0f)
                {
                    InterpolatorManager::Instance().Add(new LinearInterpolator(&m_fFadeOut, 0.0f, 1.0f, 0.6f), true);
                }

                m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f - m_fFadeOut);
                m_GlowRenderObject.SetColor(1.0f, 1.0f, 1.0f, 0.0f);

                if (m_fFadeOut >= 1.0f)
                {
                    Disable();
                }
            }
            else
            {
                float alpha = 1.0f - m_fGlowTime;
                m_GlowRenderObject.SetColor(alpha, alpha, alpha, 1.0f);
            }
        }
        else
        {
            float alpha = 1.0f - m_fGlowTime;
            m_GlowRenderObject.SetColor(alpha, alpha, alpha, 1.0f);
        }
    }
}

//////////////////////////
//////////////////////////

void Cube::Light(bool isPlayer, bool isSteel)
{
    if (m_Door == CUBE_DOOR_NO)
    {
        m_GlowRenderObject.Activate(true);
        m_fGlowTime = 0.0f;

        if (isPlayer)
        {
            if (isSteel)
            {
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_METALIC_BOUNCE), m_vPosition);
            }
            else
            {
                Audio::Instance().PlayNextCubeSound(m_vPosition);
            }
        }
    }
    else if (((m_Door == CUBE_DOOR_RED) && !m_pThePlayer->GetDoorKey(RED_DOOR_KEY)) || ((m_Door == CUBE_DOOR_BLUE) && !m_pThePlayer->GetDoorKey(BLUE_DOOR_KEY)))
    {
        m_pDoorGlowInterpolator->Redefine(0.0f, 1.0f, 0.2f, false, 0.6f);
        m_pDoorGlowInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pDoorGlowInterpolator, false, m_pTheScene->GetGameTimer());

        if (isPlayer)
        {
            if (isSteel)
            {
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_METALIC_BOUNCE), m_vPosition);
            }
            else
            {
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_CLOSED_DOOR), m_vPosition);
            }
        }
    }

    if (m_bBreak)
    {
        ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 1.0f, Vec3(0, 0, 0), 10, 0.6f);
    }
}

//////////////////////////
//////////////////////////

void Cube::ContactWithPlayer(Player* thePlayer, const float impulse, Timer * timer)
{
    if (thePlayer->GetAmmo(STEEL_AMMO) > 0.0f)
    {
        if (m_bBreak && impulse > 2.5f)
        {
            m_pTheScene->GetCamera3D()->AddNoise(0.3f * impulse, timer);

            ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 2.5f, 1.1f, Vec3(0, 0, 0), 16, 0.9f);
            ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.5f, 1.1f, Vec3(0, 0, 0), 8, 0.2f);

            Disable();

            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_CUBE_BREAK), m_vPosition);
        }
        else
        {
            m_pTheScene->GetCamera3D()->AddNoise(0.18f * impulse, timer);

            if (impulse > 0.6f)
            {
                Light(true, true);
            }
        }
    }
    else if (impulse > 0.6f)
    {
        Light(true, false);
    }
}

//////////////////////////
//////////////////////////

void Cube::ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers)
{
    if ((m_Door == CUBE_DOOR_NO) && (impulse > 1.0f))
    {
        Light(false, false);
    }
}

//////////////////////////
//////////////////////////

void Cube::Enable(void)
{
    NPC::Enable();

    if (m_bHasCollision)
        PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_WALLS, c_iWallsCollidesWith);
}

//////////////////////////
//////////////////////////

void Cube::Disable(void)
{
    NPC::Disable();

    if (m_bHasCollision)
        PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

//////////////////////////
//////////////////////////

void Cube::Reset(void)
{
    m_fFadeOut = 0.0f;
    m_bDoorWantsToDissapear = false;

    m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);

    if (m_Door != CUBE_DOOR_NO)
    {
        m_GlowRenderObject.Activate(true);
        m_fGlowTime = 0.0f;
        m_GlowRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);
    }
    else
    {
        m_GlowRenderObject.SetColor(1.0f, 1.0f, 1.0f, 0.0f);
        m_fGlowTime = m_fGlowDuration;
    }

    if (IsValidPointer(m_pDoorGlowInterpolator) && m_pDoorGlowInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pDoorGlowInterpolator);
    }

    if (!m_bEnable)
    {
        Enable();
    }
}