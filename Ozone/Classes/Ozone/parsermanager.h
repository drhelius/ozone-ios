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
 * File:   parsermanager.h
 * Author: nacho
 *
 * Created on 18 de junio de 2009, 23:35
 */

#pragma once
#ifndef _PARSERMANAGER_H
#define	_PARSERMANAGER_H

#include "defines.h"
#include "singleton.h"
#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include "cube.h"
#include "decoration.h"
#include "episode.h"

class ParserManager : public Singleton<ParserManager>
{

    ////friend class Singleton<ParserManager>;

public:

    ParserManager();
    ~ParserManager();

    void GetCubeConfigData(std::vector<stCUBE_CONFIG_FILE>* cubeVector, char* szConfigFile);
    void GetDecoConfigData(std::vector<stDECO_CONFIG_FILE>* decorationVector, char* szConfigFile);
    void GetEpisodeConfigData(std::vector<stEPISODE_CONFIG_FILE>* episodeVector, char* szConfigFile);

};

#endif	/* _PARSERMANAGER_H */

