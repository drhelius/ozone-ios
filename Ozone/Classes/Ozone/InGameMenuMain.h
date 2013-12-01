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
 * File:   InGameMenuMain.h
 * Author: nacho
 *
 * Created on 17 de febrero de 2010, 16:53
 */

#ifndef _INGAMEMENUMAIN_H
#define	_INGAMEMENUMAIN_H

#include "InGameMenu.h"
#include "inputmanager.h"

class InGameMenuMain : public InGameMenu
{

private:

    RenderObject m_ContinueRO;
    RenderObject m_RestartRO;
    RenderObject m_MainMenuRO;    

    InputCallback<InGameMenuMain>* m_pInputCallbackContinue;
    InputCallback<InGameMenuMain>* m_pInputCallbackRestart;
    InputCallback<InGameMenuMain>* m_pInputCallbackMainMenu;
    InputCallbackGeneric* m_pInputResponseContinue;
    InputCallbackGeneric* m_pInputResponseRestart;
    InputCallbackGeneric* m_pInputResponseMainMenu;

public:

    InGameMenuMain(Timer* pTimer);
    virtual ~InGameMenuMain();

    virtual void Init(float width, float height);
    virtual void Update(void);

    virtual void Show(void);

    void InputContinue(stInputCallbackParameter parameter, int id);
    void InputRestart(stInputCallbackParameter parameter, int id);
    void InputMainMenu(stInputCallbackParameter parameter, int id);

    void SetCallbackContinue(InputCallbackGeneric* pCallback)
    {
        m_pInputResponseContinue = pCallback;
    };

    void SetCallbackRestart(InputCallbackGeneric* pCallback)
    {
        m_pInputResponseRestart = pCallback;
    };

    void SetCallbackMainMenu(InputCallbackGeneric* pCallback)
    {
        m_pInputResponseMainMenu = pCallback;
    };
};

#endif	/* _INGAMEMENUMAIN_H */

