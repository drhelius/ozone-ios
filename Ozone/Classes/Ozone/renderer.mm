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
 * File:   renderer.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:30
 */

#include <typeinfo>
#include "textfont.h"
#include "renderer.h"
#include "renderable.h"
#include "renderobject.h"
#include "physicsmanager.h"

Camera* Renderer::ms_pCamera3D = NULL;
Camera* Renderer::ms_pCamera2D = NULL;

//////////////////////////
//////////////////////////

Renderer::Renderer(void) : m_iScreenWidth(IPHONE_SCREEN_WIDTH), m_iScreenHeight(IPHONE_SCREEN_HEIGHT)
{
    Log("+++ Renderer::Renderer ...\n");

    m_bIsClean = true;

    Log("+++ Renderer::Renderer correcto\n");
}

//////////////////////////
//////////////////////////

Renderer::~Renderer()
{
    Log("+++ Renderer::~Renderer ...\n");

    Cleanup();

    Log("+++ Renderer::~Renderer destruido\n");
}

//////////////////////////
//////////////////////////

void Renderer::Init(EAGLContext* pContext, GLuint renderBuffer,
        GLuint frameBuffer, GLuint depthBuffer)
{
    Log("+++ Renderer::Init ...\n");

    m_pContext = pContext;
    m_gluiViewRenderbuffer = renderBuffer;
    m_gluiViewFramebuffer = frameBuffer;
    m_gluiDepthRenderbuffer = depthBuffer;

    m_bIsClean = false;

    m_bClearingScreen = false;

    InitPointer(m_pCurrentTexture);
    InitPointer(m_pCurrentMesh);
    InitPointer(m_pCurrentRenderLayer);
    m_CurrentColor.r = 1.0f;
    m_CurrentColor.g = 1.0f;
    m_CurrentColor.b = 1.0f;
    m_CurrentColor.a = 1.0f;

    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    glEnable(GL_TEXTURE_2D);
    glDepthFunc(DEFAULT_DEPTH_FUNC);
    glColor4f(1.0f, 1.0f, 1.0f, 1.0f);

    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);

    Log("+++ Renderer::Init correcto\n");
}

//////////////////////////
//////////////////////////

void Renderer::Cleanup(void)
{
    if (!m_bIsClean)
    {
        Log("+++ Renderer::Cleanup ...\n");

        m_bIsClean = true;

        Log("+++ Renderer::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void Renderer::BeginRender(void)
{
    m_iDrawCalls = 0;
    m_iPolyCount = 0;

    [EAGLContext setCurrentContext : m_pContext];

    glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_gluiViewFramebuffer);
    glViewport(0, 0, m_iScreenWidth, m_iScreenHeight);

    if (m_bClearingScreen)
    {
        glClear(GL_COLOR_BUFFER_BIT);
    }

    //glEnableClientState(GL_VERTEX_ARRAY);
    //glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}

//////////////////////////
//////////////////////////

void Renderer::EndRender(void)
{
    //glDisableClientState(GL_VERTEX_ARRAY);
    //glDisableClientState(GL_TEXTURE_COORD_ARRAY);

    GLenum attachments[] = { GL_DEPTH_ATTACHMENT_OES, GL_STENCIL_ATTACHMENT_OES };
    glDiscardFramebufferEXT(GL_FRAMEBUFFER_OES, 2, attachments);

    glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_gluiViewRenderbuffer);
    [m_pContext presentRenderbuffer : GL_RENDERBUFFER_OES];
}

//////////////////////////
//////////////////////////

bool SortByTexturePredicate(const RenderObject* lhs, const RenderObject* rhs)
{
    return strcmp(lhs->GetTexture()->GetName(), rhs->GetTexture()->GetName()) < 0;
}

//////////////////////////
//////////////////////////

bool SortByZPredicate(RenderObject* lhs, RenderObject* rhs)
{
    return lhs->GetPosition().z < rhs->GetPosition().z;
}

//////////////////////////
//////////////////////////

bool Renderer::SortByDistanceToCameraPredicate(RenderObject* lhs, RenderObject* rhs)
{
    Vec3 camera = ms_pCamera3D->GetPosition();
    Vec3 lhsPos = lhs->GetPosition();
    Vec3 rhsPos = rhs->GetPosition();

    Vec3 vecDistLHS = (camera - lhsPos);
    float distSqrLHS = vecDistLHS.lenSqr();

    Vec3 vecDistRHS = (camera - rhsPos);
    float distSqrRHS = vecDistRHS.lenSqr();

    return distSqrLHS > distSqrRHS;
}

//////////////////////////
//////////////////////////

void Renderer::Render(void)
{
    //BeginRender();

    for (TRenderLayerMapIterator i = m_RenderLayerMap.begin(); i != m_RenderLayerMap.end(); i++)
    {
        m_pCurrentRenderLayer = &i->second;

        glClear(GL_DEPTH_BUFFER_BIT);

        if (m_pCurrentRenderLayer->is3D)
        {
            ms_pCamera3D->Update();

            m_pCurrentRenderLayer->renderList[NORMAL_RENDER_LIST].sort(SortByTexturePredicate);
            m_pCurrentRenderLayer->renderList[TRANSPARENT_RENDER_LIST].sort(SortByDistanceToCameraPredicate);

            DrawLists3D();
        }
        else
        {
            ms_pCamera2D->Update();

            m_pCurrentRenderLayer->renderList[NORMAL_RENDER_LIST].sort(SortByTexturePredicate);
            m_pCurrentRenderLayer->renderList[TRANSPARENT_RENDER_LIST].sort(SortByZPredicate);

            DrawLists2D();
        }

        ClearLists();
    }

#ifdef DEBUG_PHYSICS
    if (PhysicsManager::Instance().GetDynamicsWorld())
    {
        glDisable(GL_TEXTURE_2D);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
        glClear(GL_DEPTH_BUFFER_BIT);

        ms_pCamera3D->Update();

        PhysicsManager::Instance().GetDynamicsWorld()->debugDrawWorld();

        glEnable(GL_TEXTURE_2D);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);

        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    }
#endif

    //EndRender();
}

//////////////////////////
//////////////////////////

void Renderer::DrawLists3D(void)
{
    glMatrixMode(GL_TEXTURE);
    glLoadIdentity();
    glScalef(1.0f / 512.0f, -1.0f / 512.0f, 1.0f / 512.0f);

    glMatrixMode(GL_MODELVIEW);

    for (TRenderObjectListIterator j = m_pCurrentRenderLayer->renderList[NORMAL_RENDER_LIST].begin(); j != m_pCurrentRenderLayer->renderList[NORMAL_RENDER_LIST].end(); j++)
    {
        DoRenderObject3D(*j);
    }

    glDepthMask(GL_FALSE);
    glEnable(GL_BLEND);

    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    bool transparentCache = true;

    for (TRenderObjectListIterator j = m_pCurrentRenderLayer->renderList[TRANSPARENT_RENDER_LIST].begin(); j != m_pCurrentRenderLayer->renderList[TRANSPARENT_RENDER_LIST].end(); j++)
    {
        RenderObject* pRO = (*j);

        if ((pRO->GetType() == RENDER_OBJECT_ADDITIVE))
        {
            if (transparentCache)
            {
                glBlendFunc(GL_SRC_ALPHA, GL_ONE);
                transparentCache = false;
            }
        }
        else
        {
            if (!transparentCache)
            {
                glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                transparentCache = true;
            }
        }

        DoRenderObject3D(pRO);
    }

    glDepthMask(GL_TRUE);
    glDisable(GL_BLEND);
}

//////////////////////////
//////////////////////////

void Renderer::DrawLists2D(void)
{
    glMatrixMode(GL_TEXTURE);
    glLoadIdentity();

    glMatrixMode(GL_MODELVIEW);

    for (TRenderObjectListIterator j = m_pCurrentRenderLayer->renderList[NORMAL_RENDER_LIST].begin(); j != m_pCurrentRenderLayer->renderList[NORMAL_RENDER_LIST].end(); j++)
    {
        DoRenderObject2D(*j);
    }

    glDepthMask(GL_FALSE);
    glEnable(GL_BLEND);

    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    bool transparentCache = true;

    for (TRenderObjectListIterator j = m_pCurrentRenderLayer->renderList[TRANSPARENT_RENDER_LIST].begin(); j != m_pCurrentRenderLayer->renderList[TRANSPARENT_RENDER_LIST].end(); j++)
    {
        RenderObject* pRO = (*j);

        if ((pRO->GetType() == RENDER_OBJECT_ADDITIVE))
        {
            if (transparentCache)
            {
                glBlendFunc(GL_SRC_ALPHA, GL_ONE);
                transparentCache = false;
            }
        }
        else
        {
            if (!transparentCache)
            {
                glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
                transparentCache = true;
            }
        }

        DoRenderObject2D(pRO);
    }

    glDepthMask(GL_TRUE);
    glDisable(GL_BLEND);
}

//////////////////////////
//////////////////////////

void Renderer::DoRenderObject2D(RenderObject* pRO)
{
    if (IsValidPointer(pRO->m_pCustomCamera))
    {
        pRO->m_pCustomCamera->Update();
    }

    if (!pRO->m_bUseDepthTest)
    {
        glDepthFunc(GL_ALWAYS);
    }

    if (pRO->m_bUseColor)
    {
        if (m_CurrentColor.r != pRO->m_Color.r || m_CurrentColor.g != pRO->m_Color.g ||
                m_CurrentColor.b != pRO->m_Color.b || m_CurrentColor.a != pRO->m_Color.a)
        {
            m_CurrentColor.r = pRO->m_Color.r;
            m_CurrentColor.g = pRO->m_Color.g;
            m_CurrentColor.b = pRO->m_Color.b;
            m_CurrentColor.a = pRO->m_Color.a;
            glColor4f(m_CurrentColor.r, m_CurrentColor.g, m_CurrentColor.b, m_CurrentColor.a);
        }
    }
    else if (m_CurrentColor.r != 1.0f || m_CurrentColor.g != 1.0f ||
            m_CurrentColor.b != 1.0f || m_CurrentColor.a != 1.0f)
    {
        m_CurrentColor.r = 1.0f;
        m_CurrentColor.g = 1.0f;
        m_CurrentColor.b = 1.0f;
        m_CurrentColor.a = 1.0f;
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    }

    BindTexture(pRO);
    BindMesh(pRO);

    if (pRO->m_Type == RENDER_OBJECT_TEXT)
    {
        pRO->m_TextFontContext.pFont->UpdateTextMesh(pRO->m_TextFontContext.text);
    }

    glPushMatrix();
    glMultMatrixf(pRO->m_mtxTransform.f);

    if (pRO->m_bUseTextureTransform)
    {
        glMatrixMode(GL_TEXTURE);
        glPushMatrix();
        glLoadMatrixf(pRO->m_mtxTextureTransform.f);
    }

    if (m_pCurrentMesh->UsingVBOs())
    {

    }
    else
    {
        VERTEX_2D* pVerts = (VERTEX_2D*) m_pCurrentMesh->GetVertices();
        glVertexPointer(3, GL_FLOAT, sizeof (VERTEX_2D), &pVerts[0].x);
        glTexCoordPointer(2, GL_FLOAT, sizeof (VERTEX_2D), &pVerts[0].u);
        glDrawArrays(m_pCurrentMesh->GetDrawMode(), 0, m_pCurrentMesh->GetVertexCount());
    }

    if (pRO->m_bUseTextureTransform)
    {
        glPopMatrix();
        glMatrixMode(GL_MODELVIEW);
    }

    glPopMatrix();

    if (!pRO->m_bUseDepthTest)
    {
        glDepthFunc(DEFAULT_DEPTH_FUNC);
    }

    if (IsValidPointer(pRO->m_pCustomCamera))
    {
        ms_pCamera3D->Update();
    }
}

//////////////////////////
//////////////////////////

void Renderer::DoRenderObject3D(RenderObject* pRO)
{
    if (IsValidPointer(pRO->m_pCustomCamera))
    {
        pRO->m_pCustomCamera->Update();
    }

    if (pRO->m_CullMode != RENDER_OBJECT_CULL_BACK)
    {
        switch (pRO->m_CullMode)
        {
            case RENDER_OBJECT_CULL_FRONT:
            {
                glCullFace(GL_FRONT);
                break;
            }
            case RENDER_OBJECT_CULL_DISABLED:
            {
                glDisable(GL_CULL_FACE);
                break;
            }
        }
    }

    if (!pRO->m_bUseDepthTest)
    {
        glDepthFunc(GL_ALWAYS);
    }

    if (pRO->m_bUseColor)
    {
        if (m_CurrentColor.r != pRO->m_Color.r || m_CurrentColor.g != pRO->m_Color.g ||
                m_CurrentColor.b != pRO->m_Color.b || m_CurrentColor.a != pRO->m_Color.a)
        {
            m_CurrentColor.r = pRO->m_Color.r;
            m_CurrentColor.g = pRO->m_Color.g;
            m_CurrentColor.b = pRO->m_Color.b;
            m_CurrentColor.a = pRO->m_Color.a;
            glColor4f(m_CurrentColor.r, m_CurrentColor.g, m_CurrentColor.b, m_CurrentColor.a);
        }
    }
    else if (m_CurrentColor.r != 1.0f || m_CurrentColor.g != 1.0f ||
            m_CurrentColor.b != 1.0f || m_CurrentColor.a != 1.0f)
    {
        m_CurrentColor.r = 1.0f;
        m_CurrentColor.g = 1.0f;
        m_CurrentColor.b = 1.0f;
        m_CurrentColor.a = 1.0f;
        glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
    }

    BindTexture(pRO);
    BindMesh(pRO);

    glPushMatrix();
    glMultMatrixf(pRO->m_mtxTransform.f);

    if (m_pCurrentMesh->UsingVBOs())
        glScalef(1.0f / 16.0f, 1.0f / 16.0f, 1.0f / 16.0f);

    if (pRO->m_bUseTextureTransform)
    {
        glMatrixMode(GL_TEXTURE);
        glPushMatrix();
        glLoadMatrixf(pRO->m_mtxTextureTransform.f);
        glScalef(1.0f / 512.0f, -1.0f / 512.0f, 1.0f / 512.0f);
    }

    if (m_pCurrentMesh->UsingVBOs())
    {
        switch (m_pCurrentMesh->VertexFormat())
        {
            case VERTEX_3D_FORMAT:
            {
                glVertexPointer(3, GL_SHORT, sizeof (VERTEX_3D), 0);
                glTexCoordPointer(2, GL_SHORT, sizeof (VERTEX_3D), ((char*) NULL + (4 * sizeof (GLshort))));
                break;
            }
            case VERTEX_3D_NORMALS_FORMAT:
            {
                break;
            }
            case VERTEX_2D_FORMAT:
            {
                break;
            }
        }

        glDrawElements(m_pCurrentMesh->GetDrawMode(), m_pCurrentMesh->GetFaceCount() * 3, GL_UNSIGNED_SHORT, 0);
    }
    else
    {
        switch (m_pCurrentMesh->VertexFormat())
        {
            case VERTEX_3D_FORMAT:
            {
                VERTEX_3D* pVerts = (VERTEX_3D*) m_pCurrentMesh->GetVertices();
                glVertexPointer(3, GL_SHORT, sizeof (VERTEX_3D), &pVerts[0].x);
                glTexCoordPointer(2, GL_SHORT, sizeof (VERTEX_3D), &pVerts[0].u);
                break;
            }
            case VERTEX_3D_NORMALS_FORMAT:
            {
                break;
            }
            case VERTEX_2D_FORMAT:
            {
                break;
            }
        }

        glDrawElements(m_pCurrentMesh->GetDrawMode(), m_pCurrentMesh->GetFaceCount() * 3, GL_UNSIGNED_SHORT, m_pCurrentMesh->GetIndices());

    }

    if (pRO->m_bUseTextureTransform)
    {
        glPopMatrix();
        glMatrixMode(GL_MODELVIEW);
    }

    glPopMatrix();

    if (!pRO->m_bUseDepthTest)
    {
        glDepthFunc(DEFAULT_DEPTH_FUNC);
    }

    if (pRO->m_CullMode != RENDER_OBJECT_CULL_BACK)
    {
        switch (pRO->m_CullMode)
        {
            case RENDER_OBJECT_CULL_FRONT:
            {
                glCullFace(GL_BACK);
                break;
            }
            case RENDER_OBJECT_CULL_DISABLED:
            {
                glEnable(GL_CULL_FACE);
                break;
            }
        }
    }

    if (IsValidPointer(pRO->m_pCustomCamera))
    {
        ms_pCamera3D->Update();
    }
}

//////////////////////////
//////////////////////////

void Renderer::BindTexture(RenderObject* pRO)
{
    if (m_pCurrentTexture != pRO->m_pTexture)
    {
        m_pCurrentTexture = pRO->m_pTexture;

        if (m_pCurrentTexture)
        {
            glBindTexture(GL_TEXTURE_2D, m_pCurrentTexture->GetID());
        }
        else
        {
            glBindTexture(GL_TEXTURE_2D, 0);
        }
    }
}

//////////////////////////
//////////////////////////

void Renderer::BindMesh(RenderObject* pRO)
{
    if (m_pCurrentMesh != pRO->m_pMesh)
    {
        m_pCurrentMesh = pRO->m_pMesh;

        if (m_pCurrentMesh->UsingVBOs())
        {
            glBindBuffer(GL_ARRAY_BUFFER, m_pCurrentMesh->GetVBOvertices());
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, m_pCurrentMesh->GetVBOindexes());
        }
        else
        {
            glBindBuffer(GL_ARRAY_BUFFER, 0);
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
        }
    }
}

//////////////////////////
//////////////////////////

void Renderer::Add(Renderable* pRenderable)
{
    int layer = pRenderable->GetLayer();
    bool is3D = pRenderable->Is3D();

    TRenderLayerMapIterator lowerBound = m_RenderLayerMap.lower_bound(layer);

    stRenderLayer* pRenderLayer = NULL;

    ///--- ya estaba
    if (lowerBound != m_RenderLayerMap.end() &&
            !(m_RenderLayerMap.key_comp()(layer, lowerBound->first)))
    {
        pRenderLayer = &lowerBound->second;
    }
        ///--- no estaba
    else
    {
        stRenderLayer tempRenderLayer;
        tempRenderLayer.is3D = is3D;

        TRenderLayerMapPair insertPair(layer, tempRenderLayer);
        TRenderLayerMapIterator result = m_RenderLayerMap.insert(lowerBound, insertPair);

        pRenderLayer = &result->second;
    }

    for (TRenderObjectListIterator i = pRenderable->m_RenderObjectList.begin(); i != pRenderable->m_RenderObjectList.end(); i++)
    {
        RenderObject* pObject = *i;

        if (pObject->IsActive())
        {
            int list = NORMAL_RENDER_LIST;

            switch (pObject->m_Type)
            {
                case RENDER_OBJECT_NORMAL:
                {
                    list = NORMAL_RENDER_LIST;
                    break;
                }
                case RENDER_OBJECT_TRANSPARENT:
                case RENDER_OBJECT_ADDITIVE:
                case RENDER_OBJECT_TEXT:
                {
                    list = TRANSPARENT_RENDER_LIST;
                    break;
                }
            }

            pRenderLayer->renderList[list].push_back(pObject);

            m_iDrawCalls++;
            m_iPolyCount += pObject->GetMesh()->GetFaceCount();
        }
    }
}

//////////////////////////
//////////////////////////

void Renderer::ClearLists(void)
{
    for (int i = 0; i < RENDER_LIST_COUNT; i++)
    {
        m_pCurrentRenderLayer->renderList[i].clear();
    }
}

//////////////////////////
//////////////////////////

void Renderer::SetClearColor(float r, float g, float b, float alpha)
{
    glClearColor(r, g, b, alpha);
}

//////////////////////////
//////////////////////////

void Renderer::SetClearColor(const COLOR& color)
{
    glClearColor(color.r, color.g, color.b, color.a);
}

//////////////////////////
//////////////////////////

void Renderer::EnableClearColor(bool enable)
{
    m_bClearingScreen = enable;
}





