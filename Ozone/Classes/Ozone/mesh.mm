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
 * File:   filemesh.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:29
 */

#include "mesh.h"

Mesh::Mesh(void)
{
    Log("+++ Mesh::Mesh ...\n");

    m_vboIDs[0] = 0;
    m_vboIDs[1] = 0;
    m_iFaces = 0;
    m_iVertices = 0;

    m_VertexFormat = VERTEX_3D_FORMAT;

    InitPointer(m_pIndices);
    InitPointer(m_pVertices);

    m_bUsingVBOs = false;
    m_bErrorLoading = false;

    m_DrawMode = GL_TRIANGLES;

    Log("+++ Mesh::Mesh correcto\n");
}

//////////////////////////
//////////////////////////

Mesh::~Mesh(void)
{
    Log("+++ Mesh::~Mesh ...\n");

    SafeDeleteArray(m_pIndices);

    switch (m_VertexFormat)
    {
        case VERTEX_3D_FORMAT:
        {
            VERTEX_3D* pVerts = (VERTEX_3D*) m_pVertices;
            SafeDeleteArray(pVerts);
            m_pVertices = NULL;
            break;
        }
        case VERTEX_3D_NORMALS_FORMAT:
        {
            VERTEX_3D_NORMALS* pVerts = (VERTEX_3D_NORMALS*) m_pVertices;
            SafeDeleteArray(pVerts);
            m_pVertices = NULL;
            break;
        }
        case VERTEX_2D_FORMAT:
        {
            VERTEX_2D* pVerts = (VERTEX_2D*) m_pVertices;
            SafeDeleteArray(pVerts);
            m_pVertices = NULL;
            break;
        }
    }

    Log("+++ Mesh::~Mesh destruido\n");
}

//////////////////////////
//////////////////////////

void Mesh::Init(const char* name, u32 iVertices, u32 iFaces, eVertexFormat vertexFormat, GLenum drawMode, bool usingVBOs)
{
    m_iFaces = iFaces;
    m_iVertices = iVertices;

    m_VertexFormat = vertexFormat;

    m_bUsingVBOs = usingVBOs;

    m_DrawMode = drawMode;

    strcpy(m_strName, name);
}



