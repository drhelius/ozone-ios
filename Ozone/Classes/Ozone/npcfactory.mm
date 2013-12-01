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
 * File:   npcfactory.cpp
 * Author: nacho
 * 
 * Created on 20 de julio de 2009, 0:02
 */

#include "npcfactory.h"

//////////////////////////
//////////////////////////

NPCFactory::NPCFactory(void)
{
}

//////////////////////////
//////////////////////////

NPCFactory::~NPCFactory()
{
}

//////////////////////////
//////////////////////////

Item* NPCFactory::GetItem(u8 type_id, short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    Item* tmp = NULL;

    switch (type_id)
    {
        case ITEM_START_PLACE_TYPE:
        {
            tmp = new StartPlace();
            break;
        }
        case ITEM_EXIT_PLACE_TYPE:
        {
            tmp = new ExitPlace();
            break;
        }
        case ITEM_BLUE_GEM_TYPE:
        {
            tmp = new BlueGem();
            break;
        }
        case ITEM_RED_GEM_TYPE:
        {
            tmp = new RedGem();
            break;
        }
        case ITEM_GREEN_GEM_TYPE:
        {
            tmp = new GreenGem();
            break;
        }
        case ITEM_YELLOW_GEM_TYPE:
        {
            tmp = new YellowGem();
            break;
        }
        case ITEM_CONVEYORBELT_PLACE_TYPE:
        {
            tmp = new ConveyorBeltPlace();
            break;
        }
        case ITEM_RED_KEY_TYPE:
        {
            tmp = new RedKey();
            break;
        }
        case ITEM_BLUE_KEY_TYPE:
        {
            tmp = new BlueKey();
            break;
        }
        case ITEM_AIRPUMP_PLACE_TYPE:
        {
            tmp = new AirPumpPlace();
            break;
        }
        case ITEM_START_TRIGGER_TYPE:
        {
            tmp = new SceneTrigger();
            break;
        }
        case ITEM_EXIT_TRIGGER_TYPE:
        {
            tmp = new SceneTrigger();
            break;
        }
        case ITEM_AREA_TRIGGER_TYPE:
        {
            tmp = new SceneTrigger();
            break;
        }
        case ITEM_NUCLEAR_TYPE:
        {
            tmp = new NuclearGem();
            break;
        }
        case ITEM_ELECTRIC_TYPE:
        {
            tmp = new ElectricGem();
            break;
        }
        default:
        {
            break;
        }
    }

    if (IsValidPointer(tmp))
    {
        tmp->SetPositionX((posX + (width / 2)) * 10.0f);
        tmp->SetPositionY(0.0f);
        tmp->SetPositionZ((posY + (height / 2)) * 10.0f);

        tmp->Init(posX, posY, rotation, width, height, szScript);
    }

    return tmp;
}
//////////////////////////
//////////////////////////

TeleporterPlace* NPCFactory::GetTeleporterPlace(u8 type_id, short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    TeleporterPlace* tmp = new TeleporterPlace();

    if (IsValidPointer(tmp))
    {
        tmp->SetPositionX((posX + (width / 2)) * 10.0f);
        tmp->SetPositionY(-20.0f);
        tmp->SetPositionZ((posY + (height / 2)) * 10.0f);

        tmp->Init(posX, posY, rotation, width, height, szScript);
    }

    return tmp;
}

//////////////////////////
//////////////////////////

Enemy* NPCFactory::GetEnemy(u8 type_id, short posX, short posY, u8 rotation, short width, short height, char* szScript)
{
    Enemy* tmp = NULL;

    switch (type_id)
    {
        case ENEMY_BOUNCE_TYPE:
        {
            tmp = new BounceEnemy();
            break;
        }
        case ENEMY_INLINETHROWING_TYPE:
        {
            tmp = new InlineThrowingEnemy();
            break;
        }
        case ENEMY_SEARCHTHROWING_TYPE:
        {
            tmp = new SearchThrowingEnemy();
            break;
        }
        case ENEMY_SEARCH_TYPE:
        {
            tmp = new SearchEnemy();
            break;
        }
        case ENEMY_ARM_TYPE:
        {
            tmp = new ArmEnemy();
            break;
        }
        case ENEMY_ELECTRIC_TYPE:
        {
            tmp = new ElectricEnemy();
            break;
        }
        case ENEMY_MULTI_BLADE_TYPE:
        {
            tmp = new MultiBladeEnemy();
            break;
        }
        case ENEMY_SPIKE_TYPE:
        {
            tmp = new SpikeEnemy();
            break;
        }
        case ENEMY_SPIKEGROUP_TYPE:
        {
            tmp = new SpikeGroupEnemy();
            break;
        }
        case ENEMY_SPITTING_TYPE:
        {
            tmp = new SpittingEnemy();
            break;
        }
        case ENEMY_LANCES_TYPE:
        {
            tmp = new LancesEnemy();
            break;
        }
        case ENEMY_BLADES_TYPE:
        {
            tmp = new BladeEnemy(false);
            break;
        }
        case ENEMY_BLADES_REVERSE_TYPE: //case ENEMY_MOVINGCUBE_TYPE:
        {
            tmp = new BladeEnemy(true); //MovingCubeEnemy();
            break;
        }
        case ENEMY_MOVINGCROSS_TYPE:
        {
            tmp = new MovingCrossEnemy();
            break;
        }
        case ENEMY_MOVINGWALL_TYPE:
        {
            tmp = new MovingWallEnemy(false);
            break;
        }
        case ENEMY_MOVINGWALL_REVERSE_TYPE:
        {
            tmp = new MovingWallEnemy(true);
            break;
        }
        case ENEMY_MOVINGCROSS_SMALL_TYPE:
        {
            tmp = new MovingCrossSmallEnemy();
            break;
        }
        case ENEMY_BOSS_EARTH_TYPE:
        {
            tmp = new BossEarthEnemy();
            break;
        }
        case ENEMY_BOSS_VULCAN_TYPE:
        {
            tmp = new BossVulcanEnemy();
            break;
        }
        case ENEMY_BOSS_OCEAN_TYPE:
        {
            tmp = new BossOceanEnemy();
            break;
        }
        case ENEMY_BOSS_SPACE_TYPE:
        {
            tmp = new BossSpaceEnemy();
            break;
        }
        default:
        {
            break;
        }
    }

    if (IsValidPointer(tmp))
    {
        tmp->SetPositionX((posX + (width / 2)) * 10.0f);
        tmp->SetPositionY(0.0f);
        tmp->SetPositionZ((posY + (height / 2)) * 10.0f);

        tmp->Init(posX, posY, rotation, width, height, szScript);
    }

    return tmp;
}

//////////////////////////
//////////////////////////

Cube* NPCFactory::GetCube(int layer, u8 type_id, short posX, short posY, short width, short height, u8 rotation,
        std::vector<stCUBE_CONFIG_FILE>& cubeConfigVector, const char* szEpisode)
{
    Cube* tmp = new Cube();

    tmp->SetPositionX((posX + (width / 2)) * 10.0f);
    tmp->SetPositionY(0.0f + (layer * 80.0f));
    tmp->SetPositionZ((posY + (height / 2)) * 10.0f);

    tmp->Init(cubeConfigVector[type_id], szEpisode, rotation, layer == 0);

    return tmp;
}

//////////////////////////
//////////////////////////

Decoration* NPCFactory::GetDecoration(int layer, u8 type_id, short posX, short posY, u8 rotation, short width, short height,
        std::vector<stDECO_CONFIG_FILE>& decoConfigVector, const char* szEpisode)
{

    Decoration* tmp = new Decoration();

    short n_width = width;
    short n_height = height;

    if (rotation == 1 || rotation == 3)
    {
        n_width = height;
        n_height = width;
    }

    tmp->SetPositionX((posX + (n_width / 2)) * 10.0f);
    tmp->SetPositionY(40.0f + (layer * 80.0f));
    tmp->SetPositionZ((posY + (n_height / 2)) * 10.0f);

    tmp->Init(decoConfigVector[type_id], szEpisode, rotation, width, height);

    return tmp;
}