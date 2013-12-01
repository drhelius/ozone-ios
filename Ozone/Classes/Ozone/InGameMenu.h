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
 * File:   InGameMenu.h
 * Author: nacho
 *
 * Created on 16 de febrero de 2010, 16:35
 */

#ifndef _INGAMEMENU_H
#define	_INGAMEMENU_H

#include "renderable.h"
#include "renderobject.h"
#include "timer.h"
#include "interpolatormanager.h"
#include "fader.h"
#include "textfont.h"

class InGameMenu
{

protected:

    RenderObject m_TopLeftRO;
    RenderObject m_TopRO;
    RenderObject m_TopRightRO;
    RenderObject m_LeftRO;
    RenderObject m_CenterRO;
    RenderObject m_RightRO;
    RenderObject m_BottomLeftRO;
    RenderObject m_BottomRO;
    RenderObject m_BottomRightRO;

    RenderObject m_LogoRO;

    Renderable m_Renderable;

    TextFont* m_pTextFont;

    float m_fWidth;
    float m_fHeight;
    float m_fAlpha;
    float m_fMotion;
    float m_fSelectionOpacity;

    int m_iSelection;

    bool m_bActive;
    bool m_bHiding;
    bool m_bShowLogo;

    LinearInterpolator* m_pAlphaInterpolator;
    SineInterpolator* m_pMotionInterpolator;
    CosineInterpolator* m_pSelectionInterpolator;

    Fader* m_pFader;
    Timer* m_pTimer;

public:

    InGameMenu(void);
    virtual ~InGameMenu();

    virtual void Init(float width, float height);
    virtual void Update(void);

    virtual void Show(void);
    virtual void Hide(void);
    virtual void Disable(void);

    bool IsActive(void)
    {
        return m_bActive;
    };

    void SetWidth(float width)
    {
        m_fWidth = width;
    };

    void SetHeight(float height)
    {
        m_fHeight = height;
    };

    float GetWidth(void) const
    {
        return m_fWidth;
    };

    float GetHeight(void) const
    {
        return m_fHeight;
    };
};

#endif	/* _INGAMEMENU_H */

