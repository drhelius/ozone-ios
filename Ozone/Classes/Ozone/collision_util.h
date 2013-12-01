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
 * File:   collision_util.h
 * Author: nacho
 *
 * Created on 30 de julio de 2009, 19:37
 */

#ifndef _COLLISION_UTIL_H
#define	_COLLISION_UTIL_H

#define BIT(x) (1 << (x))

enum eCollisionTypes
{

    COL_NOTHING = 0,
    COL_PLAYER = BIT(0),
    COL_WALLS = BIT(1),
    COL_ITEMS = BIT(2),
    COL_ENEMIES = BIT(3),
    COL_PLACES = BIT(4),
    COL_RIGIDS = BIT(5),
    COL_GOOD_SHOTS = BIT(6),
    COL_BAD_SHOTS = BIT(7),
    COL_PLAYER_GHOST = BIT(8),
    COL_SMOKE = BIT(9),
    COL_NUKE_GHOST = BIT(10),
    COL_ELECTRIC_GHOST = BIT(11)
};

#ifdef DEBUG_NO_CLIP
const int c_iPlayerCollidesWith = 0;
#else
const int c_iPlayerCollidesWith = COL_WALLS | COL_RIGIDS;
#endif
const int c_iWallsCollidesWith = COL_PLAYER | COL_ITEMS | COL_GOOD_SHOTS | COL_BAD_SHOTS | COL_ENEMIES;
const int c_iItemsCollidesWith = COL_WALLS | COL_ITEMS | COL_PLAYER_GHOST;
const int c_iEnemiesCollidesWith = COL_WALLS | COL_ENEMIES | COL_GOOD_SHOTS | COL_PLAYER_GHOST | COL_RIGIDS | COL_NUKE_GHOST | COL_ELECTRIC_GHOST;
const int c_iPlacesCollidesWith = COL_PLAYER_GHOST;
const int c_iRigidsCollidesWith = COL_PLAYER | COL_GOOD_SHOTS | COL_ENEMIES | COL_NUKE_GHOST;
const int c_iGoodShotsCollidesWith = COL_WALLS | COL_ENEMIES | COL_RIGIDS;
const int c_iBadShotsCollidesWith = COL_WALLS | COL_PLAYER_GHOST | COL_NUKE_GHOST;
const int c_iPlayerGhostCollidesWith = COL_ENEMIES | COL_ITEMS | COL_PLACES | COL_BAD_SHOTS;
const int c_iSmokeCollidesWith = 0;
const int c_iNukeGhostCollidesWith = COL_ENEMIES | COL_BAD_SHOTS | COL_RIGIDS;
const int c_iElectricGhostCollidesWith = COL_ENEMIES;

enum eCollisionObjectTypes
{

    COL_OBJ_PLAYER = 0,
    COL_OBJ_GHOST_PLAYER,
    COL_OBJ_NPC,
    COL_OBJ_GHOST_NUKE,
    COL_OBJ_GHOST_ELECTRIC
};

class CollisionInfo
{

private:

    eCollisionObjectTypes m_Type;
    void* m_pObject;
    int m_AdditionalData;

public:

    CollisionInfo(eCollisionObjectTypes type, void* pointer, int additionalData = 0)
    {
        m_Type = type;
        m_pObject = pointer;
        m_AdditionalData = additionalData;
    };

    void* GetPointer(void)
    {
        return m_pObject;
    };

    eCollisionObjectTypes GetType(void)
    {
        return m_Type;
    };
    int GetAdditionalData(void)
    {
        return m_AdditionalData;
    };
};

struct stCollisionPair
{
    float impulse;
    CollisionInfo* pObj1;
    CollisionInfo* pObj2;
};

struct cmp_stCollisionPair
{

    bool operator()(stCollisionPair a, stCollisionPair b)
    {
        return (((int)a.pObj1 + (int)a.pObj2) < ((int)b.pObj1 + (int)b.pObj2));
    }
};

#endif	/* _COLLISION_UTIL_H */

