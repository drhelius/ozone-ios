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
 * File:   decoration.cpp
 * Author: nacho
 * 
 * Created on 9 de abril de 2009, 13:47
 */

#include "decoration.h"
#include "meshmanager.h"
#include "texturemanager.h"

Decoration::Decoration(void) : NPC()
{
}

Decoration::~Decoration()
{
}

void Decoration::Init(stDECO_CONFIG_FILE& deco_config, const char* szEpisode, int rotation, short width, short height)
{
    eRenderObjectType opacity = RENDER_OBJECT_NORMAL;

    float finalRot = MAT_ToRadians(rotation * 90.0f);

    MatrixRotationY(m_mtxRotation, finalRot);
    m_MainRenderObject.SetTransform(m_mtxRotation);

    switch (deco_config.opacity)
    {
        case DECO_OPACITY_NO:
        {
            m_bStaticLevel = true;
            m_bEnable = false;
            opacity = RENDER_OBJECT_NORMAL;
            break;
        }
        case DECO_OPACITY_TRANSPARENT:
        {
            opacity = RENDER_OBJECT_TRANSPARENT;
            break;
        }
        case DECO_OPACITY_ADDITIVE:
        {
            opacity = RENDER_OBJECT_ADDITIVE;
            break;
        }
    }

    if (deco_config.pMesh == NULL)
    {
        char mesh[100];
        sprintf(mesh, "game/episodes/%s/%s/%s", szEpisode, "decorations", deco_config.mesh);
        deco_config.pMesh = MeshManager::Instance().GetMeshFromFile(mesh, !m_bStaticLevel);
    }

    if (deco_config.pTexture == NULL)
    {
        char texture[100];
        sprintf(texture, "game/episodes/%s/%s/%s", szEpisode, "decorations", deco_config.texture);
        deco_config.pTexture = TextureManager::Instance().GetTexture(texture, true);
    }

    m_MainRenderObject.Init(deco_config.pMesh, deco_config.pTexture, opacity);
    m_MainRenderObject.SetPosition(this->GetPosition());

    if (!m_bStaticLevel)
    {
        m_RenderObjectList.push_back(&m_MainRenderObject);
    }
}


