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
 * File:   cube.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 20:56
 */

#pragma once
#ifndef _CUBE_H
#define	_CUBE_H

#include "npc.h"
#include "interpolatormanager.h"

enum eCubeOpacity
{

    CUBE_OPACITY_NO,
    CUBE_OPACITY_TRANSPARENT,
    CUBE_OPACITY_ADDITIVE
};

enum eCubeDoor
{

    CUBE_DOOR_NO,
    CUBE_DOOR_BLUE,
    CUBE_DOOR_RED
};

struct stCUBE_CONFIG_FILE
{

    char mesh[100];
    char texture[100];
    char glow_texture[100];
    char sound[100];
    eCubeOpacity opacity;
    bool cube_break;
    eCubeDoor door;
    float fade;
    float friction;
    bool invisible;
    Texture* pTexture;
    Texture* pGlowTexture;
    Mesh* pMesh;
};

class Cube : public NPC
{

private:

    SquareInterpolator* m_pDoorGlowInterpolator;

    static btCollisionShape* m_pCubeShape;
    RenderObject m_GlowRenderObject;

    float m_fGlowDuration;
    float m_fGlowTime;

    float m_fFadeOut;

    eCubeDoor m_Door;
    bool m_bBreak;

    bool m_bDoorWantsToDissapear;

    bool m_bHasCollision;

    void Light(bool isPlayer, bool isSteel);


public:

    Cube(void);
    ~Cube();

    virtual void Init(stCUBE_CONFIG_FILE& cube_config, const char* szEpisode, int rotation, bool collision);
    virtual void Update(Timer* timer);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
    virtual void ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers);

    virtual void Enable(void);
    virtual void Disable(void);
    virtual void Reset(void);
};

#endif	/* _CUBE_H */

