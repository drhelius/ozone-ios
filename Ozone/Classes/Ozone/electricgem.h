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
 * File:   electricgem.h
 * Author: nacho
 *
 * Created on 22 de agosto de 2009, 0:28
 */

#pragma once
#ifndef _ELECTRICGEM_H
#define	_ELECTRICGEM_H

#include "gem.h"

class ElectricGem : public Gem
{

private:

    float m_fFadeOut;
    float m_fStartRotation;

    LinearInterpolator* m_pFadeInterpolator;

public:

    ElectricGem(void);
    ~ElectricGem();
    virtual void Init(short posX, short posY, u8 rotation, short width, short height, char* szScript);
    virtual void Update(Timer* timer);

    virtual void Enable(void);
    virtual void Disable(void);
    virtual void Reset(void);

    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);

};

#endif	/* _ELECTRICGEM_H */

