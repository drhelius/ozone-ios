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

using System;
using System.Collections.Generic;
using System.Text;

namespace Editor
{
    enum eRotationType
    {
        ROTATION_DISABLED,
        ROTATION_NORMAL,
        ROTATION_MIRROR
    };

    class ObjetoEscena
    {
        public byte tipo;   ///--- 0 es cubo, 1 es item, 2 es enemigo

        public short posX;
        public short posY;

        public byte id;

        public byte rotation;

        public bool dynamic;

        public short width;
        public short height;

        public string script;

        public string estilo;

        public int upper;

        public eRotationType rotation_type;


        //--------------------------------------------------------------------
        // Función:    ObjetoEscena
        // Propósito:  
        // Fecha:      miércoles, 01 de febrero de 2006, 15:23:50
        //--------------------------------------------------------------------
        public ObjetoEscena()
        {
        }


        //--------------------------------------------------------------------
        // Función:    ObjetoEscena
        // Propósito:  
        // Fecha:      miércoles, 01 de febrero de 2006, 10:34:50
        //--------------------------------------------------------------------
        public ObjetoEscena(byte tipo, byte id, short x, short y, byte rotation, short width, short height, string script,string estilo, int upper)
        {
            this.posX = x;
            this.posY = y;
            this.id = id;
            this.rotation = rotation;
            this.tipo = tipo;
            this.dynamic = false;
            this.width = width;
            this.height = height;
            this.script = script;
            this.estilo = estilo;
            this.upper = upper;
        }
    }
}
