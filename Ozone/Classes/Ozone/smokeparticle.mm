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
 * File:   smokeparticle.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 0:02
 */

#include "smokeparticle.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "scene.h"

SmokeParticle::SmokeParticle(void) : Particle() { }

//////////////////////////
//////////////////////////

void SmokeParticle::Init(void)
{
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/smoke"),
            TextureManager::Instance().GetTexture("game/entities/particles", true), RENDER_OBJECT_TRANSPARENT);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_MainRenderObject.UseColor(true);
    m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);
    m_RenderObjectList.push_back(&m_MainRenderObject);
}

//////////////////////////
//////////////////////////

void SmokeParticle::Update(Timer* timer)
{
    if (!m_bDead)
    {
        float dTime = timer->GetDeltaTime();
        m_vScale += dTime * 4.2f;
        m_vPosition += (m_vDir * dTime);

        m_fTimeToLive = MAT_Max(0.0f, m_fTimeToLive - dTime);

        if (m_fTimeToLive <= 0.5f)
        {
            m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, m_fTimeToLive * 2.0f);

            if (m_fTimeToLive <= 0.0f)
            {
                m_bDead = true;
            }
        }

        MATRIX rot;
        MatrixScaling(m_MainRenderObject.GetTransform(), m_vScale.x, m_vScale.y, m_vScale.z);
        MatrixRotationY(rot, m_fRotationY);
        MatrixMultiply(m_MainRenderObject.GetTransform(), m_MainRenderObject.GetTransform(), rot);
        m_vPosition.y = -10.0f - ((1.0f - m_fTimeToLive) * 10.0f);
        m_MainRenderObject.SetPosition(m_vPosition);
    }
}

//////////////////////////
//////////////////////////

void SmokeParticle::Enable(void)
{
    Particle::Enable();
    m_MainRenderObject.SetColor(1.0f, 1.0f, 1.0f, 1.0f);
}

//////////////////////////
//////////////////////////

void SmokeParticle::Disable(void)
{
    Particle::Disable();
}
