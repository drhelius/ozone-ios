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
 * File:   scene.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 21:00
 */

#pragma once
#ifndef _SCENE_H
#define	_SCENE_H

#include "textfont.h"
#include "timer.h"
#include "cube.h"
#include "decoration.h"
#include "camera.h"
#include "inputmanager.h"
#include <vector>
#include <set>
#include <list>
#include "sector.h"
#include "Bitset.h"
#include "player.h"
#include "physicsmanager.h"
#include "interpolatormanager.h"
#include "hud.h"
#include "backgrounds.h"
#include "InGameMenuMain.h"
#include "InGameMenuDie.h"
#include "InGameMenuEndLevel.h"
#include "InGameMenuText.h"
#include "SaveManager.h"
#include "menugamestate.h"

class Scene
{

    enum eObjectType
    {

        OBJ_TYPE_CUBE = 0,
        OBJ_TYPE_ITEM = 1,
        OBJ_TYPE_ENEMY = 2,
        OBJ_TYPE_TRANSPORTER = 3,
        OBJ_TYPE_DECO = 4
    };

    enum eCameraMovingFov
    {

        FOV_GOING_IN,
        FOV_GOING_OUT,
        FOV_IDLE_IN,
        FOV_IDLE_OUT
    };

    enum eInputButtons
    {

        INPUT_BUTTON_BRAKE,
        INPUT_BUTTON_DEFLATE,
        INPUT_BUTTON_FIRE,
        INPUT_BUTTON_MENU,
        INPUT_BUTTON_NUCLEAR,
        MAX_INPUT_BUTTON
    };

private:

    InGameMenuMain* m_pInGameMenuMain;
    InGameMenuDie* m_pInGameMenuDie;
    InGameMenuEndLevel* m_pInGameMenuEndLevel;
    InGameMenuText* m_pInGameMenuText;

    int m_iDynamicCountID;

    char m_szEpisode[30];

    int m_iBackground;

    Player* m_pPlayer;

    Timer* m_pGameTimer;
    Timer* m_pMenuTimer;
    Timer m_TimerCamera;

    Timer m_PlayTimer;

    float m_fCameraFov;
    eCameraMovingFov m_CameraMovingFov;
    SinusoidalInterpolator* m_pCameraFovInterpolator;

    bool m_bIsFinalBoss;

    float m_fDeltaTime;
    float m_fLastTimeDeflateUpdated;
    bool m_bNeedCleanup;

    TextFont* m_pTextFont;
    TextFont* m_pTextFontSmall;

    Bitset m_StaticRenderedBitset[3];
    Bitset m_DynamicRenderedBitset[3];

    typedef std::list<NPC*> TNPCList;
    typedef TNPCList::iterator TNPCListIterator;

    typedef std::vector<NPC*> TNPCVector;

    TNPCVector m_StaticNPCVector[3];
    TNPCVector m_DynamicNPCVector[3];
    TNPCVector m_RenderNPCVector[3];

    typedef std::vector<Sector*> TSectorVector;
    typedef TSectorVector::iterator TSectorVectorIterator;
    TSectorVector m_SectorVector[3];

    typedef std::set<stCollisionPair, cmp_stCollisionPair> TCollisionPairList;
    typedef TCollisionPairList::iterator TCollisionPairListIterator;

    TCollisionPairList m_CollisionPairCacheList;

    Camera* m_pCamera3D;
    Camera* m_pCamera2D;

    InputCallback<Scene>* m_pInputCallbackController;
    InputCallback<Scene>* m_pInputCallbackBrake;
    InputCallback<Scene>* m_pInputCallbackFire;
    InputCallback<Scene>* m_pInputCallbackNuclear;
    InputCallback<Scene>* m_pInputCallbackDeflate;
    InputCallback<Scene>* m_pInputCallbackMenu;

    InputCallback<Scene>* m_pInputCallbackMenuInGameContinue;
    InputCallback<Scene>* m_pInputCallbackMenuInGameMainMenu;
    InputCallback<Scene>* m_pInputCallbackMenuInGameReset;
    InputCallback<Scene>* m_pInputCallbackMenuInGameNextLevel;

    bool m_bInputButtonsState[MAX_INPUT_BUTTON];

    PhysicsCallback<Scene>* m_pPhysicsTickCallback;

    int m_iSectorCountX;
    int m_iSectorCountY;

    int m_iGemCount;

    int m_iCurrentTutorialPopUp;

    bool m_bIsReadyToFinish;
    bool m_bIsReadyToReset;
    bool m_bLevelCompleted;
    bool m_bIsCustomLevel;

    Hud* m_pHud;

    Backgrounds* m_pBackgrounds;

    Vec3 m_veclogControl;

    Vec3 m_vecExitPos;

    void GenerateStaticLevel(int sector, int sectorX, int sectorY);
    void LoadLevelLayer(int layer, FILE* pFile, std::vector<stCUBE_CONFIG_FILE>& cubeConfigVector, std::vector<stDECO_CONFIG_FILE>& decoConfigVector);
    void LoadBackground(const char* szStyle);

    void UpdatePhysics(void);
    void UpdateNPCs(void);
    void UpdateInput(void);
    void UpdateBackground(void);
    void UpdateHud(void);
    void UpdateCamera(void);
    void UpdateSectors(void);
    void UpdateTutorialPopUps(void);
    void SetupSectorsForRendering(int minX, int maxX, int minY, int maxY);
    void RenderSector(int layer, int sector);
    void ClearSectors(void);
    bool CheckVisiblePosition(float x, float y);
    void ClearRenderBitSets(void);
    void AddInputRegions(void);

public:

    Scene(Timer* pTimer, Timer* pMenuTimer);
    ~Scene();

    void Update(void);

    void Reset(void);

    void Init(void);

    void LoadFromFile(char* szPath, bool sCustomLevel);
    void LoadFromURL(char* szURL);

    void Cleanup(void);

    void InputController(stInputCallbackParameter parameter, int id);
    void InputBrake(stInputCallbackParameter parameter, int id);
    void InputFire(stInputCallbackParameter parameter, int id);
    void InputNuclear(stInputCallbackParameter parameter, int id);
    void InputDeflate(stInputCallbackParameter parameter, int id);
    void InputMenu(stInputCallbackParameter parameter, int id);

    void InputMenuInGameContinue(stInputCallbackParameter parameter, int id);
    void InputMenuInGameMainMenu(stInputCallbackParameter parameter, int id);
    void InputMenuInGameNextLevel(stInputCallbackParameter parameter, int id);
    void InputMenuInGameReset(stInputCallbackParameter parameter, int id);

    void PhysicsTickCallback(const btDynamicsWorld *world, btScalar timeStep);

    void AddNPCToProperSector(NPC* pNPC, int layer);

    Camera* GetCamera3D(void) const
    {
        return m_pCamera3D;
    };

    bool IsReadyToFinish(void) const
    {
        return m_bIsReadyToFinish;
    };

    bool IsReadyToReset(void) const
    {
        return m_bIsReadyToReset;
    };

    bool IsCustomLevel(void) const
    {
        return m_bIsCustomLevel;
    };

    Timer* GetGameTimer(void) const
    {
        return m_pGameTimer;
    };

    bool IsLevelcompleted(void) const
    {
        return m_bLevelCompleted;

    };

    void SetLevelCompleted(bool completed)
    {
        m_PlayTimer.Stop();
        if (!m_bIsCustomLevel)
        {
            stCurrentEpisodeAndLevel state = MenuGameState::Instance().GetCurrentSelection();
            state.previouslyCompleted = SaveManager::Instance().LevelCompleted(state.episode, state.level, (int)floor(m_PlayTimer.GetActualTime()));
            MenuGameState::Instance().SetCurrentSelection(state);
        }
        m_bLevelCompleted = completed;
    };

    float PlayerDistanceTo(const Vec3& position) const
    {
        Vec3 dir = position - m_pPlayer->GetPosition();
        return dir.length();
    };

    int GetGemCount(void) const
    {
        return m_iGemCount;
    };
};

#endif	/* _SCENE_H */

