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
 * File:   triggermanager.cpp
 * Author: nacho
 * 
 * Created on 4 de agosto de 2009, 19:32
 */

#include "triggermanager.h"

TriggerManager::TriggerManager(void)
{
    Log("+++ TriggerManager::TriggerManager ...\n");

    Log("+++ TriggerManager::TriggerManager correcto\n");
}

//////////////////////////
//////////////////////////

TriggerManager::~TriggerManager()
{
    Log("+++ TriggerManager::~TriggerManager ...\n");

    DeleteAll();

    Log("+++ TriggerManager::~TriggerManager destruido\n");
}

//////////////////////////
//////////////////////////

void TriggerManager::Add(Trigger* pTrigger, bool managed)
{
    stTriggerNode node;

    node.pointer = pTrigger;
    node.managed = managed;

    m_TriggerList.push_back(node);

    Log("+++ TriggerManager::~Add añadido trigger %s \n", managed ? "managed" : " ");
}

//////////////////////////
//////////////////////////

void TriggerManager::Update(float fdTime)
{
    TNodeListIterator it = m_TriggerList.begin();

    while (it != m_TriggerList.end())
    {
        stTriggerNode node = (*it);

        if (node.pointer->CanKill())
        {
            if (node.managed)
            {
                SafeDelete(node.pointer);
            }

            it = m_TriggerList.erase(it);

            Log("+++ TriggerManager::~Update borrado trigger %s \n", node.managed ? "managed" : " ");
        }
        else
        {
            node.pointer->Update(fdTime);
            ++it;
        }
    }
}

//////////////////////////
//////////////////////////

void TriggerManager::DeleteAll(void)
{
    for (TNodeListIterator it = m_TriggerList.begin(); it != m_TriggerList.end(); it++)
    {
        if ((*it).managed)
        {
            SafeDelete((*it).pointer);
        }
    }

    m_TriggerList.clear();
}

