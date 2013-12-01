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
 * File:   SaveManager.h
 * Author: nacho
 *
 * Created on 3 de marzo de 2010, 18:28
 */

#ifndef _SAVEMANAGER_H
#define	_SAVEMANAGER_H

#include "singleton.h"
#include "gamemanager.h"
#include "audio.h"

struct stSaveSlot
{

    bool used;
    time_t date; //strftime
    char name[20];
    int score;
    bool level_complete[MAX_EPISODE_SLOTS][MAX_LEVELS_PER_EPISODE];
    int total_seconds;
};

struct stWaitingScoreSlot
{

    bool waiting;
    char name[20];
    int score;
    int level_complete;
    int total_seconds;
};

class SaveManager : public Singleton<SaveManager>
{

private:

    stSaveSlot m_SaveSlots[3];

    int m_iCurrentSlot;

    int m_iAward;

    stWaitingScoreSlot m_WaitingScoreSlot;

public:

    SaveManager();
    ~SaveManager();

    void SetAward(int position)
    {
        if (position < m_iAward)
        {
            m_iAward = position;
        }
    };

    int GetAward(void)
    {
        return m_iAward;
    };

    void SetCurrentSlot(int slot)
    {
        m_iCurrentSlot = slot;

#ifndef OZONE_LITE
        ///--- cheating uh!
        if (strcmp(m_SaveSlots[m_iCurrentSlot].name, "damnimgood") == 0)
        {
            GameManager::Instance().SetCheatPlayAllLevels(true);
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_EPISODE_UNLOCK));
        }
        else
        {
            GameManager::Instance().SetCheatPlayAllLevels(false);
        }
#endif
    };

    void SaveToFile(void);
    void LoadFromFile(void);
    
    bool IsLevelAlertFirstTime(void);

    bool LevelCompleted(int episode, int level, int seconds);

    bool IsLevelCompleted(int episode, int level) const
    {
        return m_SaveSlots[m_iCurrentSlot].level_complete[episode][level];
    };

    int GetScore(void) const
    {
        return m_SaveSlots[m_iCurrentSlot].score;
    };

    time_t GetDate(void) const
    {
        return m_SaveSlots[m_iCurrentSlot].date;
    };

    char* GetName(void)
    {
        return m_SaveSlots[m_iCurrentSlot].name;
    };

    void SetName(const char* szName)
    {
        strcpy(m_SaveSlots[m_iCurrentSlot].name, szName);
        time(&m_SaveSlots[m_iCurrentSlot].date);
    };

    bool IsSlotUsed(int slot, int level) const
    {
        return m_SaveSlots[slot].used;
    };

    void UseSlot(int slot)
    {
        m_SaveSlots[slot].used = true;
    };

    stSaveSlot* GetSlot(int slot)
    {
        return &m_SaveSlots[slot];
    };

    void ClearSlot(int slot);

    int GetLevelCompleted(void);

    void StoreForUpload(void)
    {
        m_WaitingScoreSlot.waiting = true;

        m_WaitingScoreSlot.level_complete = GetLevelCompleted();
        m_WaitingScoreSlot.score = GetScore();
        m_WaitingScoreSlot.total_seconds = m_SaveSlots[m_iCurrentSlot].total_seconds;
        strcpy(m_WaitingScoreSlot.name, GetName());
    };

    void ClearForUpload(void)
    {
        m_WaitingScoreSlot.waiting = false;
    };

    stWaitingScoreSlot GetWaitingScore(void)
    {
        return m_WaitingScoreSlot;
    };

    bool WaitingToUploadScore(void)
    {
        return m_WaitingScoreSlot.waiting;
    };
};

#endif	/* _SAVEMANAGER_H */

