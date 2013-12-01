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
 * File:   levelgamestate.cpp
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 21:02
 */

#include "npc.h"
#include "positionable.h"

Player* NPC::m_pThePlayer = NULL;
Scene* NPC::m_pTheScene = NULL;

NPC::NPC(void) : PhysicsMoveable(), Renderable()
{
    m_bEnable = true;
    m_bStatic = true;
    m_bStaticLevel = false;
    m_bRigid = false;
}

//////////////////////////
//////////////////////////

NPC::~NPC()
{

}

//////////////////////////
//////////////////////////

void NPC::getWorldTransform(btTransform &worldTransform) const
{
    Vec3 pos = m_vPosition;

    btVector3 newPos(pos.x * PHYSICS_SCALE_FACTOR, pos.y * PHYSICS_SCALE_FACTOR,
            pos.z * PHYSICS_SCALE_FACTOR);

    worldTransform.setIdentity();
    worldTransform.setOrigin(newPos);
}

//////////////////////////
//////////////////////////

void NPC::setWorldTransform(const btTransform &worldTransform)
{
    btVector3 pos = worldTransform.getOrigin();

    Vec3 newPos(pos.getX() * PHYSICS_INV_SCALE_FACTOR, pos.getY() * PHYSICS_INV_SCALE_FACTOR,
            pos.getZ() * PHYSICS_INV_SCALE_FACTOR);

    m_vPosition = newPos;
}
