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
 * File:   levelgamestate.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 21:02
 */

#pragma once
#ifndef _LEVELGAMESTATE_H
#define	_LEVELGAMESTATE_H

#include "singleton.h"
#include "gamestate.h"
#include "timer.h"
#include "fader.h"
#include "scene.h"

class LevelGameState : public GameState, public Singleton<LevelGameState>
{

    ////friend class Singleton<LevelGameState>;

private:

    Timer* m_pMainTimer;
    Timer* m_pMenuTimer;
    Fader* m_pFader;

    Scene* m_pScene;    

    char m_szCurrentLevel[200];
    char m_szCurrentEpisode[200];

    bool m_bFinishing;
    bool m_bReseting;

    int m_iLevel;

    bool m_bChangeMusic;
    bool m_bIsCustomLevel;

public:

    LevelGameState(void);
    ~LevelGameState();

    void Init(void);
    void Cleanup(void);

    void Pause(void);
    void Resume(void);

    void Update(void);

    void PrepareLevelForLoading(const char* szLevelPath, const char* szEpisodePath, int level, bool changeMusic, bool isCustomLevel = false);

    bool IsFaderFinished(void) const
    {
        return m_pFader->IsFinished();
    }

};

#endif	/* _LEVELGAMESTATE_H */

