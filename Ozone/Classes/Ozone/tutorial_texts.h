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
 * File:   tutorial_texts.h
 * Author: nacho
 *
 * Created on 27 de febrero de 2010, 18:41
 */

#pragma once

#ifndef _TUTORIAL_TEXTS_H
#define	_TUTORIAL_TEXTS_H

static const char* str_tutorial[] = {
    "Welcome to Ozone!\n \n"
    "In this tutorial you will learn the basic steps\n"
    "to help you play the game.\n \n"
    "For a description of all the buttons and items,\n"
    "tap the help menu on the main screen.",

    "Start by briefly tapping the movement pad to\n"
    "release air in the direction you want to move.\n \n"
    "You can slow down by tapping the brake button\n"
#ifdef GEARDOME_PLATFORM_IPAD
    "at the right of the screen.\n \n"
#else
    "at the bottom right of the screen.\n \n"
#endif
    "Releasing little puffs of air and using the\n"
    "brake are essential for fine control of the\n"
    "ball.",

    "In some narrow corridors you will need to\n"
    "deflate the ball in order to pass through them.\n \n"
    "Brake until the ball stops and then use the\n"
    "blue button on the right to deflate the ball.\n",

    "When the ball runs out of air you will die.\n \n"
    "Use the air pumps and purple items to fill\n"
    "the ball up.\n \n"
    "The blue bar at the top shows you the\n"
    "remaining air, and will turn red when the air\n"
    "is almost gone.",

    "You must collect all the yellow orbs in order\n"
    "to finish each level.\n \n"
    "The number of remaining orbs is shown at the\n"
    "top left of the screen.",

    "Only when you have collected all the yellow\n"
    "orbs, can you exit the level.\n \n"
    "Find and enter the yellow halos to finish.",

    "In some places you will need to collect keys\n"
    "to unlock doors.\n \n"
    "Use the different coloured keys to open the\n"
    "corresponding door.",

    "Teleports enable instant travel to new\n"
    "locations in the level.\n",

    "Throughout this adventure you will face several\n"
    "enemies and challenging characters.\n \n"
    "You can defeat some of them with three kind\n"
    "of weapons.",

    "The first weapon is the Plasma Gun. Collect the\n"
    "green item for 50 rounds of ammo.\n \n"
    "Fire this weapon by tapping in the green button\n"
    "when you have collected it.\n \n"
    "Practise moving in the direction of your enemy\n"
    "and firing at the same time to hit them.",

    "The second weapon is the Lightning, a blue item\n"
    "that will give you 40 seconds of electric power.\n \n"
    "When you approach the enemies they will\n"
    "automatically be shocked.",

    "The third weapon is the Nuke Wave. Collect\n"
    "the red item for 3 rounds of ammo.\n \n"
    "Fire it with the new button that will appear\n"
    "on the screen.\n \n"
    "The nuke weapon kills all the enemies on the\n"
    "screen.",

    "The Strength item will transform you into an\n"
    "invincible ball of steel for 30 seconds.\n \n"
    "With proper impulse you will be able to break\n"
    "some walls too.\n \n"
    "This item regenerates itself automatically.",

    "Try to move wisely making use of your previous\n"
    "movement to coast in the direction you want in\n"
    "order to move without losing any air.\n \n"
    "Be careful with the spikes though!",

    "You lose air everytime you tap on the control\n"
    "pad.\n \n"
    "Bouncing against walls won't hurt you and can\n"
    "be used wisely to coast around the level.\n",

    "You are ready to play Ozone!\n \n"
    "Use the brake button, take advantage of\n"
    "coasting around, control your remaining air,\n"
    "find airpumps when needed and good luck!"
};

#endif	/* _TUTORIAL_TEXTS_H */

