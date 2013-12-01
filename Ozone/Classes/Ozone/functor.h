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
 * File:   functor.h
 * Author: nacho
 *
 * Created on 4 de agosto de 2009, 19:25
 */

#pragma once
#ifndef _FUNCTOR_H
#define	_FUNCTOR_H

class Functor
{

public:

    virtual ~Functor()
    {
    };
    
    virtual void operator ()() = 0;
};

template<class Class>
class ObjFunctor : public Functor
{

protected:
    Class* m_pClassInstance;
    typedef void (Class::*funcType)();
    funcType m_theMethod;

public:

    ObjFunctor(Class* object, funcType method)
    {
        m_pClassInstance = object;
        m_theMethod = method;
    };

    void operator ()()
    {
        (m_pClassInstance->*m_theMethod)();
    };
};

#endif	/* _FUNCTOR_H */

