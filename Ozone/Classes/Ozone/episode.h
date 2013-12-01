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
 * File:   episode.h
 * Author: nacho
 *
 * Created on 29 de julio de 2009, 20:23
 */

#pragma once
#ifndef _EPISODE_H
#define	_EPISODE_H

#include "defines.h"
#include <vector>
#include <string>

struct stEPISODE_CONFIG_FILE
{

    char name[100];
    char folder[100];
};

class Episode
{

private:

    std::string m_strName;
    std::string m_strFolder;

    typedef std::vector<std::string> TStringVector;

    TStringVector m_LevelPathList;


public:

    Episode();
    ~Episode();

    void Init(stEPISODE_CONFIG_FILE config);

    const std::string& GetName(void)
    {
        return m_strName;
    };

    const std::string& GetFolder(void)
    {
        return m_strFolder;
    };
    const TStringVector& GetLevelPathList(void)
    {
        return m_LevelPathList;
    };

};

#endif	/* _EPISODE_H */

