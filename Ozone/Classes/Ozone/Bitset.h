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

/********************* H e l i o u s 2 0 0 3 ************************/
/********************************************************************/
/*						CBitset.h									*/
/*						Tabla de bits								*/
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
#pragma once
//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

#include "defines.h"

class Bitset
{

private:

    unsigned int *m_pBits;
    int m_iIntNum;

public:

    Bitset()
    {
        m_pBits = 0;
        m_iIntNum = 0;
        InitPointer(m_pBits);
    }

    ~Bitset()
    {
        SafeDeleteArray(m_pBits);
    }

    void Init(int iNumeroDeBits);
    void Set(int i);
    bool IsSet(int i);
    void Reset(int i);
    void ResetAll(void);

};

//////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
/********************************************************************/
/********************************************************************/
/*						Fin CBitset.h								*/
/********************************************************************/
/********************************************************************/
