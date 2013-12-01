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
 * File:   InGameMenuDie.h
 * Author: nacho
 *
 * Created on 23 de febrero de 2010, 16:18
 */

#ifndef _INGAMEMENUDIE_H
#define	_INGAMEMENUDIE_H

#include "InGameMenu.h"
#include "inputmanager.h"

class InGameMenuDie : public InGameMenu
{

private:

    RenderObject m_RestartRO;
    RenderObject m_MainMenuRO;

    InputCallback<InGameMenuDie>* m_pInputCallbackRestart;
    InputCallback<InGameMenuDie>* m_pInputCallbackMainMenu;
    InputCallbackGeneric* m_pInputResponseRestart;
    InputCallbackGeneric* m_pInputResponseMainMenu;

public:

    InGameMenuDie(Timer* pTimer);
    virtual ~InGameMenuDie();

    virtual void Init(float width, float height);
    virtual void Update(void);

    virtual void Show(void);

    void InputRestart(stInputCallbackParameter parameter, int id);
    void InputMainMenu(stInputCallbackParameter parameter, int id);

    void SetCallbackRestart(InputCallbackGeneric* pCallback)
    {
        m_pInputResponseRestart = pCallback;
    };

    void SetCallbackMainMenu(InputCallbackGeneric* pCallback)
    {
        m_pInputResponseMainMenu = pCallback;
    };
};

#endif	/* _INGAMEMENUDIE_H */

