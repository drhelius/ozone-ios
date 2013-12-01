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
 * File:   texturemanager.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 0:16
 */

#pragma once
#ifndef _TEXTUREMANAGER_H
#define	_TEXTUREMANAGER_H

#include <map>
#include <string>
#include "singleton.h"

class Texture;

class TextureManager : public Singleton<TextureManager>
{

    ////friend class Singleton<TextureManager>;

private:

    typedef std::map<std::string, Texture*> TTextureMap;
    typedef std::pair<std::string, Texture*> TTextureMapPair;
    typedef TTextureMap::iterator TTextureMapIterator;
    typedef std::pair<TTextureMapIterator, bool> TTextureMapResultPair;

    TTextureMap m_TextureMap;

    

    bool LoadTexture(Texture* pTexture, bool mipmaps);
    GLboolean GenMipMap2D(GLubyte *src, GLubyte **dst, int srcWidth, int srcHeight, int *dstWidth, int *dstHeight, int level);

public:

    TextureManager();
    ~TextureManager();

    Texture* GetTexture(const char* strTextureName, bool mipmaps = false);

    bool UnloadTexture(const char* strTextureName);
    bool UnloadTexture(Texture* pTexture);
    int UnloadAll(void);
};

#endif	/* _TEXTUREMANAGER_H */

