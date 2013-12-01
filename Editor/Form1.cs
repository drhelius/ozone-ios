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
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace Editor
{
    public partial class MainForm : Form
    {
        
        EditorManager m_EditorManager = new EditorManager();        


        //--------------------------------------------------------------------
        // Función:    MainForm
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:09:20
        //--------------------------------------------------------------------
        public MainForm()
        {
            InitializeComponent();
        }

        private string m_currentDirectory;


        //--------------------------------------------------------------------
        // Función:    MainForm_Load
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:09:32
        //--------------------------------------------------------------------
        private void MainForm_Load(object sender, EventArgs e)
        {
            this.SetStyle(ControlStyles.AllPaintingInWmPaint, true);
            this.SetStyle(ControlStyles.UserPaint, true);
            this.SetStyle(ControlStyles.DoubleBuffer, true);

            timerScripts.Start();

            buttonSave.Enabled = false;

            m_EditorManager.Start(this);

            try
            {
                m_currentDirectory = System.Environment.CurrentDirectory;

                FileStream f = new FileStream(m_currentDirectory + "\\editor.dat", FileMode.Open);

                BinaryReader br = new BinaryReader(f);

                checkBoxFondo.Checked = br.ReadBoolean();
                checkBoxPantalla.Checked = br.ReadBoolean();
                m_EditorManager.RectsActivate = checkBoxRects.Checked = br.ReadBoolean();
                checkBoxScriptLabels.Checked = br.ReadBoolean();
                checkBoxScripts.Checked = br.ReadBoolean();
                checkBoxSelector.Checked = br.ReadBoolean();

                string state = br.ReadString();

                switch (state)
                {
                    case "Normal":
                    {
                        this.WindowState = FormWindowState.Normal;
                        break;
                    }
                    case "Maximized":
                    {
                        this.WindowState = FormWindowState.Maximized;
                        break;
                    }
                    case "Minimized":
                    {
                        this.WindowState = FormWindowState.Normal;
                        break;
                    }
                }

                checkBoxWireframe.Checked = br.ReadBoolean();
                checkBox1.Checked = br.ReadBoolean();
                checkBoxDecorations.Checked = br.ReadBoolean();

                br.Close();
            }
            catch (Exception)
            {
            }
        }


        //--------------------------------------------------------------------
        // Función:    pictureBoxRendering_MouseEnter
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:09:41
        //--------------------------------------------------------------------
        private void pictureBoxRendering_MouseEnter(object sender, EventArgs e)
        {
            Cursor.Hide();
            m_EditorManager.ShowItemCursor = true;
        }


        //--------------------------------------------------------------------
        // Función:    pictureBoxRendering_MouseLeave
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:09:50
        //--------------------------------------------------------------------
        private void pictureBoxRendering_MouseLeave(object sender, EventArgs e)
        {
            Cursor.Show();
            m_EditorManager.ShowItemCursor = false;
            pictureBoxRendering.Invalidate();
        }


        //--------------------------------------------------------------------
        // Función:    pictureBoxRendering_MouseMove
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:10:05
        //--------------------------------------------------------------------
        private void pictureBoxRendering_MouseMove(object sender, MouseEventArgs e)
        {            
            m_EditorManager.MouseMove(e.Location, e.Button, e);

            pictureBoxRendering.Invalidate();
        }


        //--------------------------------------------------------------------
        // Función:    pictureBoxRendering_Paint
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:10:14
        //--------------------------------------------------------------------
        private void pictureBoxRendering_Paint(object sender, PaintEventArgs e)
        {
            m_EditorManager.Render(e.Graphics);                        
        }


        //--------------------------------------------------------------------
        // Función:    radioCubos_CheckedChanged
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:10:23
        //--------------------------------------------------------------------
        private void radioCubos_CheckedChanged(object sender, EventArgs e)
        {
            if (radioCubos.Checked)
            {
                comboBoxPiso.Enabled = true;

                imageListCubos.Images.Clear();

                foreach (Bitmap bmp in m_EditorManager.m_ImagenesCubos[comboBoxEstilos.Text])
                {
                    imageListCubos.Images.Add(bmp);
                }

                listViewTextures.Clear();
                listViewTextures.LargeImageList = imageListCubos;

                for (int i = 0; i < m_EditorManager.m_ImagenesCubos[comboBoxEstilos.Text].Length; i++)
                {
                    listViewTextures.Items.Add(new ListViewItem("" + (i < 10 ? "0" : "") + (i+1), i));    
                }

                comboBoxEstilos.Enabled = true;
                listViewTextures.Items[0].Selected = true;
            }


        }


        //--------------------------------------------------------------------
        // Función:    radioTransport_CheckedChanged
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:10:40
        //--------------------------------------------------------------------
        private void radioTransport_CheckedChanged(object sender, EventArgs e)
        {
            if (radioTransport.Checked)
            {
                comboBoxPiso.SelectedIndex = 0;
                comboBoxPiso.Enabled = false;

                listViewTextures.Clear();
                listViewTextures.LargeImageList = imageListTrans;

                listViewTextures.Items.Add(new ListViewItem("", 0));

                comboBoxEstilos.Enabled = false;
                listViewTextures.Items[0].Selected = true;
            }
        }


        //--------------------------------------------------------------------
        // Función:    radioEnemigos_CheckedChanged
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:10:48
        //--------------------------------------------------------------------
        private void radioEnemigos_CheckedChanged(object sender, EventArgs e)
        {
            if (radioEnemigos.Checked)
            {
                comboBoxPiso.SelectedIndex = 0;
                comboBoxPiso.Enabled = false;

                listViewTextures.Clear();
                listViewTextures.LargeImageList = imageListEnems;

                for (int i = 0; i < EditorManager.NUM_ENEMS; i++)
                {
                    listViewTextures.Items.Add(new ListViewItem("" + (i < 10 ? "0" : "") + (i+1), i));
                }

                comboBoxEstilos.Enabled = false;
                listViewTextures.Items[0].Selected = true;
            }
        }


        //--------------------------------------------------------------------
        // Función:    radioItems_CheckedChanged
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:10:59
        //--------------------------------------------------------------------
        private void radioItems_CheckedChanged(object sender, EventArgs e)
        {
            if (radioItems.Checked)
            {
                comboBoxPiso.SelectedIndex = 0;
                comboBoxPiso.Enabled = false;

                listViewTextures.Clear();
                listViewTextures.LargeImageList = imageListItems;

                for (int i = 0; i < EditorManager.NUM_ITEMS; i++)
                {
                    listViewTextures.Items.Add(new ListViewItem("" + (i < 10 ? "0" : "") + (i + 1), i));
                }

                comboBoxEstilos.Enabled = false;
                listViewTextures.Items[0].Selected = true;
            }
        }


        //--------------------------------------------------------------------
        // Función:    horizontalScrollBar_Scroll
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:11:06
        //--------------------------------------------------------------------
        private void horizontalScrollBar_Scroll(object sender, ScrollEventArgs e)
        {
            m_EditorManager.CameraCoordinateX = e.NewValue;
            pictureBoxRendering.Invalidate();
        }


        //--------------------------------------------------------------------
        // Función:    verticalScrollBar_Scroll
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:11:15
        //--------------------------------------------------------------------
        private void verticalScrollBar_Scroll(object sender, ScrollEventArgs e)
        {
            m_EditorManager.CameraCoordinateY = e.NewValue;
            pictureBoxRendering.Invalidate();
        }


        //--------------------------------------------------------------------
        // Función:    pictureBoxRendering_MouseDown
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:11:23
        //--------------------------------------------------------------------
        public void pictureBoxRendering_MouseDown(object sender, MouseEventArgs e)
        {
            if (checkBoxPantalla.Checked)
                return;

            string script = "";
            if (comboBoxScripts.SelectedIndex != 0)
            {
                script = comboBoxScripts.Text;
            }

            string estilo = "";

            if (e.Button == MouseButtons.Left)
            {
                if (radioCubos.Checked && !checkBoxLock.Checked)
                {
                    estilo = comboBoxEstilos.Text;

                    if (listViewTextures.SelectedIndices.Count == 1)
                    {
                        if (numericUpDownCursorX.Value > 1)
                        {
                            for (int i = 0; i < numericUpDownCursorX.Value; i++)
                            {
                                switch (comboBoxPiso.SelectedIndex)
                                {
                                    case 0:
                                    {
                                        m_EditorManager.AddObject(0, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, "", 8 * i, 0, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);
                                        break;
                                    }
                                    case 1:                                   
                                    case 2:
                                    {
                                        m_EditorManager.AddCubeLevel(0, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, "", 8 * i, 0, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);
                                        break;
                                    }
                                }
                                
                            }
                        }
                        else if (numericUpDownCursorY.Value > 1)
                        {
                            for (int i = 0; i < numericUpDownCursorY.Value; i++)
                            {
                                switch (comboBoxPiso.SelectedIndex)
                                {
                                    case 0:
                                    {
                                        m_EditorManager.AddObject(0, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, "", 0, 8 * i, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);
                                        break;
                                    }
                                    case 1:
                                    case 2:
                                    {
                                        m_EditorManager.AddCubeLevel(0, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, "", 0, 8 * i, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);
                                        break;
                                    }
                                }                                
                            }
                        }
                        else
                        {
                            switch (comboBoxPiso.SelectedIndex)
                            {
                                case 0:
                                {
                                    m_EditorManager.AddObject(0, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, "", 0, 0, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);
                                    break;
                                }
                                case 1:
                                case 2:
                                {
                                    m_EditorManager.AddCubeLevel(0, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, "", 0, 0, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);
                                    break;
                                }
                            }                             
                        }

                        pictureBoxRendering.Invalidate();
                    }
                    else
                    {
                        listViewTextures.Items[0].Selected = true;
                         //MessageBox.Show("Select a cube.", "Select a cube", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                else if (radioItems.Checked && !checkBoxLock.Checked)
                {
                    if (comboBoxPiso.SelectedIndex != 0)
                        return;                    

                    if (listViewTextures.SelectedIndices.Count == 1)
                    {
                        if (numericUpDownCursorX.Value > 1)
                        {
                            for (int i = 0; i < numericUpDownCursorX.Value; i++)
                            {
                                m_EditorManager.AddObject(1, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 8 * i, 0, m_EditorManager.MouseRealCoordinates, 0, estilo);
                            }
                        }
                        else if (numericUpDownCursorY.Value > 1)
                        {
                            for (int i = 0; i < numericUpDownCursorY.Value; i++)
                            {
                                m_EditorManager.AddObject(1, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 0, 8 * i, m_EditorManager.MouseRealCoordinates, 0, estilo);
                            }
                        }
                        else                           
                        {
                            m_EditorManager.AddObject(1, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 0, 0, m_EditorManager.MouseRealCoordinates, 0, estilo);
                        }

                        pictureBoxRendering.Invalidate();
                    }
                    else
                    {
                        listViewTextures.Items[0].Selected = true;
                        //MessageBox.Show("Select an item.", "Select an item", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                else if (radioEnemigos.Checked && !checkBoxLock.Checked)
                {
                    if (comboBoxPiso.SelectedIndex != 0)
                        return;

                    if (listViewTextures.SelectedIndices.Count == 1)
                    {
                        if (numericUpDownCursorX.Value > 1)
                        {
                            for (int i = 0; i < numericUpDownCursorX.Value; i++)
                            {
                                m_EditorManager.AddObject(2, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 8 * i, 0, m_EditorManager.MouseRealCoordinates, 0, estilo);
                            }
                        }
                        else if (numericUpDownCursorY.Value > 1)
                        {
                            for (int i = 0; i < numericUpDownCursorY.Value; i++)
                            {
                                m_EditorManager.AddObject(2, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 0, 8 * i, m_EditorManager.MouseRealCoordinates, 0, estilo);
                            }
                        }
                        else
                        {
                            m_EditorManager.AddObject(2, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 0, 0, m_EditorManager.MouseRealCoordinates, 0, estilo);
                        }

                        pictureBoxRendering.Invalidate();
                    }
                    else
                    {
                        listViewTextures.Items[0].Selected = true;
                        //MessageBox.Show("Select an enemy.", "Select an enemy", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                else if (radioTransport.Checked && !checkBoxLock.Checked)
                {
                    if (comboBoxPiso.SelectedIndex != 0)
                        return;

                    if (listViewTextures.SelectedIndices.Count == 1)
                    {
                        m_EditorManager.AddObject(3, (byte)listViewTextures.SelectedIndices[0], 100, script, 0, 0, m_EditorManager.MouseRealCoordinates, 0, estilo);
                        
                        pictureBoxRendering.Invalidate();
                    }
                    else
                    {
                        listViewTextures.Items[0].Selected = true;
                        //MessageBox.Show("Select the teleporter.", "Select the teleporter", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
                else if (radioDecoration.Checked)
                {
                    estilo = comboBoxEstilos.Text;

                    if (listViewTextures.SelectedIndices.Count == 1)
                    {
                        if (numericUpDownCursorX.Value > 1)
                        {
                            for (int i = 0; i < numericUpDownCursorX.Value; i++)
                            {
                                m_EditorManager.AddObject(4, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 8 * i, 0, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);
                            }
                        }
                        else if (numericUpDownCursorY.Value > 1)
                        {
                            for (int i = 0; i < numericUpDownCursorY.Value; i++)
                            {
                                m_EditorManager.AddObject(4, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 0, 8 * i, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);
                            }
                        }
                        else
                        {
                            m_EditorManager.AddObject(4, (byte)listViewTextures.SelectedIndices[0], m_EditorManager.Rotation, script, 0, 0, m_EditorManager.MouseRealCoordinates, comboBoxPiso.SelectedIndex, estilo);

                        }
                       
                        pictureBoxRendering.Invalidate();
                    }
                    else
                    {
                        listViewTextures.Items[0].Selected = true;
                        //MessageBox.Show("Select a decoration.", "Select a decoration", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    }
                }
            }
            
            if (e.Button == MouseButtons.Right)
            {
                if (radioCubos.Checked && !checkBoxLock.Checked)
                {
                    m_EditorManager.DeleteObject(0);
                    pictureBoxRendering.Invalidate();
                }
                else if (radioItems.Checked && !checkBoxLock.Checked)
                {
                    m_EditorManager.DeleteObject(1);
                    pictureBoxRendering.Invalidate();
                }
                else if (radioEnemigos.Checked && !checkBoxLock.Checked)
                {
                    m_EditorManager.DeleteObject(2);
                    pictureBoxRendering.Invalidate();
                }
                else if (radioTransport.Checked && !checkBoxLock.Checked)
                {
                    m_EditorManager.DeleteObject(3);
                    pictureBoxRendering.Invalidate();
                }
                else if (radioDecoration.Checked)
                {
                    m_EditorManager.DeleteObject(4);
                    pictureBoxRendering.Invalidate();
                }
            }
        }        


        //--------------------------------------------------------------------
        // Función:    checkBoxPantalla_CheckedChanged
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 9:11:40
        //--------------------------------------------------------------------
        private void checkBoxPantalla_CheckedChanged(object sender, EventArgs e)
        {
            pictureBoxRendering.Invalidate();
        }


        //--------------------------------------------------------------------
        // Función:    abrirToolStripMenuItem_Click
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 11:39:04
        //--------------------------------------------------------------------
        private void abrirToolStripMenuItem_Click(object sender, EventArgs e)
        {
            openFileDialog.ShowDialog();         
        }
        

        //--------------------------------------------------------------------
        // Función:    saveFileDialog_FileOk
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 11:44:15
        //--------------------------------------------------------------------
        private void saveFileDialog_FileOk(object sender, CancelEventArgs e)
        {
            this.Text = "Ozone iPhone Editor " + EditorManager.EDITOR_VERSION + " - " + saveFileDialog.FileName;

            m_EditorManager.CURRENT_FILE = saveFileDialog.FileName;

            buttonSave.Enabled = true;
            
            m_EditorManager.SaveFile(saveFileDialog.OpenFile());

            toolStripStatusLabel1.Text = "File saved: " + m_EditorManager.CURRENT_FILE; 
        }


        //--------------------------------------------------------------------
        // Función:    guardarComoToolStripMenuItem_Click
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 11:48:46
        //--------------------------------------------------------------------
        private void guardarComoToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (m_EditorManager.m_iTeleport % 2 == 1)
            {
                MessageBox.Show("There is a telerporter without pair.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                return;
            }

            saveFileDialog.ShowDialog();
        }


        //--------------------------------------------------------------------
        // Función:    nuevoToolStripMenuItem_Click
        // Propósito:  
        // Fecha:      miércoles, 25 de enero de 2006, 12:06:41
        //--------------------------------------------------------------------
        private void nuevoToolStripMenuItem_Click(object sender, EventArgs e)
        {
            this.Text = "Ozone iPhone Editor " + EditorManager.EDITOR_VERSION + "";
            m_EditorManager.CURRENT_FILE = "";
            buttonSave.Enabled = false;
            m_EditorManager.ResetScene();
            pictureBoxRendering.Invalidate();
        }


        //--------------------------------------------------------------------
        // Función:    buttonRotacion_Click
        // Propósito:  
        // Fecha:      lunes, 30 de enero de 2006, 16:07:34
        //--------------------------------------------------------------------
        private void buttonRotacion_Click(object sender, EventArgs e)
        {
            m_EditorManager.Rotation++;

            m_EditorManager.Rotation %= 4;

            if (m_EditorManager.Rotation == 0)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha1;
            }
            else if (m_EditorManager.Rotation == 1)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha2;
            }
            else if (m_EditorManager.Rotation == 2)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha3;
            }
            else if (m_EditorManager.Rotation == 3)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha4;
            }
        }


        //--------------------------------------------------------------------
        // Función:    openFileDialog_FileOk
        // Propósito:  
        // Fecha:      miércoles, 01 de febrero de 2006, 15:30:02
        //--------------------------------------------------------------------
        private void openFileDialog_FileOk(object sender, CancelEventArgs e)
        {
            this.Text = "Ozone iPhone Editor " + EditorManager.EDITOR_VERSION + " - " + openFileDialog.FileName;

            m_EditorManager.CURRENT_FILE = openFileDialog.FileName;

            buttonSave.Enabled = true;
            radioCubos.Checked = true;

            m_EditorManager.OpenFile(openFileDialog.OpenFile());

            toolStripStatusLabel1.Text = "File opened: " + m_EditorManager.CURRENT_FILE;                
            
            pictureBoxRendering.Invalidate();          
        }


        //--------------------------------------------------------------------
        // Función:    numericUpDownCursorX_ValueChanged
        // Propósito:  
        // Fecha:      viernes, 03 de febrero de 2006, 9:16:10
        //--------------------------------------------------------------------
        private void numericUpDownCursorX_ValueChanged(object sender, EventArgs e)
        {
            numericUpDownCursorY.Value = 1;
        }


        //--------------------------------------------------------------------
        // Función:    numericUpDownCursorY_ValueChanged
        // Propósito:  
        // Fecha:      viernes, 03 de febrero de 2006, 9:16:25
        //--------------------------------------------------------------------
        private void numericUpDownCursorY_ValueChanged(object sender, EventArgs e)
        {
            numericUpDownCursorX.Value = 1;
        }


        //--------------------------------------------------------------------
        // Función:    abrirToolStripMenuItem1_Click
        // Propósito:  
        // Fecha:      miércoles, 08 de febrero de 2006, 13:40:14
        //--------------------------------------------------------------------
        private void abrirToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            openFileDialog.ShowDialog();
        }


        //--------------------------------------------------------------------
        // Función:    guardarComoToolStripMenuItem1_Click
        // Propósito:  
        // Fecha:      miércoles, 08 de febrero de 2006, 13:40:06
        //--------------------------------------------------------------------
        private void guardarComoToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (!m_EditorManager.m_bStart)
            {
                MessageBox.Show("There is no entry point.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                return;
            }
            /*
            if (!m_EditorManager.m_bExit)
            {
                MessageBox.Show("There is no exit point.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                              
                return;
            }            
            */
            if (m_EditorManager.m_iTeleport % 2 == 1)
            {
                MessageBox.Show("There is a telerporter without pair.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                return;
            }
            /*
            if (m_EditorManager.m_iGemCount <= 0)
            {
                MessageBox.Show("There are no yellow gems.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                return;
            }
            */
            saveFileDialog.ShowDialog();
        }


        //--------------------------------------------------------------------
        // Función:    salirToolStripMenuItem1_Click
        // Propósito:  
        // Fecha:      miércoles, 08 de febrero de 2006, 13:39:57
        //--------------------------------------------------------------------
        private void salirToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }


        //--------------------------------------------------------------------
        // Función:    nuevoToolStripMenuItem1_Click
        // Propósito:  
        // Fecha:      jueves, 09 de febrero de 2006, 18:01:06
        //--------------------------------------------------------------------
        private void nuevoToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            this.Text = "Ozone iPhone Editor " + EditorManager.EDITOR_VERSION + "";
            m_EditorManager.CURRENT_FILE = "";
            buttonSave.Enabled = false;
            m_EditorManager.ResetScene();
            pictureBoxRendering.Invalidate();
            radioCubos.Checked = true;
            toolStripStatusLabel1.Text = ""; 
        }


        //--------------------------------------------------------------------
        // Función:    checkBoxFondo_CheckedChanged
        // Propósito:  
        // Fecha:      lunes, 23 de octubre de 2006, 18:31:07
        //--------------------------------------------------------------------
        private void checkBoxFondo_CheckedChanged(object sender, EventArgs e)
        {
            m_EditorManager.BackgroundActivate = checkBoxFondo.Checked;
            pictureBoxRendering.Invalidate();
        }


        //--------------------------------------------------------------------
        // Función:    comboBoxFondo_SelectedIndexChanged
        // Propósito:  
        // Fecha:      lunes, 23 de octubre de 2006, 18:31:31
        //--------------------------------------------------------------------
        private void comboBoxFondo_SelectedIndexChanged(object sender, EventArgs e)
        {
            m_EditorManager.Background = comboBoxFondo.SelectedIndex;
            pictureBoxRendering.Invalidate();
        }


        //--------------------------------------------------------------------
        // Función:    exportarParaOzoneToolStripMenuItem_Click
        // Creador:    Nacho (AMD)
        // Fecha:      Friday  05/10/2007  17:16:37
        //--------------------------------------------------------------------
        private void exportarParaOzoneToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (m_EditorManager.m_iTeleport % 2 == 1)
            {
                MessageBox.Show("There is a telerporter without pair.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);


                return;
            }

            saveFileDialog1.ShowDialog();
        }

        private void saveFileDialog1_FileOk(object sender, CancelEventArgs e)
        {            
//     m_EditorManager.ExportFile(saveFileDialog1.OpenFile());
        }

        private void checkBoxRects_CheckedChanged(object sender, EventArgs e)
        {
            m_EditorManager.RectsActivate = checkBoxRects.Checked;
            pictureBoxRendering.Invalidate();
        }

        private void radioDecoration_CheckedChanged(object sender, EventArgs e)
        {
            if (radioDecoration.Checked)
            {
                comboBoxPiso.Enabled = true;

                imageListDeco.Images.Clear();

                foreach (Bitmap bmp in m_EditorManager.m_ImagenesDecos[comboBoxEstilos.Text])
                {
                    imageListDeco.Images.Add(bmp);
                }

                listViewTextures.Clear();
                listViewTextures.LargeImageList = imageListDeco;

                for (int i = 0; i < m_EditorManager.m_ImagenesDecos[comboBoxEstilos.Text].Length; i++)
                {
                    listViewTextures.Items.Add(new ListViewItem("" + (i < 10 ? "0" : "") + (i + 1), i));
                }

                comboBoxEstilos.Enabled = true;

                checkBoxDecorations.Checked = true;
            }
        }

        private void pictureBoxRendering_Click(object sender, EventArgs e)
        {
            pictureBoxRendering.Focus();
        }

        class CompareFileInfo : IComparer<FileInfo>
        {
            public int Compare(FileInfo x, FileInfo y)
            {
                return x.Name.CompareTo(y.Name);
            }
        }

        private void buttonScripts_Click(object sender, EventArgs e)
        {
            m_EditorManager.m_ListaScripts.Clear();
            comboBoxScripts.Items.Clear();

            
            FileInfo[] rgFiles;
            int i = 0;

            //

            DirectoryInfo di = new DirectoryInfo("gfx/episodes");
            DirectoryInfo[] rgDirs = di.GetDirectories();

            Array.Sort(rgDirs, new EditorManager.CompareDirectoryInfo());

            foreach (DirectoryInfo din in rgDirs)
            {

                DirectoryInfo dinfo = new DirectoryInfo("gfx/episodes/" + din.Name + "/scripts");
                rgFiles = dinfo.GetFiles("*.script");
                Array.Sort(rgFiles, new CompareFileInfo());

                string[] tempListScripts = new string[rgFiles.Length + 1];

                i = 0;

                tempListScripts[i] = " - none - ";

                foreach (FileInfo fi in rgFiles)
                {
                    tempListScripts[i + 1] = fi.Name.Replace(".script", "");
                    i++;
                }

                m_EditorManager.m_ListaScripts.Add(tempListScripts);
            }

            foreach (string script in m_EditorManager.m_ListaScripts[comboBoxEstilos.SelectedIndex])
            {
                comboBoxScripts.Items.Add(script);
            }

            comboBoxScripts.SelectedIndex = 0;

            /*
            comboBoxScripts.Items.Clear();

            DirectoryInfo di = new DirectoryInfo("scripts");
            FileInfo[] rgFiles = di.GetFiles("*.script");

            Array.Sort(rgFiles, new CompareFileInfo());

            int i = 0;

            comboBoxScripts.Items.Add(" - none - ");

            foreach (FileInfo fi in rgFiles)
            {

                comboBoxScripts.Items.Add(fi.Name.Replace(".script", ""));

                i++;
            }

            comboBoxScripts.SelectedIndex = 0;*/
        }

        private void pictureBoxRendering_MouseUp(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Middle)
                m_EditorManager.m_bPulsaBtnCentro = false;
            
            if (e.Button == MouseButtons.Middle)
                m_EditorManager.m_bPulsaBtnIzqdo = false;
        }

        private void timerScripts_Tick(object sender, EventArgs e)
        {
            if (checkBoxScripts.Checked)
            {
                m_EditorManager.m_bRenderScripts = !m_EditorManager.m_bRenderScripts;
                pictureBoxRendering.Invalidate();
            }
        }

        private void checkBoxScripts_CheckedChanged(object sender, EventArgs e)
        {
            m_EditorManager.m_bRenderScripts = true;
            pictureBoxRendering.Invalidate();
        }

        private void checkBoxScriptLabels_CheckedChanged(object sender, EventArgs e)
        {
            pictureBoxRendering.Invalidate();
        }



        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            try
            {
                FileStream f = new FileStream(m_currentDirectory + "\\editor.dat", FileMode.Create);

                BinaryWriter bw = new BinaryWriter(f);

                bw.Write(checkBoxFondo.Checked);
                bw.Write(checkBoxPantalla.Checked);
                bw.Write(checkBoxRects.Checked);
                bw.Write(checkBoxScriptLabels.Checked);
                bw.Write(checkBoxScripts.Checked);
                bw.Write(checkBoxSelector.Checked);
                bw.Write(this.WindowState.ToString());
                bw.Write(checkBoxWireframe.Checked);
                bw.Write(checkBox1.Checked);
                bw.Write(checkBoxDecorations.Checked);

                bw.Close();

                f.Close();
            }
            catch (Exception)
            {
            }

        }

        private void comboBoxPiso_SelectedIndexChanged(object sender, EventArgs e)
        {
            
            m_EditorManager.m_iCurrentFloor = comboBoxPiso.SelectedIndex;    
       
            switch (comboBoxPiso.SelectedIndex)
            {
                case 0:
                {
                    comboBoxPiso.ForeColor = Color.FromArgb(200, 50, 50);
                    break;
                }
                case 1:
                {
                    comboBoxPiso.ForeColor = Color.FromArgb(50, 150, 50);
                    break;
                }
                case 2:
                {
                    comboBoxPiso.ForeColor = Color.FromArgb(10, 100, 180);
                    break;
                }
            }
        }

        private int previousStyleIndex = 0;

        private void comboBoxEstilos_SelectedIndexChanged(object sender, EventArgs e)
        {
            bool doChange = false;

            if (m_EditorManager.IsSafeToChangeStylo(comboBoxEstilos.Text))
            {
                doChange = true;
            }
            else
            {
                DialogResult ret = MessageBox.Show("Warning! If you change the scene to this episode some objects will lose its ID because there are less objects in the new episode.\n\nAre you sure to continue changing the episode?", "Changing episode...", MessageBoxButtons.YesNo, MessageBoxIcon.Warning);

                doChange = (ret == DialogResult.Yes);
            }

            if (doChange)
            {


                pictureBoxRendering.Invalidate();

                imageListCubos.Images.Clear();

                foreach (Bitmap bmp in m_EditorManager.m_ImagenesCubos[comboBoxEstilos.Text])
                {
                    imageListCubos.Images.Add(bmp);
                }


                imageListDeco.Images.Clear();

                foreach (Bitmap bmp in m_EditorManager.m_ImagenesDecos[comboBoxEstilos.Text])
                {
                    imageListDeco.Images.Add(bmp);
                }

                listViewTextures.Clear();

                if (radioCubos.Checked)
                {
                    listViewTextures.LargeImageList = imageListCubos;

                    for (int i = 0; i < m_EditorManager.m_ImagenesCubos[comboBoxEstilos.Text].Length; i++)
                    {
                        listViewTextures.Items.Add(new ListViewItem("" + (i < 10 ? "0" : "") + (i + 1), i));
                    }
                }
                else if (radioDecoration.Checked)
                {
                    listViewTextures.LargeImageList = imageListDeco;

                    for (int i = 0; i < m_EditorManager.m_ImagenesDecos[comboBoxEstilos.Text].Length; i++)
                    {
                        listViewTextures.Items.Add(new ListViewItem("" + (i < 10 ? "0" : "") + (i + 1), i));
                    }
                }

                comboBoxScripts.Items.Clear();



                foreach (string script in m_EditorManager.m_ListaScripts[comboBoxEstilos.SelectedIndex])
                {
                    comboBoxScripts.Items.Add(script);
                }

                comboBoxScripts.SelectedIndex = 0;


                m_EditorManager.UpdateStylos(comboBoxEstilos.Text);

                previousStyleIndex = comboBoxEstilos.SelectedIndex;
            }
            else
            {
                comboBoxEstilos.SelectedIndex = previousStyleIndex;
            }

/*

            DirectoryInfo di = new DirectoryInfo("scripts");
            FileInfo[] rgFiles = di.GetFiles("*.script");

            Array.Sort(rgFiles, new CompareFileInfo());

            int i = 0;

            comboBoxScripts.Items.Add(" - none - ");

            foreach (FileInfo fi in rgFiles)
            {

                comboBoxScripts.Items.Add(fi.Name.Replace(".script", ""));

                i++;
            }

            comboBoxScripts.SelectedIndex = 0;*/
        }

        private void MainForm_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Right)
            {
                m_EditorManager.Rotation = 0;
            }
            else if (e.KeyCode == Keys.Down)
            {
                m_EditorManager.Rotation = 1;
            }
            else if (e.KeyCode == Keys.Left)
            {
                m_EditorManager.Rotation = 2;
            }
            else if (e.KeyCode == Keys.Up)
            {
                m_EditorManager.Rotation = 3;
            }

            if (m_EditorManager.Rotation == 0)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha1;
            }
            else if (m_EditorManager.Rotation == 1)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha2;
            }
            else if (m_EditorManager.Rotation == 2)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha3;
            }
            else if (m_EditorManager.Rotation == 3)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha4;
            }

            pictureBoxRendering.Focus();
        }

        private void MainForm_KeyPress(object sender, KeyPressEventArgs e)
        {
            pictureBoxRendering.Focus();
        }

        private void pictureBoxRendering_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e)
        {
            if (e.KeyCode == Keys.Right)
            {
                m_EditorManager.Rotation = 0;
            }
            else if (e.KeyCode == Keys.Down)
            {
                m_EditorManager.Rotation = 1;
            }
            else if (e.KeyCode == Keys.Left)
            {
                m_EditorManager.Rotation = 2;
            }
            else if (e.KeyCode == Keys.Up)
            {
                m_EditorManager.Rotation = 3;
            }

            if (m_EditorManager.Rotation == 0)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha1;
            }
            else if (m_EditorManager.Rotation == 1)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha2;
            }
            else if (m_EditorManager.Rotation == 2)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha3;
            }
            else if (m_EditorManager.Rotation == 3)
            {
                buttonRotacion.Image = global::Editor.Properties.Resources.flecha4;
            }

            pictureBoxRendering.Focus();
        }

        private void listViewTextures_SelectedIndexChanged(object sender, EventArgs e)
        {
            checkBoxPantalla.Checked = false;
        }

        private void buttonSave_Click(object sender, EventArgs e)
        {
            if (m_EditorManager.CURRENT_FILE != "")
            {
                m_EditorManager.SaveFile(new FileStream(m_EditorManager.CURRENT_FILE, FileMode.Create));

                toolStripStatusLabel1.Text = "File saved: " + m_EditorManager.CURRENT_FILE; 
                //MessageBox.Show("File saved.", "File saved", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                MessageBox.Show("The file could not be saved.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            }
        }

        private void checkBoxWireframe_CheckedChanged(object sender, EventArgs e)
        {
            pictureBoxRendering.Invalidate();
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            m_EditorManager.m_bRenderTriggers = checkBox1.Checked;
            pictureBoxRendering.Invalidate();
        }

        private void toolStripStatusLabel2_Click(object sender, EventArgs e)
        {
            if (sender is ToolStripLabel)
            {
                ToolStripLabel toolStripLabel1 = sender as ToolStripLabel;

                // Start Internet Explorer and navigate to the URL in the
                // tag property.
                System.Diagnostics.Process.Start("IEXPLORE.EXE", toolStripLabel1.Tag.ToString());

                // Set the LinkVisited property to true to change the color.
                toolStripLabel1.LinkVisited = false;
            }

        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            (new AboutBox1()).ShowDialog();
        }

        private void clearAllDecorationsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            m_EditorManager.ClearAll(4);
            pictureBoxRendering.Invalidate();
        }

        private void clearAllItesmToolStripMenuItem_Click(object sender, EventArgs e)
        {
            m_EditorManager.ClearAll(1);
            m_EditorManager.m_bStartTrigger = false;
            m_EditorManager.m_bExitTrigger = false;
            m_EditorManager.m_bStart = false;
            m_EditorManager.m_bExit = false;
            pictureBoxRendering.Invalidate();
        }

        private void clearAllEntitiesToolStripMenuItem_Click(object sender, EventArgs e)
        {
            m_EditorManager.ClearAll(2);
            pictureBoxRendering.Invalidate();
        }

        private void clearAllTeleportsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            m_EditorManager.ClearAll(3);
            pictureBoxRendering.Invalidate();
        }

        private void clearAllTriggersToolStripMenuItem_Click(object sender, EventArgs e)
        {
            m_EditorManager.ClearAll(1, 10);
            m_EditorManager.ClearAll(1, 11);
            m_EditorManager.ClearAll(1, 12);

            m_EditorManager.m_bStartTrigger = false;
            m_EditorManager.m_bExitTrigger = false;

            pictureBoxRendering.Invalidate();
        }

        private void clearAllCubesToolStripMenuItem_Click(object sender, EventArgs e)
        {
            m_EditorManager.ClearAll(0);
            pictureBoxRendering.Invalidate();
        }

        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            DialogResult ret = MessageBox.Show("Would you like to save before you quit?", "Quitting...", MessageBoxButtons.YesNo, MessageBoxIcon.Question);

            if (ret == DialogResult.Yes)
            {
                if (m_EditorManager.CURRENT_FILE != "")
                {
                    m_EditorManager.SaveFile(new FileStream(m_EditorManager.CURRENT_FILE, FileMode.Create));
                    
                    MessageBox.Show("File saved.", "File saved", MessageBoxButtons.OK, MessageBoxIcon.Information);
                }
                else
                {
                    bool error = false;
                    if (!m_EditorManager.m_bStart)
                    {
                        MessageBox.Show("There is no entry point.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                        error = true;
                    }
                    /*
                    if (!m_EditorManager.m_bExit)
                    {
                        MessageBox.Show("There is no exit point.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                        error = true;
                    }*/

                    if (m_EditorManager.m_iTeleport % 2 == 1)
                    {
                        MessageBox.Show("There is a telerporter without pair.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);

                        error = true;
                    }
                    /*
                    if (m_EditorManager.m_iGemCount <= 0)
                    {
                        MessageBox.Show("There are no yellow gems.", "Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        error = true;
                    }*/

                    if (error)
                    {
                        e.Cancel = true;   
                    }
                    else
                    {
                        saveFileDialog.ShowDialog();
                    }
                }
            }
        }

        private void comboBoxScripts_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {/*
            if (checkBoxLock.Checked)
            {
                checkBoxLock.Text = "Unlock current level";
            }
            else
            {
                checkBoxLock.Text = "Lock current level";
            }*/
        }

        private void checkBoxDecorations_CheckedChanged(object sender, EventArgs e)
        {
            pictureBoxRendering.Invalidate();
        }
    }
}