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
 * File:   sector.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 20:57
 */

#pragma once
#ifndef _SECTOR_H
#define	_SECTOR_H

#include "npc.h"

#define SECTOR_WIDTH 500
#define SECTOR_HEIGHT 400

class Sector
{

public:

    Renderable m_StaticLevelRenderable;
    
    typedef std::list<NPC*> TSectorNPCList;
    typedef TSectorNPCList::iterator TSectorNPCListIterator;

    Sector(int staticCount);
    ~Sector(void);

    NPC** GetStaticNPCArray(void)
    {
        return m_pStaticNPCArray;
    }

    TSectorNPCList& GetDynamicNPCList(void)
    {
        return m_DynamicNPCList;
    };

    int GetStaticCount(void)
    {
        return m_iStaticCount;
    }

    Renderable* GetStaticLevel(void)
    {
        return &m_StaticLevelRenderable;
    }

private:

    NPC** m_pStaticNPCArray;

    TSectorNPCList m_DynamicNPCList;

    int m_iStaticCount;
};

#endif	/* _SECTOR_H */

