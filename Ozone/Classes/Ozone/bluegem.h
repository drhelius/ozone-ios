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
 * File:   bluegem.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:37
 */

#pragma once
#ifndef _BLUEGEM_H
#define	_BLUEGEM_H

#include "gem.h"
#include "interpolatormanager.h"

class BlueGem : public Gem
{

private:

    static bool m_bAlternateSound;

    float m_fRotationOffset;
    float m_fFadeOut;

    LinearInterpolator* m_pFadeInterpolator;

public:
    BlueGem(void);
    virtual ~BlueGem();
    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);

    virtual void Enable(void);
    virtual void Disable(void);
    virtual void Reset(void);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
};

#endif	/* _BLUEGEM_H */

