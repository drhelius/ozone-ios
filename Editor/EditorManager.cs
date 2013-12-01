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
using System.Drawing;
using System.IO;
using System.Windows.Forms;


namespace Editor
{
    class EditorManager
    {
        private const int DISTANCIA_ORDENADO = 1300;
        public const string EDITOR_VERSION = "1.3.7";
        private const int SECTOR_WIDTH = 50;
        private const int SECTOR_HEIGHT = 40;
        private const int GRID_SIZE = 6;
        private const int CUBE_SIZE = GRID_SIZE * 8;
        private const byte FILE_VERSION = 3;

        public string CURRENT_FILE = "";


        public class CompareFileInfo : IComparer<FileInfo>
        {
            public int Compare(FileInfo x, FileInfo y)
            {                
                return x.Name.CompareTo(y.Name);                
            }
        }

        public class CompareDirectoryInfo : IComparer<DirectoryInfo>
        {
            public int Compare(DirectoryInfo x, DirectoryInfo y)
            {
                return x.Name.CompareTo(y.Name);
            }
        }

        public class CompareObjetoEscenaDistance : IComparer<ObjetoEscena>
        {
            public int Compare(ObjetoEscena x, ObjetoEscena y)
            {
                float distanceX = (float)Math.Sqrt(Math.Pow(x.posX - DISTANCIA_ORDENADO, 2) + Math.Pow(x.posY - (-DISTANCIA_ORDENADO), 2));
                float distanceY = (float)Math.Sqrt(Math.Pow(y.posX - DISTANCIA_ORDENADO, 2) + Math.Pow(y.posY - (-DISTANCIA_ORDENADO), 2));

                if (distanceX < distanceY)
                    return -1;
                else if (distanceX < distanceY)
                    return 1;
                else
                    return 0;
            }
        }

        struct Sector
        { 
            public List<int> staticObjectsIndices;
        };
  
        public int m_iCurrentFloor;
        public bool m_bPulsaBtnCentro;
        public bool m_bPulsaBtnIzqdo;

        private Font arial_small = new Font(new FontFamily("Arial"), 7, FontStyle.Bold);
        private Font arial = new Font(new FontFamily("Arial"), 10, FontStyle.Bold);
        private Font arial_teleport = new Font(new FontFamily("Arial"), 16, FontStyle.Bold);
        private Font arial2 = new Font(new FontFamily("Arial"), 13, FontStyle.Bold);

        private Point m_MouseCoordGuardadas;
        private Point m_MouseCoordPintarGuardadas;
        private Point m_MouseScreenCoordinates;
        private Point m_MouseRealCoordinates;
        private Point m_CameraCoordinates;

        private Brush m_BrownBrush = Brushes.Brown;
        private Pen m_BlackPen = new Pen(Color.Black);
        private Pen m_GrayPen = new Pen(Color.FromArgb(240, 240, 240));
        private Pen m_GridPen = new Pen(Color.FromArgb(88, 95, 104));
        private Pen m_DarkGrayPen = new Pen(Color.FromArgb(180, 180, 180));

        private Pen[] m_SelectorPen = new Pen[3];
        
        public const int NUM_ITEMS = 20;
        public const int NUM_ENEMS = 22;

        public bool m_bRenderScripts;
        public bool m_bRenderTriggers;

        private bool m_bShowItemCursor = false;

        private List<ObjetoEscena> m_ListaEscena = new List<ObjetoEscena>();

        private List<ObjetoEscena> m_ListaNivel1 = new List<ObjetoEscena>();
        private List<ObjetoEscena> m_ListaNivel2 = new List<ObjetoEscena>();

        public List<string[]> m_ListaScripts = new List<string[]>();
        


        public Dictionary<string, Bitmap[]> m_ImagenesCubos = new Dictionary<string,Bitmap[]>();
        public Dictionary<string, Bitmap[]> m_ImagenesDecos = new Dictionary<string, Bitmap[]>();
        public Bitmap[] m_ImagenesFondos;
        private Bitmap[] m_ImagenesItems = new Bitmap[NUM_ITEMS];
        private Bitmap[] m_ImagenesEnems = new Bitmap[NUM_ENEMS];

        private Bitmap[] m_ImagenSelectorCubo = new Bitmap[3];
        private Bitmap m_ImagenHoverCubo;
        private Bitmap m_ImagenTransporter;

        private MainForm m_TheForm;

        private byte m_iRotation;

        public bool m_bRedKey, m_bBlueKey, m_bExit, m_bStart, m_bExitTrigger, m_bStartTrigger, m_bFondoActivo, m_bRectActivo;

        public int m_iGemCount;

        private int m_iCubeCount;

        private int m_iBackground;

        public int m_iTeleport;


        //********************************************************************
        // Property:   Background
        // Propósito:  
        // Fecha:      lunes, 23 de octubre de 2006, 18:32:17
        //********************************************************************
        public int Background
        {
            set 
            {
                m_iBackground = value;
            }
            get
            {
                return m_iBackground;
            }
        }

        public bool RectsActivate
        {
            set
            {
                m_bRectActivo = value;
            }
            get
            {
                return m_bRectActivo;
            }
        }   

        //********************************************************************
        // Property:   Background
        // Propósito:  
        // Fecha:      lunes, 23 de octubre de 2006, 18:30:47
        //********************************************************************
        public bool BackgroundActivate
        {
            set { m_bFondoActivo = value; }
            get { return m_bFondoActivo; }
        }              

        //********************************************************************
        // Property:   MouseRealCoordinates
        // Propósito:  
        // Fecha:      martes, 07 de febrero de 2006, 13:09:48
        //********************************************************************
        public Point MouseRealCoordinates
        {            
            get { return m_MouseRealCoordinates; }
        }

        //********************************************************************
        // Property:   CameraCoordinateX
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 10:24:43
        //********************************************************************
        public int CameraCoordinateX
        {
            set { m_CameraCoordinates.X = value; }
            get { return m_CameraCoordinates.X; }
        }


        //********************************************************************
        // Property:   CameraCoordinateY
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 10:44:21
        //********************************************************************
        public int CameraCoordinateY
        {
            set { m_CameraCoordinates.Y = value; }
            get { return m_CameraCoordinates.Y; }
        }


        //********************************************************************
        // Property:   ShowItemCursor
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 10:14:11
        //********************************************************************
        public bool ShowItemCursor
        {
            set { m_bShowItemCursor = value; }
            get { return m_bShowItemCursor; }
        }


        //********************************************************************
        // Property:   Rotation
        // Propósito:  
        // Fecha:      lunes, 30 de enero de 2006, 16:07:08
        //********************************************************************
        public byte Rotation
        {
            set { m_iRotation = value; }
            get { return m_iRotation; }
        }


        //--------------------------------------------------------------------
        // Función:    Start
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 10:05:13
        //--------------------------------------------------------------------
        public void Start(MainForm theForm)
        {
            m_TheForm = theForm;

            m_SelectorPen[0] = new Pen(Color.FromArgb(255, 160, 160));
            m_SelectorPen[1] = new Pen(Color.FromArgb(160, 220, 160));
            m_SelectorPen[2] = new Pen(Color.FromArgb(160, 210, 230));
        

            m_ImagenSelectorCubo[0] = (Bitmap)Bitmap.FromFile("gfx/selector.png");
            m_ImagenSelectorCubo[1] = (Bitmap)Bitmap.FromFile("gfx/selector1.png");
            m_ImagenSelectorCubo[2] = (Bitmap)Bitmap.FromFile("gfx/selector2.png");
            m_ImagenTransporter = (Bitmap)Bitmap.FromFile("gfx/trans_editor.png");
            m_ImagenHoverCubo = (Bitmap)Bitmap.FromFile("gfx/selector_over.png");

            m_TheForm.imageListTrans.Images.Add(m_ImagenTransporter);

            /////

            FileInfo[] rgFiles;
            int i = 0;

            //

            DirectoryInfo di = new DirectoryInfo("gfx/episodes");
            DirectoryInfo[] rgDirs = di.GetDirectories();

            Array.Sort(rgDirs, new CompareDirectoryInfo());

            foreach (DirectoryInfo din in rgDirs)
            {
                if (din.Name.StartsWith("."))
                {
                    continue;
                }

                m_TheForm.comboBoxEstilos.Items.Add(din.Name);    

                DirectoryInfo dinfo = new DirectoryInfo("gfx/episodes/" + din.Name + "/cubes");
                rgFiles = dinfo.GetFiles("*_cube.png");
                Array.Sort(rgFiles, new CompareFileInfo());

                Bitmap[] tempListCubes = new Bitmap[rgFiles.Length];

                i = 0;

                foreach (FileInfo fi in rgFiles)
                {
                    tempListCubes[i] = (Bitmap)Bitmap.FromFile(fi.FullName);
                    i++;
                }

                m_ImagenesCubos.Add(din.Name, tempListCubes);




                dinfo = new DirectoryInfo("gfx/episodes/" + din.Name + "/decor");
                rgFiles = dinfo.GetFiles("*_decor.png");
                Array.Sort(rgFiles, new CompareFileInfo());

                Bitmap[] tempListDecor = new Bitmap[rgFiles.Length];

                i = 0;

                foreach (FileInfo fi in rgFiles)
                {
                    tempListDecor[i] = (Bitmap)Bitmap.FromFile(fi.FullName);
                    i++;
                }

                m_ImagenesDecos.Add(din.Name, tempListDecor);



                dinfo = new DirectoryInfo("gfx/episodes/" + din.Name + "/scripts");
                rgFiles = dinfo.GetFiles("*.script");
                Array.Sort(rgFiles, new CompareFileInfo());

                string[] tempListScripts = new string[rgFiles.Length +1 ];

                i = 0;

                tempListScripts[i] = " - none - ";

                foreach (FileInfo fi in rgFiles)
                {
                    tempListScripts[i + 1] = fi.Name.Replace(".script", "");
                    i++;
                }

                m_ListaScripts.Add(tempListScripts);

            }

            m_TheForm.comboBoxEstilos.SelectedIndex = 0;

            foreach (Bitmap bmp in m_ImagenesCubos[m_TheForm.comboBoxEstilos.Text])
            {
                m_TheForm.imageListCubos.Images.Add(bmp);
            }

            foreach (Bitmap bmp in m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text])
            {
                m_TheForm.imageListDeco.Images.Add(bmp);
            }
           
           
            //////

            di = new DirectoryInfo("gfx/bg");
            rgFiles = di.GetFiles("*.png");

            Array.Sort(rgFiles, new CompareFileInfo());


            m_ImagenesFondos = new Bitmap[rgFiles.Length];

            i = 0;          

            foreach (FileInfo fi in rgFiles)
            {
                m_ImagenesFondos[i] = (Bitmap)Bitmap.FromFile(fi.FullName);

                m_TheForm.comboBoxFondo.Items.Add(fi.Name);
                
                i++;
            }

            m_TheForm.comboBoxFondo.SelectedIndex = 0;


            /////////
/*
            di = new DirectoryInfo("scripts");
            rgFiles = di.GetFiles("*.script");

            Array.Sort(rgFiles, new CompareFileInfo());           

            i = 0;

            m_TheForm.comboBoxScripts.Items.Add(" - none - ");

            foreach (FileInfo fi in rgFiles)
            {     

                m_TheForm.comboBoxScripts.Items.Add(fi.Name.Replace(".script",""));

                i++;
            }

            m_TheForm.comboBoxScripts.SelectedIndex = 0;
*/
            /////////
            /*
            for (i = 0; i < NUM_DECOS; i++)
            {
                int index = i + 1;
                m_ImagenesDecos[i] = (Bitmap)Bitmap.FromFile("gfx/decor/" + ((index >= 10) ? index.ToString() : ("0" + index.ToString())) + "_decor.png");
            }

            for (i = 0; i < NUM_DECOS; i++)
            {
                m_TheForm.imageListDeco.Images.Add(m_ImagenesDecos[i]);
            }

            */
            for (i = 0; i < NUM_ITEMS; i++)
            {
                int index = i + 1;
                m_ImagenesItems[i] = (Bitmap)Bitmap.FromFile("gfx/items/" + ((index >= 10) ? index.ToString() : ("0" + index.ToString())) + "_item.png");
            }

            for (i = 0; i < NUM_ITEMS; i++)
            {
                m_TheForm.imageListItems.Images.Add(m_ImagenesItems[i]);
            }

            for (i = 0; i < NUM_ENEMS; i++)
            {
                int index = i + 1;

                m_ImagenesEnems[i] = (Bitmap)Bitmap.FromFile("gfx/entities/" + ((index >= 10) ? index.ToString() : ("0" + index.ToString())) + "_ent.png");            
            }

            for (i = 0; i < NUM_ENEMS; i++)
            {
                m_TheForm.imageListEnems.Images.Add(m_ImagenesEnems[i]);
            
            }

            m_TheForm.comboBoxFondo.SelectedIndex = 0;
            m_TheForm.comboBoxEstilos.SelectedIndex = 0;
            m_TheForm.comboBoxEstilos.SelectedIndex = 0;
            ResetScene();

            m_TheForm.Text = "Ozone iPhone Editor " + EDITOR_VERSION + " ";
        }


        //--------------------------------------------------------------------
        // Función:    Render
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 10:05:19
        //--------------------------------------------------------------------
        public void Render(Graphics gfx)
        {            
            gfx.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.NearestNeighbor;

            if (m_bFondoActivo)
            {
                for (int i = 0; i < 20; i++)
                {
                    for (int j = 0; j < 15; j++)
                    {
                        gfx.DrawImage(m_ImagenesFondos[m_iBackground], i*128, j*128, m_ImagenesFondos[m_iBackground].Width, m_ImagenesFondos[m_iBackground].Height);
                    }
                }
            }
            else
            {
                for (int i = 0; i < 500; i++)
                {
                    gfx.DrawLine(m_GridPen, 0, GRID_SIZE * i, 3000, GRID_SIZE * i);
                }

                for (int i = 0; i < 500; i++)
                {
                    gfx.DrawLine(m_GridPen, GRID_SIZE * i, 0, GRID_SIZE * i, 2000);
                }
            }

            

      
            RenderScene(gfx);

            if (m_TheForm.checkBoxPantalla.Checked)
            {
                if (m_bShowItemCursor)
                {
                    gfx.DrawRectangle(m_BlackPen, (m_MouseScreenCoordinates.X * GRID_SIZE) - 240, (m_MouseScreenCoordinates.Y * GRID_SIZE) - 168, 480, 336);
                    gfx.DrawRectangle(Pens.White, (m_MouseScreenCoordinates.X * GRID_SIZE) - 241, (m_MouseScreenCoordinates.Y * GRID_SIZE) - 169, 482, 338);
                }
            }
            else if (m_bShowItemCursor)
            {
                if (m_TheForm.radioItems.Checked && m_TheForm.listViewTextures.SelectedIndices.Count == 1 && m_TheForm.comboBoxPiso.SelectedIndex == 0)
                {

                    for (int j = 0; j < m_TheForm.numericUpDownCursorY.Value; j++)
                        for (int i = (int)(m_TheForm.numericUpDownCursorX.Value) - 1; i >=0 ; i--)
                        {
                
                            eRotationType temp;
                                            
                            temp = eRotationType.ROTATION_DISABLED;

                            if (m_TheForm.listViewTextures.SelectedIndices[0] == 6)
                                temp = eRotationType.ROTATION_NORMAL;


                            if (temp == eRotationType.ROTATION_NORMAL)
                            {

                                if (Rotation == 1)
                                {
                                    m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate90FlipNone);
                                }
                                else if (Rotation == 2)
                                {
                                    m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate180FlipNone);
                                }
                                else if (Rotation == 3)
                                {
                                    m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate270FlipNone);
                                }
                            }

                            gfx.DrawImage(m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]], (m_MouseScreenCoordinates.X * GRID_SIZE) + (CUBE_SIZE * i), (m_MouseScreenCoordinates.Y * GRID_SIZE) + (CUBE_SIZE * j), m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]].Width, m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]].Height);

                            if (temp == eRotationType.ROTATION_NORMAL)
                            {
                                if (Rotation == 1)
                                {
                                    m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate270FlipNone);
                                }
                                else if (Rotation == 2)
                                {
                                    m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate180FlipNone);
                                }
                                else if (Rotation == 3)
                                {
                                    m_ImagenesItems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate90FlipNone);
                                }
                            }

                            if (m_TheForm.checkBoxSelector.Checked)
                                gfx.DrawImage(m_ImagenSelectorCubo[m_iCurrentFloor], (m_MouseScreenCoordinates.X * GRID_SIZE) + (CUBE_SIZE * i) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), (m_MouseScreenCoordinates.Y * GRID_SIZE) - 18 + (CUBE_SIZE * j) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), m_ImagenSelectorCubo[m_iCurrentFloor].Width, m_ImagenSelectorCubo[m_iCurrentFloor].Height);
                        }
                }
                else if (m_TheForm.radioEnemigos.Checked && m_TheForm.listViewTextures.SelectedIndices.Count == 1 && m_TheForm.comboBoxPiso.SelectedIndex == 0)
                {


                    for (int j = 0; j < m_TheForm.numericUpDownCursorY.Value; j++)
                        for (int i = (int)(m_TheForm.numericUpDownCursorX.Value) - 1; i >= 0; i--)
                        {
                            eRotationType temp = eRotationType.ROTATION_NORMAL;

                            switch (m_TheForm.listViewTextures.SelectedIndices[0])
                            {
                                case 3:
                                case 5:
                                case 7:
                                case 8:                                
                                    {
                                        temp = eRotationType.ROTATION_DISABLED;
                                        break;
                                    }
                                case 6:
                                case 13:
                                case 14:
                                case 16:
                                    {
                                        temp = eRotationType.ROTATION_MIRROR;
                                        break;
                                    }
                            }

                            if (temp == eRotationType.ROTATION_NORMAL)
                            {
                                if (Rotation == 1)
                                {
                                    m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate90FlipNone);
                                }
                                else if (Rotation == 2)
                                {
                                    m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate180FlipNone);
                                }
                                else if (Rotation == 3)
                                {
                                    m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate270FlipNone);
                                }
                            }
                            else if (temp == eRotationType.ROTATION_MIRROR)
                            {
                                if (Rotation > 1)
                                {
                                    m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.RotateNoneFlipX);
                                }                                
                            }

                            gfx.DrawImage(m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]], (m_MouseScreenCoordinates.X * GRID_SIZE) + (CUBE_SIZE * i), (m_MouseScreenCoordinates.Y * GRID_SIZE) + (CUBE_SIZE * j), m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].Width, m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].Height);

                            if (temp == eRotationType.ROTATION_NORMAL)
                            {
                                if (Rotation == 1)
                                {
                                    m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate270FlipNone);
                                }
                                else if (Rotation == 2)
                                {
                                    m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate180FlipNone);
                                }
                                else if (Rotation == 3)
                                {
                                    m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate90FlipNone);
                                }
                            }
                            else if (temp == eRotationType.ROTATION_MIRROR)
                            {
                                if (Rotation > 1)
                                {                                   
                                    m_ImagenesEnems[m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.RotateNoneFlipX);
                                }
                            }

                            if (m_TheForm.checkBoxSelector.Checked)
                                gfx.DrawImage(m_ImagenSelectorCubo[m_iCurrentFloor], (m_MouseScreenCoordinates.X * GRID_SIZE) + (CUBE_SIZE * i) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), (m_MouseScreenCoordinates.Y * GRID_SIZE) - 18 + (CUBE_SIZE * j) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), m_ImagenSelectorCubo[m_iCurrentFloor].Width, m_ImagenSelectorCubo[m_iCurrentFloor].Height);
                        }
                }
                else if (m_TheForm.radioTransport.Checked && m_TheForm.listViewTextures.SelectedIndices.Count == 1 && m_TheForm.comboBoxPiso.SelectedIndex == 0)
                {


                    gfx.DrawImage(m_ImagenTransporter, (m_MouseScreenCoordinates.X * GRID_SIZE), (m_MouseScreenCoordinates.Y * GRID_SIZE), CUBE_SIZE, CUBE_SIZE);

                    if (m_TheForm.checkBoxSelector.Checked)
                        gfx.DrawImage(m_ImagenSelectorCubo[m_iCurrentFloor], (m_MouseScreenCoordinates.X * GRID_SIZE)  + (9 * m_TheForm.comboBoxPiso.SelectedIndex), (m_MouseScreenCoordinates.Y * GRID_SIZE) - 18 - (18 * m_TheForm.comboBoxPiso.SelectedIndex), m_ImagenSelectorCubo[m_iCurrentFloor].Width, m_ImagenSelectorCubo[m_iCurrentFloor].Height);
                        
                }
                else if (m_TheForm.radioDecoration.Checked && m_TheForm.listViewTextures.SelectedIndices.Count == 1)
                {


                    for (int j = 0; j < m_TheForm.numericUpDownCursorY.Value; j++)
                        for (int i = (int)(m_TheForm.numericUpDownCursorX.Value) - 1; i >= 0; i--)
                        {
                            if (Rotation == 1)
                            {
                                m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate90FlipNone);
                            }
                            else if (Rotation == 2)
                            {
                                m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate180FlipNone);
                            }
                            else if (Rotation == 3)
                            {
                                m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate270FlipNone);
                            }

                            gfx.DrawImage(m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]], (m_MouseScreenCoordinates.X * GRID_SIZE) + (CUBE_SIZE * i) + (9 * (m_TheForm.comboBoxPiso.SelectedIndex + 1)), (m_MouseScreenCoordinates.Y * GRID_SIZE) + (CUBE_SIZE * j) - (18 * (m_TheForm.comboBoxPiso.SelectedIndex + 1)), m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]].Width, m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]].Height);

                            if (Rotation == 1)
                            {
                                m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate270FlipNone);
                            }
                            else if (Rotation == 2)
                            {
                                m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate180FlipNone);
                            }
                            else if (Rotation == 3)
                            {
                                m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]].RotateFlip(RotateFlipType.Rotate90FlipNone);
                            }

                            if (m_TheForm.checkBoxSelector.Checked)
                                gfx.DrawImage(m_ImagenSelectorCubo[m_iCurrentFloor], (m_MouseScreenCoordinates.X * GRID_SIZE) + (CUBE_SIZE * i) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), (m_MouseScreenCoordinates.Y * GRID_SIZE) - 18 + (CUBE_SIZE * j) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), m_ImagenSelectorCubo[m_iCurrentFloor].Width, m_ImagenSelectorCubo[m_iCurrentFloor].Height);
                        }
                }
                else
                {
                    Image img = m_TheForm.listViewTextures.SelectedIndices.Count != 0 ? m_ImagenesCubos[m_TheForm.comboBoxEstilos.Text][m_TheForm.listViewTextures.SelectedIndices[0]] : m_ImagenSelectorCubo[m_iCurrentFloor];

                    if (m_TheForm.checkBoxSelector.Checked)
                    {
                        img = m_ImagenSelectorCubo[m_iCurrentFloor];
                    }

                    for (int j = 0; j < m_TheForm.numericUpDownCursorY.Value; j++)
                        for (int i = (int)(m_TheForm.numericUpDownCursorX.Value) - 1; i >= 0; i--)
                        {    
                        
                            gfx.DrawImage(img, (m_MouseScreenCoordinates.X * GRID_SIZE) + (CUBE_SIZE * i) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), (m_MouseScreenCoordinates.Y * GRID_SIZE) - 18 + (CUBE_SIZE * j) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), m_ImagenSelectorCubo[m_iCurrentFloor].Width, m_ImagenSelectorCubo[m_iCurrentFloor].Height);

                            if (!m_TheForm.checkBoxSelector.Checked && m_TheForm.checkBoxWireframe.Checked)
                            {
                                gfx.DrawImage(m_ImagenHoverCubo, (m_MouseScreenCoordinates.X * GRID_SIZE) + (CUBE_SIZE * i) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), (m_MouseScreenCoordinates.Y * GRID_SIZE) - 18 + (CUBE_SIZE * j) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), m_ImagenSelectorCubo[m_iCurrentFloor].Width, m_ImagenSelectorCubo[m_iCurrentFloor].Height);
                            }
                        }
                }
            }
        }


        //--------------------------------------------------------------------
        // Función:    MouseMove
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 10:15:39
        //--------------------------------------------------------------------
        public void MouseMove(Point location, MouseButtons button, MouseEventArgs e)
        {
            m_MouseScreenCoordinates.X = (location.X / GRID_SIZE);
            m_MouseScreenCoordinates.Y = (location.Y / GRID_SIZE);

            m_MouseRealCoordinates.X = m_MouseScreenCoordinates.X + m_CameraCoordinates.X;
            m_MouseRealCoordinates.Y = m_MouseScreenCoordinates.Y + m_CameraCoordinates.Y;

            m_TheForm.textBoxX.Text = m_MouseRealCoordinates.X.ToString();
            m_TheForm.textBoxY.Text = m_MouseRealCoordinates.Y.ToString();

            if (button == MouseButtons.Middle)
            {
                if (!m_bPulsaBtnCentro)
                {
                    m_bPulsaBtnCentro = true;
                    m_MouseCoordGuardadas = m_MouseRealCoordinates;
                }

                CameraCoordinateX = m_MouseCoordGuardadas.X - m_MouseScreenCoordinates.X;
                CameraCoordinateY = m_MouseCoordGuardadas.Y - m_MouseScreenCoordinates.Y;

                CameraCoordinateX = Math.Max(0, CameraCoordinateX);
                CameraCoordinateY = Math.Max(0, CameraCoordinateY);

                CameraCoordinateX = Math.Min(1000, CameraCoordinateX);
                CameraCoordinateY = Math.Min(1000, CameraCoordinateY);

                m_TheForm.verticalScrollBar.Value = CameraCoordinateY;
                m_TheForm.horizontalScrollBar.Value = CameraCoordinateX;
                /*
                CameraCoordinateX -= difx;
                CameraCoordinateY -= dify;*/
            }
            else if (button == MouseButtons.Left)
            {
                if (!m_bPulsaBtnIzqdo)
                {
                    m_bPulsaBtnIzqdo = true;
                    m_MouseCoordPintarGuardadas = m_MouseRealCoordinates;
                }

                if (m_MouseCoordPintarGuardadas != m_MouseRealCoordinates)
                {
                    m_MouseCoordPintarGuardadas = m_MouseRealCoordinates;

                    m_TheForm.pictureBoxRendering_MouseDown(this, e);
                }
            }
        }


        //--------------------------------------------------------------------
        // Función:    DeleteObject
        // Propósito:  
        // Fecha:      lunes, 30 de enero de 2006, 10:38:00
        //--------------------------------------------------------------------
        public void DeleteObject(byte tipo)
        {
            Point pos = m_MouseRealCoordinates;
            List<ObjetoEscena> lista = null;

            switch (m_TheForm.comboBoxPiso.SelectedIndex)
            {
                case 0:
                {
                    lista = m_ListaEscena;
                    break;
                }
                case 1:
                {
                    lista = m_ListaNivel1;
                    //pos.X += 3;
                    //pos.Y -= 6;
                    break;
                }
                case 2:
                {
                    lista = m_ListaNivel2;
                    //pos.X += 6;
                    //pos.Y -= 12;
                    break;
                }
            }

            ObjetoEscena temp = null;            

            foreach (ObjetoEscena c in lista)
            {
                if (c.tipo != tipo)
                    continue;

                

                if ((pos.X >= c.posX) && (pos.X < (c.posX + 8)) && (pos.Y >= c.posY) && (pos.Y < (c.posY + 8)))
                {
                    temp = c;

                    ///--- llave roja
                    if (c.tipo == 1 && c.id == 7)
                    {
                        m_bRedKey = false;
                    }

                    ///--- llave azul
                    if (c.tipo == 1 && c.id == 8)
                    {
                        m_bBlueKey = false;
                    }

                    if (c.tipo == 1 && c.id == 1)
                    {
                        m_bExit = false;
                    }
                    if (c.tipo == 1 && c.id == 0)
                    {
                        m_bStart = false;
                    }
             

                    break;
                }               
            }

            if (temp != null)
            {
                lista.Remove(temp);

                if (temp.tipo == 1 && temp.id == 2)
                {
                    m_iGemCount--;
                }

                if (temp.tipo == 3)
                {
                    if (temp.rotation == (m_iTeleport / 2))
                    {
                        m_iTeleport--;
                    }

                    ObjetoEscena delete = null;

                    foreach (ObjetoEscena c in lista)
                    {
                        if (c.tipo == 3)
                        {
                            if (c.rotation == temp.rotation)
                            {
                                delete = c;
                                break;
                            }
                        }
                    }

                    lista.Remove(delete);

                }

                ///--- actualizar contadores


                if (temp.tipo == 0)
                {
                    m_iCubeCount--;
                }

                m_TheForm.textBoxGemas.Text = m_iGemCount.ToString();

                m_TheForm.textBoxCubos.Text = m_iCubeCount.ToString();

                m_TheForm.textBoxTeleport.Text = ((byte)(m_iTeleport / 2)).ToString();

                m_TheForm.textBoxElements.Text = (m_ListaEscena.Count + m_ListaNivel1.Count + m_ListaNivel2.Count).ToString();


            }
        }

        public void ClearAll(byte tipo)
        {
            ClearAll(tipo, -1);
        }

        public void ClearAll(byte tipo, int id)
        {
            for (int l = 0; l < 3; l++)
            {
                List<ObjetoEscena> lista = null;
                switch (l)
                {
                    case 0:
                    {
                        lista = m_ListaEscena;
                        break;
                    }
                    case 1:
                    {
                        lista = m_ListaNivel1;
                        break;
                    }
                    case 2:
                    {
                        lista = m_ListaNivel2;
                        break;
                    }
                }


                ObjetoEscena temp = null;

                

                for (int i = lista.Count-1; i >= 0 ; i--)
                {
                    temp = lista[i];

                    if (temp.tipo == tipo)
                    {
                        if (id >= 0)
                        {
                            if (temp.id != id)
                            {
                                continue;
                            }
                        }

                        lista.RemoveAt(i);

                        if (temp.tipo == 1 && temp.id == 2)
                        {
                            m_iGemCount--;
                        }

                        if (temp.tipo == 3)
                        {
                            m_iTeleport--;  
                        }

                        ///--- actualizar contadores


                        if (temp.tipo == 0)
                        {
                            m_iCubeCount--;
                        }

                        m_TheForm.textBoxGemas.Text = m_iGemCount.ToString();

                        m_TheForm.textBoxCubos.Text = m_iCubeCount.ToString();

                        m_TheForm.textBoxTeleport.Text = ((byte)(m_iTeleport / 2)).ToString();

                        m_TheForm.textBoxElements.Text = (m_ListaEscena.Count + m_ListaNivel1.Count + m_ListaNivel2.Count).ToString();

                    }
                }
            }

        }


        //--------------------------------------------------------------------
        // Función:    AddObject
        // Propósito:  
        // Fecha:      martes, 24 de octubre de 2006, 17:44:57
        //--------------------------------------------------------------------
        public void AddCubeLevel(byte tipo, byte id, byte rot, string script, int offsetX, int offsetY, Point pos, int piso, string estilo)
        {
            List<ObjetoEscena> lista = null;

            switch (piso)
            {                
                case 1:
                {
                    lista = m_ListaNivel1;
                    break;
                }
                case 2:
                {
                    lista = m_ListaNivel2;
                    break;
                }
            }
            
            Point coord = new Point(pos.X + offsetX, pos.Y + offsetY);

            short width = 8;
            short height = 8;

            switch (tipo)
            {
                case 1:
                {
                    width = (short)(m_ImagenesItems[id].Width / GRID_SIZE);
                    height = (short)(m_ImagenesItems[id].Height / GRID_SIZE);
                    break;
                }
                case 2:
                {
                    width = (short)(m_ImagenesEnems[id].Width / GRID_SIZE);
                    height = (short)(m_ImagenesEnems[id].Height / GRID_SIZE);
                    break;
                }
                case 3:
                {
                    width = (short)(m_ImagenTransporter.Width / GRID_SIZE);
                    height = (short)(m_ImagenTransporter.Height / GRID_SIZE);
                    break;
                }
                case 4:
                {
                    width = (short)(m_ImagenesDecos[estilo][id].Width / GRID_SIZE);
                    height = (short)(m_ImagenesDecos[estilo][id].Height / GRID_SIZE);
                    break;
                }
            }

            //string estilo = (tipo == 0 || tipo == 4) ? m_TheForm.comboBoxEstilos.Text : "";

            ObjetoEscena temp = new ObjetoEscena(tipo, id, (short)coord.X, (short)coord.Y, rot, width, height, script, estilo, -1);

            ///--- 0 es cubo, 1 es item, 2 es enemigo, 3 tele, 4 deco
            ///
            switch (tipo)
            {
                case 0:
                {
                    temp.rotation_type = eRotationType.ROTATION_DISABLED;
                    break;
                }
                case 1:
                {
                    temp.rotation_type = eRotationType.ROTATION_DISABLED;

                    if (id == 6)
                        temp.rotation_type = eRotationType.ROTATION_NORMAL;

                    break;
                }
                case 2:
                {
                    temp.rotation_type = eRotationType.ROTATION_NORMAL;

                    switch (id)
                    {
                        case 3:
                        case 5:
                        case 7:
                        case 8:
                        {
                            temp.rotation_type = eRotationType.ROTATION_DISABLED;
                            break;
                        }
                        case 6:
                        case 13:
                        case 14:
                        case 16:
                        {
                            temp.rotation_type = eRotationType.ROTATION_MIRROR;
                            break;
                        }
                    }
                    break;
                }
                case 3:
                {
                    temp.rotation_type = eRotationType.ROTATION_DISABLED;
                    break;
                }
                case 4:
                {
                    temp.rotation_type = eRotationType.ROTATION_NORMAL;
                    break;
                }

            }

            if (tipo == 0)
            {
                List<ObjetoEscena> lista_escena = null;
                if (piso == 1)
                {
                    lista_escena = m_ListaEscena;
                }
                else if (piso == 2)
                {
                    lista_escena = m_ListaNivel1;
                }

                if (lista_escena != null)
                {
                    int i = 0;
                    foreach (ObjetoEscena oe in lista_escena)
                    {
                        if ((oe.tipo == 0) && (oe.posX == temp.posX) && (oe.posY == temp.posY))
                        {
                            oe.upper = i;
                            break;
                        }
                        i++;
                    }
                }
            }

            if (script != "")
            {
                temp.dynamic = true;
            }

            if (tipo != 4 && !CheckValidPos(temp, piso))
                return;

            

            if (lista.Count == 0)
            {
                lista.Add(temp);
            }            
            else
            {
                int a = 0;

                float distanciaTemp = distance(temp.posX, temp.posY);

                if ((tipo == 1 && id == 1) || (tipo == 1 && id == 0))
                    distanciaTemp = 0;


                foreach (ObjetoEscena c in lista)
                {
                    float distanciaC = distance(c.posX, c.posY);

                    if ((c.tipo == 1 && c.id == 1) || (c.tipo == 1 && c.id == 0))
                        distanciaC = 0;

                    if (distanciaC < distanciaTemp)
                    {
                        a++;
                        continue;
                    }

                    break;
                }

                lista.Insert(a, temp);
            }

            ///--- actualizar contadores
            m_iCubeCount++;            
         
            m_TheForm.textBoxCubos.Text = m_iCubeCount.ToString();

            m_TheForm.textBoxElements.Text = (m_ListaEscena.Count + m_ListaNivel1.Count + m_ListaNivel2.Count).ToString();
            
        }       


        //--------------------------------------------------------------------
        // Función:    AddObject
        // Propósito:  
        // Fecha:      martes, 24 de octubre de 2006, 17:45:03
        //--------------------------------------------------------------------
        public void AddObject(byte tipo, byte id, byte rot, string script, int offsetX, int offsetY, Point pos, int piso, string estilo)
        {                      
            Point coord = new Point(pos.X + offsetX, pos.Y + offsetY);

            List<ObjetoEscena> lista = m_ListaEscena;

            short width = 8;
            short height = 8;

            switch (tipo)
            {                
                case 1:
                {
                    width = (short)(m_ImagenesItems[id].Width / GRID_SIZE);
                    height = (short)(m_ImagenesItems[id].Height / GRID_SIZE);
                    break;
                }
                case 2:
                {
                    width = (short)(m_ImagenesEnems[id].Width / GRID_SIZE);
                    height = (short)(m_ImagenesEnems[id].Height / GRID_SIZE);
                    break;
                }
                case 3:
                {
                    width = (short)(m_ImagenTransporter.Width / GRID_SIZE);
                    height = (short)(m_ImagenTransporter.Height / GRID_SIZE);
                    break;
                }
                case 4:
                {
                    width = (short)(m_ImagenesDecos[estilo][id].Width / GRID_SIZE);
                    height = (short)(m_ImagenesDecos[estilo][id].Height / GRID_SIZE);
                    break;
                }
            }

            //string estilo = (tipo == 0 || tipo == 4) ? m_TheForm.comboBoxEstilos.Text : "";

            ObjetoEscena temp = new ObjetoEscena(tipo, id, (short)coord.X, (short)coord.Y, rot, width, height, script, estilo, -1);

            ///--- 0 es cubo, 1 es item, 2 es enemigo, 3 tele, 4 deco
            ///
            switch (tipo)
            {
                case 0:
                    {
                        temp.rotation_type = eRotationType.ROTATION_DISABLED;
                        break;
                    }
                case 1:
                    {
                        temp.rotation_type = eRotationType.ROTATION_DISABLED;

                        if (id == 6)
                            temp.rotation_type = eRotationType.ROTATION_NORMAL;

                        break;
                    }
                case 2:
                    {
                        temp.rotation_type = eRotationType.ROTATION_NORMAL;

                        switch (id)
                        {
                            case 3:
                            case 5:
                            case 7:
                            case 8:
                                {
                                    temp.rotation_type = eRotationType.ROTATION_DISABLED;
                                    break;
                                }
                            case 6:
                            case 13:
                            case 14:
                            case 16:
                                {
                                    temp.rotation_type = eRotationType.ROTATION_MIRROR;
                                    break;
                                }
                        }
                        break;
                    }
                case 3:
                    {
                        temp.rotation_type = eRotationType.ROTATION_DISABLED;
                        break;
                    }
                case 4:
                    {
                        temp.rotation_type = eRotationType.ROTATION_NORMAL;
                        break;
                    }

            }

            if (tipo == 0)
            {
                List<ObjetoEscena> lista_escena = null;
                if (piso == 0)
                {
                    lista_escena = m_ListaNivel1;
                }
                else if (piso == 1)
                {
                    lista_escena = m_ListaNivel2;
                }

                if (lista_escena != null)
                {
                    int i = 0;
                    foreach (ObjetoEscena oe in lista_escena)
                    {
                        if ((oe.tipo == 0) && (oe.posX == temp.posX) && (oe.posY == temp.posY))
                        {
                            temp.upper = i;
                            break;
                        }
                        i++;
                    }
                }
            }

            if (script != "")
            {
                temp.dynamic = true;
            }

            if (tipo == 4)
            {  
                

                switch (piso)
                {
                    case 0:
                    {
                        lista = m_ListaEscena;
                        break;
                    }
                    case 1:
                    {
                        lista = m_ListaNivel1;
                        break;
                    }
                    case 2:
                    {
                        lista = m_ListaNivel2;
                        break;
                    }
                }

                foreach (ObjetoEscena c in lista)
                {
                    if (c.tipo == 4)
                    {
                        if ((coord.X == c.posX) && (coord.Y == c.posY))
                            return;
                    }

                    
                }

            }
            else if (tipo == 1 && id >= 10 && id <=12)
            {
                foreach (ObjetoEscena c in lista)
                {
                    if (c.tipo == 1 && c.id == id)
                    {
                        if ((coord.X == c.posX) && (coord.Y == c.posY))
                            return;
                    }
                }
            }
            else if (!CheckValidPos(temp, 0))
                return;
            
            bool bottom = false;            

            ///--- llave roja
            if (tipo == 1 && id == 7)
            {
                if (m_bRedKey)
                {
                    foreach (ObjetoEscena c in m_ListaEscena)
                    {
                        if (c.tipo == 1 && c.id == 7)
                        {
                            c.posX = (short)coord.X;
                            c.posY = (short)coord.Y;
                        }
                    }

                    return;
                }
                else
                {
                    m_bRedKey = true;
                }
            }

            ///--- llave azul
            if (tipo == 1 && id == 8)
            {
                if (m_bBlueKey)
                {
                    foreach (ObjetoEscena c in m_ListaEscena)
                    {
                        if (c.tipo == 1 && c.id == 8)
                        {
                            c.posX = (short)coord.X;
                            c.posY = (short)coord.Y;
                        }
                    }

                    return;
                }
                else
                {
                    m_bBlueKey = true;
                }
            }

            ///--- blades
            if (tipo == 2 && id >= 11 && id <= 12)
            {
                bottom = true;
            }


            ///--- salida del nivel
            if (tipo == 1 && id == 1)
            {
                if (m_bExit)
                {
                    foreach (ObjetoEscena c in m_ListaEscena)
                    {
                        if (c.tipo == 1 && c.id == 1)
                        {
                            c.posX = (short)coord.X;
                            c.posY = (short)coord.Y;
                        }
                    }

                    return;
                }
                else
                {
                    bottom = true;
                    m_bExit = true;
                }
            }

            ///--- entrada del nivel
            if (tipo == 1 && id == 0)
            {
                if (m_bStart)
                {
                    foreach (ObjetoEscena c in m_ListaEscena)
                    {
                        if (c.tipo == 1 && c.id == 0)
                        {
                            c.posX = (short)coord.X;
                            c.posY = (short)coord.Y;
                        }
                    }

                    return;
                }
                else
                {
                    bottom = true;
                    m_bStart = true;
                }
            }

            ///--- trigger de entrada del nivel
            if (tipo == 1 && id == 10)
            {
                if (m_bStartTrigger)
                {
                    foreach (ObjetoEscena c in m_ListaEscena)
                    {
                        if (c.tipo == 1 && c.id == 10)
                        {
                            c.posX = (short)coord.X;
                            c.posY = (short)coord.Y;
                        }
                    }

                    return;
                }
                else
                {
                    bottom = true;
                    m_bStartTrigger = true;
                }
            }

            ///--- trigger de entrada del nivel
            if (tipo == 1 && id == 11)
            {
                if (m_bExitTrigger)
                {
                    foreach (ObjetoEscena c in m_ListaEscena)
                    {
                        if (c.tipo == 1 && c.id == 11)
                        {
                            c.posX = (short)coord.X;
                            c.posY = (short)coord.Y;
                        }
                    }

                    return;
                }
                else
                {
                    bottom = true;
                    m_bExitTrigger = true;
                }
            }

                        

            ///--- si es un enemigo dinámico
            if (tipo == 2)
            {
                if ((id == 0) || (id == 3) || (id >= 18))
                {
                    temp.dynamic = true;
                }
            }

            ///--- transport
            if (tipo == 3)
            {
                if (rot == 100)
                {
                    temp.rotation = (byte)(m_iTeleport / 2);
                    m_iTeleport++;  
                }
                else
                {
                    temp.rotation = rot;

                    if ((rot*2) > (m_iTeleport - 2))
                    {
                        m_iTeleport = (rot*2) + 2;
                    }
                }
                              
            }

            if (lista.Count == 0)
            {
                lista.Add(temp);
            }
            else if (bottom)
            {
                lista.Insert(0, temp);
            }
            else
            {
                int a = 0;

                float distanciaTemp = distance(temp.posX, temp.posY);

                if ((tipo == 1 && id == 1) || (tipo == 1 && id == 0))
                    distanciaTemp = 0;


                foreach (ObjetoEscena c in lista)
                {
                    float distanciaC = distance(c.posX, c.posY);

                    if ((c.tipo == 1 && c.id == 1) || (c.tipo == 1 && c.id == 0))
                        distanciaC = 0;

                    if (distanciaC < distanciaTemp)
                    {
                        a++;
                        continue;
                    }

                    break;
                }

                lista.Insert(a, temp);
            }

            ///--- actualizar contadores
            
            if (tipo == 1 && id == 2)
            {
                m_iGemCount++;
            }

            if (tipo == 0)
            {
                m_iCubeCount++;
            }

            m_TheForm.textBoxGemas.Text = m_iGemCount.ToString();

            m_TheForm.textBoxCubos.Text = m_iCubeCount.ToString();

            m_TheForm.textBoxTeleport.Text = ((byte)(m_iTeleport / 2)).ToString();

            m_TheForm.textBoxElements.Text = (m_ListaEscena.Count + m_ListaNivel1.Count + m_ListaNivel2.Count).ToString();
        }

        private float distance(int x, int y)
        {
            return (float)Math.Sqrt(Math.Pow(x - DISTANCIA_ORDENADO, 2) + Math.Pow(y - (-DISTANCIA_ORDENADO), 2));
        }


        //--------------------------------------------------------------------
        // Función:    RenderScene
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 10:33:28
        //--------------------------------------------------------------------
        private void RenderScene(Graphics g)
        {
            if (!m_TheForm.checkBoxPantalla.Checked && m_bShowItemCursor && m_iCurrentFloor == 0)
            {
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], 0, (m_MouseScreenCoordinates.Y * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), 3000, (m_MouseScreenCoordinates.Y * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex));
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], (m_MouseScreenCoordinates.X * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 0, (m_MouseScreenCoordinates.X * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 2000);

                g.DrawLine(m_SelectorPen[m_iCurrentFloor], 0, ((m_MouseScreenCoordinates.Y + 8) * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), 3000, ((m_MouseScreenCoordinates.Y + 8) * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex));
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], ((m_MouseScreenCoordinates.X + 8) * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 0, ((m_MouseScreenCoordinates.X + 8) * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 2000);
            }


            foreach (ObjetoEscena c in m_ListaEscena)
            {
                
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (!m_bRenderScripts && c.script != "")
                    continue;

                ///--- cubo
                if (c.tipo == 0)
                {
                    g.DrawImage(m_ImagenesCubos[c.estilo][c.id], (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE), (c.posY * GRID_SIZE) - 18 - (m_CameraCoordinates.Y * GRID_SIZE), m_ImagenesCubos[c.estilo][c.id].Width, m_ImagenesCubos[c.estilo][c.id].Height);

                    if (m_TheForm.checkBoxWireframe.Checked)
                        g.DrawImage(m_ImagenHoverCubo, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE), (c.posY * GRID_SIZE) - 18 - (m_CameraCoordinates.Y * GRID_SIZE), m_ImagenesCubos[c.estilo][c.id].Width, m_ImagenesCubos[c.estilo][c.id].Height);

                    if (c.rotation != 0)
                    {
                        g.DrawString((c.rotation * 90).ToString() + "º", arial_teleport, Brushes.Black, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 6, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) + 7);
                        g.DrawString((c.rotation * 90).ToString() + "º", arial_teleport, Brushes.Yellow, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 8, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) + 6);
                    }

                    //g.DrawString(aaa.ToString()/* + " " + distance(c.posX, c.posY).ToString()*/, arial_small, Brushes.Black, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 8, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) + 7);
                }
                ///--- item
                else if (c.tipo == 1)
                {
                    if (c.id >= 10 && c.id <= 12 && !m_bRenderTriggers)
                        continue;

                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE);
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE);

                    if (m_bRectActivo)
                    {
                        if (c.rotation % 2 == 0)
                            g.DrawRectangle(m_SelectorPen[0], x, y, m_ImagenesItems[c.id].Width, m_ImagenesItems[c.id].Height);
                        else
                            g.DrawRectangle(m_SelectorPen[0], x, y, m_ImagenesItems[c.id].Height, m_ImagenesItems[c.id].Width);
                    }

                    if (c.rotation_type == eRotationType.ROTATION_NORMAL)
                    {
                        if (c.rotation == 1)
                        {
                            m_ImagenesItems[c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                        }
                        else if (c.rotation == 2)
                        {
                            m_ImagenesItems[c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                        }
                        else if (c.rotation == 3)
                        {
                            m_ImagenesItems[c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                        }
                    }
                        
                    g.DrawImage(m_ImagenesItems[c.id], x, y, m_ImagenesItems[c.id].Width, m_ImagenesItems[c.id].Height);

                    if (c.rotation_type == eRotationType.ROTATION_NORMAL)
                    {
                        if (c.rotation == 1)
                        {
                            m_ImagenesItems[c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                        }
                        else if (c.rotation == 2)
                        {
                            m_ImagenesItems[c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                        }
                        else if (c.rotation == 3)
                        {
                            m_ImagenesItems[c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                        }
                    }
                }
                ///--- enemigo
                else if (c.tipo == 2)
                {
                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE);
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE);

                    if (m_bRectActivo)
                    {
                        if (c.rotation % 2 == 0)
                            g.DrawRectangle(m_SelectorPen[0], x, y, m_ImagenesEnems[c.id].Width, m_ImagenesEnems[c.id].Height);
                        else
                            g.DrawRectangle(m_SelectorPen[0], x, y, m_ImagenesEnems[c.id].Height, m_ImagenesEnems[c.id].Width);
                    }

                    if (c.rotation_type == eRotationType.ROTATION_NORMAL)
                    {
                        if (c.rotation == 1)
                        {
                            m_ImagenesEnems[c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                        }
                        else if (c.rotation == 2)
                        {
                            m_ImagenesEnems[c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                        }
                        else if (c.rotation == 3)
                        {
                            m_ImagenesEnems[c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                        }
                    }
                    else if (c.rotation_type == eRotationType.ROTATION_MIRROR)
                    {
                        if (c.rotation > 1)
                        {
                            m_ImagenesEnems[c.id].RotateFlip(RotateFlipType.RotateNoneFlipX);
                        }
                    }
                        
                    g.DrawImage(m_ImagenesEnems[c.id], x, y, m_ImagenesEnems[c.id].Width, m_ImagenesEnems[c.id].Height);

                    if (c.rotation_type == eRotationType.ROTATION_NORMAL)
                    {
                        if (c.rotation == 1)
                        {
                            m_ImagenesEnems[c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                        }
                        else if (c.rotation == 2)
                        {
                            m_ImagenesEnems[c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                        }
                        else if (c.rotation == 3)
                        {
                            m_ImagenesEnems[c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                        }
                    }
                    else if (c.rotation_type == eRotationType.ROTATION_MIRROR)
                    {
                        if (c.rotation > 1)
                        {
                           m_ImagenesEnems[c.id].RotateFlip(RotateFlipType.RotateNoneFlipX);
                        }
                    }
                }
                ///--- transport
                else if (c.tipo == 3)
                {
                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE);
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE);

                    if (m_bRectActivo)
                    {
                        if (c.rotation % 2 == 0)
                            g.DrawRectangle(m_SelectorPen[0], x, y, m_ImagenTransporter.Width, m_ImagenTransporter.Height);
                        else
                            g.DrawRectangle(m_SelectorPen[0], x, y, m_ImagenTransporter.Height, m_ImagenTransporter.Width);
                    }
                    
                    g.DrawImage(m_ImagenTransporter, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE), (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE), m_ImagenTransporter.Width, m_ImagenTransporter.Height);
                    //g.DrawString((c.rotation).ToString(), arial2, Brushes.White, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) - 2+10, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) - 2+10);

                    int add = c.rotation < 10 ? 7 : 0;
                    g.DrawString((c.rotation).ToString(), arial_teleport, Brushes.Black, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE)+7+add, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE)+10);
                }
                
            }

            foreach (ObjetoEscena c in m_ListaEscena)
            {
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (!m_bRenderScripts && c.script != "")
                    continue;

                ///--- decoration
                if (c.tipo == 4)
                {
                    //int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE);
                    //int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE);
                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 9;
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) - 18;

                    if (m_bRectActivo)
                    {
                        if (c.rotation % 2 == 0)
                            g.DrawRectangle(m_SelectorPen[0], x, y, m_ImagenesDecos[c.estilo][c.id].Width, m_ImagenesDecos[c.estilo][c.id].Height);
                        else
                            g.DrawRectangle(m_SelectorPen[0], x, y, m_ImagenesDecos[c.estilo][c.id].Height, m_ImagenesDecos[c.estilo][c.id].Width);
                    }
                    if (c.rotation == 1)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                    }
                    else if (c.rotation == 2)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                    }
                    else if (c.rotation == 3)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                    }

                    g.DrawImage(m_ImagenesDecos[c.estilo][c.id], x, y, m_ImagenesDecos[c.estilo][c.id].Width, m_ImagenesDecos[c.estilo][c.id].Height);

                    if (c.rotation == 1)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                    }
                    else if (c.rotation == 2)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                    }
                    else if (c.rotation == 3)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                    }
                }
            }

            if (!m_TheForm.checkBoxPantalla.Checked && m_bShowItemCursor && m_iCurrentFloor == 1)
            {
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], 0, (m_MouseScreenCoordinates.Y * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), 3000, (m_MouseScreenCoordinates.Y * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex));
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], (m_MouseScreenCoordinates.X * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 0, (m_MouseScreenCoordinates.X * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 2000);

                g.DrawLine(m_SelectorPen[m_iCurrentFloor], 0, ((m_MouseScreenCoordinates.Y + 8) * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), 3000, ((m_MouseScreenCoordinates.Y + 8) * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex));
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], ((m_MouseScreenCoordinates.X + 8) * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 0, ((m_MouseScreenCoordinates.X + 8) * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 2000);
            }


            
            foreach (ObjetoEscena c in m_ListaNivel1)
            {
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (!m_bRenderScripts && c.script != "")
                    continue;

                if (c.tipo == 0)
                {
                    g.DrawImage(m_ImagenesCubos[c.estilo][c.id], (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 9, (c.posY * GRID_SIZE) - 36 - (m_CameraCoordinates.Y * GRID_SIZE), m_ImagenesCubos[c.estilo][c.id].Width, m_ImagenesCubos[c.estilo][c.id].Height);

                    if (m_TheForm.checkBoxWireframe.Checked)
                        g.DrawImage(m_ImagenHoverCubo, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 9, (c.posY * GRID_SIZE) - 36 - (m_CameraCoordinates.Y * GRID_SIZE), m_ImagenesCubos[c.estilo][c.id].Width, m_ImagenesCubos[c.estilo][c.id].Height);


                    if (c.rotation != 0)
                    {
                        g.DrawString((c.rotation * 90).ToString() + "º", arial_teleport, Brushes.Black, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 6 + 9, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) + 7 - 18);
                        g.DrawString((c.rotation * 90).ToString() + "º", arial_teleport, Brushes.Yellow, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 8 + 9, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) + 6 - 18);
                    }

                }
            }

            foreach (ObjetoEscena c in m_ListaNivel1)
            {
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (!m_bRenderScripts && c.script != "")
                    continue;

                ///--- decoration
                if (c.tipo == 4)
                {
                    //int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 9;
                    //int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) - 18;
                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 18;
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) - 36;

                    if (m_bRectActivo)
                    {
                        if (c.rotation % 2 == 0)
                            g.DrawRectangle(m_SelectorPen[1], x, y, m_ImagenesDecos[c.estilo][c.id].Width, m_ImagenesDecos[c.estilo][c.id].Height);
                        else
                            g.DrawRectangle(m_SelectorPen[1], x, y, m_ImagenesDecos[c.estilo][c.id].Height, m_ImagenesDecos[c.estilo][c.id].Width);
                    }

                    if (c.rotation == 1)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                    }
                    else if (c.rotation == 2)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                    }
                    else if (c.rotation == 3)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                    }

                    g.DrawImage(m_ImagenesDecos[c.estilo][c.id], x, y, m_ImagenesDecos[c.estilo][c.id].Width, m_ImagenesDecos[c.estilo][c.id].Height);

                    if (c.rotation == 1)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                    }
                    else if (c.rotation == 2)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                    }
                    else if (c.rotation == 3)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                    }
                }
            }


            if (!m_TheForm.checkBoxPantalla.Checked && m_bShowItemCursor && m_iCurrentFloor == 2)
            {
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], 0, (m_MouseScreenCoordinates.Y * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), 3000, (m_MouseScreenCoordinates.Y * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex));
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], (m_MouseScreenCoordinates.X * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 0, (m_MouseScreenCoordinates.X * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 2000);

                g.DrawLine(m_SelectorPen[m_iCurrentFloor], 0, ((m_MouseScreenCoordinates.Y + 8) * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex), 3000, ((m_MouseScreenCoordinates.Y + 8) * GRID_SIZE) - (18 * m_TheForm.comboBoxPiso.SelectedIndex));
                g.DrawLine(m_SelectorPen[m_iCurrentFloor], ((m_MouseScreenCoordinates.X + 8) * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 0, ((m_MouseScreenCoordinates.X + 8) * GRID_SIZE) + (9 * m_TheForm.comboBoxPiso.SelectedIndex), 2000);
            }

            

            foreach (ObjetoEscena c in m_ListaNivel2)
            {
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (!m_bRenderScripts && c.script != "")
                    continue;

                if (c.tipo == 0)
                {
                    g.DrawImage(m_ImagenesCubos[c.estilo][c.id], (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 18, (c.posY * GRID_SIZE) - 54 - (m_CameraCoordinates.Y * GRID_SIZE), m_ImagenesCubos[c.estilo][c.id].Width, m_ImagenesCubos[c.estilo][c.id].Height);

                    if (m_TheForm.checkBoxWireframe.Checked)
                        g.DrawImage(m_ImagenHoverCubo, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 18, (c.posY * GRID_SIZE) - 54 - (m_CameraCoordinates.Y * GRID_SIZE), m_ImagenesCubos[c.estilo][c.id].Width, m_ImagenesCubos[c.estilo][c.id].Height);

                    if (c.rotation != 0)
                    {
                        g.DrawString((c.rotation * 90).ToString() + "º", arial_teleport, Brushes.Black, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 6 + 18, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) + 7 - 36);
                        g.DrawString((c.rotation * 90).ToString() + "º", arial_teleport, Brushes.Yellow, (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 8 + 18, (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) + 6 - 36);
                    }
                }
            }

            foreach (ObjetoEscena c in m_ListaNivel2)
            {
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (!m_bRenderScripts && c.script != "")
                    continue;

                ///--- decoration
                if (c.tipo == 4)
                {
                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) + 27;
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) - 54;

                    if (m_bRectActivo)
                    {
                        if (c.rotation % 2 == 0)
                            g.DrawRectangle(m_SelectorPen[2], x, y, m_ImagenesDecos[c.estilo][c.id].Width, m_ImagenesDecos[c.estilo][c.id].Height);
                        else
                            g.DrawRectangle(m_SelectorPen[2], x, y, m_ImagenesDecos[c.estilo][c.id].Height, m_ImagenesDecos[c.estilo][c.id].Width);
                    }

                    if (c.rotation == 1)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                    }
                    else if (c.rotation == 2)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                    }
                    else if (c.rotation == 3)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                    }

                    g.DrawImage(m_ImagenesDecos[c.estilo][c.id], x, y, m_ImagenesDecos[c.estilo][c.id].Width, m_ImagenesDecos[c.estilo][c.id].Height);

                    if (c.rotation == 1)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate270FlipNone);
                    }
                    else if (c.rotation == 2)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate180FlipNone);
                    }
                    else if (c.rotation == 3)
                    {
                        m_ImagenesDecos[c.estilo][c.id].RotateFlip(RotateFlipType.Rotate90FlipNone);
                    }
                }
            }


            foreach (ObjetoEscena c in m_ListaEscena)
            {
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (m_TheForm.checkBoxScriptLabels.Checked && c.script != "")
                {
                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE);
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE);
                    g.FillRectangle(m_BrownBrush, x, y - 30, 100, 15);
                    g.DrawString(c.script, arial, Brushes.White, x + 1, y -32);
                    g.DrawLine(Pens.Brown, x, y, x, y -25);
                }                   
            }

            foreach (ObjetoEscena c in m_ListaNivel1)
            {
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (m_TheForm.checkBoxScriptLabels.Checked && c.script != "")
                {
                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE) +9;
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE) -18;
                    g.FillRectangle(m_BrownBrush, x, y - 30, 100, 15);
                    g.DrawString(c.script, arial, Brushes.White, x + 1, y - 32);
                    g.DrawLine(Pens.Brown, x, y, x, y - 25);
                }
            }

            foreach (ObjetoEscena c in m_ListaNivel2)
            {
                if (c.tipo == 4 && !m_TheForm.checkBoxDecorations.Checked)
                    continue;

                if (m_TheForm.checkBoxScriptLabels.Checked && c.script != "")
                {
                    int x = (c.posX * GRID_SIZE) - (m_CameraCoordinates.X * GRID_SIZE)+18;
                    int y = (c.posY * GRID_SIZE) - (m_CameraCoordinates.Y * GRID_SIZE)-36;
                    g.FillRectangle(m_BrownBrush, x, y - 30, 100, 15);
                    g.DrawString(c.script, arial, Brushes.White, x + 1, y - 32);
                    g.DrawLine(Pens.Brown, x, y, x, y - 25);
                }
            }            
        }



        //--------------------------------------------------------------------
        // Función:    CheckValidPos
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 11:25:17
        //--------------------------------------------------------------------
        private bool CheckValidPos(ObjetoEscena element, int piso)
        {
            List<ObjetoEscena> lista = null;
            /*
            if (element.rotation % 2 != 0)
            {
                short tmp = element.width;
                element.width = element.height;
                element.height = tmp;
            }*/
            
            Rectangle a = new Rectangle(element.posX, element.posY, element.width, element.height);

            if ((element.rotation % 2 != 0) && element.rotation_type == eRotationType.ROTATION_NORMAL) 
            {
                int tmp = a.Width;
                a.Width = a.Height;
                a.Height = tmp;
            }

         
            switch (piso)
            {
                case 0:
                {
                    lista = m_ListaEscena;
                    break;
                }
                case 1:
                {
                    lista = m_ListaNivel1;
                    break;
                }
                case 2:
                {
                    lista = m_ListaNivel2;
                    break;
                }
            }

            ObjetoEscena del = null;

            foreach (ObjetoEscena c in lista)
            {
                if (c.tipo == 4) /// deco
                {
                    continue;
                }

                if (c.tipo == 1 && c.id >=10 && c.id <=12) /// deco
                {
                    continue;
                } 
                
                Rectangle b = new Rectangle(c.posX, c.posY, c.width, c.height);

                if ((c.rotation % 2 != 0) && c.rotation_type == eRotationType.ROTATION_NORMAL) 
                {
                    int tmp = b.Width;
                    b.Width = b.Height;
                    b.Height = tmp;
                }

                if (element.tipo == 0 && c.tipo == 0)
                    if ((c.posX == element.posX) && (c.posY == element.posY))
                    {
                        del = c;
                        continue;
                    }

                if (b.IntersectsWith(a))
                    return false;
            }

            if (del != null)
            {
                lista.Remove(del);

                m_iCubeCount--;

                m_TheForm.textBoxCubos.Text = m_iCubeCount.ToString();

                m_TheForm.textBoxElements.Text = (m_ListaEscena.Count + m_ListaNivel1.Count + m_ListaNivel2.Count).ToString();

            }

            return true;
        }



        //--------------------------------------------------------------------
        // Función:    LoadLevel
        // Propósito:  
        // Fecha:      martes, 24 de octubre de 2006, 19:03:44
        //--------------------------------------------------------------------
        public void LoadLevel(BinaryReader br, int level)
        {                      
            int staticCount = br.ReadInt32();

            for (int i = 0; i < staticCount; i++)
            {
                ObjetoEscena temp = new ObjetoEscena();
                temp.dynamic = false;
                temp.tipo = br.ReadByte();
                temp.id = br.ReadByte();
                temp.posX = br.ReadInt16();
                temp.posY = br.ReadInt16();
                temp.rotation = br.ReadByte();
                temp.width = br.ReadInt16();
                temp.height = br.ReadInt16();
                temp.script = br.ReadString();
                temp.estilo = br.ReadString();
                temp.upper = br.ReadInt32();

                if (temp.script !="")
                    MessageBox.Show("Loading: There is a static object with script !!??.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);


                ///--- si es un cubo pillamos la informacion de los lados
                if (temp.tipo == 0)
                {
                    br.ReadByte();
                }

                if (level == 0)
                    AddObject(temp.tipo, temp.id, temp.rotation, temp.script, 0, 0, new Point(temp.posX, temp.posY), level, temp.estilo);
                else
                    AddCubeLevel(temp.tipo, temp.id, temp.rotation, temp.script, 0, 0, new Point(temp.posX, temp.posY), level, temp.estilo);

                temp = null;

                //System.Threading.Thread.Sleep(500);
                //m_TheForm.pictureBoxRendering.Invalidate();
            }

            int dynamicCount = br.ReadInt32();

            for (int i = 0; i < dynamicCount; i++)
            {
                ObjetoEscena temp = new ObjetoEscena();
                temp.dynamic = true;
                temp.tipo = br.ReadByte();
                temp.id = br.ReadByte();
                temp.posX = br.ReadInt16();
                temp.posY = br.ReadInt16();
                temp.rotation = br.ReadByte();
                temp.width = br.ReadInt16();
                temp.height = br.ReadInt16();
                temp.script = br.ReadString();
                temp.estilo = br.ReadString();
                temp.upper = br.ReadInt32();

                AddObject(temp.tipo, temp.id, temp.rotation, temp.script, 0, 0, new Point(temp.posX, temp.posY), level, temp.estilo);
            }

            int sectoresX = br.ReadInt32();
            int sectoresY = br.ReadInt32();

            for (int i = 0; i < (sectoresX * sectoresY); i++)
            {
                short count = br.ReadInt16();

                for (int j = 0; j < count; j++)
                {
                    int index = br.ReadInt32();
                }
            }
        }

        //--------------------------------------------------------------------
        // Función:    OpenFile
        // Propósito:  
        // Fecha:      miércoles, 01 de febrero de 2006, 15:20:18
        //--------------------------------------------------------------------
        public void OpenFile(Stream fileStream)
        {
            m_TheForm.checkBoxLock.Checked = true;
            ResetScene();

            BinaryReader br = new BinaryReader(fileStream);

            byte version = br.ReadByte();
            string title = br.ReadString();

            if (version != FILE_VERSION)
            {
                MessageBox.Show("The version of the file is invalid: " + version, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                br.Close();
                br = null;
                fileStream.Close();

                ResetScene();

                m_TheForm.buttonSave.Enabled = false;
                m_TheForm.Text = "Ozone iPhone Editor " + EDITOR_VERSION + " ";
                CURRENT_FILE = "";

                return;
            }

            if (title != "GEARDOME OZONE")
            {
                MessageBox.Show("The file is invalid: " + title, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);

                br.Close();
                br = null;
                fileStream.Close();

                ResetScene();

                m_TheForm.buttonSave.Enabled = false;
                m_TheForm.Text = "Ozone iPhone Editor " + EDITOR_VERSION + " ";
                CURRENT_FILE = "";
                
                return;
            }


            m_TheForm.comboBoxFondo.SelectedIndex = br.ReadByte();

            LoadLevel(br, 0);
            LoadLevel(br, 1);
            LoadLevel(br, 2);

            m_ListaEscena.Sort(new CompareObjetoEscenaDistance());
            m_ListaNivel1.Sort(new CompareObjetoEscenaDistance());
            m_ListaNivel2.Sort(new CompareObjetoEscenaDistance());

            string estilo = br.ReadString();

            m_TheForm.comboBoxEstilos.SelectedIndex = m_TheForm.comboBoxEstilos.Items.IndexOf(estilo);

            br.Close();
            br = null;
            fileStream.Close();
        }


        //--------------------------------------------------------------------
        // Función:    SaveLevel
        // Propósito:  
        // Fecha:      martes, 24 de octubre de 2006, 18:44:22
        //--------------------------------------------------------------------
        public void SaveLevel(BinaryWriter bw, int level, short xMax, short yMax)
        {
            List<ObjetoEscena> lista = null;

            switch (level)
            {
                case 0:
                {
                    lista = m_ListaEscena;
                    break;
                }
                case 1:
                {
                    lista = m_ListaNivel1;
                    break;
                }
                case 2:
                {
                    lista = m_ListaNivel2;
                    break;
                }
            }

            int staticCount = 0;
            int dynamicCount = 0;

            foreach (ObjetoEscena c in lista)
            {
                if (c.dynamic)
                {
                    dynamicCount++;
                }
                else
                {
                    staticCount++;
                }
            }

            ///--- importante pasar de little endian a big endian
            ///--- ya que java lee en big endian y c# escribe por
            ///--- defecto en little endian
            /// 
            ///--- guardamos el número de objetos estáticos
            bw.Write(staticCount);

            ///--- guardamos todos los objetos estáticos
            foreach (ObjetoEscena c in lista)
            {
                if (c.dynamic)
                    continue;                
                    
                if (!c.dynamic && c.script!="")
                    MessageBox.Show("Saving: There is a static object with script !!??.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                SaveObject(bw, c);
            }

            ///--- guardamos el número de objetos dinámicos
            bw.Write(dynamicCount);

            ///--- guardamos todos los objetos dinámicos
            foreach (ObjetoEscena c in lista)
            {
                if (!c.dynamic)
                    continue;

                SaveObject(bw, c);
            }

            ///--- calculamos el número de sectores
            int numSecX = (int)((xMax / SECTOR_WIDTH) + 1);
            int numSecY = (int)((yMax / SECTOR_HEIGHT) + 1);
            int numSec = (int)(numSecX * numSecY);

            ///--- guardamos el número de sectores
            bw.Write(numSecX);
            bw.Write(numSecY);

            Sector[] arraySectores = new Sector[numSec];

            for (int j = 0; j < numSecY; j++)
            {
                for (int i = 0; i < numSecX; i++)
                {
                    arraySectores[(numSecX * j) + i].staticObjectsIndices = new List<int>();


                    ///--- vemos los objetos estáticos de este sector

                    short indice = 0;

                    foreach (ObjetoEscena c in lista)
                    {
                        if (c.dynamic)
                            continue;

                        Rectangle a = new Rectangle(c.posX, c.posY, c.width, c.height);
                        Rectangle b = new Rectangle(i * SECTOR_WIDTH, j * SECTOR_HEIGHT, SECTOR_WIDTH, SECTOR_HEIGHT);

                        //if ((c.posX >= ((i * 16) - (c.width-1))) && (c.posX < ((i * 16) + 16)))
                          //  if ((c.posY >= ((j * 16) - 4)) && (c.posY < ((j * 16) + 16)))
                        if (a.IntersectsWith(b))
                        {
                            ///--- el objeto está en el sector actual                              

                            arraySectores[(numSecX * j) + i].staticObjectsIndices.Add(indice);
                        }

                        indice++;
                    }
                }
            }

            ///--- guardamos los sectores
            foreach (Sector s in arraySectores)
            {
                SaveSector(bw, s);
            }
        }


        //--------------------------------------------------------------------
        // Función:    SaveFile
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 11:42:04
        //--------------------------------------------------------------------
        public void SaveFile(Stream fileStream)
        {    

            BinaryWriter bw = new BinaryWriter(fileStream);

            byte version = FILE_VERSION;
            byte bg = (byte)m_TheForm.comboBoxFondo.SelectedIndex;
            
            bw.Write(version);
            bw.Write("GEARDOME OZONE");
            bw.Write(bg);

            short xMax = 0, yMax = 0;
      
            foreach (ObjetoEscena c in m_ListaEscena)
            {
                if (c.dynamic)
                    continue;

                if (c.posX > xMax)
                {
                    xMax = c.posX;
                }

                if (c.posY > yMax)
                {
                    yMax = c.posY;
                }
            }
            foreach (ObjetoEscena c in m_ListaNivel1)
            {
                if (c.dynamic)
                    continue;

                if (c.posX > xMax)
                {
                    xMax = c.posX;
                }

                if (c.posY > yMax)
                {
                    yMax = c.posY;
                }
            }
            foreach (ObjetoEscena c in m_ListaNivel2)
            {
                if (c.dynamic)
                    continue;

                if (c.posX > xMax)
                {
                    xMax = c.posX;
                }

                if (c.posY > yMax)
                {
                    yMax = c.posY;
                }
            }

            SaveLevel(bw, 0, xMax, yMax);
            SaveLevel(bw, 1, xMax, yMax);
            SaveLevel(bw, 2, xMax, yMax);
           
            ///--- cerramos el archivo

            bw.Write(m_TheForm.comboBoxEstilos.Text);

            bw.Write(m_iGemCount);

            int offset = 4 + 4 + 1 + m_TheForm.comboBoxEstilos.Text.Length;

            bw.Write(offset);

            bw.Close();
            bw = null;

            fileStream.Close();
            fileStream = null;
        }
        

        //--------------------------------------------------------------------
        // Función:    SaveSector
        // Propósito:  
        // Fecha:      jueves, 26 de enero de 2006, 14:41:50
        //--------------------------------------------------------------------
        private void SaveSector(BinaryWriter bw, Sector s)
        {
            ///--- importante pasar de little endian a big endian
            ///--- ya que java lee en big endian y c# escribe por
            ///--- defecto en little endian

            bw.Write((short)s.staticObjectsIndices.Count);

            foreach (int sh in s.staticObjectsIndices)
            {
                bw.Write(sh);
            }
        }


        //--------------------------------------------------------------------
        // Función:    SaveObject
        // Propósito:  
        // Fecha:      miércoles, 01 de febrero de 2006, 11:30:42
        //--------------------------------------------------------------------
        private void SaveObject(BinaryWriter bw, ObjetoEscena oe)
        {
            ///--- importante pasar de little endian a big endian
            ///--- ya que java lee en big endian y c# escribe por
            ///--- defecto en little endian

            bw.Write(oe.tipo);
            bw.Write(oe.id);
            bw.Write(oe.posX);
            bw.Write(oe.posY);
            bw.Write(oe.rotation);
            bw.Write(oe.width);
            bw.Write(oe.height);
            bw.Write(oe.script);
            bw.Write(oe.estilo);
            bw.Write(oe.upper);

            ///--- si es un cubo comprobar si al lado tiene otros cubos
            if (oe.tipo == 0)
            {
                byte lados = 0;

                foreach (ObjetoEscena c in m_ListaEscena)
                {
                    if ((c.id == 10) || (c.id == 11))
                    {
                        if ((oe.id != 10) && (oe.id != 11))
                            continue;
                    }

                    ///--- es cubo 
                    if (c.tipo == 0) 
                    {                        
                        if ((c.posX == oe.posX) && (c.posY == oe.posY - 4))
                        {
                            ///--- por arriba tiene un cubo   
                            lados |= 1;
                        }

                        if ((c.posX == oe.posX + 4) && (c.posY == oe.posY))
                        {
                            ///--- por la derecha tiene un cubo
                            lados |= 2;                            
                        }

                        if ((c.posX == oe.posX) && (c.posY == oe.posY + 4))
                        {
                            ///--- por abajo tiene un cubo   
                            lados |= 4;                                                     
                        }

                        if ((c.posX == oe.posX - 4) && (c.posY == oe.posY))
                        {
                            ///--- por la izquierda tiene un cubo
                            lados |= 8;
                        }                        
                    }
                }

                bw.Write(lados);
            }            
        }


        //--------------------------------------------------------------------
        // Función:    ResetScene
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 12:10:07
        //--------------------------------------------------------------------
        public void ResetScene()
        {
            m_bRenderScripts = true;

            m_bRedKey = m_bBlueKey = m_bStart = m_bExit = m_bStartTrigger = m_bExitTrigger = false;
            m_iTeleport = m_iCubeCount = m_iGemCount = 0;
            m_ListaEscena.Clear();

            m_ListaNivel1.Clear();
            m_ListaNivel2.Clear();

            m_TheForm.horizontalScrollBar.Value = 0;
            m_TheForm.verticalScrollBar.Value = 0;
            CameraCoordinateX = 0;
            CameraCoordinateY = 0;

            m_TheForm.textBoxCubos.Text = "0";
            m_TheForm.textBoxGemas.Text = "0";
            m_TheForm.textBoxTeleport.Text = "0";
            m_TheForm.textBoxElements.Text = "0";

            m_TheForm.comboBoxPiso.SelectedIndex = 0;
            m_TheForm.comboBoxFondo.SelectedIndex = 0;
            m_TheForm.comboBoxScripts.SelectedIndex = 0;
            m_TheForm.comboBoxEstilos.SelectedIndex = 0;
        }

        public bool IsSafeToChangeStylo(string newStyle)
        {
            byte maxCubes = (byte)(m_ImagenesCubos[newStyle].Length - 1);
            byte maxDecos = (byte)(m_ImagenesDecos[newStyle].Length - 1);

            foreach (ObjetoEscena c in m_ListaEscena)
            {
                if (c.tipo == 0)
                {
                    if (c.id > maxCubes)
                    {
                        return false;
                    }
                }
                else if (c.tipo == 4)
                {
                    if (c.id > maxDecos)
                    {
                        return false;
                    }
                }
            }
            foreach (ObjetoEscena c in m_ListaNivel1)
            {
                if (c.tipo == 0)
                {
                    if (c.id > maxCubes)
                    {
                        return false;
                    }
                }
                else if (c.tipo == 4)
                {
                    if (c.id > maxDecos)
                    {
                        return false;
                    }
                }
            }
            foreach (ObjetoEscena c in m_ListaNivel2)
            {
                if (c.tipo == 0)
                {
                    if (c.id > maxCubes)
                    {
                        return false;
                    }
                }
                else if (c.tipo == 4)
                {
                    if (c.id > maxDecos)
                    {
                        return false;
                    }
                }
            }

            return true;
        }

        public void UpdateStylos(string style)
        {
            byte maxCubes = (byte)(m_ImagenesCubos[m_TheForm.comboBoxEstilos.Text].Length - 1);
            byte maxDecos = (byte)(m_ImagenesDecos[m_TheForm.comboBoxEstilos.Text].Length - 1);

            foreach (ObjetoEscena c in m_ListaEscena)
            {
                if (c.tipo == 0)
                {
                    c.id = Math.Min(c.id, maxCubes);
                }
                else if (c.tipo == 4)
                {
                    c.id = Math.Min(c.id, maxDecos);
                }

                c.estilo = style;
            }
            foreach (ObjetoEscena c in m_ListaNivel1)
            {
                if (c.tipo == 0)
                {
                    c.id = Math.Min(c.id, maxCubes);
                }
                else if (c.tipo == 4)
                {
                    c.id = Math.Min(c.id, maxDecos);
                }

                c.estilo = style;
            }
            foreach (ObjetoEscena c in m_ListaNivel2)
            {
                if (c.tipo == 0)
                {
                    c.id = Math.Min(c.id, maxCubes);
                }
                else if (c.tipo == 4)
                {
                    c.id = Math.Min(c.id, maxDecos);
                }

                c.estilo = style;
            }
        }
    }
}
