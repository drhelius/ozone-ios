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
 * File:   moveable.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:59
 */

#include "moveable.h"

Moveable::Moveable(void) : Positionable()
{
    m_vSpeed.x = m_vSpeed.y = m_vSpeed.z = 0.0f;
    m_vAcceleration.x = m_vAcceleration.y = m_vAcceleration.z = 0.0f;
    m_vAngularSpeed.x = m_vAngularSpeed.y = m_vAngularSpeed.z = 0.0f;
    m_vAngularAcceleration.x = m_vAngularAcceleration.y = m_vAngularAcceleration.z = 0.0f;
    m_vGravityCenter.x = m_vGravityCenter.y = m_vGravityCenter.z = 0.0f;    
}

void Moveable::UpdateMovement(float fdTime)
{	
    
}


