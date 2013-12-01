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
 * File:   renderable.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:29
 */

#pragma once
#ifndef _RENDERABLE_H
#define	_RENDERABLE_H

#include <list>
#include "renderobject.h"
#include "renderer.h"

class Renderable
{

    friend class Renderer;

public:

    typedef std::list<RenderObject*> TRenderObjectList;
    typedef TRenderObjectList::iterator TRenderObjectListIterator;

    Renderable()
    {
        m_iLayer = 0;
        m_bIs3D = true;
    };

    TRenderObjectList& GetRenderObjectList(void)
    {
        return m_RenderObjectList;
    };

    bool Is3D(void) const
    {
        return m_bIs3D;
    }

    void Set3D(bool is3D)
    {
        m_bIs3D = is3D;
    }

    int GetLayer(void) const
    {
        return m_iLayer;
    }

    void SetLayer(int layer)
    {
        m_iLayer = layer;
    }

protected:

    TRenderObjectList m_RenderObjectList;

    int m_iLayer;
    bool m_bIs3D;
};

#endif	/* _RENDERABLE_H */

