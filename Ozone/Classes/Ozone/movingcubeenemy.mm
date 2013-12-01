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
 * File:   movingcubeenemy.cpp
 * Author: nacho
 * 
 * Created on 22 de agosto de 2009, 0:41
 */

#include "movingcubeenemy.h"
#include "meshmanager.h"
#include "texturemanager.h"

MovingCubeEnemy::MovingCubeEnemy(void) : Enemy()
{
}

void MovingCubeEnemy::Init(short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    /*
    m_MainRenderObject.Init(MeshManager::Instance().GetMeshFromFile("game/entities/13_ent"),
            TextureManager::Instance().GetTexture("game/entities/entities", true), RENDER_OBJECT_NORMAL);
    m_MainRenderObject.SetPosition(this->GetPosition());
    m_RenderObjectList.push_back(&m_MainRenderObject);

    btRigidBody::btRigidBodyConstructionInfo rigidBodyCI(0, this, m_pEnemyShape, btVector3(0, 0, 0));
    m_pRigidBody = new btRigidBody(rigidBodyCI);

    PhysicsManager::Instance().GetDynamicsWorld()->addRigidBody(m_pRigidBody, COL_ENEMIES, c_iEnemiesCollidesWith);
    */
}

