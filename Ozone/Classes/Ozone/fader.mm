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
 *  Fader.cpp
 *  PuzzleStar
 *
 *  Created by nacho on 10/11/08.
 *  Copyright 2008 d. All rights reserved.
 *
 */

#include "fader.h"
#include "meshmanager.h"

//--------------------------------------------------------------------
// Funci‚àö√µn:    CFade::CFade
// Creador:    Nacho (AMD)
// Fecha:      Wednesday  13/06/2007  14:38:15
//--------------------------------------------------------------------

Fader::Fader(void) : Renderable()
{
    Log("+++ Fader::Fader ...\n");

    m_RenderObject.Init(MeshManager::Instance().GetBoardMesh(), NULL, RENDER_OBJECT_TRANSPARENT);
    m_RenderObject.UseColor(true);

    Reset();

    VERTEX_2D* pVerts = (VERTEX_2D*) m_RenderObject.GetMesh()->GetVertices();

    pVerts[0].x = 0.0f;
    pVerts[0].y = 0.0f;
    pVerts[0].z = 0.0f;
    pVerts[1].x = 0.0f;
    pVerts[1].y = IPHONE_SCREEN_HEIGHT;
    pVerts[1].z = 0.0f;
    pVerts[2].x = IPHONE_SCREEN_HEIGHT;
    pVerts[2].y = 0.0f;
    pVerts[2].z = 0.0f;
    pVerts[3].x = IPHONE_SCREEN_HEIGHT;
    pVerts[3].y = IPHONE_SCREEN_HEIGHT;
    pVerts[3].z = 0.0f;

    m_RenderObjectList.push_back(&m_RenderObject);

    Log("+++ Fader::Fader correcto\n");
}


//--------------------------------------------------------------------
// Funci‚àö√µn:    CFade::~CFade
// Creador:    Nacho (AMD)
// Fecha:      Wednesday  13/06/2007  14:38:17
//--------------------------------------------------------------------

Fader::~Fader(void)
{
    Log("+++ Fader::~Fader ...\n");

    Log("+++ Fader::~Fader destruido\n");
}

void Fader::Reset(void)
{
    m_bPaused = false;
    m_bEnabled = true;
    m_bIs3D = false;
    m_fRed = 0.0f;
    m_fGreen = 0.0f;
    m_fBlue = 0.0f;
    m_fFadeState = 0.0f;
    m_bFadeIn = true;
    m_bFadeActive = false;
    m_fFadeTime = 0.0f;
    m_fTarget = 0.0f;
    m_fAlpha = 0.0f;

    m_RenderObject.SetColor(m_fRed, m_fGreen, m_fBlue, 0.0f);
}


//--------------------------------------------------------------------
// Funci‚àö√µn:    CFade::StartFade
// Creador:    Nacho (AMD)
// Fecha:      Thursday  14/06/2007  11:43:04
//--------------------------------------------------------------------

void Fader::StartFade(float red, float green, float blue, bool fadein, float time, float z, float end, float begin, bool additive)
{
    m_fBegin = begin;
    m_fTarget = end;
    m_bFadeActive = true;
    m_bPaused = false;
    m_bFadeIn = fadein;
    m_fFadeState = 0.0f;
    m_fFadeTime = time;
    m_fRed = red;
    m_fGreen = green;
    m_fBlue = blue;

    m_RenderObject.SetPosition(0.0f, 0.0f, z);
    m_RenderObject.SetColor(m_fRed, m_fGreen, m_fBlue, 0.0f);

    if (additive)
    {
        m_RenderObject.SetType(RENDER_OBJECT_ADDITIVE);
    }
    else
    {
        m_RenderObject.SetType(RENDER_OBJECT_TRANSPARENT);
    }
}


//--------------------------------------------------------------------
// Funci‚àö√µn:    CFade::Update
// Creador:    Nacho (AMD)
// Fecha:      Thursday  14/06/2007  11:56:53
//--------------------------------------------------------------------

void Fader::Update(float dt)
{
    if (m_bEnabled && (m_fFadeTime > 0.0f))
    {
        if (!m_bPaused)
        {
            m_fFadeState += dt;
        }

        if (m_fFadeState >= m_fFadeTime)
        {
            m_bFadeActive = false;
        }

        ///--- fade in
        if (m_bFadeIn)
        {
            m_fAlpha = 1.0f - (m_fFadeState / m_fFadeTime);
        }
            ///--- fade out
        else
        {
            m_fAlpha = m_fFadeState / m_fFadeTime;
        }

        m_fAlpha = MAT_Clampf(m_fAlpha, m_fBegin, m_fTarget);

        if (m_fAlpha > 0.0f)
        {
            m_RenderObject.SetColor(m_fRed, m_fGreen, m_fBlue, m_fAlpha);

            Renderer::Instance().Add(this);
        }
    }
}
