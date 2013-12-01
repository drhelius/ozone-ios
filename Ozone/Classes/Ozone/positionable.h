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
 * File:   positionable.h
 * Author: nacho
 *
 * Created on 18 de junio de 2009, 23:36
 */

#pragma once
#ifndef _POSITIONABLE_H
#define	_POSITIONABLE_H

#include "defines.h"

class Positionable
{

protected:

    Vec3 m_vPosition;
    Vec3 m_vScale;
    MATRIX m_mtxRotation;

public:

    Positionable(void)
    {
        m_vPosition.x = m_vPosition.y = m_vPosition.z = 0.0f;
        m_vScale.x = m_vScale.y = m_vScale.z = 0.0f;
        MatrixIdentity(m_mtxRotation);
    };

    const Vec3& GetPosition(void) const
    {
        return m_vPosition;
    };

    void SetPosition(const Vec3& position)
    {
        m_vPosition = position;
    };

    float GetPositionX(void) const
    {
        return m_vPosition.x;
    };

    float GetPositionY(void) const
    {
        return m_vPosition.y;
    };

    float GetPositionZ(void) const
    {
        return m_vPosition.z;
    };

    void SetPositionX(const float x)
    {
        m_vPosition.x = x;
    };

    void SetPositionY(const float y)
    {
        m_vPosition.y = y;
    };

    void SetPositionZ(const float z)
    {
        m_vPosition.z = z;
    };
    
    const Vec3& GetScale(void) const
    {
        return m_vScale;
    };

    void SetScale(const Vec3& scale)
    {
        m_vScale = scale;
    };

    void SetScale(const float x, const float y, const float z)
    {
        m_vScale.x = x;
        m_vScale.y = y;
        m_vScale.z = z;
    };

    float GetScaleX(void) const
    {
        return m_vScale.x;
    };

    float GetScaleY(void) const
    {
        return m_vScale.y;
    };

    float GetScaleZ(void) const
    {
        return m_vScale.z;
    };

    void SetScaleX(const float x)
    {
        m_vScale.x = x;
    };

    void SetScaleY(const float y)
    {
        m_vScale.y = y;
    };

    void SetScaleZ(const float z)
    {
        m_vScale.z = z;
    };

    MATRIX& GetRotation(void)
    {
        return m_mtxRotation;
    };

    void SetRotation(const MATRIX& matrix)
    {
        m_mtxRotation = matrix;
    };
};


#endif	/* _POSITIONABLE_H */

