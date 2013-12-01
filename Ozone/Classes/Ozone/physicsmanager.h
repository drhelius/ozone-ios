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
 * File:   physicsmanager.h
 * Author: nacho
 *
 * Created on 23 de julio de 2009, 23:51
 */

#pragma once
#ifndef _PHYSICSMANAGER_H
#define	_PHYSICSMANAGER_H

#include "defines.h"
#include "singleton.h"
#include "physicsdebugdrawer.h"

#ifndef GEARDOME_WE_ARE_IN_RELEASE
    //#define DEBUG_PHYSICS 1
#endif

//////////////////////////
//////////////////////////

class PhysicsCallbackGeneric
{

public:

    virtual ~PhysicsCallbackGeneric()
    {
    };
    
    virtual void Execute(const btDynamicsWorld *world, btScalar timeStep) const = 0;
};

//////////////////////////
//////////////////////////

template <class Class>
class PhysicsCallback : public PhysicsCallbackGeneric
{

public:

    typedef void (Class::*Method)(const btDynamicsWorld *world, btScalar timeStep);

private:

    Class* m_pClassInstance;
    Method m_theMethod;

public:

    PhysicsCallback(Class* class_instance, Method method)
    {
        m_pClassInstance = class_instance;
        m_theMethod = method;
    };

    virtual ~PhysicsCallback()
    {
    };

    virtual void Execute(const btDynamicsWorld *world, btScalar timeStep) const
    {
        (m_pClassInstance->*m_theMethod)(world, timeStep);
    };
};

//////////////////////////
//////////////////////////

class PhysicsManager : public Singleton<PhysicsManager>
{

    ////friend class Singleton<PhysicsManager>;

private:

    
    btDiscreteDynamicsWorld* m_pDynamicsWorld;
    btSequentialImpulseConstraintSolver* m_pConstraintSolver;
    btDefaultCollisionConfiguration* m_pCollisionConfiguration;
    btCollisionDispatcher* m_pCollisionDispatcher;
    btAxisSweep3* m_pBroadphase;
    btGhostPairCallback* m_pGhostPairCallback;

    PhysicsDebugDrawer* m_pDebugDrawer;

    bool m_bIsClean;

    static PhysicsCallbackGeneric* m_pPhysicsCallback;

public:

    PhysicsManager();
    ~PhysicsManager();

    void Update(float fdTime);

    void Init(int maxProxies, int maxPersistentManifoldPoolSize, int maxCollisionAlgorithmPoolSize, btVector3 worldAabbMin, btVector3 worldAabbMax);
    void Cleanup(void);

    static void __PhysicsCallback(btDynamicsWorld *world, btScalar timeStep)
    {
        if (IsValidPointer(m_pPhysicsCallback))
        {
            m_pPhysicsCallback->Execute(world, timeStep);
        }
    };

    void SetPhysicsCallback(PhysicsCallbackGeneric* pCallback);

    btDiscreteDynamicsWorld* GetDynamicsWorld(void)
    {
        return m_pDynamicsWorld;
    };

    btSequentialImpulseConstraintSolver* GetConstraintSolver(void)
    {
        return m_pConstraintSolver;
    };

    btDefaultCollisionConfiguration* GetCollisionConfiguration(void)
    {
        return m_pCollisionConfiguration;
    };

    btCollisionDispatcher* GetCollisionDispatcher(void)
    {
        return m_pCollisionDispatcher;
    };

    btAxisSweep3* GetBroadphase(void)
    {
        return m_pBroadphase;
    };
};

#endif	/* _PHYSICSMANAGER_H */

