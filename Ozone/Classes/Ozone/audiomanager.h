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
 * File:   audiomanager.h
 * Author: nacho
 *
 * Created on 22 de marzo de 2009, 23:30
 */

#pragma once
#ifndef _AUDIOMANAGER_H
#define	_AUDIOMANAGER_H

#import <AVFoundation/AVFoundation.h> 
#include <list>
#include <algorithm>
#include "singleton.h"
#include "SoundEngine.h"

typedef UInt32 EFFECT;
typedef AVAudioPlayer* MUSIC;

class AudioManager : public Singleton<AudioManager>
{

    ////friend class Singleton<AudioManager>;

private:

    bool m_bPlayingIPOD;

    Vec3 m_vListenerPosition;

    typedef std::list<MUSIC> TMUSICList;
    typedef TMUSICList::iterator TMUSICListIterator;

    TMUSICList m_MusicList;

    

public:

    AudioManager(void);
    ~AudioManager();

    void Init(int sampleRate);
    void Cleanup(void);

    void SetListenerPosition(float x, float y, float z);

    void SetListenerOrientation(float forwardX, float forwardY, float forwardZ, float upX, float upY, float upZ);

    Vec3 GetListenerPosition(void) const
    {
        return m_vListenerPosition;
    };

    void SetListenerGain(float gain);

    void SetEffectsVolume(float volume);
    void SetMasterVolume(float volume);

    void SetMaxDistance(float distance);
    void SetReferenceDistance(float distance);

    MUSIC LoadMusic(const char* szEffectPath);
    void UnloadMusic(MUSIC music);
    void PrepareMusic(MUSIC music);
    void PlayMusic(MUSIC music);
    void StopMusic(MUSIC music);
    void PauseMusic(MUSIC music);
    void SetMusicTime(MUSIC music, float time);
    void SetMusicLevel(MUSIC music, float level);
    void SetMusicLoops(MUSIC music, int numberOfLoops);
    bool IsPlayingMusic(MUSIC music);

    EFFECT LoadEffect(const char* szEffectPath);
    EFFECT LoadLoopingEffect(const char* szEffectPath);
    void UnloadEffect(EFFECT effect);
    void SetEffectLevel(EFFECT effect, float level);
    void SetEffectPitch(EFFECT effect, float pitch);
    void SetEffectPosition(EFFECT effect, float x, float y, float z);
    void PlayEffect(EFFECT effect, float x, float y, float z);

    void PlayEffect(EFFECT effect, Vec3 pos)
    {
        PlayEffect(effect, pos.x, pos.y, pos.z);
    };

    void PlayEffect(EFFECT effect)
    {
        PlayEffect(effect, m_vListenerPosition.x, m_vListenerPosition.y, m_vListenerPosition.z);
    };

    void StopEffect(EFFECT effect);
};

#endif	/* _AUDIOMANAGER_H */

