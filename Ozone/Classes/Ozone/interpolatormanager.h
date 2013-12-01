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
 * File:   interpolatormanager.h
 * Author: nacho
 *
 * Created on 3 de agosto de 2009, 17:21
 */

#pragma once
#ifndef _INTERPOLATORMANAGER_H
#define	_INTERPOLATORMANAGER_H

#include "singleton.h"
#include "interpolators.h"
#include "timer.h"
#include <list>

class InterpolatorManager : public Singleton<InterpolatorManager>
{

    ////friend class Singleton<InterpolatorManager>;

private:

    struct stInterpolatorNode
    {

        Interpolator* pointer;
        bool managed;
        Timer* timer;
    };

    typedef std::list<stInterpolatorNode> TNodeList;
    typedef TNodeList::iterator TNodeListIterator;

    TNodeList m_InterpolatorList;

    

public:

    InterpolatorManager(void);
    ~InterpolatorManager();

    void Add(Interpolator* pInterpolator, bool managed, Timer* pTimer = NULL);

    void Update(float fdTime);

    void DeleteAll(void);

    void Delete(Interpolator* pInterpolator);
};

#endif	/* _INTERPOLATORMANAGER_H */

