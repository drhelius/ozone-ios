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
 * File:   filemesh.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:29
 */

#pragma once
#ifndef _MESH_H
#define	_MESH_H

#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include "texturemanager.h"
#include "defines.h"

class Mesh
{

    friend class MeshManager;

private:

    GLuint m_vboIDs[2];
    u32 m_iFaces;
    u32 m_iVertices;
    eVertexFormat m_VertexFormat;
    char m_strName[256];

    u16* m_pIndices;
    void* m_pVertices;

    bool m_bUsingVBOs;
    bool m_bErrorLoading;

    GLenum m_DrawMode;

public:

    Mesh(void);
    ~Mesh(void);

    void Init(const char* name, u32 iVertices, u32 iFaces, eVertexFormat vertexFormat, GLenum drawMode, bool usingVBOs);

    bool LoadedWithErrors(void) const
    {
        return m_bErrorLoading;
    };

    bool UsingVBOs(void)
    {
        return m_bUsingVBOs;
    }

    GLenum GetDrawMode(void)
    {
        return m_DrawMode;
    }

    GLuint GetVBOvertices(void) const
    {
        return m_vboIDs[0];
    };

    GLuint GetVBOindexes(void) const
    {
        return m_vboIDs[1];
    };

    u32 GetFaceCount(void) const
    {
        return m_iFaces;
    };

    void SetFaceCount(u32 count)
    {
        m_iFaces = count;
    };

    u32 GetVertexCount(void) const
    {
        return m_iVertices;
    };

    void SetVertexCount(u32 count)
    {
        m_iVertices = count;
    };

    eVertexFormat VertexFormat(void) const
    {
        return m_VertexFormat;
    };

    const char* GetName(void) const
    {
        return m_strName;
    };

    void* GetVertices(void)
    {
        return m_pVertices;
    }

    u16* GetIndices(void)
    {
        return m_pIndices;
    }

    void SetVertices(void* pVertices)
    {
        m_pVertices = pVertices;
    }

    void SetIndices(u16* pIndices)
    {
        m_pIndices = pIndices;
    }
};

#endif	/* _MESH_H */

