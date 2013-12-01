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
 * File:   parsermanager.cpp
 * Author: nacho
 * 
 * Created on 18 de junio de 2009, 23:35
 */

#include "parsermanager.h"
#include "cube.h"

//////////////////////////
//////////////////////////

ParserManager::ParserManager()
{
    Log("+++ ParserManager::ParserManager ...\n");
    Log("+++ ParserManager::ParserManager correcto\n");
}

//////////////////////////
//////////////////////////

ParserManager::~ParserManager()
{
    Log("+++ ParserManager::~ParserManager ...\n");
    Log("+++ ParserManager::~ParserManager destruido\n");
}

//////////////////////////
//////////////////////////

void ParserManager::GetDecoConfigData(std::vector<stDECO_CONFIG_FILE>* decorationVector, char* szConfigFile)
{
    Log("+++ Parser::GetDecoConfigData %s\n", szConfigFile);

    char* ind = strrchr(szConfigFile, '/');
    char* nameSize = ind + 1;
    char pathSize[256] = {0};
    strncpy(pathSize, szConfigFile, ind - szConfigFile);
    pathSize[ind - szConfigFile] = 0;

    NSString* OCpathSize = [NSString stringWithCString : pathSize encoding : [NSString defaultCStringEncoding]];
    NSString* OCpathName = [NSString stringWithCString : nameSize encoding : [NSString defaultCStringEncoding]];
    NSString* path = [[NSBundle mainBundle] pathForResource : OCpathName ofType : @"config" inDirectory : OCpathSize];

    char current_line[256];
    char prev_line[256];
    std::ifstream myfile([path cStringUsingEncoding : 1]);

    if (!myfile.is_open())
    {
        Log("@@@ ParserManager::GetDecoConfigData imposible abrir \"%s\"\n", szConfigFile);
        return;
    }

    myfile.getline(current_line, 250);
    UTIL_PreParseLine(current_line);

    int line = 1;

    while (!myfile.eof())
    {
        strcpy(prev_line, current_line);
        myfile.getline(current_line, 250);
        UTIL_PreParseLine(current_line);
        line++;

        if (strcmp(current_line, "{") == 0)
        {
            stDECO_CONFIG_FILE deco_tmp;

            deco_tmp.pMesh = NULL;
            deco_tmp.pTexture = NULL;

            while (!myfile.eof() && strcmp(current_line, "}") != 0)
            {
                strcpy(prev_line, current_line);
                myfile.getline(current_line, 250);
                UTIL_PreParseLine(current_line);
                line++;

                int pos = 0;
                char word[100];
                char word2[100];

                UTIL_TakeNextWord(current_line, pos, word, 100);
                UTIL_TakeNextWord(current_line, pos, word2, 100);

                if (strcmp(word, "mesh") == 0)
                {
                    strcpy(deco_tmp.mesh, word2);
                }
                else if (strcmp(word, "tex") == 0)
                {
                    strcpy(deco_tmp.texture, word2);
                }
                else if (strcmp(word, "opacity") == 0)
                {
                    if (strcmp(word2, "no") == 0)
                    {
                        deco_tmp.opacity = DECO_OPACITY_NO;
                    }
                    else if (strcmp(word2, "transparent") == 0)
                    {
                        deco_tmp.opacity = DECO_OPACITY_TRANSPARENT;
                    }
                    else if (strcmp(word2, "additive") == 0)
                    {
                        deco_tmp.opacity = DECO_OPACITY_ADDITIVE;
                    }
                    else
                    {
                        Log("@@@ ParserManager::GetDecoConfigData error en 'opacity' \"%s\" line: %d word: %s\n", szConfigFile, line, word2);
                    }
                }
                else if(strcmp(word, "}") != 0)
                {
                    Log("@@@ ParserManager::GetDecoConfigData error, campo no reconocido: '%s' \"%s\" line: %d\n", word, szConfigFile, line);
                }
            }

            decorationVector->push_back(deco_tmp);
        }
    }


    myfile.close();

    Log("+++ Parser::GetDecoConfigData correcto: %s\n", szConfigFile);
}

//////////////////////////
//////////////////////////

void ParserManager::GetCubeConfigData(std::vector<stCUBE_CONFIG_FILE>* cubeVector, char* szConfigFile)
{
    Log("+++ Parser::GetCubeConfigData %s\n", szConfigFile);

    char* ind = strrchr(szConfigFile, '/');
    char* nameSize = ind + 1;
    char pathSize[256] = {0};
    strncpy(pathSize, szConfigFile, ind - szConfigFile);
    pathSize[ind - szConfigFile] = 0;

    NSString* OCpathSize = [NSString stringWithCString : pathSize encoding : [NSString defaultCStringEncoding]];
    NSString* OCpathName = [NSString stringWithCString : nameSize encoding : [NSString defaultCStringEncoding]];
    NSString* path = [[NSBundle mainBundle] pathForResource : OCpathName ofType : @"config" inDirectory : OCpathSize];

    char current_line[256];
    char prev_line[256];
    std::ifstream myfile([path cStringUsingEncoding : 1]);

    if (!myfile.is_open())
    {
        Log("@@@ ParserManager::GetCubeConfigData imposible abrir \"%s\"\n", szConfigFile);
        return;
    }

    myfile.getline(current_line, 250);
    UTIL_PreParseLine(current_line);

    int line = 1;
 
    while (!myfile.eof())
    {
        strcpy(prev_line, current_line);
        myfile.getline(current_line, 250);
        UTIL_PreParseLine(current_line);
        line++;

        if (strcmp(current_line, "{") == 0)
        {
            stCUBE_CONFIG_FILE cube_tmp;

            cube_tmp.pMesh = NULL;
            cube_tmp.pTexture = NULL;
            cube_tmp.pGlowTexture = NULL;

            while (!myfile.eof() && strcmp(current_line, "}") != 0)
            {
                strcpy(prev_line, current_line);
                myfile.getline(current_line, 250);
                UTIL_PreParseLine(current_line);
                line++;

                int pos = 0;
                char word[100];
                char word2[100];

                UTIL_TakeNextWord(current_line, pos, word, 100);
                UTIL_TakeNextWord(current_line, pos, word2, 100);

                if (strcmp(word, "mesh") == 0)
                {
                    strcpy(cube_tmp.mesh, word2);
                }
                else if (strcmp(word, "tex") == 0)
                {
                    strcpy(cube_tmp.texture, word2);
                }
                else if (strcmp(word, "glow") == 0)
                {
                    strcpy(cube_tmp.glow_texture, word2);
                }
                else if (strcmp(word, "opacity") == 0)
                {
                    if (strcmp(word2, "no") == 0)
                    {
                        cube_tmp.opacity = CUBE_OPACITY_NO;
                    }
                    else if (strcmp(word2, "transparent") == 0)
                    {
                        cube_tmp.opacity = CUBE_OPACITY_TRANSPARENT;
                    }
                    else if (strcmp(word2, "additive") == 0)
                    {
                        cube_tmp.opacity = CUBE_OPACITY_ADDITIVE;
                    }
                    else
                    {
                        Log("@@@ ParserManager::GetCubeConfigData error en 'opacity' \"%s\" line: %d word: %s\n", szConfigFile, line, word2);
                    }
                }
                else if (strcmp(word, "fade") == 0)
                {
                    cube_tmp.fade = atof(word2);
                }
                else if (strcmp(word, "friction") == 0)
                {
                    cube_tmp.friction = atof(word2);
                }
                else if (strcmp(word, "break") == 0)
                {
                    if (strcmp(word2, "yes") == 0)
                    {
                        cube_tmp.cube_break = true;
                    }
                    else if (strcmp(word2, "no") == 0)
                    {
                        cube_tmp.cube_break = false;
                    }
                    else
                    {
                        Log("@@@ ParserManager::GetCubeConfigData error en 'break' \"%s\" line: %d word: %s\n", szConfigFile, line, word2);
                    }
                }
                else if (strcmp(word, "door") == 0)
                {
                    if (strcmp(word2, "no") == 0)
                    {
                        cube_tmp.door = CUBE_DOOR_NO;
                    }
                    else if (strcmp(word2, "blue") == 0)
                    {
                        cube_tmp.door = CUBE_DOOR_BLUE;
                    }
                    else if (strcmp(word2, "red") == 0)
                    {
                        cube_tmp.door = CUBE_DOOR_RED;
                    }
                    else
                    {
                        Log("@@@ ParserManager::GetCubeConfigData error en 'door' \"%s\" line: %d word: %s\n", szConfigFile, line, word2);
                    }
                }
                else if (strcmp(word, "sound") == 0)
                {
                    strcpy(cube_tmp.sound, word2);
                }
                else if (strcmp(word, "invisible") == 0)
                {
                    if (strcmp(word2, "yes") == 0)
                    {
                        cube_tmp.invisible = true;
                    }
                    else if (strcmp(word2, "no") == 0)
                    {
                        cube_tmp.invisible = false;
                    }
                    else
                    {
                        Log("@@@ ParserManager::GetCubeConfigData error en 'sound' \"%s\" line: %d word: %s\n", szConfigFile, line, word2);
                    }
                }
                else if(strcmp(word, "}") != 0)
                {
                    Log("@@@ ParserManager::GetCubeConfigData error, campo no reconocido: '%s' \"%s\" line: %d\n", word, szConfigFile, line);
                }
            }

            cubeVector->push_back(cube_tmp);
        }
    }

    myfile.close();

    Log("+++ Parser::GetCubeConfigData correcto: %s\n", szConfigFile);
}

//////////////////////////
//////////////////////////

void ParserManager::GetEpisodeConfigData(std::vector<stEPISODE_CONFIG_FILE>* episodeVector, char* szConfigFile)
{
    Log("+++ Parser::GetEpisodeConfigData %s\n", szConfigFile);

    char* ind = strrchr(szConfigFile, '/');
    char* nameSize = ind + 1;
    char pathSize[256] = {0};
    strncpy(pathSize, szConfigFile, ind - szConfigFile);
    pathSize[ind - szConfigFile] = 0;

    NSString* OCpathSize = [NSString stringWithCString : pathSize encoding : [NSString defaultCStringEncoding]];
    NSString* OCpathName = [NSString stringWithCString : nameSize encoding : [NSString defaultCStringEncoding]];
    NSString* path = [[NSBundle mainBundle] pathForResource : OCpathName ofType : @"config" inDirectory : OCpathSize];

    char current_line[256];
    char prev_line[256];
    std::ifstream myfile([path cStringUsingEncoding : 1]);

    if (!myfile.is_open())
    {
        Log("@@@ ParserManager::GetEpisodeConfigData imposible abrir \"%s\"\n", szConfigFile);
        return;
    }

    myfile.getline(current_line, 250);
    UTIL_PreParseLine(current_line);

    int line = 1;

    while (!myfile.eof())
    {
        strcpy(prev_line, current_line);
        myfile.getline(current_line, 250);
        UTIL_PreParseLine(current_line);
        line++;

        if (strcmp(current_line, "{") == 0)
        {
            stEPISODE_CONFIG_FILE episode_tmp;

            while (!myfile.eof() && strcmp(current_line, "}") != 0)
            {
                strcpy(prev_line, current_line);
                myfile.getline(current_line, 250);
                UTIL_PreParseLine(current_line);
                line++;

                int pos = 0;
                char word[100];
                char word2[100];

                UTIL_TakeNextWord(current_line, pos, word, 100);
                UTIL_TakeNextName(current_line, pos, word2, 100);

                if (strcmp(word, "name") == 0)
                {
                    strcpy(episode_tmp.name, word2);
                }
                else if (strcmp(word, "folder") == 0)
                {
                    strcpy(episode_tmp.folder, word2);
                }                
                else if(strcmp(word, "}") != 0)
                {
                    Log("@@@ ParserManager::GetEpisodeConfigData error, campo no reconocido: '%s' \"%s\" line: %d\n", word, szConfigFile, line);
                }
            }

            episodeVector->push_back(episode_tmp);
        }
    }

    myfile.close();

    Log("+++ Parser::GetEpisodeConfigData correcto: %s\n", szConfigFile);
}

