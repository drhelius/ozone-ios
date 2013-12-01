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
 * File:   SaveManager.mm
 * Author: nacho
 * 
 * Created on 3 de marzo de 2010, 18:28
 */

#include "SaveManager.h"

//////////////////////////
//////////////////////////

SaveManager::SaveManager()
{
    Log("+++ SaveManager::SaveManager ...\n");

    for (int i = 0; i < 3; i++)
    {
        for (int episode = 0; episode < MAX_EPISODE_SLOTS; episode++)
        {
            for (int level = 0; level < MAX_LEVELS_PER_EPISODE; level++)
            {
                m_SaveSlots[i].level_complete[episode][level] = false;
            }
        }

        m_SaveSlots[i].score = 0;
        m_SaveSlots[i].used = false;
        m_SaveSlots[i].date = 0;
        m_SaveSlots[i].total_seconds = 0;
    }

    m_WaitingScoreSlot.level_complete = 0;
    m_WaitingScoreSlot.score = 0;
    m_WaitingScoreSlot.total_seconds = 0;
    m_WaitingScoreSlot.waiting = false;

    m_iCurrentSlot = 0;

    m_iAward = 5;

    Log("+++ SaveManager::SaveManager correcto\n");
}

//////////////////////////
//////////////////////////

SaveManager::~SaveManager()
{
    Log("+++ SaveManager::~SaveManager ...\n");

    Log("+++ SaveManager::~SaveManager destruido\n");
}

//////////////////////////
//////////////////////////

void SaveManager::ClearSlot(int slot)
{
    Log("+++ SaveManager::ClearSlot ...\n");

    for (int episode = 0; episode < MAX_EPISODE_SLOTS; episode++)
    {
        for (int level = 0; level < MAX_LEVELS_PER_EPISODE; level++)
        {
            m_SaveSlots[slot].level_complete[episode][level] = false;
        }
    }

    m_SaveSlots[slot].score = 0;
    m_SaveSlots[slot].used = false;
    m_SaveSlots[slot].date = 0;
    m_SaveSlots[slot].total_seconds = 0;

    Log("+++ SaveManager::ClearSlot correcto\n");
}

//////////////////////////
//////////////////////////

bool SaveManager::LevelCompleted(int episode, int level, int seconds)
{
    Log("+++ SaveManager::LevelCompleted ...\n");

    bool ret = m_SaveSlots[m_iCurrentSlot].level_complete[episode][level];

    if (!ret)
    {
        m_SaveSlots[m_iCurrentSlot].total_seconds += seconds;
        m_SaveSlots[m_iCurrentSlot].score += 2473 + (level * 3) + (episode * 9) - seconds;
    }

    m_SaveSlots[m_iCurrentSlot].level_complete[episode][level] = true;

    time(&m_SaveSlots[m_iCurrentSlot].date);

    Log("+++ SaveManager::LevelCompleted correcto\n");

    return ret;
}

//////////////////////////
//////////////////////////

void SaveManager::SaveToFile(void)
{
    Log("+++ SaveManager::SaveToFile ...\n");

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"paths=%@", paths);
    NSString *documentsDirectory = [paths objectAtIndex : 0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent : @"savegame.dat"];

    FILE* pFile = fopen([path cStringUsingEncoding : 1], "wb");

    if (pFile == NULL)
    {
        Log("@@@ SaveManager::SaveToFile Imposible abrir el fichero para escritura: %s\n", [path cStringUsingEncoding : 1]);
        return;
    }

    int count = 0;
    count += fwrite(m_SaveSlots, 3, sizeof (stSaveSlot), pFile);
    count += fwrite(&m_WaitingScoreSlot, 1, sizeof (stWaitingScoreSlot), pFile);

    if (m_iAward < 1 || m_iAward > 3)
    {
        m_iAward = 5;
    }

    count += fwrite(&m_iAward, 1, sizeof (int), pFile);

    fclose(pFile);


    Log("+++ SaveManager::SaveToFile correcto\n");
}

//////////////////////////
//////////////////////////

void SaveManager::LoadFromFile(void)
{
    Log("+++ SaveManager::LoadFromFile ...\n");

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"paths=%@", paths);
    NSString *documentsDirectory = [paths objectAtIndex : 0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent : @"savegame.dat"];

    FILE* pFile = fopen([path cStringUsingEncoding : 1], "rb");

    if (pFile == NULL)
    {
        Log("@@@ SaveManager::LoadFromFile Imposible abrir el fichero para lectura: %s\n", [path cStringUsingEncoding : 1]);

        SaveToFile();
        return;
    }

    int count = 0;

    size_t result = fread(m_SaveSlots, 3, sizeof (stSaveSlot), pFile);
    count += result;

    if (result != (sizeof (stSaveSlot) * 1))
    {
        Log("@@@ SaveManager::LoadFromFile Error de lectura 1: %s\n", [path cStringUsingEncoding : 1]);
    }

    result = fread(&m_WaitingScoreSlot, 1, sizeof (stWaitingScoreSlot), pFile);
    count += result;

    if (result != (sizeof (stWaitingScoreSlot) * 1))
    {
        Log("@@@ SaveManager::LoadFromFile Error de lectura 2: %s\n", [path cStringUsingEncoding : 1]);
    }

    result = fread(&m_iAward, 1, sizeof (int), pFile);
    count += result;

    if (result != (sizeof (int) * 1))
    {
        Log("@@@ SaveManager::LoadFromFile Error de lectura 3: %s\n", [path cStringUsingEncoding : 1]);
    }

    fclose(pFile);

    Log("+++ SaveManager::LoadFromFile correcto\n");
}

//////////////////////////
//////////////////////////

int SaveManager::GetLevelCompleted(void)
{
    int count = 0;
    bool end = false;

    for (int episode = 0; episode < MAX_EPISODE_SLOTS; episode++)
    {
        for (int level = 0; level < MAX_LEVELS_PER_EPISODE; level++)
        {
            if (episode == 0 && level > 5)
            {
                count += 6;
                break;
            }

            if (!m_SaveSlots[m_iCurrentSlot].level_complete[episode][level])
            {
                end = true;
                break;
            }
            else
            {
                count++;
            }
        }

        if (end)
        {
            break;
        }
    }

    return count;
}

//////////////////////////
//////////////////////////

bool SaveManager::IsLevelAlertFirstTime(void)
{
    Log("+++ SaveManager::IsLevelAlertFirstTime ...\n");
    
    bool ret = false;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"paths=%@", paths);
    NSString *documentsDirectory = [paths objectAtIndex : 0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent : @"alert.dat"];

    FILE* pFile = fopen([path cStringUsingEncoding : 1], "rb");

    if (pFile == NULL)
    {
        ret = true;
        
        Log("+++ SaveManager::IsLevelAlertFirstTime Imposible abrir el fichero para lectura: %s\n", [path cStringUsingEncoding : 1]);
        
        pFile = fopen([path cStringUsingEncoding : 1], "wb");

        if (pFile == NULL)
        {
            Log("@@@ SaveManager::SaveToFile Imposible abrir el fichero para escritura: %s\n", [path cStringUsingEncoding : 1]);
            return false;
        }
        
        int dummy = 7;
        
        fwrite(&dummy, sizeof(int), 1, pFile);
    }
    else
    {
        ret = false;
    }
    
    fclose(pFile);

    Log("+++ SaveManager::IsLevelAlertFirstTime correcto\n");
    
    return ret;
}

