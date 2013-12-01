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
 * File:   yellowgem.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:37
 */
#pragma once
#ifndef _YELLOWGEM_H
#define	_YELLOWGEM_H

#include "gem.h"

class YellowGem : public Gem
{

private:

    float m_fFadeOut;
    float m_fStartRotation;
    float m_fStartHiddingTime;
    bool m_bHide;

    LinearInterpolator* m_pFadeInterpolator;

public:

    YellowGem(void);
    ~YellowGem();
    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);
    void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);

    virtual void Enable(void);
    virtual void Disable(void);
    virtual void Reset(void);
};

#endif	/* _YELLOWGEM_H */

