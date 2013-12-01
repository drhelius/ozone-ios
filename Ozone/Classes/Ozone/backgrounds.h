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
 * File:   backgrounds.h
 * Author: nacho
 *
 * Created on 5 de octubre de 2009, 23:15
 */

#ifndef _BACKGROUNDS_H
#define	_BACKGROUNDS_H

#include "backgroundparticle.h"

class Backgrounds
{

private:

    bool m_bNeedCleanup;

    BackgroundParticle** m_pParticleArray[4];
    int m_iArraySize[4];

    Renderable* m_pRenderableBackground;
    Renderable* m_pRenderableBackgroundParticles;
    RenderObject* m_pBackground[4];

    char m_szDepthPath[100];

    float m_fMaxX;
    float m_fMaxY;

    Mesh* m_pBackgroundParticlesMesh;
    RenderObject* m_pBackgroundParticlesRO;

public:

    Backgrounds(void);
    ~Backgrounds();

    void Init(char* szBackgroundPath, char* szDepthPath, float maxX, float maxY);

    void Update(Timer* timer, const Vec3& camPos);

    void Cleanup(void);

    void InitParticleArray(int type, int count);

};

#endif	/* _BACKGROUNDS_H */

