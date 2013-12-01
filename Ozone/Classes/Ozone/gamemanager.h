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
 * File:   gamemanager.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 21:00
 */

#pragma once
#ifndef _GAMEMANAGER_H
#define	_GAMEMANAGER_H

#include "singleton.h"
#import "OzoneAppDelegate.h"

class GameState;

class GameManager : public Singleton<GameManager>
{

    ////friend class Singleton<GameManager>;

public:

    enum eDeviceType
    {

        DEVICE_3RD_GEN,
        DEVICE_2ND_GEN,
        DEVICE_1ST_GEN
    };

private:

    char m_szDownloadCode[10];

    OzoneAppDelegate* m_pDelegate;
    UIWindow* m_pWindow;

    GameState* m_pTheState;
    GameState* m_pNextState;

    bool m_bWantsToChangeState;

    bool m_bIsClean;
    bool m_bIsHomeRight;
    bool m_bPlayAllLevels;

    double m_dBeginTime;

    eDeviceType m_DeviceType;

    void CheckDeviceType(void);

public:

    GameManager(void);
    ~GameManager();

    void Init(bool isHomeRight, OzoneAppDelegate* pDelegate, UIWindow* pWindow);
    void Cleanup(void);
    void ChangeState(GameState* state);
    void Update(void);

    void SetHomeRight(bool homeRight)
    {
        m_bIsHomeRight = homeRight;
    };

    bool IsHomeRight(void) const
    {
        return m_bIsHomeRight;
    };

    eDeviceType DeviceType(void) const
    {
        return m_DeviceType;
    };

    OzoneAppDelegate* GetAppDelegate(void)
    {
        return m_pDelegate;
    };

    UIWindow* GetAppWindow(void)
    {
        return m_pWindow;
    };

    void SetCheatPlayAllLevels(bool cheating)
    {
        m_bPlayAllLevels = cheating;
    };

    bool GetCheatPlayAllLevels(void)
    {
        return m_bPlayAllLevels;
    };

    void SetDownloadCode(const char* code)
    {
        strcpy(m_szDownloadCode, code);
    };

    const char* GetDownloadCode(void)
    {
        return m_szDownloadCode;
    };
};

#endif	/* _GAMEMANAGER_H */

