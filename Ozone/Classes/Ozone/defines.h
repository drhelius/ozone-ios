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
 * File:   defines.h
 * Author: nacho
 *
 * Created on 23 de marzo de 2009, 21:51
 */

#pragma once
#ifndef _DEFINES_H
#define	_DEFINES_H

////////////////////////////////////////////////
////////////////////////////////////////////////

#ifndef GEARDOME_WE_ARE_IN_RELEASE
#define DEBUG_OZONE 1
//#define DEBUG_OZONE_ONLY_ERRORS 1
//#define DEBUG_NO_CLIP 1
#endif

//#define OZONE_PRE_RELEASE 1

//#define OZONE_XMAS 1

////////////////////////////////////////////////
////////////////////////////////////////////////

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <math.h>
#include <time.h>
#include <ctime>
#include <mach/mach.h>
#include <mach/mach_time.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#include <OpenGLES/ES1/gl.h>

#define BT_NO_PROFILE 1

#include <btBulletDynamicsCommon.h>
#include "physics/BulletCollision/CollisionDispatch/btGhostObject.h"

#include "mathutil.h"

#ifndef NULL
#define NULL 0
#endif

typedef uint64_t u64;
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;

////////////////////////////////////////////////
////////////////////////////////////////////////

#define MAX_LEVELS_PER_EPISODE 12
#define MAX_EPISODE_SLOTS 10

#define LEVEL_VERSION 3

#define ANIMATION_INTERVAL (1.0 / 61.0)

#ifdef GEARDOME_PLATFORM_IPAD
    #define IPHONE_SCREEN_WIDTH 768
    #define IPHONE_SCREEN_HEIGHT 1024
    #define IPHONE_ASPECT_RATIO 0.75f
    #define IPHONE_INVERSED_ASPECT_RATIO 1.333333333f
#else
    #define IPHONE_SCREEN_WIDTH 320
    #define IPHONE_SCREEN_HEIGHT 480
    #define IPHONE_ASPECT_RATIO 0.6666666666f
    #define IPHONE_INVERSED_ASPECT_RATIO 1.5f
#endif

#define PHYSICS_SCALE_FACTOR (1.0f / 100.0f)
#define PHYSICS_INV_SCALE_FACTOR (1.0f / PHYSICS_SCALE_FACTOR)

#define PIOVERTWOf	(3.1415926535f / 2.0f)
#define PIf			(3.1415926535f)
#define TWOPIf		(3.1415926535f * 2.0f)
#define ONEf		(1.0f)
#define M_1_PIf		(1.0f / 3.1415926535f)

#define M_PI_ENTRE_180 (0.017453293f)
#define M_180_ENTRE_PI (57.29577951f)

////////////////////////////////////////////////
////////////////////////////////////////////////

#define SafeDelete(pointer) if(pointer != NULL) {delete pointer; pointer = NULL;}
#define SafeDeleteArray(pointer) if(pointer != NULL) {delete [] pointer; pointer = NULL;}

#define InitPointer(pointer) ((pointer) = NULL)
#define IsValidPointer(pointer) ((pointer) != NULL)

#define _ABS(a)		((a) <= 0 ? -(a) : (a) )

inline void Log(const char* const msg, ...)
{
#ifdef DEBUG_OZONE

#ifdef DEBUG_OZONE_ONLY_ERRORS

    if (msg[0] != '@')
    {
        return;
    }

#endif

    static int count = 0;
    char szBuf[256];
    char szBuf2[256];

    va_list args;
    va_start(args, msg);
    vsprintf(szBuf, msg, args);
    va_end(args);

    sprintf(szBuf2, "%d %s", count, szBuf);
    printf("%s", szBuf2);

    count++;
#endif
}

inline void TriggerVibrationOniPhone(void)
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

inline float MAT_angleSignedVec2D(const Vec2 &v1, const Vec2 &v2)
{
    float perpDot = v1.x * v2.y - v1.y * v2.x;
    float dot = v1.x * v2.x + v1.y * v2.y;

    return atan2(perpDot, dot);
}

inline float MAT_angleUnsignedVec2D(const Vec2 &v1, const Vec2 &v2)
{
    float perpDot = v1.x * v2.y - v1.y * v2.x;
    float dot = v1.x * v2.x + v1.y * v2.y;

    float angle = atan2(perpDot, dot);

    if (angle < 0.0f)
        angle += TWOPIf;

    return angle;
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_abs
// Creador:    Nacho (AMD)
// Fecha:      Monday  11/06/2007  22:05:57
//--------------------------------------------------------------------

inline float MAT_abs(float num)
{
    return (num < 0) ? -num : num;
}

inline float fast_sin(float x)
{
    // simplify the range reduction
    // reduce to a -0.5..0.5 range, then apply polynomial directly
    const float P = 0.225; // const float Q = 0.775;

    x = x * M_1_PIf;
    int k = (int) roundf(x);
    x = x - k;

    float y = (4 - 4 * MAT_abs(x)) * x;

    y = P * (y * MAT_abs(y) - y) + y;

    return (k & 1) ? -y : y;
}

inline float fast_cos(float x)
{
    return fast_sin(x + PIOVERTWOf);
}

inline float fast_acos(float x)
{
    return sqrt(1 - x)*(1.5707963267948966192313216916398f + x * (-0.213300989f +
            x * (0.077980478f + x*-0.02164095f)));
}

inline void MAT_MATRIX_to_btMatrix3x3(const MATRIX& mtxIN, btMatrix3x3& btMtxOUT)
{
    btMtxOUT.setIdentity();
    btMtxOUT.setFromOpenGLSubMatrix(mtxIN.f);
}

inline void MAT_btMatrix3x3_to_MATRIX(const btMatrix3x3& btMtxIN, MATRIX& mtxOUT)
{
    MatrixIdentity(mtxOUT);

    btScalar matTmp[12];

    btMtxIN.getOpenGLSubMatrix(matTmp);

    for (int i = 0; i < 12; i++)
    {
        mtxOUT.f[i] = matTmp[i];
    }
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_ToRadians
// PropÛsito:  Pasa de Grados a Radianes
// Fecha:      martes, 28 de noviembre de 2006, 22:46:51
//--------------------------------------------------------------------

inline float MAT_ToRadians(float angle)
{
    return (angle * M_PI_ENTRE_180);
}


//--------------------------------------------------------------------
// FunciÛn:    MAT_ToDegrees
// PropÛsito:  Pasa de Radianes a Grados
// Fecha:      martes, 28 de noviembre de 2006, 22:46:41
//--------------------------------------------------------------------

inline float MAT_ToDegrees(float angle)
{
    return (angle * M_180_ENTRE_PI);
}



//--------------------------------------------------------------------
// FunciÛn:    MAT_Clamp
// Creador:    Nacho (AMD)
// Fecha:      miÈrcoles, 31 de enero de 2007, 19:50:17
//--------------------------------------------------------------------

inline int MAT_Clamp(int num, int min, int max)
{
    if (num > max)
    {
        return max;
    }
    if (num < min)
    {
        return min;
    }
    return num;
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Clampf
// Creador:    Nacho (AMD)
// Fecha:      miÈrcoles, 31 de enero de 2007, 19:50:17
//--------------------------------------------------------------------

inline float MAT_Clampf(float num, float min, float max)
{
    if (num > max)
    {
        return max;
    }
    if (num < min)
    {
        return min;
    }
    return num;
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Max
// Creador:    Nacho (AMD)
// Fecha:      Monday  11/06/2007  18:57:55
//--------------------------------------------------------------------

inline float MAT_Max(float num1, float num2)
{
    return (num1 > num2) ? num1 : num2;
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_Min
// Creador:    Nacho (AMD)
// Fecha:      Monday  11/06/2007  18:58:00
//--------------------------------------------------------------------

inline float MAT_Min(float num1, float num2)
{
    return (num1 < num2) ? num1 : num2;
}

//--------------------------------------------------------------------
// FunciÛn:    MAT_RandomInt
// Creador:    Nacho (AMD)
// PropÛsito:  Devuelve un n˙mero entero aleatorio entre dos introducidos, el alto
//			   excluido y el bajo incluido.
// Fecha:      martes, 06 de febrero de 2007, 19:29:34
//--------------------------------------------------------------------

inline int MAT_RandomInt(int low, int high)
{
    int range = high - low;
    int num = rand() % range;
    return (num + low);
}

inline void MAT_RandomInit(void)
{
    srand(time(NULL));
}

//------------------------------------------------------------------------------
// FunciÛn: MAT_RaizCuadrada
// PropÛsito: Calcula la raiz cuadrada de un float
//------------------------------------------------------------------------------

inline float MAT_RaizCuadrada(float numero)
{
    //return 1.0f / MAT_InvRaizCuadrada(numero);

    return sqrtf(numero);
}

//------------------------------------------------------------------------------
// FunciÛn: MAT_NormalizarAngulo360
// PropÛsito: Devuelve un ·ngulo normalizado entre [0 <= angle < 360]
//------------------------------------------------------------------------------

inline float MAT_NormalizarAngulo360(float angulo)
{
    while (angulo > 360.0f)
    {
        angulo -= 360.0f;
    }

    while (angulo < 0.0f)
    {
        angulo += 360.0f;
    }

    return angulo;
}

//------------------------------------------------------------------------------
// FunciÛn: MAT_NormalizarAngulo180
// PropÛsito: Devuelve un ·ngulo normalizado entre [-180 < angulo <= 180]
//------------------------------------------------------------------------------

inline float MAT_NormalizarAngulo180(float angulo)
{
    angulo = MAT_NormalizarAngulo360(angulo);
    if (angulo > 180.0f)
    {
        angulo -= 360.0f;
    }
    return angulo;
}

enum eVertexFormat
{

    VERTEX_3D_FORMAT,
    VERTEX_3D_NORMALS_FORMAT,
    VERTEX_2D_FORMAT
};

struct VERTEX_3D
{

    GLshort x, y, z, padding;
    GLshort u, v;
};

struct VERTEX_3D_NORMALS
{

    GLshort x, y, z, v_padding;
    GLbyte nx, ny, nz, n_padding;
    GLshort u, v;
};

struct VERTEX_2D
{

    GLfloat x, y, z;
    GLfloat u, v;
};

struct COLOR
{

    float r, g, b, a;
};

class TextFont;

#define TEXT_FONT_MAX_STRING_SIZE 384

struct TextFontContext
{

    TextFont* pFont;
    char text[TEXT_FONT_MAX_STRING_SIZE];
};

struct cmp_str
{

    bool operator()(char const *a, char const *b)
    {
        return strcmp(a, b) < 0;
    }
};

#include "vector.h"
#include "matrix.h"

//--------------------------------------------------------------------
// FunciÛn:    UTIL_NextWord
// PropÛsito:  Avanza dwPos hasta la prÛxima palabra de la cadena szBuff[dwPos]
// Fecha:      19/07/2004 18:59
//--------------------------------------------------------------------

inline void UTIL_NextWord(char *szBuff, int &dwPos)
{
    //--- Va hasta el final de la palabra actual
    for (; szBuff[dwPos] != '\0' && szBuff[dwPos] != ' ' && szBuff[dwPos] != '\t' && szBuff[dwPos] != '('; dwPos++);
    //--- Se salta los espacios, tabs que haya
    for (; szBuff[dwPos] == ' ' || szBuff[dwPos] == '\t'; dwPos++);
}


//--------------------------------------------------------------------
// FunciÛn:    UTIL_TakeNextWord
// PropÛsito:  Mete en 'szWord' la prÛxima palabra de la cadena szBuff[dwPos]
// Fecha:      19/07/2004 18:58
//--------------------------------------------------------------------

inline void UTIL_TakeNextWord(char *szBuff, int &dwPos, char *szWord, const int dwMaxSize)
{
    int dwLen = (int) strlen((char*) szBuff);

    for (; szBuff[dwPos] == ' ' || szBuff[dwPos] == '\t' || szBuff[dwPos] == '(' || szBuff[dwPos] == ','
            || szBuff[dwPos] == ')';)
    {
        dwPos++;
    }

    int dw;
    for (dw = 0;
            szBuff[dwPos] != '\0' && szBuff[dwPos] != ' ' && szBuff[dwPos] != '\t' && szBuff[dwPos] != '(' &&
            szBuff[dwPos] != ')' && szBuff[dwPos] != ',' &&
            dw < dwMaxSize - 1 && dwPos < dwLen;
            dwPos++, dw++)
    {
        szWord[dw] = szBuff[dwPos];
    }
    szWord[dw] = 0;
}


//--------------------------------------------------------------------
// FunciÛn:    UTIL_TakeNextName
// PropÛsito:  Coge el nombre que viene a partir de dwPos
//			   El nombre tiene que estar entre comillas y puede contener espacios
// Fecha:      19/07/2004 18:57
//--------------------------------------------------------------------

inline void UTIL_TakeNextName(const char *szLine, int &dwPos, char *szName, const int dwMaxSize)
{
    int dwLen = (int) strlen(szLine);
    bool bFnd;

    szName[0] = '\0';
    for (bFnd = true; dwPos < dwLen; dwPos++)
    {
        if (szLine[dwPos] == '\x22')
        {
            dwPos++;
            bFnd = true;
            break;
        }
    }
    if (!bFnd)
    {
        //LOG.Write(LOG_APP, "#°[E] Se esperaba un nombre entre comillas [%s]", szLine);
        return;
    }
    int i;
    for (i = 0, bFnd = false; dwPos < dwLen && i < dwMaxSize - 1; i++, dwPos++)
    {
        if (szLine[dwPos] == '\x22')
        {
            bFnd = true;
            break;
        }
        szName[i] = szLine[dwPos];
    }
    szName[i] = '\x0';
    if (!bFnd)
    {
        //LOG.Write(LOG_APP, "#°[E] No se han encontrado comillas finales o se ha llegado a dwMaxSize antes de las comillas");
        //LOG.Write(LOG_APP, "#°[E] [%s]", szLine);
    }
}

//--------------------------------------------------------------------
// FunciÛn:    UTIL_ToUpper
// PropÛsito:
// Fecha:      19/07/2004 18:49
//--------------------------------------------------------------------

inline void UTIL_ToUpper(const char *txt, char *upptxt)
{
    int i;

    for (i = 0; txt[i] != 0; i++)
    {
        if (txt[i] >= 'a' && txt[i] <= 'z')
            upptxt[i] = (char) (txt[i]-('a' - 'A'));
        else
            upptxt[i] = txt[i];
    }
    upptxt[i] = 0;
}
 

//--------------------------------------------------------------------
// FunciÛn:    UTIL_GetExtension
// PropÛsito:  Coge la extensiÛn del fichero de un path
// Fecha:      19/07/2004 18:51
//--------------------------------------------------------------------

inline void UTIL_GetExtension(const char *szPathName, char *szExt)
{
    int i, dwLen = (int) strlen(szPathName);
    szExt[0] = '\0';
    for (i = dwLen; i > 0; --i)
    {
        if (szPathName[i] == '.')
        {
            memcpy(szExt, &szPathName[i + 1], dwLen - i);
            break;
        }
    }
}


//--------------------------------------------------------------------
// FunciÛn:    UTIL_GetFileName
// PropÛsito:  Coge el nombre del fichero de un path completo
// Fecha:      19/07/2004 18:53
//--------------------------------------------------------------------

inline void UTIL_GetFileName(const char *szPathName, char *szName)
{
    szName[0] = '\0';
    int dwLen = (int) strlen(szPathName);

    int i;
    for (i = dwLen; i > 0; i--)
    {
        if (szPathName[i] == '\\' || szPathName[i] == '/')
        {
            i++;
            break;
        }
    }
    ///--- dwLen+1 para que copie el 0 final
    for (int j = 0; i < dwLen + 1; j++, i++)
    {
        szName[j] = szPathName[i];
    }
}


//-------------------------------------------------------------------------------
// FunciÛn: UTIL_PreParseLine
// PropÛsito:
//-------------------------------------------------------------------------------

inline void UTIL_PreParseLine(char *szLine)
{
    ///---------------------------------
    ///--- Elimina espacios, tabs, etc.
    ///---------------------------------
    int dwLen = int(strlen(szLine));
    int dwPos;

    if (dwLen)
    {
        ///--- Si tiene, quita el retorno de carro, espacios finales, ...
        while (szLine[dwLen - 1] < 33 && szLine[dwLen - 1] > 0 && dwLen > 0)
        {
            --dwLen;
        }
        szLine[dwLen] = '\0';
        ///--- Recorre la lÌnea
        for (dwPos = 0; dwPos < dwLen;)
        {
            ///--- Si es un comentario pasa del resto de la lÌnea
            if (szLine[dwPos] == '/' && szLine[dwPos + 1] == '/')
            {
                szLine[dwPos] = '\0';
                break;
            }
            ///--- Elimina espacios y tabs
            if (szLine[dwPos] == ' ' || szLine[dwPos] == '\t')
            {
                //XTRACEX("%d %d %s [%s]", dwPos, dwLen, &szLine[dwPos], szLine);
                memmove(&szLine[dwPos], &szLine[dwPos + 1], dwLen - dwPos);
                --dwLen;
            }
                ///--- Si es un nombre entre comillas lo conserva
            else if (szLine[dwPos] == '\x22')
            {
                for (; dwPos < dwLen;)
                {
                    ++dwPos;
                    if (szLine[dwPos] == '\x22')
                    {
                        ++dwPos;
                        break;
                    }
                }
            }
            else
            {
                ///--- Es texto, sigue hasta espacio o tab
                for (; dwPos < dwLen;)
                {
                    ++dwPos;
                    if (szLine[dwPos] == ' ')
                    {
                        ///--- deja un espacio entre palabras
                        ++dwPos;
                        break;
                    }
                    else if (szLine[dwPos] == '\t')
                    {
                        ///--- Convierte el tab a espacio
                        szLine[dwPos] = ' ';
                        ++dwPos;
                        break;
                    }
                }
            }
        }
    }
}

inline char *str_replace(char *search, char *replace, char *subject)
{
	if (search == NULL || replace == NULL || subject == NULL) return NULL;
	if (strlen(search) == 0 || strlen(replace) == 0 || strlen(subject) == 0) return NULL;

	char *replaced = (char*)calloc(1, 1), *temp = NULL;
	char *p = subject, *p3 = subject, *p2;
	int  found = 0;

	while ( (p = strstr(p, search)) != NULL) {
		found = 1;
		temp = (char*)realloc(replaced, strlen(replaced) + (p - p3) + strlen(replace));
		if (temp == NULL) {
			free(replaced);
			return NULL;
		}
		replaced = temp;
		strncat(replaced, p - (p - p3), p - p3);
		strcat(replaced, replace);
		p3 = p + strlen(search);
		p += strlen(search);
		p2 = p;
	}

	if (found == 1) {
		if (strlen(p2) > 0) {
			temp = (char*)realloc(replaced, strlen(replaced) + strlen(p2) + 1);
			if (temp == NULL) {
				free(replaced);
				return NULL;
			}
			replaced = temp;
			strcat(replaced, p2);
		}
	} else {
		temp = (char*)realloc(replaced, strlen(subject) + 1);
		if (temp != NULL) {
			replaced = temp;
			strcpy(replaced, subject);
		}
	}
	return replaced;
}


#endif	/* _DEFINES_H */

