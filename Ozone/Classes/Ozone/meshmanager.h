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
 * File:   meshmanager.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 0:16
 */

#pragma once
#ifndef _MESHMANAGER_H
#define	_MESHMANAGER_H

#include <map>
#include <string>
#include "singleton.h"
#include "mesh.h"

class MeshManager : public Singleton<MeshManager>
{

    ////friend class Singleton<MeshManager>;

private:

    typedef std::map<std::string, Mesh*> TMeshMap;
    typedef std::pair<std::string, Mesh*> TMeshMapPair;
    typedef TMeshMap::iterator TMeshMapIterator;
    typedef std::pair<TMeshMapIterator, bool> TMeshMapResultPair;

    TMeshMap m_MeshMap;

    Mesh m_TextFontMesh;

    
    bool LoadMesh(Mesh* pMesh, bool useVBO);

    bool m_bTextFontCreated;

    int m_iMeshCounter;

public:

    MeshManager();
    ~MeshManager();

    void TransformMeshToVBO(Mesh* pMesh);
    Mesh* GetCustomMesh(void);
    Mesh* GetMeshFromFile(const char* strMeshName, bool useVBO = true, bool applyEarlyReduction = false);
    Mesh* GetBoardMesh(void);
    Mesh* GetBoardMesh(float width, float height);
    Mesh* GetBoardMesh(float posX, float posY, float width, float height, float texWidht, float texHeight);
    Mesh* GetBoardMesh(float sizeX, float sizeY, float texX1, float texX2, float texY1, float texY2, float texWidht, float texHeight);
    Mesh* GetTextFontMesh(void);

    bool UnloadMesh(const char* strMeshName);
    bool UnloadMesh(Mesh* pMesh);
    void UnloadAll(void);

};

#endif	/* _MESHMANAGER_H */

