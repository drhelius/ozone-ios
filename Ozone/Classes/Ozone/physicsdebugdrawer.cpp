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
 * File:   physicsdebugdrawer.cpp
 * Author: nacho
 *
 * Created on 25 de julio de 2009, 19:15
 */

#include "physics/LinearMath/btVector3.h"


#include "physicsdebugdrawer.h"

PhysicsDebugDrawer::PhysicsDebugDrawer()
: m_debugMode(0)
{

}

void PhysicsDebugDrawer::drawLine(const btVector3& from, const btVector3& to, const btVector3& color)
{
    GLfloat lineVertices[] = {
        from.x() * PHYSICS_INV_SCALE_FACTOR, from.y() * PHYSICS_INV_SCALE_FACTOR, from.z() * PHYSICS_INV_SCALE_FACTOR,
        to.x() * PHYSICS_INV_SCALE_FACTOR, to.y() * PHYSICS_INV_SCALE_FACTOR, to.z() * PHYSICS_INV_SCALE_FACTOR
    };

    glColor4f(color.x(), color.y(), color.z(), 1.0f);

    glVertexPointer(3, GL_FLOAT, 0, lineVertices);

    glPointSize(3.0f);
    glDrawArrays(GL_POINTS, 0, 2);
    glDrawArrays(GL_LINES, 0, 2);
}

void PhysicsDebugDrawer::setDebugMode(int debugMode)
{
    m_debugMode = debugMode;
}

void PhysicsDebugDrawer::draw3dText(const btVector3& location, const char* textString)
{

}

void PhysicsDebugDrawer::reportErrorWarning(const char* warningString)
{
    Log(warningString);
}

void PhysicsDebugDrawer::drawContactPoint(const btVector3& pointOnB, const btVector3& normalOnB, btScalar distance, int lifeTime, const btVector3& color)
{

}




