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
 * File:   particlemanager.h
 * Author: nacho
 *
 * Created on 21 de septiembre de 2009, 22:43
 */

#pragma once
#ifndef _PARTICLEMANAGER_H
#define	_PARTICLEMANAGER_H

#include <list>
#include "singleton.h"
#include "particle.h"
#include "timer.h"

enum eParticleType
{

    PARTICLE_INLINE_THROWING_ENEMY = 0,
    PARTICLE_PLAYER_RED,
    PARTICLE_SEARCH_THROWING_ENEMY,
    PARTICLE_SMOKE,
    PARTICLE_SPITTING_ENEMY,
    PARTICLE_GAS,
    PARTICLE_ITEM,
    PARTICLE_ENEMY,
    PARTICLE_BOSS_SPACE,
    MAX_PARTICLE_TYPE

};

class Scene;

class ParticleManager : public Singleton<ParticleManager>
{

    ////friend class Singleton<ParticleManager>;

    struct stParticleNode
    {

        Particle* pParticle;
        int next;

        int nextUsed;
        int prevUsed;
    };

private:

    bool m_bNeedCleanup;

    stParticleNode* m_pParticleArray[MAX_PARTICLE_TYPE];
    int m_iArraySize[MAX_PARTICLE_TYPE];

    int m_iFreeSlot[MAX_PARTICLE_TYPE];
    int m_iFirstUsed[MAX_PARTICLE_TYPE];


public:

    ParticleManager(void);
    ~ParticleManager();

    void InitParticleArray(eParticleType type, int count, int& IDcounter);

    void AddParticle(eParticleType type, const Vec3& vecPos, const Vec3& vecImpulse, float timeToLive, float rotationY, const Vec3& initialSpeed, float scale = 1.0f, float r = 1.0f, float g = 1.0f, float b = 1.0f);

    void Update(Timer* timer, Scene* pScene);

    void ClearAll(void);
    void Clear(eParticleType type);

    void Cleanup(void);

    void AddExplosion(eParticleType type, const Vec3& vecPos, float impulse, float timeToLive, const Vec3& initialSpeed, int rays, float scale = 1.0f, float r = 1.0f, float g = 1.0f, float b = 1.0f);
};

#endif	/* _PARTICLEMANAGER_H */

