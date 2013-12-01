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
 * File:   inputcallback.h
 * Author: nacho
 *
 * Created on 14 de junio de 2009, 23:24
 */

#pragma once
#ifndef _INPUTCALLBACK_H
#define	_INPUTCALLBACK_H

enum eInputCallbackType
{

    PRESS_START,
    PRESS_MOVE,
    PRESS_END
};

struct stInputCallbackParameter
{
    eInputCallbackType type;
    Vec3 vector;
};

//////////////////////////
//////////////////////////

class InputCallbackGeneric
{

public:

    virtual ~InputCallbackGeneric() { };
    virtual void Execute(stInputCallbackParameter parameter, int id) const = 0;
};

//////////////////////////
//////////////////////////

template <class Class>
class InputCallback : public InputCallbackGeneric
{

public:

    typedef void (Class::*Method)(stInputCallbackParameter, int);

private:

    Class* m_pClassInstance;
    Method m_theMethod;

public:

    InputCallback(Class* class_instance, Method method)
    {
        m_pClassInstance = class_instance;
        m_theMethod = method;
    };

    virtual ~InputCallback() { };

    virtual void Execute(stInputCallbackParameter parameter, int id) const
    {
        (m_pClassInstance->*m_theMethod)(parameter, id);
    };
};

#endif	/* _INPUTCALLBACK_H */

