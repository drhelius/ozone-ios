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
 * File:   npcfactory.h
 * Author: nacho
 *
 * Created on 20 de julio de 2009, 0:02
 */

#pragma once
#ifndef _NPCFACTORY_H
#define	_NPCFACTORY_H

#include <vector>
#include "singleton.h"
#include "startplace.h"
#include "exitplace.h"
#include "bluegem.h"
#include "redgem.h"
#include "greengem.h"
#include "yellowgem.h"
#include "conveyorbeltplace.h"
#include "redkey.h"
#include "bluekey.h"
#include "airpumpplace.h"
#include "enemy.h"
#include "decoration.h"
#include "cube.h"
#include "teleporterplace.h"
#include "bounceenemy.h"
#include "inlinethrowingenemy.h"
#include "searchthrowingenemy.h"
#include "searchenemy.h"
#include "spikeenemy.h"
#include "spikegroupenemy.h"
#include "spittingenemy.h"
#include "electricgem.h"
#include "nucleargem.h"
#include "armenemy.h"
#include "bladeenemy.h"
#include "electricenemy.h"
#include "movingcrossenemy.h"
#include "movingcrosssmallenemy.h"
#include "movingcubeenemy.h"
#include "movingwallenemy.h"
#include "multibladeenemy.h"
#include "lancesenemy.h"
#include "scenetrigger.h"
#include "BossEarthEnemy.h"
#include "BossOceanEnemy.h"
#include "BossSpaceEnemy.h"
#include "BossVulcanEnemy.h"

enum eITEM_TYPE
{

    ITEM_START_PLACE_TYPE = 0,
    ITEM_EXIT_PLACE_TYPE,
    ITEM_BLUE_GEM_TYPE,
    ITEM_RED_GEM_TYPE,
    ITEM_GREEN_GEM_TYPE,
    ITEM_YELLOW_GEM_TYPE,
    ITEM_CONVEYORBELT_PLACE_TYPE,
    ITEM_RED_KEY_TYPE,
    ITEM_BLUE_KEY_TYPE,
    ITEM_AIRPUMP_PLACE_TYPE,
    ITEM_START_TRIGGER_TYPE,
    ITEM_EXIT_TRIGGER_TYPE,
    ITEM_AREA_TRIGGER_TYPE,
    ITEM_NUCLEAR_TYPE,
    ITEM_ELECTRIC_TYPE
};

enum eENEMY_TYPE
{

    ENEMY_BOUNCE_TYPE = 0,
    ENEMY_INLINETHROWING_TYPE,
    ENEMY_SEARCHTHROWING_TYPE,
    ENEMY_SEARCH_TYPE,
    ENEMY_ARM_TYPE,
    ENEMY_ELECTRIC_TYPE,
    ENEMY_MULTI_BLADE_TYPE,
    ENEMY_SPIKE_TYPE,
    ENEMY_SPIKEGROUP_TYPE,
    ENEMY_SPITTING_TYPE,
    ENEMY_LANCES_TYPE,
    ENEMY_BLADES_TYPE,
    ENEMY_BLADES_REVERSE_TYPE, //ENEMY_MOVINGCUBE_TYPE,
    ENEMY_MOVINGCROSS_TYPE,
    ENEMY_MOVINGWALL_TYPE,
    ENEMY_MOVINGWALL_REVERSE_TYPE,
    ENEMY_MOVINGCROSS_SMALL_TYPE,
    ENEMY__UNUSED__TYPE,
    ENEMY_BOSS_EARTH_TYPE,
    ENEMY_BOSS_VULCAN_TYPE,
    ENEMY_BOSS_OCEAN_TYPE,
    ENEMY_BOSS_SPACE_TYPE,
};

class NPCFactory : public Singleton<NPCFactory>
{

    ////friend class Singleton<NPCFactory>;

////private:

    

public:

    NPCFactory(void);
    ~NPCFactory();

    Cube* GetCube(int layer, u8 type_id, short posX, short posY, short width, short height, u8 rotation,
            std::vector<stCUBE_CONFIG_FILE>& cubeConfigVector, const char* szEpisode);
    Decoration* GetDecoration(int layer, u8 type_id, short posX, short posY, u8 rotation, short width, short height,
            std::vector<stDECO_CONFIG_FILE>& decoConfigVector, const char* szEpisode);
    Enemy* GetEnemy(u8 type_id, short posX, short posY, u8 rotation, short width, short height, char* szScript);
    Item* GetItem(u8 type_id, short posX, short posY, u8 rotation, short width, short height, char* szScript);
    TeleporterPlace* GetTeleporterPlace(u8 type_id, short posX, short posY, u8 rotation, short width, short height, char* szScript);
};

#endif	/* _NPCFACTORY_H */

