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
 * File:   physicsdebugdrawer.h
 * Author: nacho
 *
 * Created on 25 de julio de 2009, 19:15
 */

#pragma once
#ifndef _PHYSICSDEBUGDRAWER_H
#define	_PHYSICSDEBUGDRAWER_H

#include "defines.h"

class PhysicsDebugDrawer : public btIDebugDraw
{

    int m_debugMode;

public:

    PhysicsDebugDrawer();
   
    virtual void drawLine(const btVector3& from, const btVector3& to, const btVector3& color);

    virtual void drawContactPoint(const btVector3& PointOnB, const btVector3& normalOnB, btScalar distance, int lifeTime, const btVector3& color);

    virtual void reportErrorWarning(const char* warningString);

    virtual void draw3dText(const btVector3& location, const char* textString);

    virtual void setDebugMode(int debugMode);

    virtual int getDebugMode() const
    {
        return m_debugMode;
    }
};

#endif	/* _PHYSICSDEBUGDRAWER_H */

