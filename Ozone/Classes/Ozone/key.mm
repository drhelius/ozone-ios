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
 * File:   key.cpp
 * Author: nacho
 * 
 * Created on 9 de abril de 2009, 13:52
 */

#include "key.h"

btCollisionShape* Key::m_pKeyShape = NULL;

Key::Key(void) : Item()
{
    if (m_pKeyShape == NULL)
    {
        btScalar mass = 0.0f;
        btVector3 inertia(0, 0, 0);
        m_pKeyShape = new btSphereShape(0.3f);
        m_pKeyShape->calculateLocalInertia(mass, inertia);
    }
}

Key::~Key()
{
    SafeDelete(m_pKeyShape);
}


