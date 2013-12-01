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
 * File:   introgamestate.cpp
 * Author: nacho
 * 
 * Created on 23 de marzo de 2009, 21:01
 */

#include "introgamestate.h"
#include "texturemanager.h"
#include "meshmanager.h"
#include "renderer.h"
#include "timer.h"
#include "menugamestate.h"
#include "fader.h"

//////////////////////////
//////////////////////////

IntroGameState::IntroGameState(void) : GameState()
{
    Log("+++ IntroGameState::IntroGameState ...\n");

    InitPointer(m_pCamera3D);
    InitPointer(m_pCamera2D);
    InitPointer(m_pMainTimer);
    InitPointer(m_pFader);

    InitPointer(m_pRenderable);

    InitPointer(m_pRoGeardomeText);
    InitPointer(m_pRoGearBig);
    InitPointer(m_pRoGearSmall);

    InitPointer(m_pRoEarphoneLogo);
    InitPointer(m_pRoEarphoneBG);
    InitPointer(m_pRoEarphoneDetail);

    InitPointer(m_pInputCallbackAny);

    Log("+++ IntroGameState::IntroGameState correcto\n");
}

//////////////////////////
//////////////////////////

IntroGameState::~IntroGameState()
{
    Log("+++ IntroGameState::~IntroGameState ...\n");

    Cleanup();

    Log("+++ IntroGameState::~IntroGameState destruido\n");
}

//////////////////////////
//////////////////////////

void IntroGameState::Init(void)
{
    Log("+++ IntroGameState::Init ...\n");

    m_bNeedCleanup = true;
    m_bFinished = false;
    m_bLogo = true;
    m_bSkipping = false;
    m_bNeedsSkipping = false;

    m_pCamera3D = new Camera();
    m_pCamera2D = new Camera();
    m_pMainTimer = new Timer();
    m_pFader = new Fader();

    m_pRenderable = new Renderable();

    m_pRoGeardomeText = new RenderObject();
    m_pRoGearBig = new RenderObject();
    m_pRoGearSmall = new RenderObject();

    m_pRoEarphoneLogo = new RenderObject();
    m_pRoEarphoneBG = new RenderObject();
    m_pRoEarphoneDetail = new RenderObject();

    m_pCamera3D->SetTargeting(true);
    m_pCamera3D->SetFov(34.0f);
    m_pCamera3D->SetFarPlane(1150.0f);
    m_pCamera3D->SetNearPlane(220.0f);
    m_pCamera3D->SetMode(true);

    m_pCamera2D->SetMode(false);

    Renderer::Instance().SetClearColor(1.0f, 1.0f, 1.0f, 1.0f);
    Renderer::Instance().EnableClearColor(true);
    Renderer::Instance().SetCamera(m_pCamera3D, true);
    Renderer::Instance().SetCamera(m_pCamera2D, false);

    m_pRoGeardomeText->Init(MeshManager::Instance().GetMeshFromFile("logo/gfx/geardome_texto"),
            TextureManager::Instance().GetTexture("logo/gfx/text"), RENDER_OBJECT_NORMAL);
    m_pRoGearBig->Init(MeshManager::Instance().GetMeshFromFile("logo/gfx/nut_big"),
            TextureManager::Instance().GetTexture("logo/gfx/gear"), RENDER_OBJECT_NORMAL);
    m_pRoGearSmall->Init(MeshManager::Instance().GetMeshFromFile("logo/gfx/nut_small"),
            TextureManager::Instance().GetTexture("logo/gfx/gear"), RENDER_OBJECT_NORMAL);

    m_pRoGeardomeText->SetPosition(0.0f, 20.0f, -7.0f);

#ifdef GEARDOME_PLATFORM_IPAD
    Texture* pTexMenu = TextureManager::Instance().GetTexture("menu/gfx/menu_01");
    Texture* pTexMenu2 = TextureManager::Instance().GetTexture("menu/gfx/menu_04");

    m_pRoEarphoneLogo->Init(MeshManager::Instance().GetBoardMesh(0, 0, 914, 228,
            pTexMenu2->GetWidth(), pTexMenu2->GetHeight()), pTexMenu2, RENDER_OBJECT_TRANSPARENT);
    m_pRoEarphoneBG->Init(MeshManager::Instance().GetBoardMesh(IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH, 483, 484, 1, 315,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_NORMAL);
    m_pRoEarphoneDetail->Init(MeshManager::Instance().GetBoardMesh(2, 229, 208, 404,
            pTexMenu2->GetWidth(), pTexMenu2->GetHeight()), pTexMenu2, RENDER_OBJECT_TRANSPARENT);

    m_pRoEarphoneLogo->SetPosition((IPHONE_SCREEN_HEIGHT / 2.0f) - 457,
            (IPHONE_SCREEN_WIDTH / 2.0f) - 114, 0.0f);
    m_pRoEarphoneLogo->UseColor(true);
    m_pRoEarphoneBG->SetPosition(0.0f, 0.0f, -10.0f);
    m_pRoEarphoneDetail->UseColor(true);
#else
    Texture* pTexMenu = TextureManager::Instance().GetTexture("menu/gfx/menu_01");

    m_pRoEarphoneLogo->Init(MeshManager::Instance().GetBoardMesh(404, 98, 0, 404, 322, 420,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pRoEarphoneBG->Init(MeshManager::Instance().GetBoardMesh(IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH, 483, 484, 1, 315,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_NORMAL);
    m_pRoEarphoneDetail->Init(MeshManager::Instance().GetBoardMesh(93, 183, 419, 512, 329, 512,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);

    m_pRoEarphoneLogo->SetPosition((IPHONE_SCREEN_HEIGHT / 2.0f) - 202,
            (IPHONE_SCREEN_WIDTH / 2.0f) - 49, 0.0f);
    m_pRoEarphoneLogo->UseColor(true);
    m_pRoEarphoneBG->SetPosition(0.0f, 0.0f, -10.0f);
    m_pRoEarphoneDetail->UseColor(true);
#endif


    m_pRenderable->GetRenderObjectList().push_back(m_pRoGeardomeText);
    m_pRenderable->GetRenderObjectList().push_back(m_pRoGearBig);
    m_pRenderable->GetRenderObjectList().push_back(m_pRoGearSmall);

    m_pRenderable->Set3D(true);

    m_pFader->SetLayer(1000);
    m_pFader->StartFade(1.0f, 1.0f, 1.0f, true, 1.2f, 0.0f, 1.0f, 0.0f, true);

    m_pInputCallbackAny = new InputCallback<IntroGameState > (this, &IntroGameState::InputCallbackAny);
    InputManager::Instance().AddRectRegionEvent(0.0f, 0.0f, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH, m_pInputCallbackAny);

    m_pMainTimer->Start();

    Log("+++ IntroGameState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void IntroGameState::InputCallbackAny(stInputCallbackParameter parameter, int id)
{
    if (!m_bSkipping && !m_bNeedsSkipping && parameter.type == PRESS_START)
    {
        m_bNeedsSkipping = true;
    }
}

//////////////////////////
//////////////////////////

void IntroGameState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ IntroGameState::Cleanup ...\n");

        MeshManager::Instance().UnloadAll();
        TextureManager::Instance().UnloadAll();
        m_pRenderable->GetRenderObjectList().clear();

        SafeDelete(m_pCamera3D);
        SafeDelete(m_pCamera2D);
        SafeDelete(m_pMainTimer);
        SafeDelete(m_pFader);

        SafeDelete(m_pRenderable);

        SafeDelete(m_pRoGeardomeText);
        SafeDelete(m_pRoGearBig);
        SafeDelete(m_pRoGearSmall);

        SafeDelete(m_pRoEarphoneLogo);
        SafeDelete(m_pRoEarphoneBG);
        SafeDelete(m_pRoEarphoneDetail);

        SafeDelete(m_pInputCallbackAny);

        InputManager::Instance().ClearRegionEvents();

        Renderer::Instance().ClearLayers();

        m_bNeedCleanup = false;

        Log("+++ IntroGameState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void IntroGameState::Pause(void)
{
    Log("+++ IntroGameState::Pause ...\n");

    Log("+++ IntroGameState::Pause correcto\n");
}

//////////////////////////
//////////////////////////

void IntroGameState::Resume(void)
{
    Log("+++ IntroGameState::Resume ...\n");

    Log("+++ IntroGameState::Resume correcto\n");
}

//////////////////////////
//////////////////////////

void IntroGameState::UpdateLogo(void)
{
    float h = m_pMainTimer->GetActualTime();
    float f = h + 9.5f;

    float heightCamera = 100.0f - ((h / 9.4f) * 100.0f);

    if (h >= 9.4f)
    {
        f = 9.4f + 9.5f;
        heightCamera = 0.0f;
    }

    if (h >= 11.0f && h < 12.0f && m_pFader->IsFinished())
    {
        m_pFader->StartFade(1.0f, 1.0f, 1.0f, false, 1.0f, 0.0f, 1.0f, 0.0f, true);
    }

    if (h >= 12.0f && m_pFader->IsFinished())
    {
        m_bLogo = false;
    }

    Vec3 eye;
    eye.x = 100.f + (700.0f * fast_cos(f / 2.0f));
    eye.y = (100.0f + (30.0f * fast_sin(f / 3.0f))) + heightCamera;
    eye.z = -(-150.0f + (300.0f * fast_sin(f / 4.0f)));

    Vec3 look;
    look.x = -140.0f;
    look.y = 60.0f - (heightCamera / 2.0f);
    look.z = 0.0f;

    m_pCamera3D->SetTarget(look);
    m_pCamera3D->SetPosition(eye);

    float time = h * 20.0f;

    MATRIX T, R;
    MatrixTranslation(T, -166.586f, 103.963f, -60.0f);
    MatrixRotationZ(R, (-(time / 15.0f) * 1.5f) - 10.5f);
    MatrixMultiply(m_pRoGearSmall->GetTransform(), R, T);

    MatrixTranslation(T, -249.805f, 84.738f, -60.0f);
    MatrixRotationZ(R, time / 15.0f);
    MatrixMultiply(m_pRoGearBig->GetTransform(), R, T);
}

//////////////////////////
//////////////////////////

void IntroGameState::UpdateEarPhones(void)
{
    float actualTime = m_pMainTimer->GetActualTime();
    float deltaTime = m_pMainTimer->GetDeltaTime();

    float alpha = MAT_Clampf((actualTime - 0.5f) / 2.0f, 0.0f, 1.0f);

    m_pRoEarphoneLogo->SetColor(1.0f, 1.0f, 1.0f, alpha);

    alpha = MAT_Clampf((actualTime - 1.0f) * 1.0f, 0.0f, 1.0f);

    m_pRoEarphoneDetail->SetColor(1.0f, 1.0f, 1.0f, alpha);

    static float rot = -90.0f;
    static float vel = 1.0f;

    if (actualTime >= 1.0f)
    {
        vel += -rot * deltaTime * 0.8f;
        vel *= 0.92f;
        rot += vel;
    }

#ifdef GEARDOME_PLATFORM_IPAD
    MATRIX mt1, mt2, mr, mres;
    MatrixTranslation(mt1, 0.0f, -404.0f, 0.0f);
    MatrixRotationZ(mr, MAT_ToRadians(-rot - 90.0f));
    MatrixTranslation(mt2, 510.0f, 404.0f + 75.0f, -1.0f);
#else
    MATRIX mt1, mt2, mr, mres;
    MatrixTranslation(mt1, 0.0f, -183.0f, 0.0f);
    MatrixRotationZ(mr, MAT_ToRadians(-rot - 90.0f));
    MatrixTranslation(mt2, 240.0f, 183.0f + 20.0f, -1.0f);
#endif
    
    MatrixMultiply(mres, mt1, mr);
    MatrixMultiply(m_pRoEarphoneDetail->GetTransform(), mres, mt2);

    if (actualTime >= 5.0f && actualTime < 5.5f && m_pFader->IsFinished())
    {
        m_pFader->StartFade(0.0f, 0.0f, 0.0f, false, 0.5f, 0.0f);
    }

    if (actualTime >= 5.5f && m_pFader->IsFinished())
    {
        m_bFinished = true;
    }

}

//////////////////////////
//////////////////////////

void IntroGameState::Update(void)
{
    m_pMainTimer->Update();

    InputManager::Instance().Update();

    Renderer::Instance().Add(m_pRenderable);

    bool bDrawingLogo = m_bLogo;

    if (m_bLogo)
    {
        UpdateLogo();
    }
    else
    {
        UpdateEarPhones();
    }

    if (m_bNeedsSkipping && m_pFader->IsFinished())
    {
        m_bSkipping = true;
        m_bNeedsSkipping = false;

        m_pFader->StartFade(0.0f, 0.0f, 0.0f, false, 0.2f, 0.0f);
    }

    if (m_bSkipping && m_pFader->IsFinished())
    {
        m_bFinished = true;
    }

    m_pFader->Update(m_pMainTimer->GetDeltaTime());

    //Renderer::Instance().Render();

    if (bDrawingLogo != m_bLogo)
    {
        Renderer::Instance().ClearLayers();
        Renderer::Instance().EnableClearColor(false);
        m_pRenderable->GetRenderObjectList().clear();
        m_pRenderable->Set3D(false);
        m_pRenderable->GetRenderObjectList().push_back(m_pRoEarphoneLogo);
        m_pFader->StartFade(1.0f, 1.0f, 1.0f, true, 0.5f, 0.0f, 1.0f, 0.0f, true);
        m_pRenderable->GetRenderObjectList().push_back(m_pRoEarphoneBG);
        m_pRenderable->GetRenderObjectList().push_back(m_pRoEarphoneDetail);

        m_pMainTimer->Start();
    }

    if (m_bFinished)
    {
        GameManager::Instance().ChangeState(&MenuGameState::Instance());
    }
}
