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
 *  textfont.mm
 *  Ozone
 *
 *  Created by nacho on 20/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "renderobject.h"


#include "textfont.h"
#include "meshmanager.h"
#include "renderable.h"

TextFont::TextFont(void)
{
    m_iLetterSize = 16;
}

//////////////////////////
//////////////////////////

TextFont::~TextFont(void) { }

//////////////////////////
//////////////////////////

void TextFont::Add(const char* strText, float x, float y, float z)
{
    COLOR c = {1.0f, 1.0f, 1.0f, 1.0f};

    Add(strText, x, y, z, c);
}

//////////////////////////
//////////////////////////

void TextFont::Add(const char* strText, float x, float y, float z, COLOR& color, bool centered)
{
    char text[TEXT_FONT_MAX_STRING_SIZE];

    strcpy(text, strText);

    char * tok = strtok(text, "\n");

    float offsetY = 0.0f;

    while (tok != NULL)
    {
        TextFontContext context;

        context.pFont = this;
        strcpy(context.text, tok);

        float offsetX = 0;

        if (centered)
        {
            const char* begin = context.text;
            const char* end = context.text + strlen(context.text);

            for (; begin != end; ++begin)
            {
                u8 currentChar = (u8) (*begin);

                if (currentChar < 32)
                {
                    currentChar = 0;
                }

                offsetX += m_SizeArray[currentChar] + 1.0f;
            }

            offsetX = offsetX / 2.0f;
        }

        RenderObject tempRO;

        tempRO.Init(m_pMesh, m_pTexture, RENDER_OBJECT_TEXT);
        tempRO.SetPosition(x - floor(offsetX), y + offsetY, z);
        tempRO.SetColor(color);
        tempRO.UseColor(true);
        tempRO.SetTextFontContext(context);
        //tempRO.UseDepthTest(false);

        m_RenderList.push_back(tempRO);

        tok = strtok(NULL, "\n");

#ifdef GEARDOME_PLATFORM_IPAD
        offsetY += m_iLetterSize - (2 * (m_iLetterSize / 16)) + 3;
#else
        offsetY += m_iLetterSize - (2 * (m_iLetterSize / 16));
#endif
    }
}

//////////////////////////
//////////////////////////

void TextFont::Begin(void)
{
    m_RenderList.clear();
    m_Renderable.GetRenderObjectList().clear();
}

//////////////////////////
//////////////////////////

void TextFont::End(void)
{
    for (TRenderObjectListIterator i = m_RenderList.begin(); i != m_RenderList.end(); i++)
    {
        m_Renderable.GetRenderObjectList().push_back(&(*i));
    }

    Renderer::Instance().Add(&m_Renderable);
}

//////////////////////////
//////////////////////////

void TextFont::Init(const char* strTexture, const char* strSizeFile, int layer)
{
    Log("+++ TextFont::Init Cargando font: %s %s\n", strTexture, strSizeFile);

    m_Renderable.Set3D(false);
    m_Renderable.SetLayer(layer);

    m_pTexture = TextureManager::Instance().GetTexture(strTexture);

    m_iLetterSize = m_pTexture->GetWidth() / 16;

    m_pMesh = MeshManager::Instance().GetTextFontMesh();

    char* ind = strrchr(strSizeFile, '/');
    char* nameSize = ind + 1;
    char pathSize[256] = {0};
    strncpy(pathSize, strSizeFile, ind - strSizeFile);
    pathSize[ind - strSizeFile] = 0;

    NSString* OCpathSize = [NSString stringWithCString : pathSize encoding : [NSString defaultCStringEncoding]];
    NSString* OCpathName = [NSString stringWithCString : nameSize encoding : [NSString defaultCStringEncoding]];
    NSString* path = [[NSBundle mainBundle] pathForResource : OCpathName ofType : @"dat" inDirectory : OCpathSize];

    FILE* pFile = fopen([path cStringUsingEncoding : 1], "r");

    if (pFile == NULL)
    {
        Log("@@@ TextFont::Init Imposible abrir font size file: %s\n", strSizeFile);
        return;
    }

    fread(m_SizeArray, sizeof (u8), 256, pFile);

    m_SizeArray[0] = m_iLetterSize - (4 * (m_iLetterSize / 16));
    ;

    fclose(pFile);

    Log("+++ TextFont::Init font cargada\n");
}

//////////////////////////
//////////////////////////

void TextFont::UpdateTextMesh(const char* strText)
{
    m_pMesh->SetVertexCount(strlen(strText) * 6);

    const char* begin = strText;
    const char* end = strText + strlen(strText);

    float offset = 0;
    int quad = 0;
    float texSize = m_pTexture->GetWidth();
    float fontSize = texSize / 16.0f;

    VERTEX_2D* pVertices = (VERTEX_2D*) m_pMesh->GetVertices();

    for (; begin != end; ++begin)
    {
        u8 currentChar = (u8) (*begin);

        if (currentChar < 32)
        {
            currentChar = 0;
        }

        int tx = currentChar % 16;
        int ty = currentChar / 16;

        float txf1 = (tx * fontSize) / texSize;
        float tyf2 = (ty * fontSize) / texSize;
        float txf2 = ((tx * fontSize) + fontSize) / texSize;
        float tyf1 = ((ty * fontSize) + fontSize) / texSize;

        pVertices[quad].x = offset;
        pVertices[quad].y = 0.0f;
        pVertices[quad].z = 0.0f;
        pVertices[quad].u = txf1;
        pVertices[quad].v = tyf2;

        pVertices[quad + 2].x = offset + fontSize;
        pVertices[quad + 2].y = fontSize;
        pVertices[quad + 2].z = 0.0f;
        pVertices[quad + 2].u = txf2;
        pVertices[quad + 2].v = tyf1;

        pVertices[quad + 1].x = offset;
        pVertices[quad + 1].y = fontSize;
        pVertices[quad + 1].z = 0.0f;
        pVertices[quad + 1].u = txf1;
        pVertices[quad + 1].v = tyf1;

        pVertices[quad + 3].x = offset;
        pVertices[quad + 3].y = 0.0f;
        pVertices[quad + 3].z = 0.0f;
        pVertices[quad + 3].u = txf1;
        pVertices[quad + 3].v = tyf2;

        pVertices[quad + 5].x = offset + fontSize;
        pVertices[quad + 5].y = 0.0f;
        pVertices[quad + 5].z = 0.0f;
        pVertices[quad + 5].u = txf2;
        pVertices[quad + 5].v = tyf2;

        pVertices[quad + 4].x = offset + fontSize;
        pVertices[quad + 4].y = fontSize;
        pVertices[quad + 4].z = 0.0f;
        pVertices[quad + 4].u = txf2;
        pVertices[quad + 4].v = tyf1;

        offset += m_SizeArray[currentChar] + 1.0f;
        quad += 6;
    }
}

//////////////////////////
//////////////////////////