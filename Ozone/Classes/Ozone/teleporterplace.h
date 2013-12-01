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
 * File:   teleporterplace.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 0:14
 */

#pragma once
#ifndef _TELEPORTERPLACE_H
#define	_TELEPORTERPLACE_H

#include "place.h"

class TeleporterPlace : public Place
{

private:

    RenderObject m_UpperLayer;
    float m_AccumulatedTime;
    TeleporterPlace* m_pPartner;
    int m_iID;

    btCollisionShape* m_pTeleporterShape;

    static float m_fTimeFromLastTeleport;

public:

    TeleporterPlace(void);
    ~TeleporterPlace();

    void SetPartner(TeleporterPlace* pPartner)
    {
        m_pPartner = pPartner;
    };

    TeleporterPlace* GetPartner(void) const
    {
        return m_pPartner;
    };

    int GetID(void) const
    {
        return m_iID;
    };

    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);
    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
};

#endif	/* _TELEPORTERPLACE_H */

