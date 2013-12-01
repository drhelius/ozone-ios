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
 * File:   decoration.h
 * Author: nacho
 *
 * Created on 9 de abril de 2009, 13:47
 */

#pragma once
#ifndef _DECORATION_H
#define	_DECORATION_H

#include "npc.h"

enum eDecoOpacity
{

    DECO_OPACITY_NO,
    DECO_OPACITY_TRANSPARENT,
    DECO_OPACITY_ADDITIVE
};

struct stDECO_CONFIG_FILE
{

    char mesh[100];
    char texture[100];
    eDecoOpacity opacity;
    Texture* pTexture;
    Mesh* pMesh;
};

class Decoration : public NPC
{

public:
    Decoration(void);
    ~Decoration(void);

    void Init(stDECO_CONFIG_FILE& deco_config, const char* szEpisode, int rotation, short width, short height);
    virtual void Update(Timer* timer) {};

};

#endif	/* _DECORATION_H */

