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
 * File:   backgroundparticle.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 0:03
 */

#include "backgroundparticle.h"
#include "meshmanager.h"
#include "texturemanager.h"

BackgroundParticle::BackgroundParticle(int type, float maxX, float maxY) : Particle()
{
    m_iType = type;
    m_fRotation = 0.0f;

    m_fMaxX = maxX;
    m_fMaxY = maxY;
}

//////////////////////////
//////////////////////////

void BackgroundParticle::Init(char* szDepthPath)
{
    MATRIX mtxRotY;
    MatrixRotationY(mtxRotY, MAT_ToRadians(MAT_RandomInt(0, 360)));

    Vec4 vDir4 = Vec4(1.0f, 0.0f, 0.0f, 0.0f);
    MatrixVec4Multiply(vDir4, vDir4, mtxRotY);
    m_vDir = Vec3(vDir4.ptr());

    m_fAngularVel = (MAT_RandomInt(5, 30) * (MAT_RandomInt(0, 2) == 0 ? 1 : -1)) * M_PI_ENTRE_180;

    char depth_model[150];

    switch (m_iType)
    {
        case 0:
        {
            sprintf(depth_model, "%s/depth_04", szDepthPath);
            m_fLinearVel = MAT_RandomInt(20, 60);
            break;
        }
        case 1:
        {
            sprintf(depth_model, "%s/depth_03", szDepthPath);
            m_fLinearVel = MAT_RandomInt(10, 30);
            break;
        }
        case 2:
        {
            if (MAT_RandomInt(0, 2) == 0)
            {
                sprintf(depth_model, "%s/depth_02", szDepthPath);
            }
            else
            {
                sprintf(depth_model, "%s/depth_02a", szDepthPath);
            }
            m_fLinearVel = MAT_RandomInt(10, 30);
            break;
        }
        case 3:
        {
            sprintf(depth_model, "%s/depth_01", szDepthPath);
            m_fLinearVel = MAT_RandomInt(1, 10);
            break;
        }
    }

    m_vDir = m_vDir * m_fLinearVel;

    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile(depth_model, false, true),
            NULL, RENDER_OBJECT_ADDITIVE);
}

//////////////////////////
//////////////////////////

void BackgroundParticle::Update(Timer* timer)
{
    float deltaTime = timer->GetDeltaTime();

    m_fRotation += m_fAngularVel * deltaTime;

    MatrixRotationY(m_mtxRotation, m_fRotation);

    m_vPosition += (m_vDir * deltaTime);

    if (m_vPosition.x < -500.0f)
    {
        m_vPosition.x = m_fMaxX;
    }
    else if (m_vPosition.x > m_fMaxX)
    {
        m_vPosition.x = -500.0f;
    }

    if (m_vPosition.z < -500.0f)
    {
        m_vPosition.z = m_fMaxY;
    }
    else if (m_vPosition.z > m_fMaxY)
    {
        m_vPosition.z = -500.0f;
    }    
}
