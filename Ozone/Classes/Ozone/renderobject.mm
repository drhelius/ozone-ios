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
 *  renderobject.cpp
 *  Ozone
 *
 *  Created by nacho on 10/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "renderobject.h"

RenderObject::RenderObject(void)
{
    MatrixIdentity(m_mtxTransform);
    MatrixIdentity(m_mtxTextureTransform);
    m_Type = RENDER_OBJECT_NORMAL;
    InitPointer(m_pTexture);
    InitPointer(m_pMesh);
    InitPointer(m_pCustomCamera);
    m_bUseTextureTransform = false;
    m_bUseDepthTest = true;
    m_bUseColor = false;
    m_bActive = true;
    m_CullMode = RENDER_OBJECT_CULL_BACK;

    SetColor(1.0f, 1.0f, 1.0f, 1.0f);
}

//////////////////////////
//////////////////////////

Vec3 RenderObject::GetPosition(void) const
{
    return Vec3(m_mtxTransform.f[_41], m_mtxTransform.f[_42], m_mtxTransform.f[_43]);
}

//////////////////////////
//////////////////////////

void RenderObject::Init(Mesh* pMesh, Texture* pTexture, eRenderObjectType type)
{
    m_Type = type;
    m_pMesh = pMesh;

    if (IsValidPointer(m_pMesh) && m_pMesh->LoadedWithErrors())
    {        
        m_pTexture = TextureManager::Instance().GetTexture("/missing_model", true);
    }
    else
    {
        m_pTexture = pTexture;
    }
}

//////////////////////////
//////////////////////////

void RenderObject::SetPosition(float x, float y, float z)
{
    m_mtxTransform.f[_41] = x;
    m_mtxTransform.f[_42] = y;
    m_mtxTransform.f[_43] = z;
}

//////////////////////////
//////////////////////////

void RenderObject::SetPosition(const Vec3& pos)
{
    m_mtxTransform.f[_41] = pos.x;
    m_mtxTransform.f[_42] = pos.y;
    m_mtxTransform.f[_43] = pos.z;
}

