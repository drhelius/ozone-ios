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
/*						    Camera.cpp								*/
/*																    */
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////

#include "camera.h"
#include "gamemanager.h"
#include <OpenGLES/EAGL.h>
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>


//--------------------------------------------------------------------
// Funci�n:    CCamera::CCamera
// Prop�sito:  
// Fecha:      martes, 28 de noviembre de 2006, 22:18:14
//--------------------------------------------------------------------

Camera::Camera(void)
{
    Log("+++ Camera::Camera ...\n");

    m_fFov = 40.0f;

    m_fPitch = m_fYaw = m_fRoll = 0.0f;

    //m_fYaw = MAT_ToRadians(180.0f);

    m_fNearPlane = 2.0f;
    m_fFarPlane = 100.0f;

    m_vTarget.x = 0.0f;
    m_vTarget.y = 0.0f;
    m_vTarget.z = 0.0f;

    m_vPosition.x = 0.0f;
    m_vPosition.y = 0.0f;
    m_vPosition.z = -30.0f;

    m_vLook.x = 0.0f;
    m_vLook.y = 0.0f;
    m_vLook.z = 1.0f;

    m_vRight.x = 1.0f;
    m_vRight.y = 0.0f;
    m_vRight.z = 0.0f;

    m_vUp.x = 0.0f;
    m_vUp.y = 1.0f;
    m_vUp.z = -1.0f;

    m_bPerspective = true;
    m_bRatate90 = true;
    m_bTargeting = false;

    m_fNoiseDuration = 0.0f;
    m_fNoiseStart = 0.0f;
    InitPointer(m_pNoiseTimer);

    MatrixIdentity(m_matAbsoluteTransform);


    Log("+++ Camera::Camera correcto\n");
}

//--------------------------------------------------------------------
// Funci�n:    CCamera::~CCamera
// Prop�sito:  
// Fecha:      martes, 28 de noviembre de 2006, 22:18:16
//--------------------------------------------------------------------

Camera::~Camera(void)
{
    Log("+++ Camera::~Camera destruida\n");
}

void Camera::AddNoise(float duration, Timer* timer)
{
    m_fNoiseStart = timer->GetActualTime();
    m_fNoiseDuration = duration;
    m_pNoiseTimer = timer;
}


//--------------------------------------------------------------------
// Funci�n:    CCamera::Update
// Prop�sito:  
// Fecha:      mi�rcoles, 29 de noviembre de 2006, 20:08:12
//--------------------------------------------------------------------

void Camera::Update(void)
{
    if (m_bPerspective)
    {
        if (m_fNoiseDuration > 0.0f)
        {
            if (m_pNoiseTimer->IsRunning())
            {
                float actualTime = m_pNoiseTimer->GetActualTime();
                float timeOffset = actualTime - m_fNoiseStart;

                if (timeOffset < m_fNoiseDuration)
                {
                    float noiseAmp = m_fNoiseDuration - timeOffset;
                    float angle = fmod(actualTime, TWOPIf);
                    float noise = 10.0f * noiseAmp * sin(60.0f * angle);

                    m_vPosition += (m_vRight * noise);
                    m_vTarget += (m_vRight * noise);
                }
                else
                {
                    m_fNoiseDuration = 0.0f;
                }
            }
        }


        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glMultMatrixf(m_matAbsoluteTransform.f);

        float top, bottom, left, right;
        top = m_fNearPlane * tanf(M_PI_ENTRE_180 * m_fFov / 2.0f);
        bottom = -top;
        right = IPHONE_ASPECT_RATIO * top;
        left = -right;
        glFrustumf(left, right, bottom, top, m_fNearPlane, m_fFarPlane);

        if (m_bRatate90)
        {
            if (GameManager::Instance().IsHomeRight())
            {
                glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
            }
            else
            {
                glRotatef(90.0f, 0.0f, 0.0f, 1.0f);
            }
        }

        if (m_bTargeting)
        {
            m_vUp = Vec3(0.0f, 1.0f, 0.0f);
            MatrixLookAtRH(m_matView, m_vPosition, m_vTarget, m_vUp);
        }
        else
        {
            MATRIX T, Rx, Ry, Rz;

            MatrixTranslation(T, -m_vPosition.x, -m_vPosition.y, -m_vPosition.z);
            MatrixRotationX(Rx, -m_fPitch);
            MatrixRotationY(Ry, -m_fYaw);
            MatrixRotationZ(Rz, -m_fRoll);

            MatrixMultiply(m_matView, Rz, Ry);
            MatrixMultiply(m_matView, Rx, m_matView);
            MatrixMultiply(m_matView, T, m_matView);
        }

        m_vRight.x = m_matView.f[_11];
        m_vRight.y = m_matView.f[_21];
        m_vRight.z = m_matView.f[_31];

        m_vUp.x = m_matView.f[_12];
        m_vUp.y = m_matView.f[_22];
        m_vUp.z = m_matView.f[_32];

        m_vLook.x = m_matView.f[_13];
        m_vLook.y = m_matView.f[_23];
        m_vLook.z = m_matView.f[_33];

        glMatrixMode(GL_MODELVIEW);
        glLoadMatrixf(m_matView.f);
    }
    else
    {
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();

        if (m_bRatate90)
        {
            if (GameManager::Instance().IsHomeRight())
            {
                glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
            }
            else
            {
                glRotatef(90.0f, 0.0f, 0.0f, 1.0f);
            }

            glOrthof(0.0f, IPHONE_SCREEN_HEIGHT, IPHONE_SCREEN_WIDTH, 0.0f, -100.0f, 100.0f);
        }
        else
        {
            glOrthof(0.0f, IPHONE_SCREEN_WIDTH, IPHONE_SCREEN_HEIGHT, 0.0f, -100.0f, 100.0f);
        }

        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
    }
}


//--------------------------------------------------------------------
// Funci�n:    CCamera::SetMode
// Prop�sito:  
// Fecha:      mi�rcoles, 29 de noviembre de 2006, 19:17:46
//--------------------------------------------------------------------

void Camera::SetMode(bool bPerspective)
{
    m_bPerspective = bPerspective;
}


//--------------------------------------------------------------------
// Funci�n:    CCamera::GoForward
// Prop�sito:  
// Fecha:      mi�rcoles, 29 de noviembre de 2006, 19:13:59
//--------------------------------------------------------------------

void Camera::GoForward(float speed, float deltaTime)
{
    m_vPosition += m_vLook * (speed * deltaTime);
}


//--------------------------------------------------------------------
// Funci�n:    CCamera::GoStrafe
// Prop�sito:  
// Fecha:      mi�rcoles, 29 de noviembre de 2006, 19:14:01
//--------------------------------------------------------------------

void Camera::GoStrafe(float speed, float deltaTime)
{
    m_vPosition += m_vRight * (speed * deltaTime);
}


//--------------------------------------------------------------------
// Funci�n:    CCamera::GoUp
// Prop�sito:  
// Fecha:      mi�rcoles, 29 de noviembre de 2006, 19:13:56
//--------------------------------------------------------------------

void Camera::GoUp(float speed, float deltaTime)
{
    m_vPosition += m_vUp * (speed * deltaTime);
}

/********************************************************************/
/********************************************************************/
/*							End Camera.cpp							*/
/*																    */
/********************************************************************/
/********************************************************************/
//////////////////////////////////////////////////////////////////////



