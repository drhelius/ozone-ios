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
 * File:   triggers.h
 * Author: nacho
 *
 * Created on 4 de agosto de 2009, 19:32
 */

#pragma once
#ifndef _TRIGGERS_H
#define	_TRIGGERS_H

#include "defines.h"
#include "functor.h"

//////////////////////////
//////////////////////////

class Trigger
{

protected:

    bool m_bCanKill;
    bool m_bPaused;

    float m_fDuration;
    float m_fElapsedTime;

    bool m_bFireOnce;

    Functor* m_pFunctor;

public:

    Trigger(Functor* pFunctor, bool fireOnce, float duration)
    {
        m_pFunctor = pFunctor;
        m_bFireOnce = fireOnce;
        m_fDuration = duration;
        m_bCanKill = false;
        m_bPaused = false;
        m_fElapsedTime = 0.0f;
    };

    virtual ~Trigger()
    {
    };

    virtual bool Test(void) = 0;

    virtual void DoAction(void) = 0;

    void Update(float fdTime)
    {
        if (m_bPaused)
            return;

        m_fElapsedTime += fdTime;

        if ((m_fDuration > 0.0f) && (m_fElapsedTime >= m_fDuration))
        {
            Kill();
        }
        else if (Test())
        {
            DoAction();

            if (m_bFireOnce)
            {
                Kill();
            }
        }
    };

    virtual void Pause(void)
    {
        m_bPaused = true;
    };

    virtual void Continue(void)
    {
        m_bPaused = false;
    };

    virtual void Kill(void)
    {
        m_bCanKill = true;
    };

    virtual void Reset(void)
    {
        m_fElapsedTime = 0.0f;
    };

    bool CanKill(void) const
    {
        return m_bCanKill;
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class TrueTrigger : public Trigger
{

protected:

    T* m_pSubject;

public:

    TrueTrigger(T* subject, Functor* pFunctor, bool fireOnce, float duration) : Trigger(pFunctor, fireOnce, duration)
    {
        m_pSubject = subject;
    };

    virtual bool Test(void)
    {
        return((*this->m_pSubject) == true);
    };

    virtual void DoAction(void)
    {
        (*m_pFunctor)();
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class FalseTrigger : public Trigger
{

protected:

    T* m_pSubject;

public:

    FalseTrigger(T* subject, Functor* pFunctor, bool fireOnce, float duration) : Trigger(pFunctor, fireOnce, duration)
    {
        m_pSubject = subject;
    };

    virtual bool Test(void)
    {
        return((*this->m_pSubject) == false);
    };

    virtual void DoAction(void)
    {
        (*m_pFunctor)();
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class ComparisonTrigger : public Trigger
{

protected:

    T* m_pSubject;
    T* m_pObject;

public:

    ComparisonTrigger(T* subject, T* object, Functor* pFunctor, bool fireOnce, float duration) : Trigger(pFunctor, fireOnce, duration)
    {
        m_pSubject = subject;
        m_pObject = object;
    };

    virtual void DoAction(void)
    {
        (*m_pFunctor)();
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class EqualsTrigger : public ComparisonTrigger<T>
{

public:

    EqualsTrigger(T* subject, T* object, Functor* pFunctor, bool fireOnce = true, float duration = 0.0f) : ComparisonTrigger<T>(subject, object, pFunctor, fireOnce, duration)
    {
    };

    virtual bool Test(void)
    {
        return((*this->m_pSubject) == (*this->m_pObject));
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class NotEqualsTrigger : public ComparisonTrigger<T>
{

public:

    NotEqualsTrigger(T* subject, T* object, Functor* pFunctor, bool fireOnce = true, float duration = 0.0f) : ComparisonTrigger<T>(subject, object, pFunctor, fireOnce, duration)
    {
    };

    virtual bool Test(void)
    {
        return((*this->m_pSubject) != (*this->m_pObject));
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class GreaterTrigger : public ComparisonTrigger<T>
{

public:

    GreaterTrigger(T* subject, T* object, Functor* pFunctor, bool fireOnce = true, float duration = 0.0f) : ComparisonTrigger<T>(subject, object, pFunctor, fireOnce, duration)
    {
    };

    virtual bool Test(void)
    {
        return((*this->m_pSubject) > (*this->m_pObject));
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class LesserTrigger : public ComparisonTrigger<T>
{

public:

    LesserTrigger(T* subject, T* object, Functor* pFunctor, bool fireOnce = true, float duration = 0.0f) : ComparisonTrigger<T>(subject, object, pFunctor, fireOnce, duration)
    {
    };

    virtual bool Test(void)
    {
        return((*this->m_pSubject) < (*this->m_pObject));
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class GreatEqualTrigger : public ComparisonTrigger<T>
{

public:

    GreatEqualTrigger(T* subject, T* object, Functor* pFunctor, bool fireOnce = true, float duration = 0.0f) : ComparisonTrigger<T>(subject, object, pFunctor, fireOnce, duration)
    {
    };

    virtual bool Test(void)
    {
        return((*this->m_pSubject) >= (*this->m_pObject));
    };
};

//////////////////////////
//////////////////////////

template<typename T>
class LessEqualTrigger : public ComparisonTrigger<T>
{

public:

    LessEqualTrigger(T* subject, T* object, Functor* pFunctor, bool fireOnce = true, float duration = 0.0f) : ComparisonTrigger<T>(subject, object, pFunctor, fireOnce, duration)
    {
    };

    virtual bool Test(void)
    {
        return((*this->m_pSubject) <= (*this->m_pObject));
    };
};


#endif	/* _TRIGGERS_H */

