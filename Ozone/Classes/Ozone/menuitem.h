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
 * File:   menuitem.h
 * Author: nacho
 *
 * Created on 12 de junio de 2009, 0:27
 */

#ifndef _MENUITEM_H
#define	_MENUITEM_H

#include "moveable.h"
#include "renderobject.h"

class MenuItem : public Moveable
{

public:

    RenderObject renderObject;
    char* text;

    MenuItem(void);
    ~MenuItem(void);
};

#endif	/* _MENUITEM_H */

