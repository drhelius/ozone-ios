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
 * File:   physicsmanager.cpp
 * Author: nacho
 * 
 * Created on 23 de julio de 2009, 23:51
 */

#include "physicsmanager.h"

PhysicsCallbackGeneric* PhysicsManager::m_pPhysicsCallback = NULL;

//////////////////////////
//////////////////////////

PhysicsManager::PhysicsManager()
{
    Log("+++ PhysicsManager::PhysicsManager ...\n");

    m_bIsClean = true;

    InitPointer(m_pDynamicsWorld);
    InitPointer(m_pConstraintSolver);
    InitPointer(m_pCollisionDispatcher);
    InitPointer(m_pBroadphase);
    InitPointer(m_pCollisionConfiguration);
    InitPointer(m_pGhostPairCallback);

    InitPointer(m_pDebugDrawer);

    Log("+++ PhysicsManager::PhysicsManager correcto\n");
}

//////////////////////////
//////////////////////////

PhysicsManager::~PhysicsManager()
{
    Log("+++ PhysicsManager::~PhysicsManager ...\n");

    Cleanup();

    Log("+++ PhysicsManager::~PhysicsManager destruido\n");

}

//////////////////////////
//////////////////////////

void PhysicsManager::Update(float fdTime)
{
    m_pDynamicsWorld->stepSimulation(fdTime, 20);
}

//////////////////////////
//////////////////////////

void PhysicsManager::Init(int maxProxies, int maxPersistentManifoldPoolSize, int maxCollisionAlgorithmPoolSize, btVector3 worldAabbMin, btVector3 worldAabbMax)
{
    Log("+++ PhysicsManager::Init ...\n");

    m_pPhysicsCallback = NULL;

    m_pBroadphase = new btAxisSweep3(worldAabbMin, worldAabbMax, maxProxies);

    m_pGhostPairCallback = new btGhostPairCallback();
    m_pBroadphase->getOverlappingPairCache()->setInternalGhostPairCallback(m_pGhostPairCallback);

    btDefaultCollisionConstructionInfo constructionInfo;

    constructionInfo.m_defaultMaxCollisionAlgorithmPoolSize = maxCollisionAlgorithmPoolSize;
    constructionInfo.m_defaultMaxPersistentManifoldPoolSize = maxPersistentManifoldPoolSize;

    m_pCollisionConfiguration = new btDefaultCollisionConfiguration(constructionInfo);

    m_pCollisionDispatcher = new btCollisionDispatcher(m_pCollisionConfiguration);

    m_pConstraintSolver = new btSequentialImpulseConstraintSolver;

    m_pDynamicsWorld = new btDiscreteDynamicsWorld(m_pCollisionDispatcher, m_pBroadphase,
            m_pConstraintSolver, m_pCollisionConfiguration);

#ifdef DEBUG_PHYSICS
    m_pDebugDrawer = new PhysicsDebugDrawer();
    m_pDebugDrawer->setDebugMode(btIDebugDraw::DBG_DrawWireframe | btIDebugDraw::DBG_DrawAabb);

    m_pDynamicsWorld->setDebugDrawer(m_pDebugDrawer);
#endif

    m_bIsClean = false;

    Log("+++ PhysicsManager::Init correcto\n");
}

//////////////////////////
//////////////////////////

void PhysicsManager::SetPhysicsCallback(PhysicsCallbackGeneric* pCallback)
{
    m_pPhysicsCallback = pCallback;

    if (IsValidPointer(m_pDynamicsWorld))
    {
        m_pDynamicsWorld->setInternalTickCallback(&PhysicsManager::__PhysicsCallback);
    }
}

//////////////////////////
//////////////////////////

void PhysicsManager::Cleanup(void)
{
    if (!m_bIsClean)
    {
        Log("+++ PhysicsManager::Cleanup ...\n");

        SafeDelete(m_pDynamicsWorld);
        SafeDelete(m_pConstraintSolver);
        SafeDelete(m_pCollisionDispatcher);
        SafeDelete(m_pBroadphase);
        SafeDelete(m_pCollisionConfiguration);
        SafeDelete(m_pGhostPairCallback);

        SafeDelete(m_pDebugDrawer);

        m_bIsClean = true;

        Log("+++ PhysicsManager::Cleanup correcto\n");
    }
}

