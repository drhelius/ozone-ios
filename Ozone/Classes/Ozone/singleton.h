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
 * File:   singleton.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 20:58
 */

#pragma once
#ifndef _SINGLETON_H
#define	_SINGLETON_H

#include "defines.h"

template<typename T> class Singleton
{
public:

    static T& Instance(void)
    {
        static T singleton;

        return singleton;
    };
};

#endif	/* _SINGLETON_H */

