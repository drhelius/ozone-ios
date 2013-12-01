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
 * File:   submenumainstate.cpp
 * Author: nacho
 * 
 * Created on 11 de junio de 2009, 23:23
 */

#include "menugamestate.h"
#include "textfont.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "timer.h"
#include "SubMenuOptionsState.h"
#include "SubMenuSaveSelectionState.h"
#include "SubMenuCustomLevelsState.h"
#include "SubMenuHighScoresState.h"
#include "SubMenuFullVersionState.h"
#include "SubMenuCreditsState.h"
#include "SubMenuHelpState.h"
#include "gamemanager.h"
#include "levelgamestate.h"
#include "audio.h"
#include "SaveManager.h"

#ifdef OZONE_LITE
const char * SubMenuMainState::ms_MenuTexts[] = {"Start", "Full Version Features", "High Scores", "Help"};
#else
const char * SubMenuMainState::ms_MenuTexts[] = {"Start", "High Scores", "Help", "Custom Levels", "More Games"};
#endif
//////////////////////////
//////////////////////////

SubMenuMainState::SubMenuMainState(void) : SubMenuState()
{
    Log("+++ SubMenuMainState::SubMenuMainState ...\n");

    m_bExiting = false;
    m_bSendingScore = false;

    InitPointer(m_pNextSubMenu);

    InitPointer(m_pCamera3DCubeBig);

    InitPointer(m_pCamera2D);
    InitPointer(m_pMainTimer);

    InitPointer(m_pRenderableMidLayer3DCubeBig);
    InitPointer(m_pRenderableHighLayer2D);

    InitPointer(m_pCubeBig);
    InitPointer(m_pTextFont);

    InitPointer(m_pTopButton);

#ifdef OZONE_LITE
    InitPointer(m_pBuyButton);
    InitPointer(m_pBuyButtonGlow);

    InitPointer(m_pBuyGlowInterpolator);

    m_fBuyGlow = 0.0f;
#endif

    InitPointer(m_pInputCallbackMenu);
    InitPointer(m_pInputCallbackSend);

    InitPointer(m_pUICallbackScore);
    InitPointer(m_pUICallbackLevelAlert);

    for (int i = 0; i < MENU_ITEMS; i++)
    {
        InitPointer(m_pMenuItems[i]);
    }

    Log("+++ SubMenuMainState::SubMenuMainState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuMainState::~SubMenuMainState(void)
{
    Log("+++ SubMenuMainState::~SubMenuMainState ...\n");

    Cleanup();

    Log("+++ SubMenuMainState::~SubMenuMainState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuMainState::Reset(void)
{
    Log("+++ SubMenuMainState::Reset ...\n");

    InitPointer(m_pNextSubMenu);

    m_bExiting = false;
    m_bSendingScore = false;
    m_CurrentState = SUB_MENU_LOADING;
    m_bFinishing = false;

    InputManager::Instance().ClearRegionEvents();

    switch (SaveManager::Instance().GetAward())
    {
        case 1:
        {
            m_pCubeBig->renderObject.SetTexture(TextureManager::Instance().GetTexture("menu/gfx/main_cube_1"));
            break;
        }
        case 2:
        {
            m_pCubeBig->renderObject.SetTexture(TextureManager::Instance().GetTexture("menu/gfx/main_cube_2"));
            break;
        }
        case 3:
        {
            m_pCubeBig->renderObject.SetTexture(TextureManager::Instance().GetTexture("menu/gfx/main_cube_3"));
            break;
        }
    }

    for (int i = 0; i < MENU_ITEMS; i++)
    {

#ifdef GEARDOME_PLATFORM_IPAD
        m_pMenuItems[i]->renderObject.SetPosition(-593.0f - (400.0f * i), 250.0f + (100.0f * i), 0.0f);
        /*
        if (i == 0)
        {
            InputManager::Instance().AddRectRegionEvent(0, 70.0f + (100.0f * i), 591, 71, m_pInputCallbackMenu, i);
        }
        else*/
        {
            InputManager::Instance().AddRectRegionEvent(0, 244.0f + (100.0f * i), 591, 85, m_pInputCallbackMenu, i);
        }
#else
        m_pMenuItems[i]->renderObject.SetPosition(-244.0f - (200.0f * i), 104.0f + (41.0f * i), 0.0f);

        if (i == 0)
        {
            InputManager::Instance().AddRectRegionEvent(0, 70.0f + (41.0f * i), 242, 71, m_pInputCallbackMenu, i);
        }
        else
        {
            InputManager::Instance().AddRectRegionEvent(0, 101.0f + (41.0f * i), 242, 40, m_pInputCallbackMenu, i);
        }
#endif


    }

#ifdef OZONE_LITE
#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(0, 244.0f + (100.0f * 4), 591, 120, m_pInputCallbackMenu, 4);
#else
    InputManager::Instance().AddRectRegionEvent(0, 101.0f + (41.0f * 4), 242, 55, m_pInputCallbackMenu, 4);
#endif
#endif

    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 250.0f, IPHONE_SCREEN_WIDTH - 90.0f, 250.0f, 90.0f, m_pInputCallbackSend);

    m_pMainTimer->Start();

    Log("+++ SubMenuMainState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuMainState::Init(TextFont* pTextFont, Fader* pFader)
{
    Log("+++ SubMenuMainState::Init ...\n");

    m_bNeedCleanup = true;

    m_pTextFont = pTextFont;
    m_pFader = pFader;

    m_pMainTimer = new Timer();
    m_pCamera3DCubeBig = new Camera();
    m_pCamera2D = new Camera();
    m_pRenderableMidLayer3DCubeBig = new Renderable();
    m_pRenderableHighLayer2D = new Renderable();
    m_pCubeBig = new MenuItem();

    m_pInputCallbackMenu = new InputCallback<SubMenuMainState > (this, &SubMenuMainState::InputCallbackMenu);
    m_pInputCallbackSend = new InputCallback<SubMenuMainState > (this, &SubMenuMainState::InputCallbackSend);

    m_pUICallbackScore = new UICallback<SubMenuMainState > (this, &SubMenuMainState::UICallbackScore);
    m_pUICallbackLevelAlert = new UICallback<SubMenuMainState > (this, &SubMenuMainState::UICallbackLevelAlert);

    TextureManager::Instance().GetTexture("menu/gfx/main_cube_1");
    TextureManager::Instance().GetTexture("menu/gfx/main_cube_2");
    TextureManager::Instance().GetTexture("menu/gfx/main_cube_3");

    Texture* pTexMenu = TextureManager::Instance().GetTexture("menu/gfx/menu_01");
#ifdef GEARDOME_PLATFORM_IPAD
    Mesh* pMesh = MeshManager::Instance().GetBoardMesh(0, 893, 591, 73,
            pTexMenu->GetWidth(), pTexMenu->GetHeight());
#else
    Mesh* pMesh = MeshManager::Instance().GetBoardMesh(1, 422, 242, 34,
            pTexMenu->GetWidth(), pTexMenu->GetHeight());
#endif

    for (int i = 0; i < MENU_ITEMS; i++)
    {
        m_pMenuItems[i] = new MenuItem();
        m_pMenuItems[i]->renderObject.Init(pMesh, pTexMenu, RENDER_OBJECT_TRANSPARENT);
        m_pMenuItems[i]->renderObject.UseColor(true);

        m_pRenderableHighLayer2D->GetRenderObjectList().push_back(&m_pMenuItems[i]->renderObject);
    }

    m_pTopButton = new RenderObject();

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTopButton->Init(MeshManager::Instance().GetBoardMesh(176, 49, 769, 593, 893, 942,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    m_pTopButton->SetPosition(IPHONE_SCREEN_HEIGHT - 176, IPHONE_SCREEN_WIDTH - 53.0f, 0.0f);
#else
    m_pTopButton->Init(MeshManager::Instance().GetBoardMesh(23, 74, 487, 510, 1, 75,
            pTexMenu->GetWidth(), pTexMenu->GetHeight()), pTexMenu, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pTopButton->GetTransform(), MAT_ToRadians(-90.0f));
    m_pTopButton->SetPosition(IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH - 26.0f, 0.0f);
#endif

    m_pTopButton->UseColor(true);
    m_pRenderableHighLayer2D->GetRenderObjectList().push_back(m_pTopButton);



#ifdef OZONE_LITE    

    m_pBuyButton = new RenderObject();

#ifdef GEARDOME_PLATFORM_IPAD
    Texture* pTexBuy = TextureManager::Instance().GetTexture("menu/gfx/04");
    m_pBuyButton->Init(MeshManager::Instance().GetBoardMesh(0, 768, 380, 154,
            pTexBuy->GetWidth(), pTexBuy->GetHeight()), pTexBuy, RENDER_OBJECT_TRANSPARENT);
    m_pBuyButton->SetPosition(0.0f, IPHONE_SCREEN_WIDTH - 154.0f, 0.0f);
#else
    Texture* pTexBuy = TextureManager::Instance().GetTexture("menu/gfx/05");
    m_pBuyButton->Init(MeshManager::Instance().GetBoardMesh(2, 323, 190, 77,
            pTexBuy->GetWidth(), pTexBuy->GetHeight()), pTexBuy, RENDER_OBJECT_TRANSPARENT);
    m_pBuyButton->SetPosition(0.0f, IPHONE_SCREEN_WIDTH - 77.0f, 0.0f);
#endif

    m_pBuyButton->UseColor(true);
    m_pRenderableHighLayer2D->GetRenderObjectList().push_back(m_pBuyButton);


    m_pBuyButtonGlow = new RenderObject();

#ifdef GEARDOME_PLATFORM_IPAD
    m_pBuyButtonGlow->Init(MeshManager::Instance().GetBoardMesh(382, 768, 380, 154,
            pTexBuy->GetWidth(), pTexBuy->GetHeight()), pTexBuy, RENDER_OBJECT_ADDITIVE);
    m_pBuyButtonGlow->SetPosition(0.0f, IPHONE_SCREEN_WIDTH - 154.0f, 0.0f);
#else
    m_pBuyButtonGlow->Init(MeshManager::Instance().GetBoardMesh(193, 323, 190, 77,
            pTexBuy->GetWidth(), pTexBuy->GetHeight()), pTexBuy, RENDER_OBJECT_ADDITIVE);
    m_pBuyButtonGlow->SetPosition(0.0f, IPHONE_SCREEN_WIDTH - 77.0f, 1.0f);
#endif

    m_pBuyButtonGlow->UseColor(true);
    m_pRenderableHighLayer2D->GetRenderObjectList().push_back(m_pBuyButtonGlow);


    m_pBuyGlowInterpolator = new SineInterpolator(&m_fBuyGlow, 0.0f, 1.0f, 2.0f);

    InterpolatorManager::Instance().Add(m_pBuyGlowInterpolator, false);
#endif


    m_pCubeBig->renderObject.Init(MeshManager::Instance().GetMeshFromFile("menu/gfx/main_cube"),
            TextureManager::Instance().GetTexture("menu/gfx/main_cube"), RENDER_OBJECT_ADDITIVE);

    m_pCubeBig->renderObject.UseColor(true);

    m_pRenderableMidLayer3DCubeBig->GetRenderObjectList().push_back(&m_pCubeBig->renderObject);

    m_pRenderableMidLayer3DCubeBig->Set3D(true);
    m_pRenderableMidLayer3DCubeBig->SetLayer(500);
    m_pRenderableHighLayer2D->Set3D(false);
    m_pRenderableHighLayer2D->SetLayer(600);

    m_pCamera3DCubeBig->SetTargeting(true);
    m_pCamera3DCubeBig->SetFov(45.0f);
    m_pCamera3DCubeBig->SetFarPlane(1150.0f);
    m_pCamera3DCubeBig->SetNearPlane(1.0f);
    m_pCamera3DCubeBig->SetMode(true);
    m_pCamera3DCubeBig->SetPosition(0.0f, 8.0f, 18.0f);

    m_pCamera2D->SetMode(false);

    Renderer::Instance().EnableClearColor(false);
    Renderer::Instance().SetCamera(m_pCamera3DCubeBig, true);
    Renderer::Instance().SetCamera(m_pCamera2D, false);

    Reset();
    
    if (SaveManager::Instance().IsLevelAlertFirstTime())
    {
        UIManager::Instance().RaiseEvent(UI_EVENT_LEVELALERT, m_pUICallbackLevelAlert);
    }

    m_pMainTimer->Start();

    Log("+++ SubMenuMainState::Init correcto\n");

}

//////////////////////////
//////////////////////////

void SubMenuMainState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ SubMenuMainState::Cleanup ...\n");

        MeshManager::Instance().UnloadAll();
        TextureManager::Instance().UnloadAll();
        InputManager::Instance().ClearRegionEvents();

        Renderer::Instance().ClearLayers();

        InitPointer(m_pTextFont);
        InitPointer(m_pNextSubMenu);

        SafeDelete(m_pMainTimer);

        SafeDelete(m_pCamera3DCubeBig);

        SafeDelete(m_pCamera2D);

        SafeDelete(m_pRenderableMidLayer3DCubeBig);
        SafeDelete(m_pRenderableHighLayer2D);

        SafeDelete(m_pCubeBig);

        SafeDelete(m_pTopButton);

#ifdef OZONE_LITE
        SafeDelete(m_pBuyButton);
        SafeDelete(m_pBuyButtonGlow);

        InitPointer(m_pBuyGlowInterpolator);
#endif

        SafeDelete(m_pInputCallbackMenu);
        SafeDelete(m_pInputCallbackSend);

        SafeDelete(m_pUICallbackScore);
        SafeDelete(m_pUICallbackLevelAlert);

        for (int i = 0; i < MENU_ITEMS; i++)
        {
            SafeDelete(m_pMenuItems[i]);
        }

        m_bNeedCleanup = false;

        Log("+++ SubMenuMainState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::UpdateLoading(void)
{
    m_pMainTimer->Update();

    UpdateCube();
    UpdateItemsLoading();

    Renderer::Instance().Add(m_pRenderableMidLayer3DCubeBig);
    Renderer::Instance().Add(m_pRenderableHighLayer2D);
}

//////////////////////////
//////////////////////////

void SubMenuMainState::UpdateClosing(void)
{
    m_pMainTimer->Update();

    UpdateCube();
    UpdateItemsClosing();

    Renderer::Instance().Add(m_pRenderableMidLayer3DCubeBig);
    Renderer::Instance().Add(m_pRenderableHighLayer2D);
}

//////////////////////////
//////////////////////////

void SubMenuMainState::Update(void)
{
    m_pMainTimer->Update();

    UpdateCube();
    UpdateItems();

    Renderer::Instance().Add(m_pRenderableMidLayer3DCubeBig);
    Renderer::Instance().Add(m_pRenderableHighLayer2D);

    if (m_bExiting)
    {
        m_bExiting = false;
        m_CurrentState = SUB_MENU_CLOSING;
    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::UpdateCube(void)
{
    float deltaTime = m_pMainTimer->GetDeltaTime();

    MATRIX matTrans;

    if (GameManager::Instance().IsHomeRight())
    {
        MatrixTranslation(matTrans, -0.1f, -0.5f, 0.0f);
    }
    else
    {
        MatrixTranslation(matTrans, 0.1f, 0.5f, 0.0f);
    }

    m_pCamera3DCubeBig->SetAbsoluteTransform(matTrans);


    MATRIX scaleBig;

    MatrixScaling(scaleBig, 0.1f, 0.1f, 0.1f);

    /// cube big

    Vec3 rot = m_pCubeBig->GetAngularSpeed();

    rot.y -= 0.2f * deltaTime;

    m_pCubeBig->SetAngularSpeed(rot);

    MatrixRotationY(m_pCubeBig->renderObject.GetTransform(), rot.y);
    MatrixMultiply(m_pCubeBig->renderObject.GetTransform(), m_pCubeBig->renderObject.GetTransform(), scaleBig);

    float mult = 0.9f;

    if (m_CurrentState == SUB_MENU_CLOSING)
        mult = 1.3f;

    float num = MAT_abs(m_pMenuItems[0]->renderObject.GetPosition().x * mult) / 244.0f;
    float trans = MAT_Clampf(1.0f - num, 0.0f, 1.0f);

    m_pCubeBig->renderObject.SetColor(1.0f, 1.0f, 1.0f, trans);


    m_pTopButton->Activate(SaveManager::Instance().WaitingToUploadScore());
    m_pTopButton->SetColor(1.0f, 1.0f, 1.0f, trans);

#ifdef OZONE_LITE
    m_pBuyButton->SetColor(1.0f, 1.0f, 1.0f, trans);
    m_pBuyButtonGlow->SetColor(1.0f, 1.0f, 1.0f, MAT_Min(m_fBuyGlow, trans));
#endif

    if (SaveManager::Instance().WaitingToUploadScore())
    {
        COLOR cFont = {1.0f, 1.0f, 1.0f, trans};

#ifdef GEARDOME_PLATFORM_IPAD
        m_pTextFont->Add("Submit Score", IPHONE_SCREEN_HEIGHT - 260.0f, IPHONE_SCREEN_WIDTH - 64.0f, 0.0f, cFont);
#else
        m_pTextFont->Add("Submit Score", IPHONE_SCREEN_HEIGHT - 130.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFont);
#endif

    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::UpdateItems(void)
{
    COLOR cFont = {1.0f, 1.0f, 1.0f, 1.0f};
    for (int i = 0; i < MENU_ITEMS; i++)
    {
        Vec3 pos = m_pMenuItems[i]->renderObject.GetPosition();

#ifdef GEARDOME_PLATFORM_IPAD
        m_pTextFont->Add(ms_MenuTexts[i], 72.0f, pos.y - 2.0f, 10.0f, cFont);
#else
        m_pTextFont->Add(ms_MenuTexts[i], 34.0f, pos.y - 2.0f, 10.0f, cFont);
#endif

    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::UpdateItemsLoading(void)
{
    float deltaTime = m_pMainTimer->GetDeltaTime();

    COLOR cFont = {1.0f, 1.0f, 1.0f, 1.0f};

    for (int i = 0; i < MENU_ITEMS; i++)
    {
        Vec3 pos = m_pMenuItems[i]->renderObject.GetPosition();

        float dist = MAT_abs(pos.x);

        pos.x += dist * deltaTime * 5.0f;

        if (pos.x > -0.4f)
            pos.x = 0.0f;

        m_pMenuItems[i]->renderObject.SetPosition(pos);

#ifdef GEARDOME_PLATFORM_IPAD
        m_pTextFont->Add(ms_MenuTexts[i], pos.x + 72.0f, pos.y - 2.0f, 0.0f, cFont);
#else
        m_pTextFont->Add(ms_MenuTexts[i], pos.x + 34.0f, pos.y - 2.0f, 0.0f, cFont);
#endif

        if (i == (MENU_ITEMS - 1) && pos.x == 0.0f)
        {
            m_CurrentState = SUB_MENU_IDLE;
        }

        //m_pMenuItems[i]->renderObject.SetColor(1.0f, 1.0f, 1.0f,
        //        MAT_Clampf(m_pMainTimer->GetActualTime() * 1.0f - (i * 0.2f), 0.0f, 1.0f));
    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::UpdateItemsClosing(void)
{
    float deltaTime = m_pMainTimer->GetDeltaTime();

    COLOR cFont = {1.0f, 1.0f, 1.0f, 1.0f};

    for (int i = 0; i < MENU_ITEMS; i++)
    {
        Vec3 pos = m_pMenuItems[i]->renderObject.GetPosition();

        float dist = 350.0f + (150.0f * i) - MAT_abs(pos.x);


        pos.x -= dist * deltaTime * 2.5f;

        if (pos.x < (-350.0f - (150.0f * i)))
            pos.x = -350.0f - (150.0f * i);

        m_pMenuItems[i]->renderObject.SetPosition(pos);

#ifdef GEARDOME_PLATFORM_IPAD
        m_pTextFont->Add(ms_MenuTexts[i], pos.x + 72.0f, pos.y - 2.0f, 0.0f, cFont);
#else
        m_pTextFont->Add(ms_MenuTexts[i], pos.x + 34.0f, pos.y - 2.0f, 0.0f, cFont);
#endif

        if (i == 0 && pos.x <= -240.0f)
        {
            m_bFinishing = true;

            MenuGameState::Instance().SetSubMenu(m_pNextSubMenu);
        }

        //m_pMenuItems[i]->renderObject.SetColor(1.0f, 1.0f, 1.0f,
        //        MAT_Clampf(m_pMainTimer->GetActualTime() * 1.0f - (i * 0.2f), 0.0f, 1.0f));
    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::InputCallbackMenu(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_SELECTION));

        switch (id)
        {
#ifdef OZONE_LITE
            case 0:
            {
                Log("--------- input load game\n");
                m_bExiting = true;
                m_pNextSubMenu = &SubMenuSaveSelectionState::Instance();
                break;
            }
            case 1:
            {
                Log("--------- input full version\n");
                m_bExiting = true;
                m_pNextSubMenu = &SubMenuFullVersionState::Instance();
                break;
            }
            case 2:
            {
                Log("--------- input high scores\n");
                m_bExiting = true;
                m_pNextSubMenu = &SubMenuHighScoresState::Instance();
                break;
            }
            case 3:
            {
                Log("--------- input help\n");
                m_bExiting = true;
                m_pNextSubMenu = &SubMenuHelpState::Instance();
                break;
            }
            case 4:
            {
                Log("--------- input buy\n");
#ifdef GEARDOME_PLATFORM_IPAD
                [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://itunes.ozonehd.com"]];
#else
                [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://ozone.itunes.geardome.com"]];
#endif
                break;
            }
#else
            case 0:
            {
                Log("--------- input load game\n");
                m_bExiting = true;
                m_pNextSubMenu = &SubMenuSaveSelectionState::Instance();
                break;
            }
            case 1:
            {
                Log("--------- input high scores\n");
#ifndef OZONE_PRE_RELEASE
                m_bExiting = true;
                m_pNextSubMenu = &SubMenuHighScoresState::Instance();
#endif
                break;
            }
            case 2:
            {
                Log("--------- input help\n");
                m_bExiting = true;
                m_pNextSubMenu = &SubMenuHelpState::Instance();
                break;
            }
            case 4:
            {
                Log("--------- play haven \n");
                UIManager::Instance().RaiseEvent(UI_EVENT_PLAYHAVEN, m_pUICallbackScore);
                break;
            }
            case 3:
            {
                Log("--------- custom levels \n");
                m_bExiting = true;
                m_pNextSubMenu = &SubMenuCustomLevelsState::Instance();
                /*
                Log("--------- input tell your friends\n");

                NSString *recipients = @"mailto: ?subject=Try Ozone for iPhone and iPod Touch!";
#ifdef GEARDOME_PLATFORM_IPAD
                NSString *body = @"&body=Hey friend,\n\nTry <a href='http://itunes.ozonehd.com'>Ozone HD for iPad</a>!";
#else
                NSString *body = @"&body=Hey friend,\n\nTry <a href='http://ozone.itunes.geardome.com'>Ozone for iPhone and iPod Touch</a>!";
#endif

                NSString *email = [NSString stringWithFormat : @"%@%@", recipients, body];
                email = [email stringByAddingPercentEscapesUsingEncoding : NSUTF8StringEncoding];

                [[UIApplication sharedApplication] openURL : [NSURL URLWithString : email]];*/


                break;
            }
#endif
        }
    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::InputCallbackSend(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && SaveManager::Instance().WaitingToUploadScore() && !m_bSendingScore)
    {
        m_bSendingScore = true;
        UIManager::Instance().RaiseEvent(UI_EVENT_ASKSENDSCORE, m_pUICallbackScore);
    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::UICallbackScore(int button, const char* szName)
{
    if (button == 1)
    {
        UIManager::Instance().RaiseEvent(UI_EVENT_DOSENDWAITINGSCORE);
    }
    else
    {
        m_bSendingScore = false;
    }
}

//////////////////////////
//////////////////////////

void SubMenuMainState::UICallbackLevelAlert(int button, const char* szName)
{
    if (button == 1)
    {
        [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://ozone-editor.geardome.com"]];
    }
}