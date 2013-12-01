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
 * File:   interpolatormanager.cpp
 * Author: nacho
 * 
 * Created on 3 de agosto de 2009, 17:21
 */

#include "interpolatormanager.h"

InterpolatorManager::InterpolatorManager(void)
{
    Log("+++ InterpolatorManager::InterpolatorManager ...\n");

    Log("+++ InterpolatorManager::InterpolatorManager correcto\n");
}

//////////////////////////
//////////////////////////

InterpolatorManager::~InterpolatorManager()
{
    Log("+++ InterpolatorManager::~InterpolatorManager ...\n");

    DeleteAll();

    Log("+++ InterpolatorManager::~InterpolatorManager destruido\n");
}

//////////////////////////
//////////////////////////

void InterpolatorManager::DeleteAll(void)
{
    for (TNodeListIterator it = m_InterpolatorList.begin(); it != m_InterpolatorList.end(); it++)
    {
        if ((*it).managed)
        {
            SafeDelete((*it).pointer);
        }
    }

    m_InterpolatorList.clear();
}

//////////////////////////
//////////////////////////

void InterpolatorManager::Delete(Interpolator* pInterpolator)
{
    for (TNodeListIterator it = m_InterpolatorList.begin(); it != m_InterpolatorList.end(); it++)
    {
        if ((*it).pointer == pInterpolator)
        {
            if ((*it).managed)
            {
                SafeDelete((*it).pointer);
            }

            m_InterpolatorList.erase(it);

            Log("+++ InterpolatorManager::~Delete borrado interpolator %s \n", (*it).managed ? "managed" : " ");
            
            break;
        }
    }
}

//////////////////////////
//////////////////////////

void InterpolatorManager::Add(Interpolator* pInterpolator, bool managed, Timer* pTimer)
{
    stInterpolatorNode node;

    node.pointer = pInterpolator;
    node.managed = managed;
    node.timer = pTimer;

    m_InterpolatorList.push_back(node);

    Log("+++ InterpolatorManager::~Add añadido interpolator %s \n", managed ? "managed" : " ");
}

//////////////////////////
//////////////////////////

void InterpolatorManager::Update(float fdTime)
{
    TNodeListIterator it = m_InterpolatorList.begin();

    while (it != m_InterpolatorList.end())
    {
        stInterpolatorNode node = (*it);

        if (node.pointer->CanKill())
        {
            if (node.managed)
            {
                SafeDelete(node.pointer);
            }

            it = m_InterpolatorList.erase(it);

            Log("+++ InterpolatorManager::~Update borrado interpolator %s \n", node.managed ? "managed" : " ");
        }
        else
        {
            if (IsValidPointer(node.timer))
            {
                node.pointer->Update(node.timer->GetDeltaTime());
            }
            else
            {
                node.pointer->Update(fdTime);
            }
            
            ++it;
        }
    }
}
