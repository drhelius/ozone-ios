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

/********************************************************************/
/********************************************************************/
/*								Bitset.cpp							*/
/*																    */
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////

#include "Bitset.h"


//--------------------------------------------------------------------
// Funcin:    CBitset::Init
// Creador:    Nacho (AMD)
// Fecha:      mircoles, 31 de enero de 2007, 19:30:45
//--------------------------------------------------------------------

void Bitset::Init(int iBitNumber)
{
    // Obtenemos el numero de integers necesarios
    m_iIntNum = (iBitNumber >> 5) + 1;

    // Borramos si ya tuvieramos una tabla
    SafeDeleteArray(m_pBits);

    // Creamos la tabla y la inicilizamos a 0
    m_pBits = new unsigned int[m_iIntNum];

    ResetAll();
}


//--------------------------------------------------------------------
// Funcin:    CBitset::Set
// Creador:    Nacho (AMD)
// Fecha:      mircoles, 31 de enero de 2007, 19:30:53
//--------------------------------------------------------------------

void Bitset::Set(int i)
{
    m_pBits[i >> 5] |= (1 << (i & 31));
}


//--------------------------------------------------------------------
// Funcin:    CBitset::IsSet
// Creador:    Nacho (AMD)
// Fecha:      mircoles, 31 de enero de 2007, 19:30:50
//--------------------------------------------------------------------

bool Bitset::IsSet(int i)
{
    return((m_pBits[i >> 5] & (1 << (i & 31))) != 0);
}


//--------------------------------------------------------------------
// Funcin:    CBitset::Reset
// Creador:    Nacho (AMD)
// Fecha:      mircoles, 31 de enero de 2007, 19:30:49
//--------------------------------------------------------------------

void Bitset::Reset(int i)
{
    m_pBits[i >> 5] &= ~(1 << (i & 31));
}


//--------------------------------------------------------------------
// Funcin:    CBitset::ResetAll
// Creador:    Nacho (AMD)
// Fecha:      mircoles, 31 de enero de 2007, 19:30:47
//--------------------------------------------------------------------

void Bitset::ResetAll(void)
{
    memset(m_pBits, 0, sizeof(unsigned int) * m_iIntNum);
}


/********************************************************************/
/********************************************************************/
/*							End Bitset.cpp							*/
/*																    */
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////
