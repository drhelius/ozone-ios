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
 *  textfont.h
 *  Ozone
 *
 *  Created by nacho on 20/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */
#pragma once

#include "defines.h"
#include "renderobject.h"
#include "renderable.h"

class TextFont
{

public:

    TextFont(void);
    ~TextFont(void);
    void Add(const char* strText, float x, float y, float z, COLOR& color, bool centered = false);
    void Add(const char* strText, float x, float y, float z);
    void Init(const char* strTexture, const char* strSizeFile, int layer);
    void UpdateTextMesh(const char* strText);
    void Begin(void);
    void End(void);

    int GetRenderListCount(void) { return m_RenderList.size(); };

private:

    typedef std::list<RenderObject> TRenderObjectList;
    typedef TRenderObjectList::iterator TRenderObjectListIterator;

    Texture* m_pTexture;
    Mesh* m_pMesh;
    u8 m_SizeArray[256];
    Renderable m_Renderable;

    int m_iLetterSize;

    TRenderObjectList m_RenderList;

};

