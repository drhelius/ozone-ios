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
 *  SubMenuHighScoresState.cpp
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#include "SubMenuHighScoresState.h"
#include "menugamestate.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "audio.h"

//////////////////////////
//////////////////////////

SubMenuHighScoresState::SubMenuHighScoresState(void) : SubMenuState()
{
    Log("+++ SubMenuHighScoresState::SubMenuHighScoresState ...\n");

    InitPointer(m_pTextFont);
    InitPointer(m_pInputCallbackBack);
    InitPointer(m_pInputCallbackTop);
    InitPointer(m_pUICallbackList);
    InitPointer(m_pUICallbackWeb);

    InitPointer(m_pRenderableMidLayer2D);
    InitPointer(m_pBackground);
    InitPointer(m_pBackButton);
    InitPointer(m_pMenuBar);
    InitPointer(m_pTopButton);
    InitPointer(m_pTopGlow);

    InitPointer(m_pMenuOpacityInterpolator);

    m_fMenuOpacity = 0.0f;

    m_bNeedCleanup = false;
    m_bShowingList = false;

    Log("+++ SubMenuHighScoresState::SubMenuHighScoresState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuHighScoresState::~SubMenuHighScoresState(void)
{
    Log("+++ SubMenuHighScoresState::~SubMenuHighScoresState ...\n");

    Cleanup();

    Log("+++ SubMenuHighScoresState::~SubMenuHighScoresState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::Reset(void)
{
    Log("+++ SubMenuHighScoresState::Reset ...\n");

    m_bWebReceived = false;
    UIManager::Instance().RaiseEvent(UI_EVENT_GETSCORES, m_pUICallbackWeb);

    InputManager::Instance().ClearRegionEvents();

    m_bFinishing = false;
    m_CurrentState = SUB_MENU_LOADING;
    m_fMenuOpacity = 0.0f;
    m_fGlowRotation = 0.0f;
    m_pChangingToMenu = NULL;


#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 70.0f, 200.0f, 70.0f, m_pInputCallbackBack);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 200.0f, IPHONE_SCREEN_WIDTH - 70.0f, 200.0f, 70.0f, m_pInputCallbackTop);
#else
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 35.0f, 100.0f, 35.0f, m_pInputCallbackBack);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 150.0f, IPHONE_SCREEN_WIDTH - 35.0f, 150.0f, 35.0f, m_pInputCallbackTop);
#endif

    ResetInterpolators();

    m_GlowTimer.Start();

    Log("+++ SubMenuHighScoresState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::Init(TextFont* pTextFont, Fader* pFader)
{
    Log("+++ SubMenuHighScoresState::Init ...\n");

    m_bNeedCleanup = true;
    m_pTextFont = pTextFont;
    m_pFader = pFader;

    Texture* pTexMenu01 = TextureManager::Instance().GetTexture("menu/gfx/menu_01");
    Texture* pTexScores = TextureManager::Instance().GetTexture("menu/gfx/scores");

    m_pRenderableMidLayer2D = new Renderable();
    m_pRenderableMidLayer2D->Set3D(false);
    m_pRenderableMidLayer2D->SetLayer(600);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pBackButton = new RenderObject();
    m_pBackButton->Init(MeshManager::Instance().GetBoardMesh(593, 893, 176, 49,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pBackButton->SetPosition(0.0f, IPHONE_SCREEN_WIDTH - 60.0f, 0.0f);
    m_pBackButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackButton);

    m_pMenuBar = new RenderObject();
    m_pMenuBar->Init(MeshManager::Instance().GetBoardMesh(0, 966, 524, 46,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pMenuBar->SetPosition(0.0f, 210.0f, 0.0f);
    m_pMenuBar->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pMenuBar);

    m_pTopButton = new RenderObject();
    m_pTopButton->Init(MeshManager::Instance().GetBoardMesh(176, 49, 769, 593, 893, 942,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pTopButton->SetPosition(IPHONE_SCREEN_HEIGHT - 176.0f, IPHONE_SCREEN_WIDTH - 60.0f, 0.0f);
    m_pTopButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pTopButton);


    m_pTopGlow = new RenderObject();
    m_pTopGlow->Init(MeshManager::Instance().GetBoardMesh(2, 391, 119, 119,
            pTexScores->GetWidth(), pTexScores->GetHeight()), pTexScores, RENDER_OBJECT_ADDITIVE);

    m_pTopGlow->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pTopGlow);


    m_pBackground = new RenderObject();
    m_pBackground->Init(MeshManager::Instance().GetBoardMesh(0, 0, 1024, 388,
            pTexScores->GetWidth(), pTexScores->GetHeight()), pTexScores, RENDER_OBJECT_TRANSPARENT);
    m_pBackground->SetPosition(0.0f, 280.0f, 0.0f);
    m_pBackground->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackground);
#else
    m_pBackButton = new RenderObject();
    m_pBackButton->Init(MeshManager::Instance().GetBoardMesh(23, 74, 510, 487, 1, 75,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pBackButton->GetTransform(), MAT_ToRadians(90.0f));
    m_pBackButton->SetPosition(0.0f, IPHONE_SCREEN_HEIGHT - 163.0f, 0.0f);
    m_pBackButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackButton);

    m_pMenuBar = new RenderObject();
    m_pMenuBar->Init(MeshManager::Instance().GetBoardMesh(27, 236, 512, 485, 329, 93,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pMenuBar->GetTransform(), MAT_ToRadians(90.0f));
    m_pMenuBar->SetPosition(0.0f, 115.0f, 0.0f);
    m_pMenuBar->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pMenuBar);

    m_pTopButton = new RenderObject();
    m_pTopButton->Init(MeshManager::Instance().GetBoardMesh(23, 74, 487, 510, 1, 75,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight()), pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    MatrixRotationZ(m_pTopButton->GetTransform(), MAT_ToRadians(-90.0f));
    m_pTopButton->SetPosition(IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH - 26.0f, 0.0f);
    m_pTopButton->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pTopButton);


    m_pTopGlow = new RenderObject();
    m_pTopGlow->Init(MeshManager::Instance().GetBoardMesh(2, 184, 70, 70,
            pTexScores->GetWidth(), pTexScores->GetHeight()), pTexScores, RENDER_OBJECT_ADDITIVE);

    m_pTopGlow->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pTopGlow);


    m_pBackground = new RenderObject();
    m_pBackground->Init(MeshManager::Instance().GetBoardMesh(0, 0, 480, 182,
            pTexScores->GetWidth(), pTexScores->GetHeight()), pTexScores, RENDER_OBJECT_TRANSPARENT);
    m_pBackground->SetPosition(0.0f, 110.0f, 0.0f);
    m_pBackground->UseColor(true);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pBackground);

#endif

    m_pInputCallbackBack = new InputCallback<SubMenuHighScoresState > (this, &SubMenuHighScoresState::InputCallbackBack);
    m_pInputCallbackTop = new InputCallback<SubMenuHighScoresState > (this, &SubMenuHighScoresState::InputCallbackTop);
    m_pUICallbackList = new UICallback<SubMenuHighScoresState > (this, &SubMenuHighScoresState::UICallbackList);
    m_pUICallbackWeb = new UICallback<SubMenuHighScoresState > (this, &SubMenuHighScoresState::UICallbackWeb);

    m_pMenuOpacityInterpolator = new LinearInterpolator(&m_fMenuOpacity, 0.0f, 1.0f, 0.3f);

    m_pMenuOpacityInterpolator->Pause();

    Log("+++ SubMenuHighScoresState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {
        Log("+++ SubMenSubMenuHighScoresStateuOptionsState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);
        SafeDelete(m_pInputCallbackTop);
        SafeDelete(m_pUICallbackList);
        SafeDelete(m_pUICallbackWeb);

        SafeDelete(m_pRenderableMidLayer2D);
        SafeDelete(m_pBackground);
        SafeDelete(m_pBackButton);
        SafeDelete(m_pMenuBar);
        SafeDelete(m_pTopButton);
        SafeDelete(m_pTopGlow);

        SafeDelete(m_pMenuOpacityInterpolator);

        InputManager::Instance().ClearRegionEvents();

        m_bNeedCleanup = false;

        Log("+++ SubMenuHighScoresState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::ResetInterpolators(void)
{
    m_pMenuOpacityInterpolator->Continue();
    m_pMenuOpacityInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pMenuOpacityInterpolator, false);
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::UpdateLoading(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        m_CurrentState = SUB_MENU_IDLE;
    }
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::UpdateClosing(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        MenuGameState::Instance().SetSubMenu(m_pChangingToMenu);
    }
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::Update(void)
{
    m_GlowTimer.Update();

    Renderer::Instance().Add(m_pRenderableMidLayer2D);

    float menuOpacity = (m_CurrentState == SUB_MENU_CLOSING) ? (1.0f - m_fMenuOpacity) : m_fMenuOpacity;

    COLOR cFont = {0.99f, 0.46f, 0.28f, menuOpacity};

    if (m_bWebReceived)
    {
        if (strcmp(m_szScores, "") == 0)
        {
#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFont->Add("Check your Internet connection", 20.0f, 200.0f, 0.0f, cFont);
#else
            m_pTextFont->Add("Check your Internet connection", 10.0f, 86.0f, 0.0f, cFont);
#endif

        }
        else
        {

#ifdef GEARDOME_PLATFORM_IPAD
            m_pTextFont->Add("Hall Of Fame", 20.0f, 200.0f, 0.0f, cFont);
#else
            m_pTextFont->Add("Hall Of Fame", 10.0f, 86.0f, 0.0f, cFont);
#endif

            COLOR cFontText = {1.0f, 1.0f, 1.0f, menuOpacity};

            char* text = m_szScores;

            char * tok = strchr(text, '\n');

            float offsetY = 0.0f;
            int row = 0;

#ifdef GEARDOME_PLATFORM_IPAD

            while (tok != NULL && row < 10)
            {
                char line_buffer[50];

                strncpy(line_buffer, text, tok - text);
                line_buffer[tok - text] = 0;

                char* line = line_buffer;

                char * pch = strchr(line_buffer, '%');

                int token = 0;
                while (pch != NULL)
                {
                    char word[50];
                    strncpy(word, line, pch - line);
                    word[pch - line] = 0;

                    if (token == 1)
                    {
                        m_pTextFont->Add(word, 325.0f, 313.0f + offsetY, 0.0f, cFontText, true);
                    }
                    else if (token == 0)
                    {
                        m_pTextFont->Add(word, 567.0f, 313.0f + offsetY, 0.0f, cFontText, true);
                    }
                    else
                    {
                        if (strcmp(word, "6") == 0)
                        {
                            strcpy(word, "Tutorial");
                        }
                        else if (strcmp(word, "24") == 0)
                        {
                            strcpy(word, "Earth");
                        }
                        else if (strcmp(word, "36") == 0)
                        {
                            strcpy(word, "Vulcan");
                        }
                        else if (strcmp(word, "48") == 0)
                        {
                            strcpy(word, "Ocean");
                        }
                        else if (strcmp(word, "60") == 0)
                        {
                            strcpy(word, "Space");
                        }
                        else
                        {
                            strcpy(word, "Tutorial");
                        }

                        m_pTextFont->Add(word, 835.0f, 313.0f + offsetY, 0.0f, cFontText, true);
                    }

                    line = pch + 1;
                    pch = strchr(pch + 1, '%');
                    token++;
                }

                text = tok + 1;
                tok = strchr(tok + 1, '\n');

                offsetY += 32.0f;
                row++;
            }
#else
            while (tok != NULL && row < 10)
            {
                char line_buffer[50];

                strncpy(line_buffer, text, tok - text);
                line_buffer[tok - text] = 0;

                char* line = line_buffer;

                char * pch = strchr(line_buffer, '%');

                int token = 0;
                while (pch != NULL)
                {
                    char word[50];
                    strncpy(word, line, pch - line);
                    word[pch - line] = 0;

                    if (token == 1)
                    {
                        m_pTextFont->Add(word, 150.0f, 125.0f + offsetY, 0.0f, cFontText, true);
                    }
                    else if (token == 0)
                    {
                        m_pTextFont->Add(word, 267.0f, 125.0f + offsetY, 0.0f, cFontText, true);
                    }
                    else
                    {
                        if (strcmp(word, "6") == 0)
                        {
                            strcpy(word, "Tutorial");
                        }
                        else if (strcmp(word, "24") == 0)
                        {
                            strcpy(word, "Earth");
                        }
                        else if (strcmp(word, "36") == 0)
                        {
                            strcpy(word, "Vulcan");
                        }
                        else if (strcmp(word, "48") == 0)
                        {
                            strcpy(word, "Ocean");
                        }
                        else if (strcmp(word, "60") == 0)
                        {
                            strcpy(word, "Space");
                        }
                        else
                        {
                            strcpy(word, "Tutorial");
                        }

                        m_pTextFont->Add(word, 393.0f, 125.0f + offsetY, 0.0f, cFontText, true);
                    }

                    line = pch + 1;
                    pch = strchr(pch + 1, '%');
                    token++;
                }

                text = tok + 1;
                tok = strchr(tok + 1, '\n');

                offsetY += 15.0f;
                row++;
            }
#endif
        }
    }
    else
    {

#ifdef GEARDOME_PLATFORM_IPAD
        m_pTextFont->Add("Connecting to server...", 20.0f, 200.0f, 0.0f, cFont);
#else
        m_pTextFont->Add("Connecting to server...", 10.0f, 86.0f, 0.0f, cFont);
#endif
    }


    m_pBackButton->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pBackground->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pTopButton->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pMenuBar->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    m_pTopButton->Activate(m_bWebReceived && (strcmp(m_szScores, "") != 0));

    m_fGlowRotation += MAT_NormalizarAngulo360(m_GlowTimer.GetDeltaTime() * 18.0f);

#ifdef GEARDOME_PLATFORM_IPAD
    MATRIX rot, tr1, tr2;
    MatrixTranslation(tr1, -59.0f, -59.0f, 5.0f);
    MatrixTranslation(tr2, 59.0f - 0.0f, 59.0f + 280.0f, 0.0f);
    MatrixRotationZ(rot, MAT_ToRadians(m_fGlowRotation));
    MatrixMultiply(m_pTopGlow->GetTransform(), tr1, rot);
    MatrixMultiply(m_pTopGlow->GetTransform(), m_pTopGlow->GetTransform(), tr2);
    m_pTopGlow->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
#else
    MATRIX rot, tr1, tr2;
    MatrixTranslation(tr1, -35.0f, -35.0f, 5.0f);
    MatrixTranslation(tr2, 35.0f - 5.0f, 35.0f + 105.0f, 0.0f);
    MatrixRotationZ(rot, MAT_ToRadians(m_fGlowRotation));
    MatrixMultiply(m_pTopGlow->GetTransform(), tr1, rot);
    MatrixMultiply(m_pTopGlow->GetTransform(), m_pTopGlow->GetTransform(), tr2);
    m_pTopGlow->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
#endif


    COLOR cFontBack = {1.0f, 1.0f, 1.0f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("BACK", 40.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBack);
#else
    m_pTextFont->Add("BACK", 20.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBack);
#endif



    if (m_bWebReceived && (strcmp(m_szScores, "") != 0))
    {
#ifdef GEARDOME_PLATFORM_IPAD
        m_pTextFont->Add("Top 100", IPHONE_SCREEN_HEIGHT - 175.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBack);
#else
        m_pTextFont->Add("Top 100", IPHONE_SCREEN_HEIGHT - 85.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBack);
#endif
    }
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::InputCallbackBack(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bShowingList)
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_BACK));

        Log("--------- input BACK\n");
        m_CurrentState = SUB_MENU_CLOSING;
        ResetInterpolators();
        m_fMenuOpacity = 0.0f;
        m_pChangingToMenu = &SubMenuMainState::Instance();
    }
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::InputCallbackTop(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bShowingList && m_bWebReceived && (strcmp(m_szScores, "") != 0))
    {
        AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_SELECTION));

        Log("--------- input TOP\n");

        m_bShowingList = true;

        UIManager::Instance().RaiseEvent(UI_EVENT_SHOWSCORESLIST, m_pUICallbackList);
    }
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::UICallbackList(int button, const char* text)
{
    m_bShowingList = false;
}

//////////////////////////
//////////////////////////

void SubMenuHighScoresState::UICallbackWeb(int button, const char* text)
{
    strncpy(m_szScores, text, 9998);
    m_bWebReceived = true;
}

