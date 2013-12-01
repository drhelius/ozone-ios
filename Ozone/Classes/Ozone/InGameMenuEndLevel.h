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
 * File:   InGameMenuEndLevel.h
 * Author: nacho
 *
 * Created on 23 de febrero de 2010, 16:19
 */

#ifndef _INGAMEMENUENDLEVEL_H
#define	_INGAMEMENUENDLEVEL_H

#include "InGameMenu.h"
#include "inputmanager.h"

class InGameMenuEndLevel : public InGameMenu
{

private:

    RenderObject m_NextRO;
    RenderObject m_MainMenuRO;

    InputCallback<InGameMenuEndLevel>* m_pInputCallbackNext;
    InputCallback<InGameMenuEndLevel>* m_pInputCallbackMainMenu;
    InputCallbackGeneric* m_pInputResponseNext;
    InputCallbackGeneric* m_pInputResponseMainMenu;

    bool m_bEndOfEpisode;

public:

    InGameMenuEndLevel(Timer* pTimer);
    virtual ~InGameMenuEndLevel();

    virtual void Init(float width, float height);
    virtual void Update(void);

    virtual void Show(void);

    void InputNext(stInputCallbackParameter parameter, int id);
    void InputMainMenu(stInputCallbackParameter parameter, int id);

    void SetCallbackNext(InputCallbackGeneric* pCallback)
    {
        m_pInputResponseNext = pCallback;
    };

    void SetCallbackMainMenu(InputCallbackGeneric* pCallback)
    {
        m_pInputResponseMainMenu = pCallback;
    };

    void SetEndOfEpisode(void)
    {
        m_bEndOfEpisode = true;
    };
};

#endif	/* _INGAMEMENUENDLEVEL_H */

