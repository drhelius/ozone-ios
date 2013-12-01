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
 * File:   physicsmoveable.h
 * Author: nacho
 *
 * Created on 26 de julio de 2009, 2:07
 */

#pragma once
#ifndef _PHYSICSMOVEABLE_H
#define	_PHYSICSMOVEABLE_H

#include "defines.h"
#include "positionable.h"
#include "collision_util.h"

class PhysicsMoveable : public Positionable, public btMotionState
{

protected:

    btRigidBody* m_pRigidBody;

public:

    PhysicsMoveable(void) : Positionable(), btMotionState()
    {
        InitPointer(m_pRigidBody);
    };

    virtual ~PhysicsMoveable()
    {
        if (IsValidPointer(m_pRigidBody))
        {
            CollisionInfo* pInfo = (CollisionInfo*) m_pRigidBody->getUserPointer();
            SafeDelete(pInfo);
        }
        
        SafeDelete(m_pRigidBody);
    };

    btRigidBody* GetRigidBody(void)
    {
        return m_pRigidBody;
    };
};

#endif	/* _PHYSICSMOVEABLE_H */

