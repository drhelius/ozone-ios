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
 * File:   submenuepisodeselectionstate.cpp
 * Author: nacho
 * 
 * Created on 8 de septiembre de 2009, 0:40
 */

#include "submenuepisodeselectionstate.h"
#include "menugamestate.h"
#include "submenumainstate.h"
#include "meshmanager.h"
#include "texturemanager.h"
#include "SubMenuLevelSelectionState.h"
#include "SubMenuSaveSelectionState.h"
#include "parsermanager.h"
#include "audio.h"
#include "SaveManager.h"
#include "gamemanager.h"

//////////////////////////
//////////////////////////

SubMenuEpisodeSelectionState::SubMenuEpisodeSelectionState(void) : SubMenuState()
{
    Log("+++ SubMenuEpisodeSelectionState::SubMenuEpisodeSelectionState ...\n");

    InitPointer(m_pTextFont);
    InitPointer(m_pInputCallbackBack);
    InitPointer(m_pInputCallbackArrowLeft);
    InitPointer(m_pInputCallbackArrowRight);
    InitPointer(m_pInputCallbackAnySlot);

    InitPointer(m_pUICallbackScore);
    InitPointer(m_pUICallbackItunes);

    InitPointer(m_pRenderableMidLayer2D);
    InitPointer(m_pBackButton);
    InitPointer(m_pMenuBar);

    InitPointer(m_pLeftArrow[0]);
    InitPointer(m_pLeftArrow[1]);
    InitPointer(m_pRightArrow[0]);
    InitPointer(m_pRightArrow[1]);

    for (int i = 0; i < MAX_EPISODE_SLOTS; i++)
    {

        m_EpisodeSlots[i].enabled = false;
        m_EpisodeSlots[i].completed = false;
        m_EpisodeSlots[i].locked = true;
        InitPointer(m_EpisodeSlots[i].pFrameRO);
        InitPointer(m_EpisodeSlots[i].pLockRO);
    }

    InitPointer(m_pMenuOpacityInterpolator);
    InitPointer(m_pArrowsSineInterpolator);
    InitPointer(m_pMovementInterpolator);
    InitPointer(m_pMenuOpacityInterpolator);
    InitPointer(m_pUnlockInterpolator);

    m_bSendingScore = false;
    m_bNeedCleanup = false;
    m_fMenuOpacity = 0.0f;
    m_fMovementOffset = 0.0f;
    m_fSelectionOpacity = 1.0f;
    m_iSelection = -1;
    m_iUnlockEpisode = -1;
    m_fUnlockAlpha = 0.0f;
    m_bWantToClose = false;
    m_bUnlockEpisode = false;

    Log("+++ SubMenuEpisodeSelectionState::SubMenuEpisodeSelectionState correcto\n");
}

//////////////////////////
//////////////////////////

SubMenuEpisodeSelectionState::~SubMenuEpisodeSelectionState(void)
{
    Log("+++ SubMenuEpisodeSelectionState::~SubMenuEpisodeSelectionState ...\n");

    Cleanup();

    Log("+++ SubMenuEpisodeSelectionState::~SubMenuEpisodeSelectionState destruido\n");
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::Reset(void)
{
    Log("+++ SubMenuEpisodeSelectionState::Reset ...\n");

    InputManager::Instance().ClearRegionEvents();

    m_bFinishing = false;
    m_CurrentState = SUB_MENU_LOADING;
    m_fMenuOpacity = 0.0f;
    m_fArrowSineOffset = 0.0f;
    m_pChangingToMenu = NULL;
    m_bWantToClose = false;
    m_fSelectionOpacity = 1.0f;
    m_iSelection = -1;

    if (m_bUnlockEpisode)
    {
        m_iCurrentPage = MAT_Clamp(m_iUnlockEpisode - 1, 0, m_iActiveSlots - 3);
#ifdef GEARDOME_PLATFORM_IPAD
        m_fMovementOffset = (m_iCurrentPage * 300.0f);
#else
        m_fMovementOffset = (m_iCurrentPage * 136.0f);
#endif
    }
    else
    {
        m_iCurrentPage = 0;
        m_fMovementOffset = 0.0f;
    }

#ifdef GEARDOME_PLATFORM_IPAD
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 70.0f, 200.0f, 70.0f, m_pInputCallbackBack);

    InputManager::Instance().AddRectRegionEvent(0.0f, 380.0f, 72.0f, 98.0f, m_pInputCallbackArrowLeft);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 72.0f, 380.0f, 72.0f, 98.0f, m_pInputCallbackArrowRight);

    for (int i = 0; i < 3; i++)
    {
        InputManager::Instance().AddRectRegionEvent(76.0f + (300.0f * i), 330.0f, 256, 256, m_pInputCallbackAnySlot, i);
    }
#else
    InputManager::Instance().AddRectRegionEvent(0.0f, IPHONE_SCREEN_WIDTH - 35.0f, 100.0f, 35.0f, m_pInputCallbackBack);

    InputManager::Instance().AddRectRegionEvent(0.0f, 140.0f, 36.0f, 63.0f, m_pInputCallbackArrowLeft);
    InputManager::Instance().AddRectRegionEvent(IPHONE_SCREEN_HEIGHT - 36.0f, 140.0f, 36.0f, 63.0f, m_pInputCallbackArrowRight);

    for (int i = 0; i < 3; i++)
    {
        InputManager::Instance().AddRectRegionEvent(38.0f + (136.0f * i), 135.0f, 128, 128, m_pInputCallbackAnySlot, i);
    }
#endif

    ResetInterpolators();

    Log("+++ SubMenuEpisodeSelectionState::Reset correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::ResetInterpolators(void)
{
    m_pMenuOpacityInterpolator->Continue();
    m_pMenuOpacityInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pMenuOpacityInterpolator, false);
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::Init(TextFont* pTextFont, Fader* pFader)
{
    Log("+++ SubMenuEpisodeSelectionState::Init ...\n");

    m_bNeedCleanup = true;
    m_pTextFont = pTextFont;
    m_pFader = pFader;

    std::vector<stEPISODE_CONFIG_FILE> episodeVector;

    ParserManager::Instance().GetEpisodeConfigData(&episodeVector, "menu/episodes");

    for (std::vector<stEPISODE_CONFIG_FILE>::size_type i = 0; i < episodeVector.size(); i++)
    {
        m_EpisodeSlots[i].enabled = true;
        Episode* tmp = new Episode();
        tmp->Init(episodeVector[i]);
        m_EpisodeVector.push_back(tmp);
    }

    m_iActiveSlots = episodeVector.size();

    m_pRenderableMidLayer2D = new Renderable();
    m_pRenderableMidLayer2D->Set3D(false);
    m_pRenderableMidLayer2D->SetLayer(600);

    Texture* pTexMenu01 = TextureManager::Instance().GetTexture("menu/gfx/menu_01");
    Texture* pTexLocked = TextureManager::Instance().GetTexture("menu/gfx/episode_locked");

#ifdef GEARDOME_PLATFORM_IPAD

    Mesh* pMeshSlot = MeshManager::Instance().GetBoardMesh(256, 256);

    Mesh* pUpArrow = MeshManager::Instance().GetBoardMesh(917, 926, 52, 98,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrow = MeshManager::Instance().GetBoardMesh(971, 926, 52, 98,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pUpArrowLeft = MeshManager::Instance().GetBoardMesh(52, 98, 969, 917, 926, 1024,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrowLeft = MeshManager::Instance().GetBoardMesh(52, 98, 1023, 971, 926, 1024,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
#else

    Mesh* pMeshSlot = MeshManager::Instance().GetBoardMesh(128, 128);

    Mesh* pUpArrow = MeshManager::Instance().GetBoardMesh(157, 458, 29, 51,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrow = MeshManager::Instance().GetBoardMesh(127, 458, 29, 51,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pUpArrowLeft = MeshManager::Instance().GetBoardMesh(29, 51, 186, 157, 509, 458,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
    Mesh* pDownArrowLeft = MeshManager::Instance().GetBoardMesh(29, 51, 156, 127, 509, 458,
            pTexMenu01->GetWidth(), pTexMenu01->GetHeight());
#endif

    for (int i = 0; i < MAX_EPISODE_SLOTS; i++)
    {
        if (m_EpisodeSlots[i].enabled)
        {
            char textureSlot[128];

            sprintf(textureSlot, "%s/menu/episode_icon", m_EpisodeVector[i]->GetFolder().c_str());

            m_EpisodeSlots[i].pFrameRO = new RenderObject();
            m_EpisodeSlots[i].pFrameRO->Init(pMeshSlot, TextureManager::Instance().GetTexture(textureSlot), RENDER_OBJECT_TRANSPARENT);
            m_EpisodeSlots[i].pFrameRO->UseColor(true);
            m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_EpisodeSlots[i].pFrameRO);

            m_EpisodeSlots[i].pLockRO = new RenderObject();
            m_EpisodeSlots[i].pLockRO->Init(pMeshSlot, pTexLocked, RENDER_OBJECT_TRANSPARENT);
            m_EpisodeSlots[i].pLockRO->UseColor(true);
            m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_EpisodeSlots[i].pLockRO);
        }
    }

    m_pLeftArrow[0] = new RenderObject();
    m_pLeftArrow[1] = new RenderObject();
    m_pRightArrow[0] = new RenderObject();
    m_pRightArrow[1] = new RenderObject();

    m_pLeftArrow[0]->Init(pDownArrowLeft, pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pLeftArrow[0]->SetPosition(0.0f, 146.0f, 0.0f);
    m_pLeftArrow[0]->UseColor(true);
    m_pLeftArrow[1]->Init(pUpArrowLeft, pTexMenu01, RENDER_OBJECT_ADDITIVE);
    m_pLeftArrow[1]->SetPosition(0.0f, 146.0f, 2.0f);
    m_pLeftArrow[1]->UseColor(true);
    m_pLeftArrow[1]->Activate(false);

    m_pRightArrow[0]->Init(pDownArrow, pTexMenu01, RENDER_OBJECT_TRANSPARENT);
    m_pRightArrow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 29.0f, 146.0f, 0.0f);
    m_pRightArrow[0]->UseColor(true);
    m_pRightArrow[1]->Init(pUpArrow, pTexMenu01, RENDER_OBJECT_ADDITIVE);
    m_pRightArrow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 29.0f, 146.0f, 2.0f);
    m_pRightArrow[1]->UseColor(true);
    m_pRightArrow[1]->Activate(false);

    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pLeftArrow[0]);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pLeftArrow[1]);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pRightArrow[0]);
    m_pRenderableMidLayer2D->GetRenderObjectList().push_back(m_pRightArrow[1]);

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
#endif
    m_pInputCallbackBack = new InputCallback<SubMenuEpisodeSelectionState > (this, &SubMenuEpisodeSelectionState::InputCallbackBack);
    m_pInputCallbackArrowLeft = new InputCallback<SubMenuEpisodeSelectionState > (this, &SubMenuEpisodeSelectionState::InputCallbackArrowLeft);
    m_pInputCallbackArrowRight = new InputCallback<SubMenuEpisodeSelectionState > (this, &SubMenuEpisodeSelectionState::InputCallbackArrowRight);
    m_pInputCallbackAnySlot = new InputCallback<SubMenuEpisodeSelectionState > (this, &SubMenuEpisodeSelectionState::InputCallbackAnySlot);

    m_pUICallbackScore = new UICallback<SubMenuEpisodeSelectionState > (this, &SubMenuEpisodeSelectionState::UICallbackScore);
    m_pUICallbackItunes = new UICallback<SubMenuEpisodeSelectionState > (this, &SubMenuEpisodeSelectionState::UICallbackItunes);

    m_pMenuOpacityInterpolator = new LinearInterpolator(&m_fMenuOpacity, 0.0f, 1.0f, 0.3f);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pMovementInterpolator = new EaseInterpolator(&m_fMovementOffset, 0.0f, 300.0f, 2.0f, 0.5f, true);
    m_pArrowsSineInterpolator = new SineInterpolator(&m_fArrowSineOffset, 0.0f, 7.0f, 3.0f);
#else
    m_pMovementInterpolator = new EaseInterpolator(&m_fMovementOffset, 0.0f, 136.0f, 2.0f, 0.5f, true);
    m_pArrowsSineInterpolator = new SineInterpolator(&m_fArrowSineOffset, 0.0f, 7.0f, 2.0f);
#endif

    m_pSelectionInterpolator = new CosineInterpolator(&m_fSelectionOpacity, 1.0f, 0.0f, 0.25f, true, 0.5f);
    m_pUnlockInterpolator = new SquareInterpolator(&m_fUnlockAlpha, 0.0f, 1.0f, 0.5f, false, 2.5f);

    m_pMenuOpacityInterpolator->Pause();

    m_pArrowsSineInterpolator->Reset();

    InterpolatorManager::Instance().Add(m_pArrowsSineInterpolator, false);

    Log("+++ SubMenuEpisodeSelectionState::Init correcto\n");
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::Cleanup(void)
{
    if (m_bNeedCleanup)
    {

        Log("+++ SubMenuEpisodeSelectionState::Cleanup ...\n");

        InitPointer(m_pTextFont);

        SafeDelete(m_pInputCallbackBack);
        SafeDelete(m_pInputCallbackArrowLeft);
        SafeDelete(m_pInputCallbackArrowRight);
        SafeDelete(m_pInputCallbackAnySlot);

        SafeDelete(m_pUICallbackScore);
        SafeDelete(m_pUICallbackItunes);

        SafeDelete(m_pRenderableMidLayer2D);

        SafeDelete(m_pLeftArrow[0]);
        SafeDelete(m_pLeftArrow[1]);
        SafeDelete(m_pRightArrow[0]);
        SafeDelete(m_pRightArrow[1]);

        for (int i = 0; i < MAX_EPISODE_SLOTS; i++)
        {

            SafeDelete(m_EpisodeSlots[i].pFrameRO);
            SafeDelete(m_EpisodeSlots[i].pLockRO);
        }

        for (std::vector<Episode*>::size_type i = 0; i < m_EpisodeVector.size(); i++)
        {
            SafeDelete(m_EpisodeVector[i]);
        }

        m_EpisodeVector.clear();

        SafeDelete(m_pBackButton);
        SafeDelete(m_pMenuBar);

        SafeDelete(m_pMenuOpacityInterpolator);
        SafeDelete(m_pArrowsSineInterpolator);
        SafeDelete(m_pMovementInterpolator);
        SafeDelete(m_pSelectionInterpolator);
        SafeDelete(m_pUnlockInterpolator);

        InputManager::Instance().ClearRegionEvents();

        m_bNeedCleanup = false;

        Log("+++ SubMenuEpisodeSelectionState::Cleanup correcto\n");
    }
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::UpdateLoading(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        m_CurrentState = SUB_MENU_IDLE;
    }
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::UpdateClosing(void)
{
    Update();

    if (m_fMenuOpacity >= 1.0f)
    {
        MenuGameState::Instance().SetSubMenu(m_pChangingToMenu);
    }
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::Update(void)
{
    Renderer::Instance().Add(m_pRenderableMidLayer2D);

    float menuOpacity = (m_CurrentState == SUB_MENU_CLOSING) ? (1.0f - m_fMenuOpacity) : m_fMenuOpacity;

    COLOR cFont = {0.99f, 0.46f, 0.28f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("Select Episode", 20.0f, 200.0f, 0.0f, cFont);
#else
    m_pTextFont->Add("Select Episode", 10.0f, 86.0f, 0.0f, cFont);
#endif

    m_pMenuBar->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    for (int i = 0; i < MAX_EPISODE_SLOTS; i++)
    {
        if (m_EpisodeSlots[i].enabled)
        {
            bool isUnlocked = true;

            if (i > 0)
            {
                for (int level = 0; level < ((i == 1) ? 6 : MAX_LEVELS_PER_EPISODE); level++)
                {
                    ///--- se comprueba si estan acabados todos los anteriores
                    if (!SaveManager::Instance().IsLevelCompleted(i - 1, level))
                    {
                        isUnlocked = false;
                        break;
                    }
                }
            }

            if (GameManager::Instance().GetCheatPlayAllLevels())
            {
                isUnlocked = true;
            }

#ifdef GEARDOME_PLATFORM_IPAD
            float posX = (-m_fMovementOffset) + 81.0f + (300.0f * i);

            float opacity = 1.0f;

            if (posX > 880.0f)
            {
                opacity = 1.0f - MAT_Clampf((posX - 880.0f) / 110.0f, 0.0f, 1.0f);
            }
            else if (posX < 76.0f)
            {
                opacity = 1.0f - MAT_Clampf((76.0f - posX) / 400.0f, 0.0f, 1.0f);
            }
#else
            float posX = (-m_fMovementOffset) + 38.0f + (136.0f * i);


            float opacity = 1.0f;

            if (posX > 408.0f)
            {
                opacity = 1.0f - MAT_Clampf((posX - 408.0f) / 42.0f, 0.0f, 1.0f);
            }
            else if (posX < 38.0f)
            {
                opacity = 1.0f - MAT_Clampf((38.0f - posX) / 150.0f, 0.0f, 1.0f);
            }
#endif

            if (m_iSelection == i)
            {
                opacity = MAT_Min(opacity, m_fSelectionOpacity);
            }

            if (m_CurrentState != SUB_MENU_IDLE)
            {
                opacity = MAT_Min(menuOpacity, opacity);
            }

            COLOR cFontName = {1.0f, 1.0f, 1.0f, opacity};

            bool unlocking = false;

#ifdef OZONE_PRE_RELEASE
            if (i > 2)
            {
                cFontName.a = 0.50f;
                m_EpisodeSlots[i].pLockRO->Activate(true);
                m_EpisodeSlots[i].pFrameRO->Activate(false);
            }
            else
            {
                m_EpisodeSlots[i].pLockRO->Activate(false);
                m_EpisodeSlots[i].pFrameRO->Activate(true);
            }
#else
            m_EpisodeSlots[i].pLockRO->Activate(!isUnlocked);
            m_EpisodeSlots[i].pFrameRO->Activate(isUnlocked);

            if (!isUnlocked)
            {
                cFontName.a = MAT_Min(opacity, 0.50f);
            }

            if ((m_CurrentState == SUB_MENU_IDLE) && (m_iUnlockEpisode == i))
            {
                if (!m_bUnlockEpisode && !m_pUnlockInterpolator->IsActive() && m_bSendingScore)
                {
                    m_bSendingScore = false;
                    UIManager::Instance().RaiseEvent(UI_EVENT_ASKSENDSCORE, m_pUICallbackScore);
                }

                if (m_bUnlockEpisode)
                {
                    m_bUnlockEpisode = false;
                    InterpolatorManager::Instance().Add(m_pUnlockInterpolator, false);
                    AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_EPISODE_UNLOCK));
                }

                if (m_pUnlockInterpolator->IsActive())
                {
                    unlocking = true;
                    m_EpisodeSlots[i].pLockRO->Activate(true);
                    m_EpisodeSlots[i].pFrameRO->Activate(m_fUnlockAlpha == 0.0f);
                }
            }
            else if (m_bUnlockEpisode && (m_CurrentState == SUB_MENU_LOADING) && (m_iUnlockEpisode == i))
            {
                m_EpisodeSlots[i].pLockRO->Activate(true);
                m_EpisodeSlots[i].pFrameRO->Activate(false);
            }
#endif

#ifdef GEARDOME_PLATFORM_IPAD
            m_EpisodeSlots[i].pFrameRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_EpisodeSlots[i].pLockRO->SetColor(1.0f, 1.0f, 1.0f, (unlocking) ? m_fUnlockAlpha : opacity);

            m_EpisodeSlots[i].pFrameRO->SetPosition(posX, 330.0f, 0.0f);
            m_EpisodeSlots[i].pLockRO->SetPosition(posX, 330.0f, 2.0f);

            m_pTextFont->Add(m_EpisodeVector[i]->GetName().c_str(), posX + 128.0f, 570.0f, 0.0f, cFontName, true);
#else
            m_EpisodeSlots[i].pFrameRO->SetColor(1.0f, 1.0f, 1.0f, opacity);
            m_EpisodeSlots[i].pLockRO->SetColor(1.0f, 1.0f, 1.0f, (unlocking) ? m_fUnlockAlpha : opacity);

            m_EpisodeSlots[i].pFrameRO->SetPosition(posX, 135.0f, 0.0f);
            m_EpisodeSlots[i].pLockRO->SetPosition(posX, 135.0f, 2.0f);

            m_pTextFont->Add(m_EpisodeVector[i]->GetName().c_str(), posX + 64.0f, 255.0f, 0.0f, cFontName, true);
#endif
        }
    }

    if (m_iCurrentPage == 0)
    {
        m_pLeftArrow[0]->Activate(false);
        m_pLeftArrow[1]->Activate(false);
    }
    else
    {
        m_pLeftArrow[0]->Activate(true);
    }

    if (m_iCurrentPage == (m_iActiveSlots - 3))
    {
        m_pRightArrow[0]->Activate(false);
        m_pRightArrow[1]->Activate(false);
    }
    else
    {
        m_pRightArrow[0]->Activate(true);
    }

    m_pLeftArrow[0]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pLeftArrow[1]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pRightArrow[0]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);
    m_pRightArrow[1]->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

#ifdef GEARDOME_PLATFORM_IPAD
    m_pLeftArrow[0]->SetPosition(4.0f + (m_fArrowSineOffset * 4.0f), 380.0f, 0.0f);
    m_pLeftArrow[1]->SetPosition(4.0f + (m_fArrowSineOffset * 4.0f), 380.0f, 2.0f);
    m_pRightArrow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 62.0f - (m_fArrowSineOffset * 4.0f), 380.0f, 0.0f);
    m_pRightArrow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 62.0f - (m_fArrowSineOffset * 4.0f), 380.0f, 2.0f);
#else
    m_pLeftArrow[0]->SetPosition(2.0f + m_fArrowSineOffset, 146.0f, 0.0f);
    m_pLeftArrow[1]->SetPosition(2.0f + m_fArrowSineOffset, 146.0f, 2.0f);
    m_pRightArrow[0]->SetPosition(IPHONE_SCREEN_HEIGHT - 31.0f - m_fArrowSineOffset, 146.0f, 0.0f);
    m_pRightArrow[1]->SetPosition(IPHONE_SCREEN_HEIGHT - 31.0f - m_fArrowSineOffset, 146.0f, 2.0f);
#endif

    m_pBackButton->SetColor(1.0f, 1.0f, 1.0f, menuOpacity);

    COLOR cFontBack = {1.0f, 1.0f, 1.0f, menuOpacity};

#ifdef GEARDOME_PLATFORM_IPAD
    m_pTextFont->Add("BACK", 40.0f, IPHONE_SCREEN_WIDTH - 68.0f, 0.0f, cFontBack);
#else
    m_pTextFont->Add("BACK", 20.0f, IPHONE_SCREEN_WIDTH - 32.0f, 0.0f, cFontBack);
#endif

    if (m_bWantToClose && m_pSelectionInterpolator->IsFinished())
    {
        m_bWantToClose = false;
        m_CurrentState = SUB_MENU_CLOSING;
        ResetInterpolators();
        m_fMenuOpacity = 0.0f;
        m_pChangingToMenu = &SubMenuLevelSelectionState::Instance();
    }
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::InputCallbackBack(stInputCallbackParameter parameter, int id)
{
    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bWantToClose)
    {
        if (!m_bSendingScore && !m_bUnlockEpisode && !m_pUnlockInterpolator->IsActive())
        {
            AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_BACK));

            Log("--------- input BACK\n");
            m_CurrentState = SUB_MENU_CLOSING;
            ResetInterpolators();
            m_fMenuOpacity = 0.0f;
            m_pChangingToMenu = &SubMenuMainState::Instance();
        }
    }
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::InputCallbackArrowLeft(stInputCallbackParameter parameter, int id)
{
    if (!m_pLeftArrow[1]->IsActive() && parameter.type == PRESS_START && m_iCurrentPage != 0 && !m_bWantToClose)
    {
        if (!m_bSendingScore && !m_bUnlockEpisode && !m_pUnlockInterpolator->IsActive())
        {
            m_pLeftArrow[1]->Activate(true);

            m_iCurrentPage--;

            if (m_iCurrentPage < 0)
                m_iCurrentPage = 0;

#ifdef GEARDOME_PLATFORM_IPAD
            if (m_pMovementInterpolator->IsActive())
            {
                m_pMovementInterpolator->Redefine(m_iCurrentPage * 300.0f, m_fMovementOffset, 2.0f, 0.5f, true);
            }
            else
            {
                m_pMovementInterpolator->Reset();
                m_pMovementInterpolator->Redefine(m_iCurrentPage * 300.0f, m_fMovementOffset, 2.0f, 0.5f, true);
                InterpolatorManager::Instance().Add(m_pMovementInterpolator, false);
            }
#else
            if (m_pMovementInterpolator->IsActive())
            {
                m_pMovementInterpolator->Redefine(m_iCurrentPage * 136.0f, m_fMovementOffset, 2.0f, 0.5f, true);
            }
            else
            {
                m_pMovementInterpolator->Reset();
                m_pMovementInterpolator->Redefine(m_iCurrentPage * 136.0f, m_fMovementOffset, 2.0f, 0.5f, true);
                InterpolatorManager::Instance().Add(m_pMovementInterpolator, false);
            }
#endif
        }
    }
    else if (parameter.type == PRESS_END)
    {
        m_pLeftArrow[1]->Activate(false);
    }
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::InputCallbackArrowRight(stInputCallbackParameter parameter, int id)
{
    int maxPage = m_iActiveSlots - 3;

    if (!m_pRightArrow[1]->IsActive() && parameter.type == PRESS_START && (m_iCurrentPage < maxPage) && !m_bWantToClose)
    {
        if (!m_bSendingScore && !m_bUnlockEpisode && !m_pUnlockInterpolator->IsActive())
        {
            m_pRightArrow[1]->Activate(true);

            m_iCurrentPage++;

            if (m_iCurrentPage > maxPage)
                m_iCurrentPage = maxPage;

#ifdef GEARDOME_PLATFORM_IPAD
            if (m_pMovementInterpolator->IsActive())
            {
                m_pMovementInterpolator->Redefine(m_iCurrentPage * 300.0f, m_fMovementOffset, 2.0f, 0.5f, true);
            }
            else
            {
                m_pMovementInterpolator->Reset();
                m_pMovementInterpolator->Redefine(m_iCurrentPage * 300.0f, m_fMovementOffset, 2.0f, 0.5f, true);
                InterpolatorManager::Instance().Add(m_pMovementInterpolator, false);
            }
#else
            if (m_pMovementInterpolator->IsActive())
            {
                m_pMovementInterpolator->Redefine(m_iCurrentPage * 136.0f, m_fMovementOffset, 2.0f, 0.5f, true);
            }
            else
            {
                m_pMovementInterpolator->Reset();
                m_pMovementInterpolator->Redefine(m_iCurrentPage * 136.0f, m_fMovementOffset, 2.0f, 0.5f, true);
                InterpolatorManager::Instance().Add(m_pMovementInterpolator, false);
            }
#endif
        }
    }
    else if (parameter.type == PRESS_END)
    {
        m_pRightArrow[1]->Activate(false);
    }
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::InputCallbackAnySlot(stInputCallbackParameter parameter, int id)
{

#ifdef OZONE_PRE_RELEASE
    if ((id + m_iCurrentPage) > 2)
        return;
#endif

    if (m_CurrentState == SUB_MENU_IDLE && parameter.type == PRESS_START && !m_bWantToClose)
    {
        bool isUnlocked = true;

        int i = id + m_iCurrentPage;

        if (i > 0)
        {
            for (int level = 0; level < ((i == 1) ? 6 : MAX_LEVELS_PER_EPISODE); level++)
            {
                ///--- se comprueba si estan acabados todos los anteriores
                if (!SaveManager::Instance().IsLevelCompleted(i - 1, level))
                {
                    isUnlocked = false;
                    break;
                }
            }
        }

#ifdef OZONE_PRE_RELEASE
        isUnlocked = !((id + m_iCurrentPage) > 2);
#endif

        if (GameManager::Instance().GetCheatPlayAllLevels())
        {
            isUnlocked = true;
        }

        if (isUnlocked)
        {
            if (!m_bSendingScore && !m_bUnlockEpisode && !m_pUnlockInterpolator->IsActive())
            {
                AudioManager::Instance().PlayEffect(Audio::Instance().GetEffect(kSOUND_MENU_SELECTION));

                m_bWantToClose = true;

                m_pSelectionInterpolator->Reset();
                InterpolatorManager::Instance().Add(m_pSelectionInterpolator, false);

                m_iSelection = i;

                stCurrentEpisodeAndLevel state = MenuGameState::Instance().GetCurrentSelection();
                state.episode = m_iSelection;
                MenuGameState::Instance().SetCurrentSelection(state);

                SubMenuLevelSelectionState::Instance().PrepareEpisode(m_EpisodeVector[m_iSelection], m_iSelection);
            }
        }
#ifdef OZONE_LITE
        else
        {
            UIManager::Instance().RaiseEvent(UI_EVENT_ASKGOTOITUNES, m_pUICallbackItunes);
        }
#endif
    }
}

//////////////////////////
//////////////////////////

Episode * SubMenuEpisodeSelectionState::GetEpisode(int episode)
{
    return m_EpisodeVector[episode];
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::UICallbackScore(int button, const char* szName)
{
    m_bSendingScore = false;

    if (button == 1)
    {
        UIManager::Instance().RaiseEvent(UI_EVENT_DOSENDSCORE);
    }
    else
    {
        SaveManager::Instance().ClearForUpload();
    }
}

//////////////////////////
//////////////////////////

void SubMenuEpisodeSelectionState::UICallbackItunes(int button, const char* szName)
{
    if (button == 1)
    {
#ifdef GEARDOME_PLATFORM_IPAD
        [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://itunes.ozonehd.com"]];
#else
        [[UIApplication sharedApplication] openURL : [NSURL URLWithString : @"http://ozone.itunes.geardome.com"]];
#endif
    }
}