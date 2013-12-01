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
 * File:   searchthrowingenemyshotparticle.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:55
 */

#pragma once
#ifndef _SEARCHTHROWINGENEMYSHOTPARTICLE_H
#define	_SEARCHTHROWINGENEMYSHOTPARTICLE_H

#include "particle.h"

class SearchThrowingEnemyShotParticle : public Particle
{
public:
    SearchThrowingEnemyShotParticle(void);

    virtual void Init(void);
    virtual void Update(Timer* timer);

    virtual void Enable(void);
    virtual void Disable(void);

    virtual void getWorldTransform(btTransform &worldTransform) const;
    virtual void setWorldTransform(const btTransform &worldTransform);

    virtual void ContactWithNPC(NPC* theNPC, const float impulse, Timer* timer, int additionalDataThis, int additionalDataOthers);
    virtual void ContactWithPlayer(Player* thePlayer, const float impulse, Timer* timer);
    virtual void ContactWithPlayerNuke(Player* thePlayer, const float impulse, Timer* timer, int additionalData);
};

#endif	/* _SEARCHTHROWINGENEMYSHOTPARTICLE_H */

