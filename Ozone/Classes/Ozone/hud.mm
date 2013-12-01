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
 * File:   hud.cpp
 * Author: nacho
 * 
 * Created on 20 de agosto de 2009, 21:54
 */

#include "hud.h"
#include "renderer.h"

//////////////////////////
//////////////////////////

Hud::Hud()
{
    Log("+++ Hud::Hud ...\n");

    m_bNeedCleanup = false;

    m_fHudGemGlowAlpha = 0.0f;
    m_fHudPowerAlpha = 0.0f;
    m_fNuclearScale = 0.0f;
    m_fNormalScale = 0.0f;
    m_fElectricScale = 0.0f;

    InitPointer(m_pGemGlowInterpolator);

    InitPointer(m_pRenderableHud);
    InitPointer(m_pHudController);
    InitPointer(m_pHudBrakeButton);
    InitPointer(m_pHudFireButtonNormal);
    InitPointer(m_pHudFireButtonElectric);
    InitPointer(m_pHudFireButtonNuclear);
    InitPointer(m_pHudFireButtonSteel);
    InitPointer(m_pHudDeflateButton);
    InitPointer(m_pHudGemCounter);
    InitPointer(m_pHudMenuButton);
    InitPointer(m_pHudGemOverlay);
    InitPointer(m_pHudGemGlow);

    for (int i = 0; i < 24; i++)
    {
        InitPointer(m_pHudPowerBlue[i]);
        InitPointer(m_pHudPowerGray[i]);
    }

    for (int i = 0; i < 5; i++)
    {
        InitPointer(m_pHudPowerRedGlow[i]);
        InitPointer(m_pHudPowerRed[i]);
    }

    for (int i = 0; i < 5; i++)
    {
        InitPointer(m_pHudButtonGlow[i]);
        m_fHudButtonGlow[i] = 0.0f;
    }

    InitPointer(m_pHudPowerAlphaInterpolator);
    InitPointer(m_pNuclearScaleInterpolator);
    InitPointer(m_pElectricScaleInterpolator);
    InitPointer(m_pNormalScaleInterpolator);

    Log("+++ Hud::Hud correcto\n");
}

//////////////////////////
//////////////////////////

Hud::~Hud()
{
    Log("+++ Hud::~Hud ...\n");

    Cleanup();

    Log("+++ Hud::~Hud destruido\n");
}

//////////////////////////
//////////////////////////

void Hud::Init(Player* pPlayer)
{
    Log("+++ Hud::Init ...\n");

    m_pThePlayer = pPlayer;

    m_bNeedCleanup = true;

    m_pRenderableHud = new Renderable();

    m_pRenderableHud->Set3D(false);
    m_pRenderableHud->SetLayer(500);

    m_pHudController = new RenderObject();
    m_pHudBrakeButton = new RenderObject();
    m_pHudFireButtonNormal = new RenderObject();
    m_pHudFireButtonElectric = new RenderObject();
    m_pHudFireButtonNuclear = new RenderObject();
    m_pHudFireButtonSteel = new RenderObject();
    m_pHudDeflateButton = new RenderObject();
    m_pHudGemCounter = new RenderObject();
    m_pHudMenuButton = new RenderObject();
    m_pHudGemOverlay = new RenderObject();
    m_pHudGemGlow = new RenderObject();

    m_pGemGlowInterpolator = new LinearInterpolator(&m_fHudGemGlowAlpha, 0.0f, 1.0f, 0.4f);

#ifdef GEARDOME_PLATFORM_IPAD

    Texture* pTexHud = TextureManager::Instance().GetTexture("game/hud/hud_01");
    Texture* pTexHud2 = TextureManager::Instance().GetTexture("game/hud/hud_03");

    Mesh* pMeshBlue = MeshManager::Instance().GetBoardMesh(0, 141, 52, 12,
            pTexHud2->GetWidth(), pTexHud2->GetHeight());
    Mesh* pMeshGray = MeshManager::Instance().GetBoardMesh(0, 167, 52, 12,
            pTexHud2->GetWidth(), pTexHud2->GetHeight());
    Mesh* pMeshRed = MeshManager::Instance().GetBoardMesh(0, 154, 52, 12,
            pTexHud2->GetWidth(), pTexHud2->GetHeight());
    Mesh* pMeshRedGlow = MeshManager::Instance().GetBoardMesh(0, 180, 52, 10,
            pTexHud2->GetWidth(), pTexHud2->GetHeight());
    Mesh* pMeshButtonGlow = MeshManager::Instance().GetBoardMesh(137, 176, 56, 56,
            pTexHud->GetWidth(), pTexHud->GetHeight());

    for (int i = 0; i < 24; i++)
    {
        m_pHudPowerBlue[i] = new RenderObject();

        m_pHudPowerBlue[i]->Init(pMeshBlue, pTexHud2, RENDER_OBJECT_TRANSPARENT);
        m_pHudPowerBlue[i]->SetPosition(52.0f * i, 0.0f, 0.0f);
        m_pRenderableHud->GetRenderObjectList().push_back(m_pHudPowerBlue[i]);

        m_pHudPowerGray[i] = new RenderObject();

        m_pHudPowerGray[i]->Init(pMeshGray, pTexHud2, RENDER_OBJECT_TRANSPARENT);
        m_pHudPowerGray[i]->SetPosition(52.0f * i, 0.0f, 0.0f);
        m_pRenderableHud->GetRenderObjectList().push_back(m_pHudPowerGray[i]);
    }

    for (int i = 0; i < 5; i++)
    {
        m_pHudPowerRedGlow[i] = new RenderObject();
        m_pHudPowerRedGlow[i]->Init(pMeshRedGlow, pTexHud2, RENDER_OBJECT_ADDITIVE);
        m_pHudPowerRedGlow[i]->SetPosition(52.0f * i, -1.0f, 1.0f);
        m_pHudPowerRedGlow[i]->UseColor(true);

        m_pRenderableHud->GetRenderObjectList().push_back(m_pHudPowerRedGlow[i]);

        m_pHudPowerRed[i] = new RenderObject();
        m_pHudPowerRed[i]->Init(pMeshRed, pTexHud2, RENDER_OBJECT_TRANSPARENT);
        m_pHudPowerRed[i]->SetPosition(52.0f * i, 0.0f, 0.0f);

        m_pRenderableHud->GetRenderObjectList().push_back(m_pHudPowerRed[i]);
    }

    for (int i = 0; i < 4; i++)
    {
        m_fHudButtonGlow[i] = 0.0f;
    }

    m_pHudButtonGlow[0] = new RenderObject();
    m_pHudButtonGlow[0]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    MatrixScaling(m_pHudButtonGlow[0]->GetTransform(), 1.4f, 1.4f, 1.0f);
    m_pHudButtonGlow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 157.0f, IPHONE_SCREEN_WIDTH - 339.0f, 1.0f);
    m_pHudButtonGlow[0]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[0]);

    m_pHudButtonGlow[1] = new RenderObject();
    m_pHudButtonGlow[1]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    MatrixScaling(m_pHudButtonGlow[1]->GetTransform(), 1.4f, 1.4f, 1.0f);
    m_pHudButtonGlow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 85.0f, IPHONE_SCREEN_WIDTH - 480.0f, 1.0f);
    m_pHudButtonGlow[1]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[1]);

    m_pHudButtonGlow[2] = new RenderObject();
    m_pHudButtonGlow[2]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    MatrixScaling(m_pHudButtonGlow[2]->GetTransform(), 1.4f, 1.4f, 1.0f);
    m_pHudButtonGlow[2]->SetPosition(IPHONE_SCREEN_HEIGHT - 85.0f, IPHONE_SCREEN_WIDTH - 391.0f, 1.0f);
    m_pHudButtonGlow[2]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[2]);

    m_pHudButtonGlow[3] = new RenderObject();
    m_pHudButtonGlow[3]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    MatrixScaling(m_pHudButtonGlow[3]->GetTransform(), 1.4f, 1.4f, 1.0f);
    m_pHudButtonGlow[3]->SetPosition(IPHONE_SCREEN_HEIGHT - 167.0f, IPHONE_SCREEN_WIDTH - 431.0f, 1.0f);
    m_pHudButtonGlow[3]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[3]);

    m_pHudButtonGlow[4] = new RenderObject();
    m_pHudButtonGlow[4]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    m_pHudButtonGlow[4]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[4]);


    m_pHudController->Init(MeshManager::Instance().GetBoardMesh(2, 2, 124, 124,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudController->SetPosition(20.0f, IPHONE_SCREEN_WIDTH - 406.0f, 0.0f);

    m_pHudFireButtonNormal->Init(MeshManager::Instance().GetBoardMesh(121, 94, 67, 67,
            pTexHud2->GetWidth(), pTexHud2->GetHeight()), pTexHud2, RENDER_OBJECT_TRANSPARENT);

    m_pHudFireButtonElectric->Init(MeshManager::Instance().GetBoardMesh(189, 162, 67, 67,
            pTexHud2->GetWidth(), pTexHud2->GetHeight()), pTexHud2, RENDER_OBJECT_TRANSPARENT);

    m_pHudFireButtonNuclear->Init(MeshManager::Instance().GetBoardMesh(121, 162, 67, 67,
            pTexHud2->GetWidth(), pTexHud2->GetHeight()), pTexHud2, RENDER_OBJECT_TRANSPARENT);

    m_pHudFireButtonSteel->Init(MeshManager::Instance().GetBoardMesh(189, 94, 67, 67,
            pTexHud2->GetWidth(), pTexHud2->GetHeight()), pTexHud2, RENDER_OBJECT_TRANSPARENT);
    m_pHudFireButtonSteel->SetPosition(IPHONE_SCREEN_HEIGHT - 78.0f, IPHONE_SCREEN_WIDTH - 474.0f, 0.0f);

    m_pHudGemCounter->Init(MeshManager::Instance().GetBoardMesh(107, 47, 106, 46,
            pTexHud2->GetWidth(), pTexHud2->GetHeight()), pTexHud2, RENDER_OBJECT_TRANSPARENT);
    m_pHudGemCounter->SetPosition(3.0f, 18.0f, 5.0f);

    m_pHudMenuButton->Init(MeshManager::Instance().GetBoardMesh(0, 0, 106, 46,
            pTexHud2->GetWidth(), pTexHud2->GetHeight()), pTexHud2, RENDER_OBJECT_TRANSPARENT);
    m_pHudMenuButton->SetPosition(IPHONE_SCREEN_HEIGHT - 109.0f, 18.0f, 5.0f);

    m_pHudGemOverlay->Init(MeshManager::Instance().GetBoardMesh(0, 94, 106, 46,
            pTexHud2->GetWidth(), pTexHud2->GetHeight()), pTexHud2, RENDER_OBJECT_TRANSPARENT);
    m_pHudGemOverlay->SetPosition(3.0f, 18.0f, 15.0f);


    m_pHudDeflateButton->Init(MeshManager::Instance().GetBoardMesh(53, 142, 67, 67,
            pTexHud2->GetWidth(), pTexHud2->GetHeight()), pTexHud2, RENDER_OBJECT_TRANSPARENT);
    m_pHudDeflateButton->SetPosition(IPHONE_SCREEN_HEIGHT - 78.0f, IPHONE_SCREEN_WIDTH - 473.0f, 0.0f);

    m_pHudBrakeButton->Init(MeshManager::Instance().GetBoardMesh(127, 2, 67, 67,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudBrakeButton->SetPosition(IPHONE_SCREEN_HEIGHT - 78.0f, IPHONE_SCREEN_WIDTH - 384.0f, 0.0f);


    m_pHudGemGlow->Init(MeshManager::Instance().GetBoardMesh(101, 171, 24, 24,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_ADDITIVE);
    MatrixScaling(m_pHudGemGlow->GetTransform(), 4.4f, 4.4f, 1.0f);
    m_pHudGemGlow->SetPosition(0.0f, -15.0f, 20.0f);
    m_pHudGemGlow->UseColor(true);

#else

    Texture* pTexHud = TextureManager::Instance().GetTexture("game/hud/hud_01");
    Mesh* pMeshBlue = MeshManager::Instance().GetBoardMesh(207, 235, 24, 12,
            pTexHud->GetWidth(), pTexHud->GetHeight());
    Mesh* pMeshGray = MeshManager::Instance().GetBoardMesh(231, 235, 24, 12,
            pTexHud->GetWidth(), pTexHud->GetHeight());
    Mesh* pMeshRed = MeshManager::Instance().GetBoardMesh(183, 235, 24, 12,
            pTexHud->GetWidth(), pTexHud->GetHeight());
    Mesh* pMeshRedGlow = MeshManager::Instance().GetBoardMesh(156, 234, 23, 10,
            pTexHud->GetWidth(), pTexHud->GetHeight());
    Mesh* pMeshButtonGlow = MeshManager::Instance().GetBoardMesh(137, 176, 56, 56,
            pTexHud->GetWidth(), pTexHud->GetHeight());
    for (int i = 0; i < 24; i++)
    {
        m_pHudPowerBlue[i] = new RenderObject();

        m_pHudPowerBlue[i]->Init(pMeshBlue, pTexHud, RENDER_OBJECT_TRANSPARENT);
        m_pHudPowerBlue[i]->SetPosition(24.0f * i, 0.0f, 0.0f);
        m_pRenderableHud->GetRenderObjectList().push_back(m_pHudPowerBlue[i]);

        m_pHudPowerGray[i] = new RenderObject();

        m_pHudPowerGray[i]->Init(pMeshGray, pTexHud, RENDER_OBJECT_TRANSPARENT);
        m_pHudPowerGray[i]->SetPosition(24.0f * i, 0.0f, 0.0f);
        m_pRenderableHud->GetRenderObjectList().push_back(m_pHudPowerGray[i]);
    }

    for (int i = 0; i < 5; i++)
    {
        m_pHudPowerRedGlow[i] = new RenderObject();
        m_pHudPowerRedGlow[i]->Init(pMeshRedGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
        m_pHudPowerRedGlow[i]->SetPosition(24.0f * i, -1.0f, 1.0f);
        m_pHudPowerRedGlow[i]->UseColor(true);

        m_pRenderableHud->GetRenderObjectList().push_back(m_pHudPowerRedGlow[i]);

        m_pHudPowerRed[i] = new RenderObject();
        m_pHudPowerRed[i]->Init(pMeshRed, pTexHud, RENDER_OBJECT_TRANSPARENT);
        m_pHudPowerRed[i]->SetPosition(24.0f * i, 0.0f, 0.0f);

        m_pRenderableHud->GetRenderObjectList().push_back(m_pHudPowerRed[i]);
    }

    for (int i = 0; i < 4; i++)
    {
        m_fHudButtonGlow[i] = 0.0f;
    }

    m_pHudButtonGlow[0] = new RenderObject();
    m_pHudButtonGlow[0]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    m_pHudButtonGlow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 140.0f, IPHONE_SCREEN_WIDTH - 58.0f, 1.0f);
    m_pHudButtonGlow[0]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[0]);

    m_pHudButtonGlow[1] = new RenderObject();
    m_pHudButtonGlow[1]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    m_pHudButtonGlow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 60.0f, IPHONE_SCREEN_WIDTH - 140.0f, 1.0f);
    m_pHudButtonGlow[1]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[1]);

    m_pHudButtonGlow[2] = new RenderObject();
    m_pHudButtonGlow[2]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    MatrixScaling(m_pHudButtonGlow[2]->GetTransform(), 1.4f, 1.4f, 1.0f);
    m_pHudButtonGlow[2]->SetPosition(IPHONE_SCREEN_HEIGHT - 80.0f, IPHONE_SCREEN_WIDTH - 84.0f, 1.0f);
    m_pHudButtonGlow[2]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[2]);

    m_pHudButtonGlow[3] = new RenderObject();
    m_pHudButtonGlow[3]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    m_pHudButtonGlow[3]->SetPosition(IPHONE_SCREEN_HEIGHT - 116.0f, IPHONE_SCREEN_WIDTH - 115.0f, 1.0f);
    m_pHudButtonGlow[3]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[3]);

    m_pHudButtonGlow[4] = new RenderObject();
    m_pHudButtonGlow[4]->Init(pMeshButtonGlow, pTexHud, RENDER_OBJECT_ADDITIVE);
    m_pHudButtonGlow[4]->UseColor(true);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudButtonGlow[4]);


    m_pHudController->Init(MeshManager::Instance().GetBoardMesh(2, 2, 124, 124,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudController->SetPosition(5.0f, IPHONE_SCREEN_WIDTH - 129.0f, 0.0f);

    m_pHudFireButtonNormal->Init(MeshManager::Instance().GetBoardMesh(195, 2, 56, 56,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);

    m_pHudFireButtonElectric->Init(MeshManager::Instance().GetBoardMesh(195, 60, 56, 56,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);

    m_pHudFireButtonNuclear->Init(MeshManager::Instance().GetBoardMesh(195, 118, 56, 56,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);

    m_pHudFireButtonSteel->Init(MeshManager::Instance().GetBoardMesh(195, 176, 56, 56,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudFireButtonSteel->SetPosition(IPHONE_SCREEN_HEIGHT - 60.0f, IPHONE_SCREEN_WIDTH - 140.0f, 0.0f);

    m_pHudGemCounter->Init(MeshManager::Instance().GetBoardMesh(127, 127, 66, 23,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudGemCounter->SetPosition(-8.0f, 10.0f, 5.0f);

    m_pHudMenuButton->Init(MeshManager::Instance().GetBoardMesh(127, 151, 66, 23,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudMenuButton->SetPosition(IPHONE_SCREEN_HEIGHT - 57.0f, 10.0f, 5.0f);

    m_pHudGemOverlay->Init(MeshManager::Instance().GetBoardMesh(89, 127, 37, 15,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudGemOverlay->SetPosition(6.0f, 11.0f, 15.0f);


    m_pHudDeflateButton->Init(MeshManager::Instance().GetBoardMesh(126, 70, 56, 56,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudDeflateButton->SetPosition(IPHONE_SCREEN_HEIGHT - 60.0f, IPHONE_SCREEN_WIDTH - 141.0f, 0.0f);

    m_pHudBrakeButton->Init(MeshManager::Instance().GetBoardMesh(127, 2, 67, 67,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_TRANSPARENT);
    m_pHudBrakeButton->SetPosition(IPHONE_SCREEN_HEIGHT - 73.0f, IPHONE_SCREEN_WIDTH - 77.0f, 0.0f);


    m_pHudGemGlow->Init(MeshManager::Instance().GetBoardMesh(101, 171, 24, 24,
            pTexHud->GetWidth(), pTexHud->GetHeight()), pTexHud, RENDER_OBJECT_ADDITIVE);
    MatrixScaling(m_pHudGemGlow->GetTransform(), 2.2f, 2.2f, 1.0f);
    m_pHudGemGlow->SetPosition(-2.0f, -5.0f, 20.0f);
    m_pHudGemGlow->UseColor(true);

#endif

    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudController);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudFireButtonNormal); // disparo
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudFireButtonElectric); // rayos
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudFireButtonNuclear); // nuclear
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudFireButtonSteel); //acero
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudBrakeButton);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudGemCounter);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudDeflateButton);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudMenuButton);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudGemOverlay);
    m_pRenderableHud->GetRenderObjectList().push_back(m_pHudGemGlow);

    m_pHudPowerAlphaInterpolator = new SineInterpolator(&m_fHudPowerAlpha, 0.0f, 1.0f, 0.6f);

    m_pNuclearScaleInterpolator = new SpringInterpolator(&m_fNuclearScale, 0.0f, 1.0f, 2.0f, 5.0f, 1.0f, 1.0f, false, 1.0f);
    m_pElectricScaleInterpolator = new SpringInterpolator(&m_fElectricScale, 0.0f, 1.0f, 2.0f, 5.0f, 1.0f, 1.0f, false, 1.0f);
    m_pNormalScaleInterpolator = new SpringInterpolator(&m_fNormalScale, 0.0f, 1.0f, 2.0f, 5.0f, 1.0f, 1.0f, false, 1.0f);

    InterpolatorManager::Instance().Add(m_pHudPowerAlphaInterpolator, false);

    Log("+++ Hud::Init correcto\n");
}

//////////////////////////
//////////////////////////

void Hud::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ Hud::Cleanup ...\n");

        SafeDelete(m_pGemGlowInterpolator);

        SafeDelete(m_pRenderableHud);
        SafeDelete(m_pHudController);
        SafeDelete(m_pHudBrakeButton);
        SafeDelete(m_pHudFireButtonNormal);
        SafeDelete(m_pHudFireButtonElectric);
        SafeDelete(m_pHudFireButtonNuclear);
        SafeDelete(m_pHudFireButtonSteel);
        SafeDelete(m_pHudDeflateButton);
        SafeDelete(m_pHudGemCounter);
        SafeDelete(m_pHudMenuButton);
        SafeDelete(m_pHudGemOverlay);
        SafeDelete(m_pHudGemGlow);

        for (int i = 0; i < 24; i++)
        {
            SafeDelete(m_pHudPowerBlue[i]);
            SafeDelete(m_pHudPowerGray[i]);
        }

        for (int i = 0; i < 5; i++)
        {
            SafeDelete(m_pHudPowerRedGlow[i]);
            SafeDelete(m_pHudPowerRed[i]);
        }

        for (int i = 0; i < 5; i++)
        {
            SafeDelete(m_pHudButtonGlow[i]);
        }

        SafeDelete(m_pHudPowerAlphaInterpolator);
        SafeDelete(m_pNuclearScaleInterpolator);
        SafeDelete(m_pElectricScaleInterpolator);
        SafeDelete(m_pNormalScaleInterpolator);

        m_bNeedCleanup = false;

        Log("+++ Hud::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void Hud::Update(Timer* pTimer, bool* pInputState, Vec3& vecController)
{
    float deltaTime = pTimer->GetDeltaTime();

    if (m_pThePlayer->IsGemAdded())
    {
        m_pThePlayer->SetGemAdded(false);
        m_pGemGlowInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pGemGlowInterpolator, false);
    }

    if (m_pGemGlowInterpolator->IsActive())
    {
        m_pHudGemGlow->SetColor(1.0f, 1.0f, 1.0f, 1.0f - m_fHudGemGlowAlpha);
        m_pHudGemGlow->Activate(true);
    }
    else
    {
        m_pHudGemGlow->Activate(false);
    }

    if (pInputState[INPUT_BUTTON_FIRE] && m_pThePlayer->GetAmmo(NORMAL_AMMO) > 0.0f)
    {
        m_pHudButtonGlow[0]->Activate(true);
        m_fHudButtonGlow[0] = 1.0f;
    }
    else if (m_fHudButtonGlow[0] > 0.0f)
    {
        m_fHudButtonGlow[0] -= (BUTTON_GLOW_DISMISS_RATE * deltaTime);

        if (m_fHudButtonGlow[0] <= 0.0f)
        {
            m_fHudButtonGlow[0] = 0.0f;
            m_pHudButtonGlow[0]->Activate(false);
        }
    }
    m_pHudButtonGlow[0]->SetColor(1.0f, 1.0f, 1.0f, m_fHudButtonGlow[0]);

    if (pInputState[INPUT_BUTTON_DEFLATE] && (m_pThePlayer->GetAmmo(STEEL_AMMO) <= 0.0f))
    {
        m_pHudButtonGlow[1]->Activate(true);
        m_fHudButtonGlow[1] = 1.0f;
    }
    else if (m_fHudButtonGlow[1] > 0.0f)
    {
        m_fHudButtonGlow[1] -= (BUTTON_GLOW_DISMISS_RATE * deltaTime);

        if (m_fHudButtonGlow[1] <= 0.0f)
        {
            m_fHudButtonGlow[1] = 0.0f;
            m_pHudButtonGlow[1]->Activate(false);
        }
    }
    m_pHudButtonGlow[1]->SetColor(1.0f, 1.0f, 1.0f, m_fHudButtonGlow[1]);

    if (pInputState[INPUT_BUTTON_BRAKE])
    {
        m_pHudButtonGlow[2]->Activate(true);
        m_fHudButtonGlow[2] = 1.0f;
    }
    else if (m_fHudButtonGlow[2] > 0.0f)
    {
        m_fHudButtonGlow[2] -= (BUTTON_GLOW_DISMISS_RATE * deltaTime);

        if (m_fHudButtonGlow[2] <= 0.0f)
        {
            m_fHudButtonGlow[2] = 0.0f;
            m_pHudButtonGlow[2]->Activate(false);
        }
    }
    m_pHudButtonGlow[2]->SetColor(1.0f, 1.0f, 1.0f, m_fHudButtonGlow[2]);


    if (pInputState[INPUT_BUTTON_NUCLEAR] && m_pThePlayer->GetAmmo(NUCLEAR_AMMO) > 0.0f)
    {
        m_pHudButtonGlow[3]->Activate(true);
        m_fHudButtonGlow[3] = 1.0f;
    }
    else if (m_fHudButtonGlow[3] > 0.0f)
    {
        m_fHudButtonGlow[3] -= (BUTTON_GLOW_DISMISS_RATE * deltaTime);

        if (m_fHudButtonGlow[3] <= 0.0f)
        {
            m_fHudButtonGlow[3] = 0.0f;
            m_pHudButtonGlow[3]->Activate(false);
        }
    }
    m_pHudButtonGlow[3]->SetColor(1.0f, 1.0f, 1.0f, m_fHudButtonGlow[3]);

    if ((vecController.x != 0.0f) || (vecController.y != 0.0f))
    {
        MATRIX trans;
        m_pHudButtonGlow[4]->Activate(true);
        m_fHudButtonGlow[4] = 1.0f;
        MatrixScaling(m_pHudButtonGlow[4]->GetTransform(), 1.25f, 1.25f, 1.0f);
#ifdef GEARDOME_PLATFORM_IPAD
        MatrixTranslation(trans, 20.0f + 62.0f - 35.0f + vecController.x,
                IPHONE_SCREEN_WIDTH - 406.0f + 62.0f - 35.0f + vecController.y, 2.0f);
#else
        MatrixTranslation(trans, 5.0f + 62.0f - 35.0f + vecController.x,
                IPHONE_SCREEN_WIDTH - 129.0f + 62.0f - 35.0f + vecController.y, 2.0f);
#endif
        MatrixMultiply(m_pHudButtonGlow[4]->GetTransform(), m_pHudButtonGlow[4]->GetTransform(), trans);
    }
    else if (m_fHudButtonGlow[4] > 0.0f)
    {
        m_fHudButtonGlow[4] -= (BUTTON_GLOW_DISMISS_RATE * deltaTime);

        if (m_fHudButtonGlow[4] <= 0.0f)
        {
            m_fHudButtonGlow[4] = 0.0f;
            m_pHudButtonGlow[4]->Activate(false);
        }
    }
    m_pHudButtonGlow[4]->SetColor(1.0f, 1.0f, 1.0f, m_fHudButtonGlow[4]);

    float health = ((m_pThePlayer->GetAir() - PLAYER_MIN_AIR) / (PLAYER_MAX_AIR - PLAYER_MIN_AIR)) * 24.0f;
    int powerGaps = (int) health;

    for (int i = 0; i < 24; i++)
    {
        m_pHudPowerBlue[i]->Activate(i < powerGaps);
        m_pHudPowerGray[i]->Activate(i >= powerGaps);
    }

    for (int i = 0; i < 5; i++)
    {
        bool isRedGap = (powerGaps <= 5) && (i < powerGaps) && (powerGaps != 0);
        m_pHudPowerRedGlow[i]->SetColor(1.0f, 1.0f, 1.0f, m_fHudPowerAlpha);
        m_pHudPowerRedGlow[i]->Activate(isRedGap);

        m_pHudPowerRed[i]->Activate(isRedGap);
        m_pHudPowerBlue[i]->Activate(i < powerGaps);
    }

    if (m_pThePlayer->GetAmmo(STEEL_AMMO) > 0.0f)
    {
        m_pHudFireButtonSteel->Activate(true);
        m_pHudDeflateButton->Activate(false);
    }
    else
    {
        m_pHudFireButtonSteel->Activate(false);
        m_pHudDeflateButton->Activate(true);
    }

    if (!m_pHudFireButtonNormal->IsActive() && m_pThePlayer->GetAmmo(NORMAL_AMMO) > 0.0f)
    {
        m_pNormalScaleInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pNormalScaleInterpolator, false);
    }

    if (!m_pHudFireButtonNuclear->IsActive() && m_pThePlayer->GetAmmo(NUCLEAR_AMMO) > 0.0f)
    {
        m_pNuclearScaleInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pNuclearScaleInterpolator, false);
    }

    if (!m_pHudFireButtonElectric->IsActive() && m_pThePlayer->GetAmmo(ELECTRIC_AMMO) > 0.0f)
    {
        m_pElectricScaleInterpolator->Reset();
        InterpolatorManager::Instance().Add(m_pElectricScaleInterpolator, false);
    }

    m_pHudFireButtonNormal->Activate(m_pThePlayer->GetAmmo(NORMAL_AMMO) > 0.0f);
    m_pHudFireButtonNuclear->Activate(m_pThePlayer->GetAmmo(NUCLEAR_AMMO) > 0.0f);
    m_pHudFireButtonElectric->Activate(m_pThePlayer->GetAmmo(ELECTRIC_AMMO) > 0.0f);

#ifdef GEARDOME_PLATFORM_IPAD
    if (m_pNormalScaleInterpolator->CanKill())
    {
        m_pHudFireButtonNormal->SetPosition(IPHONE_SCREEN_HEIGHT - 150.0f, IPHONE_SCREEN_WIDTH - 335.0f, 0.0f);
    }
    else
    {
        MatrixTranslation(m_pHudFireButtonNormal->GetTransform(), -33.0f, -33.0f, 0.0f);
        MATRIX scale, trans;
        MatrixScaling(scale, m_fNormalScale, m_fNormalScale, 1.0f);
        MatrixTranslation(trans, IPHONE_SCREEN_HEIGHT - 117.0f, IPHONE_SCREEN_WIDTH - 302.0f, 0.0f);
        MatrixMultiply(m_pHudFireButtonNormal->GetTransform(), m_pHudFireButtonNormal->GetTransform(), scale);
        MatrixMultiply(m_pHudFireButtonNormal->GetTransform(), m_pHudFireButtonNormal->GetTransform(), trans);
    }

    if (m_pNuclearScaleInterpolator->CanKill())
    {
        m_pHudFireButtonNuclear->SetPosition(IPHONE_SCREEN_HEIGHT - 160.0f, IPHONE_SCREEN_WIDTH - 424.0f, 0.0f);
    }
    else
    {
        MatrixTranslation(m_pHudFireButtonNuclear->GetTransform(), -33.0f, -33.0f, 0.0f);
        MATRIX scale, trans;
        MatrixScaling(scale, m_fNuclearScale, m_fNuclearScale, 1.0f);
        MatrixTranslation(trans, IPHONE_SCREEN_HEIGHT - 127.0f, IPHONE_SCREEN_WIDTH - 391.0f, 0.0f);
        MatrixMultiply(m_pHudFireButtonNuclear->GetTransform(), m_pHudFireButtonNuclear->GetTransform(), scale);
        MatrixMultiply(m_pHudFireButtonNuclear->GetTransform(), m_pHudFireButtonNuclear->GetTransform(), trans);
    }

    if (m_pElectricScaleInterpolator->CanKill())
    {
        m_pHudFireButtonElectric->SetPosition(IPHONE_SCREEN_HEIGHT - 78.0f, IPHONE_SCREEN_WIDTH - 564.0f, 0.0f);
    }
    else
    {
        MatrixTranslation(m_pHudFireButtonElectric->GetTransform(), -33.0f, -33.0f, 0.0f);
        MATRIX scale, trans;
        MatrixScaling(scale, m_fElectricScale, m_fElectricScale, 1.0f);
        MatrixTranslation(trans, IPHONE_SCREEN_HEIGHT - 45.0f, IPHONE_SCREEN_WIDTH - 531.0f, 0.0f);
        MatrixMultiply(m_pHudFireButtonElectric->GetTransform(), m_pHudFireButtonElectric->GetTransform(), scale);
        MatrixMultiply(m_pHudFireButtonElectric->GetTransform(), m_pHudFireButtonElectric->GetTransform(), trans);
    }

#else

    if (m_pNormalScaleInterpolator->CanKill())
    {
        m_pHudFireButtonNormal->SetPosition(IPHONE_SCREEN_HEIGHT - 140.0f, IPHONE_SCREEN_WIDTH - 58.0f, 0.0f);
    }
    else
    {
        MatrixTranslation(m_pHudFireButtonNormal->GetTransform(), -28.0f, -28.0f, 0.0f);
        MATRIX scale, trans;
        MatrixScaling(scale, m_fNormalScale, m_fNormalScale, 1.0f);
        MatrixTranslation(trans, IPHONE_SCREEN_HEIGHT - 112.0f, IPHONE_SCREEN_WIDTH - 30.0f, 0.0f);
        MatrixMultiply(m_pHudFireButtonNormal->GetTransform(), m_pHudFireButtonNormal->GetTransform(), scale);
        MatrixMultiply(m_pHudFireButtonNormal->GetTransform(), m_pHudFireButtonNormal->GetTransform(), trans);
    }

    if (m_pNuclearScaleInterpolator->CanKill())
    {
        m_pHudFireButtonNuclear->SetPosition(IPHONE_SCREEN_HEIGHT - 116.0f, IPHONE_SCREEN_WIDTH - 115.0f, 0.0f);
    }
    else
    {
        MatrixTranslation(m_pHudFireButtonNuclear->GetTransform(), -28.0f, -28.0f, 0.0f);
        MATRIX scale, trans;
        MatrixScaling(scale, m_fNuclearScale, m_fNuclearScale, 1.0f);
        MatrixTranslation(trans, IPHONE_SCREEN_HEIGHT - 88.0f, IPHONE_SCREEN_WIDTH - 87.0f, 0.0f);
        MatrixMultiply(m_pHudFireButtonNuclear->GetTransform(), m_pHudFireButtonNuclear->GetTransform(), scale);
        MatrixMultiply(m_pHudFireButtonNuclear->GetTransform(), m_pHudFireButtonNuclear->GetTransform(), trans);
    }

    if (m_pElectricScaleInterpolator->CanKill())
    {
        m_pHudFireButtonElectric->SetPosition(IPHONE_SCREEN_HEIGHT - 60.0f, IPHONE_SCREEN_WIDTH - 197.0f, 0.0f);
    }
    else
    {
        MatrixTranslation(m_pHudFireButtonElectric->GetTransform(), -28.0f, -28.0f, 0.0f);
        MATRIX scale, trans;
        MatrixScaling(scale, m_fElectricScale, m_fElectricScale, 1.0f);
        MatrixTranslation(trans, IPHONE_SCREEN_HEIGHT - 32.0f, IPHONE_SCREEN_WIDTH - 169.0f, 0.0f);
        MatrixMultiply(m_pHudFireButtonElectric->GetTransform(), m_pHudFireButtonElectric->GetTransform(), scale);
        MatrixMultiply(m_pHudFireButtonElectric->GetTransform(), m_pHudFireButtonElectric->GetTransform(), trans);
    }
#endif

    Renderer::Instance().Add(m_pRenderableHud);
}

//////////////////////////
//////////////////////////

void Hud::Reset(void)
{
    m_fHudGemGlowAlpha = 1.0f;
    m_fHudPowerAlpha = 0.0f;
    m_fNuclearScale = 0.0f;
    m_fNormalScale = 0.0f;
    m_fElectricScale = 0.0f;
    /*
        if (m_pHudPowerAlphaInterpolator->IsActive())
        {
            InterpolatorManager::Instance().Delete(m_pHudPowerAlphaInterpolator);
        }*/
    if (m_pGemGlowInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pGemGlowInterpolator);
    }
    if (m_pNuclearScaleInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pNuclearScaleInterpolator);
    }
    if (m_pElectricScaleInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pElectricScaleInterpolator);
    }
    if (m_pNormalScaleInterpolator->IsActive())
    {
        InterpolatorManager::Instance().Delete(m_pNormalScaleInterpolator);
    }

    m_pThePlayer->SetGemAdded(false);
    m_pHudGemGlow->Activate(false);
}

