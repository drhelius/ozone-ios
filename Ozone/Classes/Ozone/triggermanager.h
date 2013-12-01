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
 * File:   triggermanager.h
 * Author: nacho
 *
 * Created on 4 de agosto de 2009, 19:32
 */

#pragma once
#ifndef _TRIGGERMANAGER_H
#define	_TRIGGERMANAGER_H

#include "singleton.h"
#include "triggers.h"
#include <list>

class TriggerManager : public Singleton<TriggerManager>
{

    ////friend class Singleton<TriggerManager>;

private:
    
    struct stTriggerNode
    {

        Trigger* pointer;
        bool managed;
    };

    typedef std::list<stTriggerNode> TNodeList;
    typedef TNodeList::iterator TNodeListIterator;

    TNodeList m_TriggerList;

public:

    TriggerManager(void);
    ~TriggerManager();

    void Add(Trigger* pTrigger, bool managed);

    void Update(float fdTime);

    void DeleteAll(void);

};

#endif	/* _TRIGGERMANAGER_H */

