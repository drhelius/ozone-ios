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
 *  renderobject.h
 *  Ozone
 *
 *  Created by nacho on 10/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _RENDEROBJECT_H
#define	_RENDEROBJECT_H

#include "mesh.h"
#include "texture.h"
#include "renderer.h"
#include "Matrix.h"
#include "camera.h"

enum eRenderObjectType
{

    RENDER_OBJECT_NORMAL,
    RENDER_OBJECT_TRANSPARENT,
    RENDER_OBJECT_ADDITIVE,
    RENDER_OBJECT_TEXT
};

enum eRenderObjectCullMode
{

    RENDER_OBJECT_CULL_FRONT,
    RENDER_OBJECT_CULL_BACK,
    RENDER_OBJECT_CULL_DISABLED
};

class RenderObject
{

    friend class Renderer;

protected:

    MATRIX m_mtxTransform;
    MATRIX m_mtxTextureTransform;

    COLOR m_Color;

    eRenderObjectCullMode m_CullMode;

    bool m_bActive;

    bool m_bUseTextureTransform;
    bool m_bUseDepthTest;
    bool m_bUseColor;

    eRenderObjectType m_Type;

    Texture* m_pTexture;
    Mesh* m_pMesh;

    TextFontContext m_TextFontContext;

    Camera* m_pCustomCamera;

public:

    RenderObject(void);

    void SetCullMode(eRenderObjectCullMode cullMode)
    {
        m_CullMode = cullMode;
    };

    eRenderObjectCullMode GetCullMode(void)
    {
        return m_CullMode;
    };

    void Activate(const bool activate)
    {
        m_bActive = activate;
    };

    bool IsActive(void) const
    {
        return m_bActive;
    };

    eRenderObjectType GetType(void) const
    {
        return m_Type;
    };

    void SetType(eRenderObjectType type)
    {
        m_Type = type;
    };

    TextFontContext GetTextFontContext(void) const
    {
        return m_TextFontContext;
    };

    void SetTextFontContext(TextFontContext context)
    {
        m_TextFontContext = context;
    };

    bool IsUsingColor(void) const
    {
        return m_bUseColor;
    };

    void UseColor(bool useColor)
    {
        m_bUseColor = useColor;
    };

    bool IsUsingDepthTest(void) const
    {
        return m_bUseDepthTest;
    };

    void UseDepthTest(bool useDepthTest)
    {
        m_bUseDepthTest = useDepthTest;
    };

    bool IsUsingTextureMatrix(void) const
    {
        return m_bUseTextureTransform;
    };

    void UseTextureMatrix(bool useMatrix)
    {
        m_bUseTextureTransform = useMatrix;
    };

    Texture* GetTexture(void) const
    {
        return m_pTexture;
    };

    void SetTexture(Texture* pTexture)
    {
        m_pTexture = pTexture;
    };

    MATRIX& GetTransform(void)
    {
        return m_mtxTransform;
    };

    void SetTransform(MATRIX& matrix)
    {
        m_mtxTransform = matrix;
    };

    MATRIX& GetTextureTransform(void)
    {
        return m_mtxTextureTransform;
    };

    void SetTextureTransform(MATRIX& matrix)
    {
        m_mtxTextureTransform = matrix;
    };

    Mesh* GetMesh(void) const
    {
        return m_pMesh;
    };

    Camera* GetCustomCamera(void)
    {
        return m_pCustomCamera;
    }

    void SetCustomCamera(Camera* camera)
    {
        m_pCustomCamera = camera;
    }

    void Init(Mesh* pMesh, Texture* pTexture, eRenderObjectType type);

    Vec3 GetPosition(void) const;
    void SetPosition(const Vec3& pos);
    void SetPosition(float x, float y, float z);

    COLOR& GetColor(void)
    {
        return m_Color;
    };

    void SetColor(COLOR& color)
    {
        m_Color = color;
    };

    void SetColor(float r, float g, float b, float a)
    {
        m_Color.r = r;
        m_Color.g = g;
        m_Color.b = b;
        m_Color.a = a;
    };
};

#endif	/* _RENDEROBJECT_H */