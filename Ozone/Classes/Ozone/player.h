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
 * File:   player.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:27
 */

#pragma once
#ifndef _PLAYER_H
#define	_PLAYER_H

#include "physicsmoveable.h"
#include "renderable.h"
#include "collision_util.h"
#include "timer.h"
#include "interpolatormanager.h"

#define PLAYER_MAX_AIR (3.9f)
#define PLAYER_MAX_AIR_STEEL (3.5f)
#define PLAYER_MIN_AIR (1.5f)
#define PLAYER_MAX_VELOCITY (5.0f)
#define PLAYER_BRAKE_RATE (2.6f)
#define PLAYER_THRUST_RATE (0.06f)
#define PLAYER_DEFLATE_RATE (0.05f)
#define PLAYER_INPUT_DEFLATE_RATE (0.22f)

#define PLAYER_VERY_BIG_ENEMY_HURT (1.6f)
#define PLAYER_BIG_ENEMY_HURT (0.6f)
#define PLAYER_SMALL_ENEMY_HURT (0.35f)
#define PLAYER_VERY_SMALL_ENEMY_HURT (0.2f)

#define MAX_INRANGE_ELECTRIC_NPCS 4
#define ELECTRIC_RANGE (25.0f)

enum ePlayerAmmo
{

    NORMAL_AMMO = 0,
    ELECTRIC_AMMO,
    STEEL_AMMO,
    NUCLEAR_AMMO,
    MAX_TYPE_AMMO
};

enum ePlayerDoorKeys
{

    RED_DOOR_KEY = 0,
    BLUE_DOOR_KEY,
    MAX_TYPE_DOOR_KEY
};

class Enemy;

class Player : public PhysicsMoveable, public Renderable
{

private:

    Vec3 m_vIniPos;
    float m_fRayWaitInterval;
    bool m_bFlashOn;
    float m_fRayWait;
    int m_iRayFrame;

    Timer m_DieTimer;

    RenderObject m_RayLayer[MAX_INRANGE_ELECTRIC_NPCS];

    typedef std::list<Enemy*> TEnemyList;
    typedef TEnemyList::iterator TEnemyListIterator;

    TEnemyList m_ElectricInRangeNPCs;

    RenderObject m_MainRenderObject;
    RenderObject m_UpperLayer;

    RenderObject m_SteelMainRenderObject;
    RenderObject m_SteelUpperLayer;

    RenderObject m_NukeLayer;
    RenderObject m_NukeLayer2;

    RenderObject m_ElectricGlowLayer;
    RenderObject m_GlowLayer;

    LinearInterpolator* m_pNukeInterpolator;

    float m_fNukeValue;

    btCollisionShape* m_pBallShape;
    btGhostObject* m_pGhostObject;

    btCollisionShape* m_pNukeShape;
    btGhostObject* m_pNukeGhostObject;

    btCollisionShape* m_pElectricShape;
    btGhostObject* m_pElectricGhostObject;

    ePlayerAmmo m_CurrentWeapon;

    float m_fAir;
    float m_fAmmo[MAX_TYPE_AMMO];

    bool m_bDoorKey[MAX_TYPE_DOOR_KEY];

    bool m_bActive;

    bool m_bAirSoundActive;
    bool m_bDeflatingSoundActive;
    bool m_bThrusting;
    bool m_bDeflating;

    bool m_bIsInContactWithAirPump;
    bool m_bContactWithAirPump;

    bool m_bIsDead;
    bool m_bIsLevelCompleted;

    bool m_bIsNukeActive;

    bool m_bAddedGem;

    bool m_bIsBossKilled;

    float m_fCurrentTime;
    float m_fLastShootTime;

    int m_iGemCount;

    Timer m_SmokeTimer;

    bool m_bPlayingElectricSound;

public:

    Player(void);
    ~Player();

    void Init(Vec3 position);

    void Update(const Timer* pTimer);

    void Reset(void);
    void Defaults(void);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    float Deflate(float damage, bool sound = false);
    float GetAir(void) const;
    float SetAir(float air);
    float Inflate(float air);

    float SetAmmo(ePlayerAmmo type, float ammo);
    float AddAmmo(ePlayerAmmo type, float ammo);
    float DropAmmo(ePlayerAmmo type, float ammo);
    float GetAmmo(ePlayerAmmo type) const;

    void AddDoorKey(ePlayerDoorKeys key);
    void DropDoorKey(ePlayerDoorKeys key);
    bool GetDoorKey(ePlayerDoorKeys key) const;

    void Brake(float dTime);
    void Thrust(const Vec3& speed, float dTime);

    void Shoot(ePlayerAmmo type);

    void AddNPCToInRangeElectricList(Enemy* pEnemy);

    bool IsInContactWithAirPump(void) const
    {
        return m_bIsInContactWithAirPump;
    };

    void ContactWithAirPump(void)
    {
        m_bContactWithAirPump = true;
    };

    bool IsActive(void) const
    {
        return m_bActive;
    };

    void Enable(void)
    {
        m_bActive = true;
    };

    void Disable(void)
    {
        m_bActive = false;
    };

    void AddGem(void)
    {
        m_iGemCount++;
        m_bAddedGem = true;
    };

    void ResetGemCounter(void)
    {
        m_iGemCount = 0;
    };

    int GetGemCounter(void) const
    {
        return m_iGemCount;
    };

    bool IsLevelCompleted(void) const
    {
        return m_bIsLevelCompleted;
    };

    void SetLevelCompleted(bool value)
    {
        m_bIsLevelCompleted = value;
    };

    bool IsDead(void) const
    {
        return m_bIsDead;
    };

    bool IsDeadTimer(void) const
    {
        return m_bIsDead && (m_DieTimer.GetActualTime() > 1.5f);
    };

    bool IsEndLevelTimer(void) const
    {
        return m_bIsDead && (m_DieTimer.GetActualTime() > 3.0f);
    };
    
    bool IsEndBossTimer(void) const
    {
        return m_bIsBossKilled && (m_DieTimer.GetActualTime() > 2.0f);
    };

    bool IsBossKilled(void) const
    {
        return m_bIsBossKilled;
    };

    void BossKilled(void)
    {
        m_bIsBossKilled = true;
        m_DieTimer.Start();
    };

    bool IsGemAdded(void) const
    {
        return m_bAddedGem;
    };

    void SetGemAdded(bool value)
    {
        m_bAddedGem = value;
    };

    ePlayerAmmo GetCurrentWeapon(void) const
    {
        return m_CurrentWeapon;
    };

    void SetCurrentWeapon(ePlayerAmmo weapon)
    {
        m_CurrentWeapon = weapon;
    };
};

#endif	/* _PLAYER_H */

