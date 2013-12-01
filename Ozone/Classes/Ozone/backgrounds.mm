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
 * File:   backgrounds.mm
 * Author: nacho
 * 
 * Created on 5 de octubre de 2009, 23:15
 */

#include "renderobject.h"
#include "gamemanager.h"
#include "backgrounds.h"
#include "meshmanager.h"
#include "texturemanager.h"

//////////////////////////
//////////////////////////

Backgrounds::Backgrounds(void)
{
    Log("+++ Backgrounds::Backgrounds ...\n");

    InitPointer(m_pRenderableBackground);
    InitPointer(m_pRenderableBackgroundParticles);

    InitPointer(m_pBackgroundParticlesMesh);
    InitPointer(m_pBackgroundParticlesRO);

    for (int i = 0; i < 4; i++)
    {
        InitPointer(m_pBackground[i]);

        InitPointer(m_pParticleArray[i]);

        m_iArraySize[i] = 0;
    }

    m_bNeedCleanup = false;

    Log("+++ Backgrounds::Backgrounds correcto\n");

}

//////////////////////////
//////////////////////////

Backgrounds::~Backgrounds()
{
    Log("+++ Backgrounds::~Backgrounds ...\n");

    Cleanup();

    Log("+++ Backgrounds::~Backgrounds destruido\n");
}

//////////////////////////
//////////////////////////

void Backgrounds::Init(char* szBackgroundPath, char* szDepthPath, float maxX, float maxY)
{

    strcpy(m_szDepthPath, szDepthPath);

    m_fMaxX = maxX;
    m_fMaxY = maxY;

    Log("+++ Backgrounds::Init ...\n");

    m_pRenderableBackground = new Renderable();
    m_pRenderableBackgroundParticles = new Renderable();

    for (int i = 0; i < 4; i++)
    {
        m_pBackground[i] = new RenderObject();
    }

    Texture* pTexBG = TextureManager::Instance().GetTexture(szBackgroundPath, true);
    Mesh* pMeshBG = MeshManager::Instance().GetMeshFromFile("game/backgrounds/background");

    m_pBackground[0]->Init(pMeshBG, pTexBG, RENDER_OBJECT_NORMAL);
    MatrixScaling(m_pBackground[0]->GetTransform(), 200.0f, 1.0f, 200.0f);
    m_pBackground[0]->SetPosition(0.0f, -800.0f, 0.0f);

    m_pBackground[1]->Init(pMeshBG, pTexBG, RENDER_OBJECT_NORMAL);
    MatrixScaling(m_pBackground[1]->GetTransform(), 200.0f, 1.0f, 200.0f);
    m_pBackground[1]->SetPosition(2000.0f, -800.0f, 0.0f);

    m_pBackground[2]->Init(pMeshBG, pTexBG, RENDER_OBJECT_NORMAL);
    MatrixScaling(m_pBackground[2]->GetTransform(), 200.0f, 1.0f, 200.0f);
    m_pBackground[2]->SetPosition(0.0f, -800.0f, 2000.0f);

    m_pBackground[3]->Init(pMeshBG, pTexBG, RENDER_OBJECT_NORMAL);
    MatrixScaling(m_pBackground[3]->GetTransform(), 200.0f, 1.0f, 200.0f);
    m_pBackground[3]->SetPosition(2000.0f, -800.0f, 2000.0f);

    float maxParticles = MAT_Max(maxX, maxY);

    //InitParticleArray(0, maxParticles / 50);
    if (GameManager::Instance().DeviceType() == GameManager::DEVICE_1ST_GEN)
    {
        InitParticleArray(1, 0);
        InitParticleArray(2, 0);
        InitParticleArray(3, 0);
    }
    else
    {

        InitParticleArray(1, maxParticles / 42);
        InitParticleArray(2, maxParticles / 30);
        #ifdef GEARDOME_PLATFORM_IPAD
        InitParticleArray(3, 0);
        #else
        InitParticleArray(3, maxParticles / 22);
        #endif
    }

    for (int i = 0; i < 4; i++)
    {
        m_pRenderableBackground->GetRenderObjectList().push_back(m_pBackground[i]);
    }

    ///////////////////////////////////////

    int totalIndexCount = 0;
    int totalVertexCount = 0;

    for (int type = 1; type < 4; type++)
    {
        totalVertexCount += (m_iArraySize[type] * 4);
        totalIndexCount += (m_iArraySize[type] * 6);
    }

    VERTEX_3D* finalVerts = new VERTEX_3D[totalVertexCount];
    u16* finalIndices = new u16[totalIndexCount];

    m_pBackgroundParticlesMesh = MeshManager::Instance().GetCustomMesh();
    m_pBackgroundParticlesMesh->SetFaceCount(totalIndexCount / 3);
    m_pBackgroundParticlesMesh->SetVertexCount(totalVertexCount);
    m_pBackgroundParticlesMesh->SetIndices(finalIndices);
    m_pBackgroundParticlesMesh->SetVertices(finalVerts);

    char depth_texture[150];
    sprintf(depth_texture, "%s/depth", szDepthPath);

    m_pBackgroundParticlesRO = new RenderObject();
    m_pBackgroundParticlesRO->Init(m_pBackgroundParticlesMesh,
            TextureManager::Instance().GetTexture(depth_texture, true), RENDER_OBJECT_ADDITIVE);

    m_pRenderableBackgroundParticles->GetRenderObjectList().push_back(m_pBackgroundParticlesRO);

    m_bNeedCleanup = true;

    Log("+++ Backgrounds::Init correcto\n");
}

//////////////////////////
//////////////////////////

void Backgrounds::InitParticleArray(int type, int count)
{
    Log("+++ Backgrounds::InitParticleArray type=%d count=%d ...\n", type, count);

    m_iArraySize[type] = count;

    m_pParticleArray[type] = new BackgroundParticle*[count];

    for (int i = 0; i < count; i++)
    {
        m_pParticleArray[type][i] = new BackgroundParticle(type, m_fMaxX, m_fMaxY);
        switch (type)
        {/*
            case 0:
            {
                m_pParticleArray[type][i]->SetPosition(Vec3(MAT_RandomInt(0, m_fMaxX), MAT_RandomInt(-700, -550), MAT_RandomInt(0, m_fMaxY)));
                break;
            }*/
            case 1:
            {
                m_pParticleArray[type][i]->SetPosition(Vec3(MAT_RandomInt(0, m_fMaxX), MAT_RandomInt(-200, -100), MAT_RandomInt(0, m_fMaxY)));
                break;
            }
            case 2:
            {
                m_pParticleArray[type][i]->SetPosition(Vec3(MAT_RandomInt(0, m_fMaxX), MAT_RandomInt(250, 300), MAT_RandomInt(0, m_fMaxY)));
                break;
            }
            case 3:
            {
                m_pParticleArray[type][i]->SetPosition(Vec3(MAT_RandomInt(0, m_fMaxX), MAT_RandomInt(500, 550), MAT_RandomInt(0, m_fMaxY)));
                break;
            }
        }

        m_pParticleArray[type][i]->Init(m_szDepthPath);
    }

    Log("+++ Backgrounds::InitParticleArray correcto\n");
}

//////////////////////////
//////////////////////////

void Backgrounds::Update(Timer* timer, const Vec3& camPos)
{
    int camPosX = (int) camPos.x;
    int camPosZ = (int) camPos.z;

    int secX = camPosX / 2000;
    int secZ = camPosZ / 2000;
    int secX2 = secX;
    int secZ2 = secZ;

    int modX = camPosX % 2000;
    int modZ = camPosZ % 2000;

    if (modX < 1000)
    {
        secX2 = secX - 1;
    }
    else
    {
        secX2 = secX + 1;
    }

    if (modZ < 1000)
    {
        secZ2 = secZ - 1;
    }
    else
    {
        secZ2 = secZ + 1;
    }

    m_pBackground[0]->SetPosition(secX * 2000.0f, -800.0f, secZ * 2000.0f);
    m_pBackground[1]->SetPosition(secX2 * 2000.0f, -800.0f, secZ * 2000.0f);
    m_pBackground[2]->SetPosition(secX * 2000.0f, -800.0f, secZ2 * 2000.0f);
    m_pBackground[3]->SetPosition(secX2 * 2000.0f, -800.0f, secZ2 * 2000.0f);

    Renderer::Instance().Add(m_pRenderableBackground);

    /////////////////////////

    //m_BackgroundParticleList.clear();

    int particleOffset = 0;

    for (int type = 1; type < 4; type++)
    {
        for (int i = 0; i < m_iArraySize[type]; i++)
        {
            BackgroundParticle* pParticle = m_pParticleArray[type][i];

            pParticle->Update(timer);

            bool isVisible = true;

            float x = pParticle->GetPositionX();
            float y = pParticle->GetPositionZ();

            switch (type)
            {/*
                case 0:
                {
                    if ((x > (camPos.x + 800.0f)) || (x < (camPos.x - 800.0f))
                            || (y > (camPos.z + 550.0f)) || (y < (camPos.z - 550.0f)))
                    {
                        isVisible = false;
                    }
                    break;
                }*/
                case 1:
                {
#ifdef GEARDOME_PLATFORM_IPAD
					if ((x > (camPos.x + 540.0f)) || (x < (camPos.x - 540.0f))
						|| (y > (camPos.z + 450.0f)) || (y < (camPos.z - 450.0f)))
#else
					if ((x > (camPos.x + 540.0f)) || (x < (camPos.x - 540.0f))
						|| (y > (camPos.z + 350.0f)) || (y < (camPos.z - 350.0f)))
#endif                    
                    {
                        isVisible = false;
                    }
                    break;
                }
                case 2:
                {
                    if ((x > (camPos.x + 300.0f)) || (x < (camPos.x - 300.0f))
                            || (y > (camPos.z + 200.0f)) || (y < (camPos.z - 200.0f)))
                    {
                        isVisible = false;
                    }
                    break;
                }
                case 3:
                {
                    if ((x > (camPos.x + 150.0f)) || (x < (camPos.x - 150.0f))
                            || (y > (camPos.z + 100.0f)) || (y < (camPos.z - 100.0f)))
                    {
                        isVisible = false;
                    }
                    break;
                }
            }

            if (isVisible)
            {
                Mesh* pParticleMesh = pParticle->GetMainRenderObject()->GetMesh();

                VERTEX_3D* verts = (VERTEX_3D*) pParticleMesh->GetVertices();
                u16 * indices = pParticleMesh->GetIndices();

                VERTEX_3D* finalVerts = (VERTEX_3D*) m_pBackgroundParticlesMesh->GetVertices();
                u16 * finalIndices = m_pBackgroundParticlesMesh->GetIndices();

                Vec3 vPos = pParticle->GetPosition();

                MATRIX mtxT;
                MatrixTranslation(mtxT, vPos.x, vPos.y, vPos.z);

                MATRIX mtxR = pParticle->GetRotation();

                int particle_offset_4 = 4 * particleOffset;

                for (int i = 0; i < 4; i++)
                {

                    int offset = particle_offset_4 + i;

                    Vec4 vIn(verts[i].x, verts[i].y, verts[i].z, 1.0f);
                    Vec4 vRotated;
                    Vec4 vOut;

                    TransTransform(&vRotated, &vIn, &mtxR);
                    TransTransform(&vOut, &vRotated, &mtxT);

                    finalVerts[offset].x = vOut.x;
                    finalVerts[offset].y = vOut.y;
                    finalVerts[offset].z = vOut.z;
                    finalVerts[offset].u = verts[i].u;
                    finalVerts[offset].v = verts[i].v;
                }

                int particle_offset_6 = 6 * particleOffset;

                for (int i = 0; i < 6; i++)
                {
                    finalIndices[particle_offset_6 + i] = indices[i] + particle_offset_4;
                }

                particleOffset++;
            }
        }
    }

    if (particleOffset > 0)
    {

        m_pBackgroundParticlesMesh->SetFaceCount(2 * particleOffset);
        m_pBackgroundParticlesMesh->SetVertexCount(4 * particleOffset);

        Renderer::Instance().Add(m_pRenderableBackgroundParticles);
    }
}

//////////////////////////
//////////////////////////

void Backgrounds::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ Backgrounds::Cleanup ...\n");

        SafeDelete(m_pRenderableBackground);
        SafeDelete(m_pRenderableBackgroundParticles);

        SafeDelete(m_pBackgroundParticlesRO);

        MeshManager::Instance().UnloadMesh(m_pBackgroundParticlesMesh);

        InitPointer(m_pBackgroundParticlesMesh);

        for (int i = 0; i < 4; i++)
        {
            SafeDelete(m_pBackground[i]);
        }

        for (int i = 0; i < 4; i++)
        {
            for (int h = 0; h < m_iArraySize[i]; h++)
            {
                SafeDelete(m_pParticleArray[i][h]);
            }

            SafeDeleteArray(m_pParticleArray[i]);
        }

        m_bNeedCleanup = false;

        Log("+++ Backgrounds::Cleanup correcto\n");
    }
}

