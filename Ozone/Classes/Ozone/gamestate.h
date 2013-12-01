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
 * File:   gamestate.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 21:01
 */

#pragma once
#ifndef _GAMESTATE_H
#define	_GAMESTATE_H

class GameState
{

protected:

    bool m_bNeedCleanup;

public:

    GameState(void)
    {
        m_bNeedCleanup = false;
    };

    virtual ~GameState(void)
    {
    };

    virtual void Init(void) = 0;
    virtual void Cleanup(void) = 0;

    virtual void Pause(void) = 0;
    virtual void Resume(void) = 0;

    virtual void Update(void) = 0;
};

#endif	/* _GAMESTATE_H */

