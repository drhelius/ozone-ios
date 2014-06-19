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
 * File:   audiomanager.cpp
 * Author: nacho
 * 
 * Created on 22 de marzo de 2009, 23:30
 */

#include "audiomanager.h"

AudioManager::AudioManager(void)
{
    Log("+++ AudioManager::AudioManager ...\n");

    m_bPlayingIPOD = false;

    m_MusicList.clear();

    Log("+++ AudioManager::AudioManager correcto\n");
}

//////////////////////////
//////////////////////////

AudioManager::~AudioManager()
{
    Log("+++ AudioManager::~AudioManager ...\n");

    Cleanup();

    Log("+++ AudioManager::~AudioManager destruido\n");
}

//////////////////////////
//////////////////////////

void AudioManager::Init(int sampleRate)
{
    Log("+++ AudioManager::Init Inicializando motor de sonido ...\n");

    AudioSessionInitialize(nil, nil, nil, nil);

    UInt32 isPlaying;
    UInt32 varSize = sizeof (isPlaying);

    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &varSize, &isPlaying);

    m_bPlayingIPOD = (isPlaying != 0);

    UInt32 audioSessionCategory = 0;

    if (isPlaying != 0)
    {
        audioSessionCategory = kAudioSessionCategory_AmbientSound;
    }
    else
    {
        audioSessionCategory = kAudioSessionCategory_SoloAmbientSound;
    }

    if (!m_bPlayingIPOD)
    {
        UInt32 fakeCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof (fakeCategory), &fakeCategory);
        AudioSessionSetActive(TRUE);
        AudioSessionSetActive(FALSE);
    }

    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof (audioSessionCategory), &audioSessionCategory);
    AudioSessionSetActive(TRUE);


    SoundEngine_Initialize(sampleRate);

    SetListenerPosition(0.0f, 0.0f, 1.0f);
    //SetReferenceDistance(80000.0f);
    //SetMaxDistance(1000000.0f);

    Log("+++ AudioManager::Init Inicializado.\n");
}

//////////////////////////
//////////////////////////

void AudioManager::Cleanup(void)
{
    Log("+++ AudioManager::Cleanup Finalizando motor de sonido ...\n");

    for (TMUSICListIterator itor = m_MusicList.begin(); itor != m_MusicList.end(); itor++)
    {
        StopMusic((*itor));

        [ (*itor) release ];
    }

    m_MusicList.clear();

    SoundEngine_Teardown();
}

//////////////////////////
//////////////////////////

MUSIC AudioManager::LoadMusic(const char* szMusicPath)
{
    if (!m_bPlayingIPOD)
    {
        Log("+++ AudioManager::LoadMusic Cargando música: %s\n", szMusicPath);

        NSError *err;

        char* ind = strrchr(szMusicPath, '/');
        char* szName = ind + 1;
        char szPath[256] = {0};
        strncpy(szPath, szMusicPath, ind - szMusicPath);
        szPath[ind - szMusicPath] = 0;

        NSString * OCname = [NSString stringWithCString : szName encoding : [NSString defaultCStringEncoding]];
        NSString * OCpath = [NSString stringWithCString : szPath encoding : [NSString defaultCStringEncoding]];

        MUSIC music = [[AVAudioPlayer alloc] initWithContentsOfURL : [NSURL fileURLWithPath :
                [[NSBundle mainBundle] pathForResource : OCname ofType : @"caf" inDirectory : OCpath]] error : &err];

        m_MusicList.push_back(music);

        Log("+++ AudioManager::LoadMusic Música cargada: %s\n", szMusicPath);

        return music;
    }
    else
    {
        Log("+++ AudioManager::LoadMusic Ignorando música: %s\n", szMusicPath);

        return NULL;
    }
}

//////////////////////////
//////////////////////////

void AudioManager::UnloadMusic(MUSIC music)
{
    if (!m_bPlayingIPOD && IsValidPointer(music))
    {
        Log("+++ AudioManager::UnloadMusic Descargando música...\n");

        TMUSICListIterator itor = find(m_MusicList.begin(), m_MusicList.end(), music);

        if (itor != m_MusicList.end())
        {
            StopMusic(music);

            [ music release ];

            m_MusicList.erase(itor);
        }
    }
}

//////////////////////////
//////////////////////////

void AudioManager::PrepareMusic(MUSIC music)
{
    if (!m_bPlayingIPOD)
    {
        [ music prepareToPlay ];
    }
}

//////////////////////////
//////////////////////////

void AudioManager::PlayMusic(MUSIC music)
{
    if (!m_bPlayingIPOD)
    {
        [ music play ];
    }
}

//////////////////////////
//////////////////////////

void AudioManager::StopMusic(MUSIC music)
{
    if (!m_bPlayingIPOD)
    {
        [ music stop ];
        SetMusicTime(music, 0.0f);
    }
}

//////////////////////////
//////////////////////////

void AudioManager::PauseMusic(MUSIC music)
{
    if (!m_bPlayingIPOD)
    {
        [ music stop ];
    }
}

//////////////////////////
//////////////////////////

void AudioManager::SetMusicTime(MUSIC music, float time)
{
    if (!m_bPlayingIPOD)
    {
        music.currentTime = time;
    }
}

//////////////////////////
//////////////////////////

void AudioManager::SetMusicLevel(MUSIC music, float level)
{
    if (!m_bPlayingIPOD)
    {
        music.volume = level;
    }
}

//////////////////////////
//////////////////////////

void AudioManager::SetMusicLoops(MUSIC music, int numberOfLoops)
{
    if (!m_bPlayingIPOD)
    {
        music.numberOfLoops = numberOfLoops;
    }
}

//////////////////////////
//////////////////////////

bool AudioManager::IsPlayingMusic(MUSIC music)
{
    if (m_bPlayingIPOD)
    {
        return false;
    }
    else
    {
        return music.playing;
    }
}

//////////////////////////
//////////////////////////

EFFECT AudioManager::LoadEffect(const char* szEffectPath)
{
    Log("+++ AudioManager::LoadEffect Cargando sonido: %s\n", szEffectPath);

    char* ind = strrchr(szEffectPath, '/');
    char* szName = ind + 1;
    char szPath[256] = {0};
    strncpy(szPath, szEffectPath, ind - szEffectPath);
    szPath[ind - szEffectPath] = 0;

    NSString * OCname = [NSString stringWithCString : szName encoding : [NSString defaultCStringEncoding]];
    NSString * OCpath = [NSString stringWithCString : szPath encoding : [NSString defaultCStringEncoding]];

    NSString * RSCpath = [[NSBundle mainBundle] pathForResource : OCname ofType : @"wav" inDirectory : OCpath];

    const char* szFinalPath = [RSCpath cStringUsingEncoding : 1];

    EFFECT effect;

    SoundEngine_LoadEffect(szFinalPath, &effect);

    Log("+++ AudioManager::LoadEffect Sonido cargado: %s\n", szEffectPath);

    return effect;
}

//////////////////////////
//////////////////////////

EFFECT AudioManager::LoadLoopingEffect(const char* szEffectPath)
{
    Log("+++ AudioManager::LoadEffect Cargando sonido con loop: %s\n", szEffectPath);

    char* ind = strrchr(szEffectPath, '/');
    char* szName = ind + 1;
    char szPath[256] = {0};
    strncpy(szPath, szEffectPath, ind - szEffectPath);
    szPath[ind - szEffectPath] = 0;

    NSString * OCname = [NSString stringWithCString : szName encoding : [NSString defaultCStringEncoding]];
    NSString * OCpath = [NSString stringWithCString : szPath encoding : [NSString defaultCStringEncoding]];

    NSString * RSCpath = [[NSBundle mainBundle] pathForResource : OCname ofType : @"wav" inDirectory : OCpath];

    const char* szFinalPath = [RSCpath cStringUsingEncoding : 1];

    EFFECT effect;

    SoundEngine_LoadLoopingEffect(szFinalPath, NULL, NULL, &effect);

    Log("+++ AudioManager::LoadEffect Sonido con loop cargado: %s\n", szEffectPath);

    return effect;
}

//////////////////////////
//////////////////////////

void AudioManager::SetListenerPosition(float x, float y, float z)
{
    m_vListenerPosition = Vec3(x, y, z);
    SoundEngine_SetListenerPosition(x, y, z);
}

//////////////////////////
//////////////////////////

void AudioManager::SetListenerOrientation(float forwardX, float forwardY, float forwardZ, float upX, float upY, float upZ)
{
    SoundEngine_SetListenerOrientation(forwardX, forwardY, forwardZ, upX, upY, upZ);
}

//////////////////////////
//////////////////////////

void AudioManager::SetListenerGain(float gain)
{
    SoundEngine_SetListenerGain(gain);
}

//////////////////////////
//////////////////////////

void AudioManager::SetEffectsVolume(float volume)
{
    SoundEngine_SetEffectsVolume(volume);
}

//////////////////////////
//////////////////////////

void AudioManager::SetMasterVolume(float volume)
{
    SoundEngine_SetMasterVolume(volume);
}

//////////////////////////
//////////////////////////

void AudioManager::SetMaxDistance(float distance)
{
    SoundEngine_SetMaxDistance(distance);
}

//////////////////////////
//////////////////////////

void AudioManager::SetReferenceDistance(float distance)
{
    SoundEngine_SetReferenceDistance(distance);
}

//////////////////////////
//////////////////////////

void AudioManager::UnloadEffect(EFFECT effect)
{
    Log("+++ AudioManager::UnloadEffect Descargando sonido...\n");

    SoundEngine_UnloadEffect(effect);
}

//////////////////////////
//////////////////////////

void AudioManager::SetEffectLevel(EFFECT effect, float level)
{
    SoundEngine_SetEffectLevel(effect, level);
}

//////////////////////////
//////////////////////////

void AudioManager::SetEffectPitch(EFFECT effect, float pitch)
{
    SoundEngine_SetEffectPitch(effect, pitch);
}

//////////////////////////
//////////////////////////

void AudioManager::SetEffectPosition(EFFECT effect, float x, float y, float z)
{
    SoundEngine_SetEffectPosition(effect, x, y, z);
}

//////////////////////////
//////////////////////////

void AudioManager::PlayEffect(EFFECT effect, float x, float y, float z)
{
    SoundEngine_SetEffectPosition(effect, x, y, z);
    SoundEngine_StartEffect(effect);
}

//////////////////////////
//////////////////////////

void AudioManager::StopEffect(EFFECT effect)
{
    SoundEngine_StopEffect(effect, false);
}
