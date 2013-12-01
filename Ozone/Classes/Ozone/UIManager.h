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
 * File:   UIManager.h
 * Author: nacho
 *
 * Created on 13 de marzo de 2010, 14:23
 */

#ifndef _UIMANAGER_H
#define	_UIMANAGER_H

#include "singleton.h"
#import "OzoneAppDelegate.h"
#include "highscores.h"

class UICallbackGeneric
{

public:

    virtual ~UICallbackGeneric() { };
    virtual void Execute(int id, const char* szText) const = 0;
};

//////////////////////////
//////////////////////////

template <class Class>
class UICallback : public UICallbackGeneric
{

public:

    typedef void (Class::*Method)(int, const char*);

private:

    Class* m_pClassInstance;
    Method m_theMethod;

public:

    UICallback(Class* class_instance, Method method)
    {
        m_pClassInstance = class_instance;
        m_theMethod = method;
    };

    virtual ~UICallback() { };

    virtual void Execute(int id, const char* szText) const
    {
        (m_pClassInstance->*m_theMethod)(id, szText);
    };
};

enum eUIevents
{
    UI_EVENT_ENTERNAME,
    UI_EVENT_ASKSENDSCORE,
    UI_EVENT_DOSENDSCORE,
    UI_EVENT_DOSENDWAITINGSCORE,
    UI_EVENT_SHOWSCORESLIST,
    UI_EVENT_SENDERROR,
    UI_EVENT_EXISTENTSCORE,
    UI_EVENT_SENDSCOREOK,
    UI_EVENT_DELETESAVESLOT,
    UI_EVENT_GETSCORES,
    UI_EVENT_ASKGOTOITUNES,
    UI_EVENT_ASKLEVELDOWNLOAD,
    UI_EVENT_LEVELDOWNLOAD,
    UI_EVENT_LEVELDOWNLOADOK,
    UI_EVENT_LEVELDOWNLOADNOTOK,
    UI_EVENT_LEVELDELETE,
    UI_EVENT_LEVELALERT,
	UI_EVENT_PLAYHAVEN
};

class UIManager : public Singleton<UIManager>
{

private:

    bool m_bWaitingEvent;
    eUIevents m_WaitingEvent;
    UICallbackGeneric* m_pCallback;
    highscores *m_pViewController;

    char m_szScoreText[256];

    void ShowScoresWindow(void);

public:
    UIManager(void);
    ~UIManager();

    void Update(void);

    void AlertViewResponse(UIAlertView* alertView, NSInteger buttonIndex);

    void WebResponse(const char* text);

    void RaiseEvent(eUIevents event)
    {
        RaiseEvent(event, NULL);
    };

    void RaiseEvent(eUIevents event, UICallbackGeneric* pCallback)
    {
        if (!m_bWaitingEvent)
        {
            m_pCallback = pCallback;
            m_bWaitingEvent = true;
            m_WaitingEvent = event;
        }
    };
};

#endif	/* _UIMANAGER_H */

