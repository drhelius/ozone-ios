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
 * File:   episode.cpp
 * Author: nacho
 * 
 * Created on 29 de julio de 2009, 20:23
 */

#include "episode.h"

//////////////////////////
//////////////////////////

Episode::Episode()
{

}

//////////////////////////
//////////////////////////

Episode::~Episode()
{
}

//////////////////////////
//////////////////////////

void Episode::Init(stEPISODE_CONFIG_FILE config)
{
    char folderPath[100];
    char levelsFolderPath[100];

    sprintf(folderPath, "game/episodes/%s", config.folder);
    sprintf(levelsFolderPath, "game/episodes/%s/levels", config.folder);

    m_strName.assign(config.name);
    m_strFolder.assign(folderPath);

    NSString* OClevelsFolderPath = [NSString stringWithCString : levelsFolderPath encoding : [NSString defaultCStringEncoding]];

    NSString *file;

    NSString *levelsDir = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent : OClevelsFolderPath];

    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath : levelsDir];

    while (file = [dirEnum nextObject])
    {

        if ([[file pathExtension] isEqualToString : @"oil"])
        {

            char fullPath[256];

            sprintf(fullPath, "%s/%s", levelsFolderPath, [file cStringUsingEncoding : 1]);

            m_LevelPathList.push_back(fullPath);
        }
    }
}

