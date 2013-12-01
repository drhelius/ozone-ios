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
 *  SubMenuFullVersionState.h
 *  Ozone
 *
 *  Created by nacho on 28/05/09.
 *  Copyright 2009 __MyCompanyName__. All rights reserved.
 *
 */

#pragma once
#ifndef _SUBMENUFULLVERSIONSTATE_H
#define	_SUBMENUFULLVERSIONSTATE_H

#include "submenustate.h"
#include "singleton.h"
#include "inputmanager.h"
#include "renderable.h"
#include "renderobject.h"

class SubMenuFullVersionState : public SubMenuState, public Singleton<SubMenuFullVersionState>
{

    ////friend class Singleton<SubMenuFullVersionState>;

private:

    InputCallback<SubMenuFullVersionState>* m_pInputCallbackBack;

    RenderObject* m_pBackgrounds[5];
    Renderable* m_pRenderableHighLayer2D;

    int m_iCurrentPage;
    float m_fTrans;

public:

    SubMenuFullVersionState(void);
    ~SubMenuFullVersionState(void);

    void Init(TextFont* pTextFont, Fader* pFader);
    void Cleanup(void);
    void Reset(void);

    void UpdateLoading(void);
    void UpdateClosing(void);
    void Update(void);

    void InputCallbackBack(stInputCallbackParameter parameter, int id);
};

#endif	/* _SUBMENUFULLVERSIONSTATE_H */