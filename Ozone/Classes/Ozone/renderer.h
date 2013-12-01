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
 * File:   renderer.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:30
 */

#pragma once
#ifndef _RENDERER_H
#define	_RENDERER_H

#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include <list>
#include <map>
#include <algorithm>
#include "defines.h"
#include "singleton.h"
#include "mesh.h"
#include "texture.h"
#include "camera.h"

#define DEFAULT_DEPTH_FUNC GL_LESS

class Renderable;
class RenderObject;

class Renderer : public Singleton<Renderer>
{

    ////friend class Singleton<Renderer>;

private:

    enum eRenderListType
    {

        NORMAL_RENDER_LIST,
        TRANSPARENT_RENDER_LIST,
        RENDER_LIST_COUNT
    };

    typedef std::list<RenderObject*> TRenderObjectList;
    typedef TRenderObjectList::iterator TRenderObjectListIterator;

    struct stRenderLayer
    {

        TRenderObjectList renderList[RENDER_LIST_COUNT];

        bool is3D;
    };

    typedef std::map<int, stRenderLayer> TRenderLayerMap;
    typedef std::pair<int, stRenderLayer> TRenderLayerMapPair;
    typedef TRenderLayerMap::iterator TRenderLayerMapIterator;
    typedef std::pair<TRenderLayerMapIterator, bool> TRenderLayerMapResultPair;

    TRenderLayerMap m_RenderLayerMap;

    Texture* m_pCurrentTexture;
    COLOR m_CurrentColor;
    Mesh* m_pCurrentMesh;
    stRenderLayer* m_pCurrentRenderLayer;

    static Camera* ms_pCamera3D;
    static Camera* ms_pCamera2D;

    int m_iDrawCalls;
    int m_iPolyCount;

    const int m_iScreenWidth;
    const int m_iScreenHeight;

    bool m_bIsClean;

    bool m_bClearingScreen;

    EAGLContext *m_pContext;
    GLuint m_gluiViewRenderbuffer;
    GLuint m_gluiViewFramebuffer;
    GLuint m_gluiDepthRenderbuffer;

    void ClearLists(void);

    void DoRenderObject2D(RenderObject* pRO);
    void DoRenderObject3D(RenderObject* pRO);

    static bool SortByDistanceToCameraPredicate(RenderObject* lhs, RenderObject* rhs);

    void DrawLists3D(void);
    void DrawLists2D(void);

    void BindTexture(RenderObject* pRO);
    void BindMesh(RenderObject* pRO);


public:

    void BeginRender(void);
    void EndRender(void);

    Renderer(void);
    ~Renderer(void);

    void Init(EAGLContext* pContext, GLuint renderBuffer, GLuint frameBuffer, GLuint depthBuffer);
    void Cleanup(void);

    void Render(void);

    void Add(Renderable* pRenderable);

    void SetClearColor(float r, float g, float b, float alpha);
    void SetClearColor(const COLOR& color);
    void EnableClearColor(bool enable);

    void SetCamera(Camera* pCamera, bool is3D)
    {
        if (is3D)
        {
            ms_pCamera3D = pCamera;
        }
        else
        {
            ms_pCamera2D = pCamera;
        }
    };

    Camera* GetCamera(bool is3D)
    {
        return is3D ? ms_pCamera3D : ms_pCamera2D;
    }

    void ClearLayers(void)
    {
        Log("+++ Renderer::ClearLayers limpiando el map\n");
        m_RenderLayerMap.clear();
    };

    int GetDrawCalls(void)
    {
        return m_iDrawCalls;
    };

    int GetPolyCount(void)
    {
        return m_iPolyCount;
    };
};



#endif	/* _RENDERER_H */

