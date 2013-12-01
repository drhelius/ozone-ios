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
 * File:   sector.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 20:57
 */

#include "sector.h"

Sector::Sector(int staticCount)
{
    m_iStaticCount = staticCount;

    m_pStaticNPCArray = new NPC* [staticCount];
}

Sector::~Sector(void)
{
    SafeDeleteArray(m_pStaticNPCArray);

    Renderable::TRenderObjectList::iterator it;

    for (it = m_StaticLevelRenderable.GetRenderObjectList().begin();
            it != m_StaticLevelRenderable.GetRenderObjectList().end(); it++)
    {
        SafeDelete((*it));
    }
}

