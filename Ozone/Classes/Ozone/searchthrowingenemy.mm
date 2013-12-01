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
 * File:   searchthrowingenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:37
 */

#include "searchthrowingenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "particlemanager.h"
#include "scene.h"

//////////////////////////
//////////////////////////

SearchThrowingEnemy::SearchThrowingEnemy(void) : Enemy()
{
    m_fLastTimeThrown = 0.0f;
    m_fRotationRad = 0.0f;
    m_Rotation = 0;
    m_fCannonRotation = 0.0f;
}

//////////////////////////
//////////////////////////

void SearchThrowingEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    m_Rotation = rotation;

    m_fRotationRad = MAT_ToRadians(rotation * 90.0f);

    if (rotation == 3)
        m_fRotationRad = MAT_ToRadians(-90.0f);

    m_fCannonRotation = m_fRotationRad;

    MATRIX mtxRotY;
    MatrixRotationY(mtxRotY, m_fRotationRad);


    Vec4 vStartThrowingPosition4 = Vec4(-27.0f, 0.0f, 0.0f, 0.0f);
    MatrixVec4Multiply(vStartThrowingPosition4, vStartThrowingPosition4, mtxRotY);

    m_vStartThrowingPosition = Vec3(vStartThrowingPosition4.ptr());
    m_vStartThrowingPosition += this->GetPosition();

    Texture* pTexture = TextureManager::Instance().GetTexture("game/entities/entities", true);

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/03_ent"),
            pTexture, RENDER_OBJECT_NORMAL);

    m_CannonRenderObejct.Init(MeshManager::Instance().GetMeshFromFile("game/entities/03a_ent"),
            pTexture, RENDER_OBJECT_NORMAL);

    MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), mtxRotY);

    m_MainRenderObject.SetPosition(this->GetPosition());
    m_vOriginalPosition = this->GetPosition();
    m_CannonRenderObejct.SetPosition(this->GetPosition());

    m_RenderObjectList.push_back(&m_MainRenderObject);
    m_RenderObjectList.push_back(&m_CannonRenderObejct);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pEnemyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);
    m_pRigidBody->setUserPointer(new CollisionInfo(COL_OBJ_NPC, this));

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}


//////////////////////////
//////////////////////////

void SearchThrowingEnemy::Update(Timer* timer)
{
    Vec3 dirToPlayer = m_pThePlayer->GetPosition() - m_vPosition;
    float lengthToPlayerSqr = dirToPlayer.lenSqr();

    if (lengthToPlayerSqr < (600.0f * 600.0f))
    {
        MATRIX matFinal, matTransCannon, matOffsetCannon, matRotCannon, matRotEnemy;

        MatrixRotationY(matRotEnemy, m_fRotationRad);
        MatrixTranslation(matTransCannon, m_vOriginalPosition.x, m_vOriginalPosition.y, m_vOriginalPosition.z);
        MatrixTranslation(matOffsetCannon, -25.0f, 0.0f, 0.0f);


        Vec4 vecCannonOffset4 = Vec4(-25.0f, 0.0f, 0.0f, 1.0f);
        MatrixVec4Multiply(vecCannonOffset4, vecCannonOffset4, matRotEnemy);

        Vec4 vecCannon4 = Vec4(m_vPosition, 1.0f);
        vecCannon4 += vecCannonOffset4;

        Vec2 vecCannon(vecCannon4.x, vecCannon4.z);

        Vec2 vecPlayer(m_pThePlayer->GetPositionX(), m_pThePlayer->GetPositionZ());

        Vec2 vecDir = vecPlayer - vecCannon;
        vecDir.normalize();

        Vec2 dir_right(1.0f, 0.0f);

        float lookAtAngle = MAT_angleSignedVec2D(dir_right, vecDir);
        float lookAtAngleDegrees = MAT_ToDegrees(lookAtAngle);

        bool active = true;

        if (m_pThePlayer->IsDead())
        {
            active = false;
        }
        else
        {
            switch (m_Rotation)
            {
                case 0:
                {
                    if (lookAtAngleDegrees > MAX_SEARCH_THROWING_ENEMY_ANGLE || lookAtAngleDegrees < -MAX_SEARCH_THROWING_ENEMY_ANGLE)
                    {
                        active = false;
                    }
                    break;
                }
                case 1:
                {
                    if (lookAtAngleDegrees < (90.0f - MAX_SEARCH_THROWING_ENEMY_ANGLE) || lookAtAngleDegrees > (90.0f + MAX_SEARCH_THROWING_ENEMY_ANGLE))
                    {
                        active = false;
                    }
                    break;
                }
                case 2:
                {
                    if (lookAtAngleDegrees > (-180.0f + MAX_SEARCH_THROWING_ENEMY_ANGLE) && lookAtAngleDegrees < (180.0f - MAX_SEARCH_THROWING_ENEMY_ANGLE))
                    {
                        active = false;
                    }
                    break;
                }
                case 3:
                {
                    if (lookAtAngleDegrees < (-90.0f - MAX_SEARCH_THROWING_ENEMY_ANGLE) || lookAtAngleDegrees > (-90.0f + MAX_SEARCH_THROWING_ENEMY_ANGLE))
                    {
                        active = false;
                    }
                    break;
                }
            }
        }

        if (active)
        {
            m_fCannonRotation = lookAtAngle;
        }
        else
        {
            float idle_pos = m_fRotationRad;

            if ((m_fCannonRotation < 0.0f) && (idle_pos > 0.0f))
                idle_pos = -idle_pos;

            if (m_fCannonRotation > idle_pos)
            {
                m_fCannonRotation -= 1.0f * timer->GetDeltaTime();

                if (m_fCannonRotation < idle_pos)
                    m_fCannonRotation = idle_pos;
            }
            else
            {
                m_fCannonRotation += 1.0f * timer->GetDeltaTime();

                if (m_fCannonRotation > idle_pos)
                    m_fCannonRotation = idle_pos;
            }

            m_fLastTimeThrown = timer->GetActualTime();
        }

        MatrixRotationY(matRotCannon, m_fCannonRotation - m_fRotationRad);

        matFinal = matRotCannon;

        MatrixMultiply(matFinal, matFinal, matOffsetCannon);
        MatrixMultiply(matFinal, matFinal, matRotEnemy);
        MatrixMultiply(matFinal, matFinal, matTransCannon);

        m_CannonRenderObejct.SetTransform(matFinal);

        float actualTime = timer->GetActualTime();
        float timeOffset = actualTime - m_fLastTimeThrown;

        if (active && timeOffset >= SEARCH_THROWING_ENEMY_CADENCY)
        {
            m_fLastTimeThrown = actualTime;

            Vec4 vThrowingDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
            MATRIX rotFire;
            MatrixMultiply(rotFire, matRotCannon, matRotEnemy);
            MatrixVec4Multiply(vThrowingDir4, vThrowingDir4, rotFire);

            Vec3 impulse = (Vec3(vThrowingDir4.ptr()) * 2.0f);

            ParticleManager::Instance().AddParticle(PARTICLE_SEARCH_THROWING_ENEMY, m_vStartThrowingPosition, impulse, 2.0f, m_fCannonRotation, Vec3(0, 0, 0));

            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_SEARCH_THROWING), m_vPosition);
        }
    }
}

//////////////////////////
//////////////////////////

void SearchThrowingEnemy::ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer)
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

void SearchThrowingEnemy::ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData)
{
    theShot->Kill();

    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, theShot->GetPosition(), 0.3f, 0.8f, Vec3(0, 0, 0), 6, 0.0f);

    Kill();
}

//////////////////////////
//////////////////////////

void SearchThrowingEnemy::ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData)
{
    Kill();
}

//////////////////////////
//////////////////////////

void SearchThrowingEnemy::Kill(void)
{
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 1.8f, 0.9f, Vec3(0, 0, 0), 16, 0.8f);
    ParticleManager::Instance().AddExplosion(PARTICLE_ENEMY, m_vPosition, 0.6f, 1.1f, Vec3(0, 0, 0), 8, 0.0f);

    Disable();

    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_NPC_DEAD), m_vPosition);
}

//////////////////////////
//////////////////////////

void SearchThrowingEnemy::Enable(void)
{
    Enemy::Enable();
    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
}

//////////////////////////
//////////////////////////

void SearchThrowingEnemy::Disable(void)
{
    Enemy::Disable();
    PhysicsManager::Instance().GetDynamicsWorld()->removeRigidBody(m_pRigidBody);
}

//////////////////////////
//////////////////////////

void SearchThrowingEnemy::getWorldTransform(btTransform &worldTransform) const
{
    Vec3 pos = m_vStartThrowingPosition;

    btVector3 newPos(pos.x * PHYSICS_SCALE_FACTOR, pos.y * PHYSICS_SCALE_FACTOR,
            pos.z * PHYSICS_SCALE_FACTOR);

    worldTransform.setIdentity();
    worldTransform.setOrigin(newPos);
}

//////////////////////////
//////////////////////////

void SearchThrowingEnemy::Reset(void)
{
    m_fLastTimeThrown = 0.0f;
    m_fCannonRotation = m_fRotationRad;
    m_fAffectedByElectricityTime = 0.0f;

    if (!m_bEnable)
    {
        Enable();
    }
}