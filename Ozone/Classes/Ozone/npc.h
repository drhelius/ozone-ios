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
 * File:   npc.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:26
 */

#pragma once
#ifndef _NPC_H
#define	_NPC_H

#include "audio.h"
#include "physicsmanager.h"
#include "physicsmoveable.h"
#include "renderable.h"
#include "collision_util.h"
#include "player.h"
#include "timer.h"

class Scene;
class Particle;
class BladeEnemy;

class NPC : public PhysicsMoveable, public Renderable
{

protected:

    int m_iID;

    bool m_bEnable;
    bool m_bStatic;
    bool m_bStaticLevel;
    bool m_bRigid;

    RenderObject m_MainRenderObject;

    static Player* m_pThePlayer;
    static Scene* m_pTheScene;

public:

    NPC(void);
    virtual ~NPC(void);

    static void SetPlayer(Player* pPlayer)
    {
        m_pThePlayer = pPlayer;
    };

    static void SetScene(Scene* pScene)
    {
        m_pTheScene = pScene;
    };

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    virtual void ContactWithPlayerShot(Particle* theShot, const float impulse, Timer* timer, int additionalData) { };

    virtual void ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData) { };

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer) { };

    virtual void ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers) { };

    virtual void Update(Timer* timer) = 0;

    virtual void Reset(void) { };

    virtual void Enable(void)
    {
        m_bEnable = true;
    };

    virtual void Disable(void)
    {
        m_bEnable = false;
    };

    bool IsEnable(void) const
    {
        return m_bEnable;
    };

    bool IsRigid(void) const
    {
        return m_bRigid;
    };

    void SetRigid(const bool isRigid)
    {
        m_bRigid = isRigid;
    };

    bool IsStatic(void) const
    {
        return m_bStatic;
    };

    void SetStatic(const bool isStatic)
    {
        m_bStatic = isStatic;
    };

    bool IsStaticLevel(void) const
    {
        return m_bStaticLevel;
    };

    RenderObject* GetMainRenderObject(void)
    {
        return &m_MainRenderObject;
    };

    int GetID(void) const
    {
        return m_iID;
    };

    void SetID(const int id)
    {
        m_iID = id;
    };
};

#endif	/* _NPC_H */

