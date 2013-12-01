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
 *  texture.h
 *  Ozone
 *
 *  Created by nacho on 13/04/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _TEXTURE_H
#define	_TEXTURE_H

#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include "texturemanager.h"

class Texture
{

    friend class TextureManager;

private:
    GLuint m_theTexture;
    int m_iWidth;
    int m_iHeight;
    bool m_bIsCompressed;
    char m_strName[256];

public:
    Texture(void);

    GLuint GetID(void) const
    {
        return m_theTexture;
    };

    int GetWidth(void) const
    {
        return m_iWidth;
    };

    int GetHeight(void) const
    {
        return m_iHeight;
    };

    bool IsCompressed(void) const
    {
        return m_bIsCompressed;
    };

    const char* GetName(void) const
    {
        return m_strName;
    };
};

#endif	/* _TEXTURE_H */