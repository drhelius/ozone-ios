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
 * File:   InGameMenuText.h
 * Author: nacho
 *
 * Created on 27 de febrero de 2010, 18:29
 */

#ifndef _INGAMEMENUTEXT_H
#define	_INGAMEMENUTEXT_H

#include "InGameMenu.h"
#include "inputmanager.h"
#include "textfont.h"

class InGameMenuText : public InGameMenu
{

private:

    int m_iCurrentTutorialPopUp;
    RenderObject m_OKRO;

    InputCallback<InGameMenuText>* m_pInputCallbackOK;
    InputCallbackGeneric* m_pInputResponseOK;

    TextFont* m_pTextFont;

public:

    InGameMenuText(Timer* pTimer);
    virtual ~InGameMenuText();

    virtual void Init(float width, float height);
    virtual void Update(void);

    virtual void Show(void);

    void InputOK(stInputCallbackParameter parameter, int id);

    void SetCallbackOK(InputCallbackGeneric* pCallback)
    {
        m_pInputResponseOK = pCallback;
    };

    void SetCurrentTutorialPopUp(int number)
    {
        m_iCurrentTutorialPopUp = number;
    };
};

#endif	/* _INGAMEMENUTEXT_H */

