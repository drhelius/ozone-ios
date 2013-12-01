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
 * File:   meshmanager.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 0:16
 */

#include "meshmanager.h"
#include "defines.h"

MeshManager::MeshManager()
{
    Log("+++ MeshManager::MeshManager ...\n");

    m_bTextFontCreated = false;
    m_iMeshCounter = 0;

    Log("+++ MeshManager::MeshManager correcto\n");
}

//////////////////////////
//////////////////////////

MeshManager::~MeshManager()
{
    Log("+++ MeshManager::~MeshManager ...\n");

    UnloadAll();

    m_bTextFontCreated = false;
    m_iMeshCounter = 0;

    Log("+++ MeshManager::~MeshManager destruido\n");
}

//////////////////////////
//////////////////////////

Mesh* MeshManager::GetTextFontMesh(void)
{
    if (!m_bTextFontCreated)
    {
        m_TextFontMesh.m_iVertices = TEXT_FONT_MAX_STRING_SIZE * 6;
        m_TextFontMesh.m_VertexFormat = VERTEX_2D_FORMAT;
        m_TextFontMesh.m_bUsingVBOs = false;
        m_TextFontMesh.m_DrawMode = GL_TRIANGLES;
        strcpy(m_TextFontMesh.m_strName, "TEXT_FONT_MESH");

        m_TextFontMesh.m_pVertices = new VERTEX_2D[TEXT_FONT_MAX_STRING_SIZE * 6];

        m_bTextFontCreated = true;
    }

    return &m_TextFontMesh;
};

//////////////////////////
//////////////////////////

bool MeshManager::LoadMesh(Mesh* pMesh, bool useVBO)
{
    Log("+++ MeshManager::LoadMesh Cargando fichero de malla: %s.o3d\n", pMesh->m_strName);

    char* ind = strrchr(pMesh->m_strName, '/');
    char* szName = ind + 1;
    char szPath[256] = {0};
    strncpy(szPath, pMesh->m_strName, ind - pMesh->m_strName);
    szPath[ind - pMesh->m_strName] = 0;

    NSString * OCname = [NSString stringWithCString : szName encoding : [NSString defaultCStringEncoding]];
    NSString * OCpath = [NSString stringWithCString : szPath encoding : [NSString defaultCStringEncoding]];

    NSString * RSCpath = [[NSBundle mainBundle] pathForResource : OCname ofType : @"o3d" inDirectory : OCpath];

    FILE* pFile = fopen([RSCpath cStringUsingEncoding : 1], "r");

    if (pFile == NULL)
    {
        Log("@@@ MeshManager::LoadMesh Imposible abrir fichero de malla: %s.o3d\n", pMesh->m_strName);
        Log("@@@ MeshManager::LoadMesh Cargando Mesh por defecto\n");

        OCname = [NSString stringWithCString : "7x7" encoding : [NSString defaultCStringEncoding]];

        RSCpath = [[NSBundle mainBundle] pathForResource : OCname ofType : @"o3d"];

        pFile = fopen([RSCpath cStringUsingEncoding : 1], "r");
        pMesh->m_bErrorLoading = true;
    }

    if (pFile != NULL)
    {
        pMesh->m_DrawMode = GL_TRIANGLES;
        pMesh->m_bUsingVBOs = useVBO;

        u32 faces = 0;
        u32 vertices = 0;

        fread(&vertices, sizeof (u32), 1, pFile);
        fread(&faces, sizeof (u32), 1, pFile);

        if (useVBO)
        {
            glGenBuffers(2, pMesh->m_vboIDs);
            glBindBuffer(GL_ARRAY_BUFFER, pMesh->m_vboIDs[0]);
        }


        if (faces == 0 && vertices == 0)
        {
            fread(&vertices, sizeof (u32), 1, pFile);
            fread(&faces, sizeof (u32), 1, pFile);

            pMesh->m_VertexFormat = VERTEX_3D_NORMALS_FORMAT;

            VERTEX_3D_NORMALS* pVertexArray = new VERTEX_3D_NORMALS[vertices];
            fread(pVertexArray, sizeof (VERTEX_3D_NORMALS), vertices, pFile);

            if (useVBO)
            {
                glBufferData(GL_ARRAY_BUFFER, vertices * sizeof (VERTEX_3D_NORMALS), pVertexArray, GL_STATIC_DRAW);
                SafeDeleteArray(pVertexArray);

                pMesh->m_pVertices = NULL;
            }
            else
            {
                pMesh->m_pVertices = pVertexArray;
            }

            Log("+++ MeshManager::LoadMesh Leida malla CON normales\n");
        }
        else
        {
            pMesh->m_VertexFormat = VERTEX_3D_FORMAT;

            VERTEX_3D* pVertexArray = new VERTEX_3D[vertices];
            fread(pVertexArray, sizeof (VERTEX_3D), vertices, pFile);

            if (useVBO)
            {
                glBufferData(GL_ARRAY_BUFFER, vertices * sizeof (VERTEX_3D), pVertexArray, GL_STATIC_DRAW);

                SafeDeleteArray(pVertexArray);

                pMesh->m_pVertices = NULL;
            }
            else
            {
                pMesh->m_pVertices = pVertexArray;
            }

            Log("+++ MeshManager::LoadMesh Leida malla SIN normales\n");
        }

        u16* pIndexArray = new u16[faces * 3];
        fread(pIndexArray, sizeof (u16), faces * 3, pFile);

        if (useVBO)
        {
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, pMesh->m_vboIDs[1]);
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, faces * 3 * sizeof (u16), pIndexArray, GL_STATIC_DRAW);

            SafeDeleteArray(pIndexArray);
        }
        else
        {
            pMesh->m_pIndices = pIndexArray;
        }

        pMesh->m_iFaces = faces;
        pMesh->m_iVertices = vertices;

        fclose(pFile);

        glBindBuffer(GL_ARRAY_BUFFER, 0);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

        if (pMesh->m_bErrorLoading)
        {
            Log("@@@ MeshManager::LoadMesh Imposible abrir fichero de malla: %s.o3d\n", pMesh->m_strName);
            //return false;
        }
        else
        {
            Log("+++ MeshManager::LoadMesh Vertices %d, Caras %d\n", vertices, faces);
            Log("+++ MeshManager::LoadMesh Malla cargada correctamente: %s.o3d\n", pMesh->m_strName);
        }
    }

    return true;
}

//////////////////////////
//////////////////////////

void MeshManager::TransformMeshToVBO(Mesh* pMesh)
{
    if (!IsValidPointer(pMesh->m_pIndices))
    {
        Log("@@@ MeshManager::TransformMeshToVBO No hay indices para la malla: %s\n", pMesh->m_strName);
        return;
    }

    if (!IsValidPointer(pMesh->m_pVertices))
    {
        Log("@@@ MeshManager::TransformMeshToVBO No hay vertices para la malla: %s\n", pMesh->m_strName);
        return;
    }

    pMesh->m_bUsingVBOs = true;

    glGenBuffers(2, pMesh->m_vboIDs);
    glBindBuffer(GL_ARRAY_BUFFER, pMesh->m_vboIDs[0]);

    switch (pMesh->m_VertexFormat)
    {
        case VERTEX_3D_FORMAT:
        {
            glBufferData(GL_ARRAY_BUFFER, pMesh->m_iVertices * sizeof (VERTEX_3D), pMesh->m_pVertices, GL_STATIC_DRAW);

            if (pMesh->m_pVertices != NULL)
            {
                delete [] ((VERTEX_3D*) pMesh->m_pVertices);
                pMesh->m_pVertices = NULL;
            }
            break;
        }
        case VERTEX_3D_NORMALS_FORMAT:
        {
            glBufferData(GL_ARRAY_BUFFER, pMesh->m_iVertices * sizeof (VERTEX_3D_NORMALS), pMesh->m_pVertices, GL_STATIC_DRAW);

            if (pMesh->m_pVertices != NULL)
            {
                delete [] ((VERTEX_3D_NORMALS*) pMesh->m_pVertices);
                pMesh->m_pVertices = NULL;
            }
            break;
        }
        case VERTEX_2D_FORMAT:
        {
            glBufferData(GL_ARRAY_BUFFER, pMesh->m_iVertices * sizeof (VERTEX_2D), pMesh->m_pVertices, GL_STATIC_DRAW);

            if (pMesh->m_pVertices != NULL)
            {

                delete [] ((VERTEX_2D*) pMesh->m_pVertices);
                pMesh->m_pVertices = NULL;
            }
            break;
        }
    }

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, pMesh->m_vboIDs[1]);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, pMesh->m_iFaces * 3 * sizeof (u16), pMesh->m_pIndices, GL_STATIC_DRAW);

    SafeDeleteArray(pMesh->m_pIndices);

    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);

    Log("+++ MeshManager::TransformMeshToVBO Malla ha sido transformada correctamente: %s\n", pMesh->m_strName);

}

//////////////////////////
//////////////////////////

Mesh* MeshManager::GetCustomMesh(void)
{
    Mesh* temp = NULL;

    temp = new Mesh();

    sprintf(temp->m_strName, "CUSTOM_MESH_%d", m_iMeshCounter);

    std::string stringMeshName(temp->m_strName);

    TMeshMapPair insertPair(stringMeshName, temp);

    TMeshMapResultPair result = m_MeshMap.insert(insertPair);

    if (result.second)
    {
        ////--- se ha insertado la malla
        Log("+++ MeshManager::GetBoardMesh Se ha insertado la nueva malla %s\n", temp->m_strName);
    }
    else
    {
        ///--- ya existia??? nunca debe entrar aqui
        Log("@@@ MeshManager::GetBoardMesh ERROR GRAVE @@@\n");
    }

    m_iMeshCounter++;

    return temp;
}

//////////////////////////
//////////////////////////

Mesh* MeshManager::GetMeshFromFile(const char* strMeshName, bool useVBO, bool applyEarlyReduction)
{
    Log("+++ MeshManager::GetMeshFromFile Buscando %s.o3d\n", strMeshName);

    TMeshMapIterator lowerBound = m_MeshMap.lower_bound(strMeshName);

    std::string stringMeshName(strMeshName);

    ///--- ya estaba
    if (lowerBound != m_MeshMap.end() &&
            !(m_MeshMap.key_comp()(stringMeshName, lowerBound->first)))
    {
        Log("+++ MeshManager::GetMeshFromFile Ya existia\n");

        return lowerBound->second;
    }
        ///--- no estaba
    else
    {
        Mesh* temp = new Mesh();
        strcpy(temp->m_strName, strMeshName);

        if (LoadMesh(temp, useVBO))
        {
            TMeshMapPair insertPair(stringMeshName, temp);

            TMeshMapIterator result = m_MeshMap.insert(lowerBound, insertPair);

            if (result->second)
            {
                if (applyEarlyReduction)
                {
                    switch (temp->m_VertexFormat)
                    {
                        case VERTEX_3D_FORMAT:
                        {
                            VERTEX_3D* pVerts = (VERTEX_3D*) temp->m_pVertices;
                            for (u32 i = 0; i < temp->m_iVertices; i++)
                            {
                                pVerts[i].x *= (1.0f / 16.0f);
                                pVerts[i].y *= (1.0f / 16.0f);
                                pVerts[i].z *= (1.0f / 16.0f);
                            }
                            break;
                        }
                        case VERTEX_3D_NORMALS_FORMAT:
                        {
                            VERTEX_3D_NORMALS* pVerts = (VERTEX_3D_NORMALS*) temp->m_pVertices;
                            for (u32 i = 0; i < temp->m_iVertices; i++)
                            {
                                pVerts[i].x *= (1.0f / 16.0f);
                                pVerts[i].y *= (1.0f / 16.0f);
                                pVerts[i].z *= (1.0f / 16.0f);
                            }
                            break;
                        }
                        case VERTEX_2D_FORMAT:
                        {
                            VERTEX_2D* pVerts = (VERTEX_2D*) temp->m_pVertices;
                            for (u32 i = 0; i < temp->m_iVertices; i++)
                            {
                                pVerts[i].x *= (1.0f / 16.0f);
                                pVerts[i].y *= (1.0f / 16.0f);
                                pVerts[i].z *= (1.0f / 16.0f);
                            }
                            break;
                        }
                    }
                }

                ////--- se ha insertado la malla
                Log("+++ MeshManager::GetMeshFromFile Se ha insertado la nueva malla\n");
                return temp;
            }
            else
            {
                ///--- ya exist√≠a??? nunca debe entrar aqui
                Log("@@@ MeshManager::GetMeshFromFile ERROR GRAVE @@@\n");
            }
        }
        else
        {
            ///--- no se pudo cargar la malla
            Log("@@@ MeshManager::GetMeshFromFile ERROR No se pudo cargar la malla %s.o3d\n", strMeshName);
        }

        SafeDelete(temp);

        return NULL;
    }
}

//////////////////////////
//////////////////////////

Mesh* MeshManager::GetBoardMesh(void)
{
    Mesh* temp = NULL;

    temp = new Mesh();

    sprintf(temp->m_strName, "BOARD_MESH_%d", m_iMeshCounter);

    temp->m_DrawMode = GL_TRIANGLE_STRIP;
    temp->m_VertexFormat = VERTEX_2D_FORMAT;
    temp->m_bUsingVBOs = false;
    temp->m_iVertices = 4;
    temp->m_pVertices = new VERTEX_2D[4];

    std::string stringMeshName(temp->m_strName);

    TMeshMapPair insertPair(stringMeshName, temp);

    TMeshMapResultPair result = m_MeshMap.insert(insertPair);

    if (result.second)
    {
        ////--- se ha insertado la malla
        Log("+++ MeshManager::GetBoardMesh Se ha insertado la nueva malla BOARD_MESH_%d\n", m_iMeshCounter);
    }
    else
    {
        ///--- ya exist√≠a??? nunca debe entrar aqui
        Log("@@@ MeshManager::GetBoardMesh ERROR GRAVE @@@\n");
    }

    m_iMeshCounter++;

    return temp;
}

//////////////////////////
//////////////////////////

Mesh* MeshManager::GetBoardMesh(float width, float height)
{
    return GetBoardMesh(0.0f, 0.0f, width, height, width, height);
}

//////////////////////////
//////////////////////////

Mesh* MeshManager::GetBoardMesh(float posX, float posY, float width, float height, float texWidht, float texHeight)
{
    return GetBoardMesh(width, height, posX, posX + width, posY, posY + height, texWidht, texHeight);
}

//////////////////////////
//////////////////////////

Mesh* MeshManager::GetBoardMesh(float sizeX, float sizeY, float texX1, float texX2, float texY1, float texY2, float texWidht, float texHeight)
{
    Mesh* temp = GetBoardMesh();
    VERTEX_2D* pVertices = (VERTEX_2D*) temp->GetVertices();

    float txf1 = texX1 / texWidht;
    float tyf2 = texY1 / texHeight;
    float txf2 = texX2 / texWidht;
    float tyf1 = texY2 / texHeight;

    pVertices[0].x = 0.0f;
    pVertices[0].y = 0.0f;
    pVertices[0].z = 0.0f;
    pVertices[0].u = txf1;
    pVertices[0].v = tyf2;

    pVertices[1].x = 0.0f;
    pVertices[1].y = 1.0f * sizeY;
    pVertices[1].z = 0.0f;
    pVertices[1].u = txf1;
    pVertices[1].v = tyf1;

    pVertices[2].x = 1.0f * sizeX;
    pVertices[2].y = 0.0f;
    pVertices[2].z = 0.0f;
    pVertices[2].u = txf2;
    pVertices[2].v = tyf2;

    pVertices[3].x = 1.0f * sizeX;
    pVertices[3].y = 1.0f * sizeY;
    pVertices[3].z = 0.0f;
    pVertices[3].u = txf2;
    pVertices[3].v = tyf1;

    return temp;
}

//////////////////////////
//////////////////////////

bool MeshManager::UnloadMesh(const char* strMeshName)
{
    std::string stringMeshName(strMeshName);

    TMeshMapIterator itor = m_MeshMap.find(stringMeshName);

    ///--- estaba
    if (itor != m_MeshMap.end())
    {
        Log("+++ MeshManager::UnloadMesh Eliminando malla: %s\n", itor->second->m_strName);

        if (itor->second->m_bUsingVBOs)
        {
            glDeleteBuffers(2, itor->second->m_vboIDs);
        }

        SafeDelete(itor->second);

        m_MeshMap.erase(itor);

        return true;
    }
        ///--- no estaba
    else
    {
        Log("@@@ MeshManager::UnloadMesh La malla NO existia\n");

        return false;
    }
}

//////////////////////////
//////////////////////////

bool MeshManager::UnloadMesh(Mesh* pMesh)
{
    if (IsValidPointer(pMesh))
    {
        if (pMesh == &m_TextFontMesh)
        {
            Log("+++ MeshManager::UnloadMesh Eliminando malla font\n");
            VERTEX_2D* pVerts = (VERTEX_2D*) m_TextFontMesh.m_pVertices;
            SafeDeleteArray(pVerts);
            m_TextFontMesh.m_pVertices = NULL;

            return true;
        }

        return UnloadMesh(pMesh->m_strName);
    }
    else
    {
        Log("@@@ MeshManager::UnloadMesh La malla NO existia\n");
        return false;
    }
}

//////////////////////////
//////////////////////////

void MeshManager::UnloadAll(void)
{
    for (TMeshMapIterator i = m_MeshMap.begin(); i != m_MeshMap.end(); i++)
    {
        Log("+++ MeshManager::UnloadAll Eliminando malla: %s\n", i->second->m_strName);

        glDeleteBuffers(2, i->second->m_vboIDs);

        SafeDelete(i->second);
    }

    m_MeshMap.clear();

    Log("+++ MeshManager::UnloadAll Eliminando malla font\n");
    VERTEX_2D* pVerts = (VERTEX_2D*) m_TextFontMesh.m_pVertices;
    SafeDeleteArray(pVerts);
    m_TextFontMesh.m_pVertices = NULL;
    m_bTextFontCreated = false;
}

