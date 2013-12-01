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
 * File:   InGameMenu.mm
 * Author: nacho
 * 
 * Created on 16 de febrero de 2010, 16:35
 */

#include "InGameMenu.h"
#include "renderer.h"
#include "meshmanager.h"
#include "texturemanager.h"

//////////////////////////
//////////////////////////

InGameMenu::InGameMenu(void)
{
    m_pTimer = NULL;

    InitPointer(m_pAlphaInterpolator);
    InitPointer(m_pMotionInterpolator);
    InitPointer(m_pSelectionInterpolator);
    InitPointer(m_pFader);
    InitPointer(m_pTextFont);

    m_bActive = false;

    m_fMotion = 0.0f;
    m_fWidth = 0.0f;
    m_fHeight = 0.0f;
    m_fAlpha = 0.0f;
    m_fSelectionOpacity = 1.0f;
    m_iSelection = 0;
    m_bHiding = false;
    m_bShowLogo = true;
}

//////////////////////////
//////////////////////////

InGameMenu::~InGameMenu()
{

    SafeDelete(m_pAlphaInterpolator);
    SafeDelete(m_pMotionInterpolator);
    SafeDelete(m_pSelectionInterpolator);
    SafeDelete(m_pFader);
    SafeDelete(m_pTextFont);
}

//////////////////////////
//////////////////////////

void InGameMenu::Init(float width, float height)
{
    m_fWidth = width;
    m_fHeight = height;

    m_Renderable.Set3D(false);
    m_Renderable.SetLayer(600);

    m_pTextFont = new TextFont();
    m_pTextFont->Init("game/fonts/game_01_font", "game/fonts/game_01_font", 600);

    Texture* pTexHud = TextureManager::Instance().GetTexture("game/hud/hud_01");
    Texture* pTexLogo = TextureManager::Instance().GetTexture("game/hud/logo");

    m_TopLeftRO.Init(MeshManager::Instance().GetBoardMesh(1, 157, 32, 32,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_TopLeftRO.UseColor(true);

    m_TopRO.Init(MeshManager::Instance().GetBoardMesh(36, 157, 1, 32,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_TopRO.UseColor(true);

    m_TopRightRO.Init(MeshManager::Instance().GetBoardMesh(67, 157, 32, 32,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_TopRightRO.UseColor(true);

    m_LeftRO.Init(MeshManager::Instance().GetBoardMesh(1, 192, 32, 1,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_LeftRO.UseColor(true);

    m_CenterRO.Init(MeshManager::Instance().GetBoardMesh(36, 192, 1, 1,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_CenterRO.UseColor(true);

    m_RightRO.Init(MeshManager::Instance().GetBoardMesh(67, 192, 32, 1,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_RightRO.UseColor(true);

    m_BottomLeftRO.Init(MeshManager::Instance().GetBoardMesh(1, 223, 32, 32,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_BottomLeftRO.UseColor(true);

    m_BottomRO.Init(MeshManager::Instance().GetBoardMesh(36, 223, 1, 32,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_BottomRO.UseColor(true);

    m_BottomRightRO.Init(MeshManager::Instance().GetBoardMesh(67, 223, 32, 32,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_BottomRightRO.UseColor(true);

#ifdef GEARDOME_PLATFORM_IPAD
    m_LogoRO.Init(MeshManager::Instance().GetBoardMesh(0, 0, 344, 102,
            pTexLogo->GetWidth(), pTexLogo->GetHeight()), pTexLogo, RENDER_OBJECT_TRANSPARENT);
#else
    m_LogoRO.Init(MeshManager::Instance().GetBoardMesh(0, 0, 172, 51,
            pTexLogo->GetWidth(), pTexLogo->GetHeight()), pTexLogo, RENDER_OBJECT_TRANSPARENT);
#endif

    m_LogoRO.UseColor(true);

    m_Renderable.GetRenderObjectList().push_back(&m_TopLeftRO);
    m_Renderable.GetRenderObjectList().push_back(&m_TopRO);
    m_Renderable.GetRenderObjectList().push_back(&m_TopRightRO);
    m_Renderable.GetRenderObjectList().push_back(&m_LeftRO);
    m_Renderable.GetRenderObjectList().push_back(&m_CenterRO);
    m_Renderable.GetRenderObjectList().push_back(&m_RightRO);
    m_Renderable.GetRenderObjectList().push_back(&m_BottomLeftRO);
    m_Renderable.GetRenderObjectList().push_back(&m_BottomRO);
    m_Renderable.GetRenderObjectList().push_back(&m_BottomRightRO);
    m_Renderable.GetRenderObjectList().push_back(&m_LogoRO);

    m_pAlphaInterpolator = new LinearInterpolator(&m_fAlpha, 0.0f, 1.0f, 0.5f);
    m_pMotionInterpolator = new SineInterpolator(&m_fMotion, -2.0f, 2.0f, 5.0f);
    m_pSelectionInterpolator = new CosineInterpolator(&m_fSelectionOpacity, 1.0f, 0.0f, 0.25f, true, 0.5f);

    InterpolatorManager::Instance().Add(m_pMotionInterpolator, false, m_pTimer);

    m_pFader = new Fader();
    m_pFader->SetLayer(600);
}

//////////////////////////
//////////////////////////

void InGameMenu::Update(void)
{
    if (m_bHiding)
    {
        if (m_fAlpha <= 0.0f)
        {
            m_bHiding = false;
            m_bActive = false;
        }
    }

    if (m_bActive)
    {
        MATRIX scale, trans;
        float centerX = IPHONE_SCREEN_HEIGHT / 2.0f;
        float centerY = IPHONE_SCREEN_WIDTH / 2.0f;
        float x = centerX - (m_fWidth / 2.0f) - 32.0f;
        float y = centerY - (m_fHeight / 2.0f) - 32.0f;

        m_TopLeftRO.SetPosition(x, y, 0.0f);
        m_TopRightRO.SetPosition(x + 32.0f + m_fWidth, y, 0.0f);
        m_BottomLeftRO.SetPosition(x, y + 32.0f + m_fHeight, 0.0f);
        m_BottomRightRO.SetPosition(x + 32.0f + m_fWidth, y + 32.0f + m_fHeight, 0.0f);

#ifdef GEARDOME_PLATFORM_IPAD
        m_LogoRO.SetPosition(centerX - 172.0f, y - 42.0f, 2.0f);
#else
        m_LogoRO.SetPosition(centerX - 86.0f, y - 20.0f, 2.0f);
#endif

        MatrixScaling(scale, m_fWidth, 1.0f, 1.0f);
        MatrixTranslation(trans, x + 32.0f, y, 0.0f);
        MatrixMultiply(m_TopRO.GetTransform(), scale, trans);

        MatrixTranslation(trans, x + 32.0f, y + 32.0f + m_fHeight, 0.0f);
        MatrixMultiply(m_BottomRO.GetTransform(), scale, trans);

        MatrixScaling(scale, 1.0f, m_fHeight, 1.0f);
        MatrixTranslation(trans, x, y + 32.0f, 0.0f);
        MatrixMultiply(m_LeftRO.GetTransform(), scale, trans);

        MatrixTranslation(trans, x + 32.0f + m_fWidth, y + 32.0f, 0.0f);
        MatrixMultiply(m_RightRO.GetTransform(), scale, trans);

        MatrixScaling(scale, m_fWidth, m_fHeight, 1.0f);
        MatrixTranslation(trans, x + 32.0f, y + 32.0f, 0.0f);
        MatrixMultiply(m_CenterRO.GetTransform(), scale, trans);

        m_TopLeftRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_TopRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_TopRightRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_LeftRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_CenterRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_RightRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_BottomLeftRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_BottomRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_BottomRightRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);

        m_LogoRO.SetColor(1.0f, 1.0f, 1.0f, m_fAlpha);
        m_LogoRO.Activate(m_bShowLogo);

        Renderer::Instance().Add(&m_Renderable);
    }

    m_pFader->Update(m_pTimer->GetDeltaTime());
}

//////////////////////////
//////////////////////////

void InGameMenu::Show(void)
{
    m_bActive = true;
    m_bHiding = false;

    m_pFader->StartFade(0.0f, 0.0f, 0.0f, false, 0.5f, -1.0f, 0.55f, 0.0f);
    m_pAlphaInterpolator->Redefine(0.0f, 1.0f, 0.5f);
    InterpolatorManager::Instance().Add(m_pAlphaInterpolator, false, m_pTimer);

    m_iSelection = 0;
}

//////////////////////////
//////////////////////////

void InGameMenu::Hide(void)
{
    if (m_bActive)
    {
        m_bHiding = true;
        m_pFader->StartFade(0.0f, 0.0f, 0.0f, true, 0.5f, -1.0f, 0.55f, 0.0f);
        m_pAlphaInterpolator->Redefine(1.0f, 0.0f, 0.5f);
        InterpolatorManager::Instance().Add(m_pAlphaInterpolator, false, m_pTimer);
    }
}

//////////////////////////
//////////////////////////

void InGameMenu::Disable(void)
{
    m_bActive = false;
    m_fAlpha = 0.0f;
    m_pFader->Reset();
}