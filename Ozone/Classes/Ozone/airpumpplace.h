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
 * File:   airpumpplace.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 0:06
 */

#pragma once
#ifndef _AIRPUMPPLACE_H
#define	_AIRPUMPPLACE_H

#include "place.h"

#define AIR_PUMP_ROTATION_SPEED_MAX (660.0f)
#define AIR_PUMP_ROTATION_SPEED_IDLE (180.0f)
#define AIR_PUMP_ROTATION_SPEED_ACCEL (400.0f)
#define AIR_PUMP_ROTATION_SPEED_DECCEL (180.0f)
#define AIR_PUMP_INFLATE_RATIO (0.4f)

class AirPumpPlace : public Place
{

private:

    float m_fRotationSpeed;
    float m_fRotation;

    static int m_iContactingWithPlayer;
    static bool m_bSoundActive;

public:
    AirPumpPlace(void);
    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);
    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);

    static void ClearContactingWithPlayer(void) { m_iContactingWithPlayer = 0; };

};

#endif	/* _AIRPUMPPLACE_H */

