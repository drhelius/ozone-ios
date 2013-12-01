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

namespace Editor
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.radioCubos = new System.Windows.Forms.RadioButton();
            this.radioItems = new System.Windows.Forms.RadioButton();
            this.radioEnemigos = new System.Windows.Forms.RadioButton();
            this.radioTransport = new System.Windows.Forms.RadioButton();
            this.listViewTextures = new System.Windows.Forms.ListView();
            this.imageListCubos = new System.Windows.Forms.ImageList(this.components);
            this.labelGemas = new System.Windows.Forms.Label();
            this.textBoxGemas = new System.Windows.Forms.TextBox();
            this.labelTeleport = new System.Windows.Forms.Label();
            this.textBoxTeleport = new System.Windows.Forms.TextBox();
            this.labelX = new System.Windows.Forms.Label();
            this.textBoxX = new System.Windows.Forms.TextBox();
            this.labelY = new System.Windows.Forms.Label();
            this.textBoxY = new System.Windows.Forms.TextBox();
            this.horizontalScrollBar = new System.Windows.Forms.HScrollBar();
            this.verticalScrollBar = new System.Windows.Forms.VScrollBar();
            this.checkBoxPantalla = new System.Windows.Forms.CheckBox();
            this.menuStrip = new System.Windows.Forms.MenuStrip();
            this.archivoToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.nuevoToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.abrirToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.guardarComoToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.salirToolStripMenuItem1 = new System.Windows.Forms.ToolStripMenuItem();
            this.actionsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.clearAllCubesToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.clearAllItesmToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.clearAllDecorationsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.clearAllEntitiesToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.clearAllTeleportsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.clearAllTriggersToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.aboutToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.archivoToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.nuevoToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.abrirToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.guardarComoToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.salirToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.textBoxCubos = new System.Windows.Forms.TextBox();
            this.labelCubos = new System.Windows.Forms.Label();
            this.groupBox = new System.Windows.Forms.GroupBox();
            this.textBoxElements = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.numericUpDownCursorX = new System.Windows.Forms.NumericUpDown();
            this.numericUpDownCursorY = new System.Windows.Forms.NumericUpDown();
            this.labelCursorX = new System.Windows.Forms.Label();
            this.labelCursorY = new System.Windows.Forms.Label();
            this.imageListItems = new System.Windows.Forms.ImageList(this.components);
            this.openFileDialog = new System.Windows.Forms.OpenFileDialog();
            this.imageListEnems = new System.Windows.Forms.ImageList(this.components);
            this.checkBoxFondo = new System.Windows.Forms.CheckBox();
            this.comboBoxFondo = new System.Windows.Forms.ComboBox();
            this.imageListTrans = new System.Windows.Forms.ImageList(this.components);
            this.label1 = new System.Windows.Forms.Label();
            this.comboBoxPiso = new System.Windows.Forms.ComboBox();
            this.saveFileDialog1 = new System.Windows.Forms.SaveFileDialog();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.comboBoxScripts = new System.Windows.Forms.ComboBox();
            this.buttonScripts = new System.Windows.Forms.Button();
            this.radioDecoration = new System.Windows.Forms.RadioButton();
            this.checkBoxRects = new System.Windows.Forms.CheckBox();
            this.imageListDeco = new System.Windows.Forms.ImageList(this.components);
            this.timerScripts = new System.Windows.Forms.Timer(this.components);
            this.checkBoxScripts = new System.Windows.Forms.CheckBox();
            this.checkBoxScriptLabels = new System.Windows.Forms.CheckBox();
            this.checkBoxSelector = new System.Windows.Forms.CheckBox();
            this.comboBoxEstilos = new System.Windows.Forms.ComboBox();
            this.buttonSave = new System.Windows.Forms.Button();
            this.checkBoxWireframe = new System.Windows.Forms.CheckBox();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusLabel2 = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusLabel1 = new System.Windows.Forms.ToolStripStatusLabel();
            this.buttonRotacion = new System.Windows.Forms.Button();
            this.pictureBoxRendering = new System.Windows.Forms.PictureBox();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.checkBoxDecorations = new System.Windows.Forms.CheckBox();
            this.checkBoxLock = new System.Windows.Forms.CheckBox();
            this.menuStrip.SuspendLayout();
            this.groupBox.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownCursorX)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownCursorY)).BeginInit();
            this.statusStrip1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxRendering)).BeginInit();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // radioCubos
            // 
            this.radioCubos.AutoSize = true;
            this.radioCubos.Location = new System.Drawing.Point(5, 65);
            this.radioCubos.Name = "radioCubos";
            this.radioCubos.Size = new System.Drawing.Size(55, 17);
            this.radioCubos.TabIndex = 0;
            this.radioCubos.TabStop = true;
            this.radioCubos.Text = "Cubes";
            this.radioCubos.UseVisualStyleBackColor = true;
            this.radioCubos.CheckedChanged += new System.EventHandler(this.radioCubos_CheckedChanged);
            // 
            // radioItems
            // 
            this.radioItems.AutoSize = true;
            this.radioItems.Location = new System.Drawing.Point(74, 88);
            this.radioItems.Name = "radioItems";
            this.radioItems.Size = new System.Drawing.Size(50, 17);
            this.radioItems.TabIndex = 2;
            this.radioItems.TabStop = true;
            this.radioItems.Text = "Items";
            this.radioItems.UseVisualStyleBackColor = true;
            this.radioItems.CheckedChanged += new System.EventHandler(this.radioItems_CheckedChanged);
            // 
            // radioEnemigos
            // 
            this.radioEnemigos.AutoSize = true;
            this.radioEnemigos.Location = new System.Drawing.Point(5, 88);
            this.radioEnemigos.Name = "radioEnemigos";
            this.radioEnemigos.Size = new System.Drawing.Size(59, 17);
            this.radioEnemigos.TabIndex = 3;
            this.radioEnemigos.TabStop = true;
            this.radioEnemigos.Text = "Entities";
            this.radioEnemigos.UseVisualStyleBackColor = true;
            this.radioEnemigos.CheckedChanged += new System.EventHandler(this.radioEnemigos_CheckedChanged);
            // 
            // radioTransport
            // 
            this.radioTransport.AutoSize = true;
            this.radioTransport.Location = new System.Drawing.Point(134, 88);
            this.radioTransport.Name = "radioTransport";
            this.radioTransport.Size = new System.Drawing.Size(64, 17);
            this.radioTransport.TabIndex = 4;
            this.radioTransport.TabStop = true;
            this.radioTransport.Text = "Teleport";
            this.radioTransport.UseVisualStyleBackColor = true;
            this.radioTransport.CheckedChanged += new System.EventHandler(this.radioTransport_CheckedChanged);
            // 
            // listViewTextures
            // 
            this.listViewTextures.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)));
            this.listViewTextures.LargeImageList = this.imageListCubos;
            this.listViewTextures.Location = new System.Drawing.Point(5, 111);
            this.listViewTextures.MultiSelect = false;
            this.listViewTextures.Name = "listViewTextures";
            this.listViewTextures.Size = new System.Drawing.Size(224, 433);
            this.listViewTextures.TabIndex = 5;
            this.listViewTextures.UseCompatibleStateImageBehavior = false;
            this.listViewTextures.SelectedIndexChanged += new System.EventHandler(this.listViewTextures_SelectedIndexChanged);
            // 
            // imageListCubos
            // 
            this.imageListCubos.ColorDepth = System.Windows.Forms.ColorDepth.Depth24Bit;
            this.imageListCubos.ImageSize = new System.Drawing.Size(38, 44);
            this.imageListCubos.TransparentColor = System.Drawing.Color.Transparent;
            // 
            // labelGemas
            // 
            this.labelGemas.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.labelGemas.AutoSize = true;
            this.labelGemas.Location = new System.Drawing.Point(6, 11);
            this.labelGemas.Name = "labelGemas";
            this.labelGemas.Size = new System.Drawing.Size(37, 13);
            this.labelGemas.TabIndex = 6;
            this.labelGemas.Text = "Gems:";
            // 
            // textBoxGemas
            // 
            this.textBoxGemas.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.textBoxGemas.Enabled = false;
            this.textBoxGemas.Location = new System.Drawing.Point(9, 27);
            this.textBoxGemas.Name = "textBoxGemas";
            this.textBoxGemas.ReadOnly = true;
            this.textBoxGemas.Size = new System.Drawing.Size(40, 20);
            this.textBoxGemas.TabIndex = 7;
            // 
            // labelTeleport
            // 
            this.labelTeleport.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.labelTeleport.AutoSize = true;
            this.labelTeleport.Location = new System.Drawing.Point(62, 11);
            this.labelTeleport.Name = "labelTeleport";
            this.labelTeleport.Size = new System.Drawing.Size(49, 13);
            this.labelTeleport.TabIndex = 8;
            this.labelTeleport.Text = "Teleport:";
            // 
            // textBoxTeleport
            // 
            this.textBoxTeleport.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.textBoxTeleport.Enabled = false;
            this.textBoxTeleport.Location = new System.Drawing.Point(65, 27);
            this.textBoxTeleport.Name = "textBoxTeleport";
            this.textBoxTeleport.ReadOnly = true;
            this.textBoxTeleport.Size = new System.Drawing.Size(47, 20);
            this.textBoxTeleport.TabIndex = 9;
            // 
            // labelX
            // 
            this.labelX.AutoSize = true;
            this.labelX.Location = new System.Drawing.Point(6, 55);
            this.labelX.Name = "labelX";
            this.labelX.Size = new System.Drawing.Size(17, 13);
            this.labelX.TabIndex = 10;
            this.labelX.Text = "X:";
            // 
            // textBoxX
            // 
            this.textBoxX.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.textBoxX.Enabled = false;
            this.textBoxX.Location = new System.Drawing.Point(9, 66);
            this.textBoxX.Name = "textBoxX";
            this.textBoxX.ReadOnly = true;
            this.textBoxX.Size = new System.Drawing.Size(40, 20);
            this.textBoxX.TabIndex = 11;
            // 
            // labelY
            // 
            this.labelY.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.labelY.AutoSize = true;
            this.labelY.Location = new System.Drawing.Point(62, 50);
            this.labelY.Name = "labelY";
            this.labelY.Size = new System.Drawing.Size(17, 13);
            this.labelY.TabIndex = 12;
            this.labelY.Text = "Y:";
            // 
            // textBoxY
            // 
            this.textBoxY.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.textBoxY.Enabled = false;
            this.textBoxY.Location = new System.Drawing.Point(65, 66);
            this.textBoxY.Name = "textBoxY";
            this.textBoxY.ReadOnly = true;
            this.textBoxY.Size = new System.Drawing.Size(46, 20);
            this.textBoxY.TabIndex = 13;
            // 
            // horizontalScrollBar
            // 
            this.horizontalScrollBar.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.horizontalScrollBar.Location = new System.Drawing.Point(235, 900);
            this.horizontalScrollBar.Maximum = 1000;
            this.horizontalScrollBar.Name = "horizontalScrollBar";
            this.horizontalScrollBar.Size = new System.Drawing.Size(925, 18);
            this.horizontalScrollBar.TabIndex = 14;
            this.horizontalScrollBar.Scroll += new System.Windows.Forms.ScrollEventHandler(this.horizontalScrollBar_Scroll);
            // 
            // verticalScrollBar
            // 
            this.verticalScrollBar.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.verticalScrollBar.Location = new System.Drawing.Point(1164, 36);
            this.verticalScrollBar.Maximum = 1000;
            this.verticalScrollBar.Name = "verticalScrollBar";
            this.verticalScrollBar.Size = new System.Drawing.Size(17, 861);
            this.verticalScrollBar.TabIndex = 15;
            this.verticalScrollBar.Scroll += new System.Windows.Forms.ScrollEventHandler(this.verticalScrollBar_Scroll);
            // 
            // checkBoxPantalla
            // 
            this.checkBoxPantalla.AutoSize = true;
            this.checkBoxPantalla.Location = new System.Drawing.Point(122, 162);
            this.checkBoxPantalla.Name = "checkBoxPantalla";
            this.checkBoxPantalla.Size = new System.Drawing.Size(85, 17);
            this.checkBoxPantalla.TabIndex = 16;
            this.checkBoxPantalla.Text = "Screen Area";
            this.checkBoxPantalla.UseVisualStyleBackColor = true;
            this.checkBoxPantalla.CheckedChanged += new System.EventHandler(this.checkBoxPantalla_CheckedChanged);
            // 
            // menuStrip
            // 
            this.menuStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.archivoToolStripMenuItem1,
            this.actionsToolStripMenuItem,
            this.aboutToolStripMenuItem});
            this.menuStrip.Location = new System.Drawing.Point(0, 0);
            this.menuStrip.Name = "menuStrip";
            this.menuStrip.Size = new System.Drawing.Size(1190, 24);
            this.menuStrip.TabIndex = 17;
            this.menuStrip.Text = "menuStrip1";
            // 
            // archivoToolStripMenuItem1
            // 
            this.archivoToolStripMenuItem1.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.nuevoToolStripMenuItem1,
            this.abrirToolStripMenuItem1,
            this.guardarComoToolStripMenuItem1,
            this.toolStripSeparator2,
            this.salirToolStripMenuItem1});
            this.archivoToolStripMenuItem1.Name = "archivoToolStripMenuItem1";
            this.archivoToolStripMenuItem1.Size = new System.Drawing.Size(37, 20);
            this.archivoToolStripMenuItem1.Text = "File";
            // 
            // nuevoToolStripMenuItem1
            // 
            this.nuevoToolStripMenuItem1.Name = "nuevoToolStripMenuItem1";
            this.nuevoToolStripMenuItem1.Size = new System.Drawing.Size(123, 22);
            this.nuevoToolStripMenuItem1.Text = "New";
            this.nuevoToolStripMenuItem1.Click += new System.EventHandler(this.nuevoToolStripMenuItem1_Click);
            // 
            // abrirToolStripMenuItem1
            // 
            this.abrirToolStripMenuItem1.Name = "abrirToolStripMenuItem1";
            this.abrirToolStripMenuItem1.Size = new System.Drawing.Size(123, 22);
            this.abrirToolStripMenuItem1.Text = "Open...";
            this.abrirToolStripMenuItem1.Click += new System.EventHandler(this.abrirToolStripMenuItem1_Click);
            // 
            // guardarComoToolStripMenuItem1
            // 
            this.guardarComoToolStripMenuItem1.Name = "guardarComoToolStripMenuItem1";
            this.guardarComoToolStripMenuItem1.Size = new System.Drawing.Size(123, 22);
            this.guardarComoToolStripMenuItem1.Text = "Save As...";
            this.guardarComoToolStripMenuItem1.Click += new System.EventHandler(this.guardarComoToolStripMenuItem1_Click);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(120, 6);
            // 
            // salirToolStripMenuItem1
            // 
            this.salirToolStripMenuItem1.Name = "salirToolStripMenuItem1";
            this.salirToolStripMenuItem1.Size = new System.Drawing.Size(123, 22);
            this.salirToolStripMenuItem1.Text = "Exit";
            this.salirToolStripMenuItem1.Click += new System.EventHandler(this.salirToolStripMenuItem1_Click);
            // 
            // actionsToolStripMenuItem
            // 
            this.actionsToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.clearAllCubesToolStripMenuItem,
            this.clearAllItesmToolStripMenuItem,
            this.clearAllDecorationsToolStripMenuItem,
            this.clearAllEntitiesToolStripMenuItem,
            this.clearAllTeleportsToolStripMenuItem,
            this.clearAllTriggersToolStripMenuItem});
            this.actionsToolStripMenuItem.Name = "actionsToolStripMenuItem";
            this.actionsToolStripMenuItem.Size = new System.Drawing.Size(59, 20);
            this.actionsToolStripMenuItem.Text = "Actions";
            // 
            // clearAllCubesToolStripMenuItem
            // 
            this.clearAllCubesToolStripMenuItem.Name = "clearAllCubesToolStripMenuItem";
            this.clearAllCubesToolStripMenuItem.Size = new System.Drawing.Size(181, 22);
            this.clearAllCubesToolStripMenuItem.Text = "Clear all cubes";
            this.clearAllCubesToolStripMenuItem.Click += new System.EventHandler(this.clearAllCubesToolStripMenuItem_Click);
            // 
            // clearAllItesmToolStripMenuItem
            // 
            this.clearAllItesmToolStripMenuItem.Name = "clearAllItesmToolStripMenuItem";
            this.clearAllItesmToolStripMenuItem.Size = new System.Drawing.Size(181, 22);
            this.clearAllItesmToolStripMenuItem.Text = "Clear all items";
            this.clearAllItesmToolStripMenuItem.Click += new System.EventHandler(this.clearAllItesmToolStripMenuItem_Click);
            // 
            // clearAllDecorationsToolStripMenuItem
            // 
            this.clearAllDecorationsToolStripMenuItem.Name = "clearAllDecorationsToolStripMenuItem";
            this.clearAllDecorationsToolStripMenuItem.Size = new System.Drawing.Size(181, 22);
            this.clearAllDecorationsToolStripMenuItem.Text = "Clear all decorations";
            this.clearAllDecorationsToolStripMenuItem.Click += new System.EventHandler(this.clearAllDecorationsToolStripMenuItem_Click);
            // 
            // clearAllEntitiesToolStripMenuItem
            // 
            this.clearAllEntitiesToolStripMenuItem.Name = "clearAllEntitiesToolStripMenuItem";
            this.clearAllEntitiesToolStripMenuItem.Size = new System.Drawing.Size(181, 22);
            this.clearAllEntitiesToolStripMenuItem.Text = "Clear all entities";
            this.clearAllEntitiesToolStripMenuItem.Click += new System.EventHandler(this.clearAllEntitiesToolStripMenuItem_Click);
            // 
            // clearAllTeleportsToolStripMenuItem
            // 
            this.clearAllTeleportsToolStripMenuItem.Name = "clearAllTeleportsToolStripMenuItem";
            this.clearAllTeleportsToolStripMenuItem.Size = new System.Drawing.Size(181, 22);
            this.clearAllTeleportsToolStripMenuItem.Text = "Clear all teleports";
            this.clearAllTeleportsToolStripMenuItem.Click += new System.EventHandler(this.clearAllTeleportsToolStripMenuItem_Click);
            // 
            // clearAllTriggersToolStripMenuItem
            // 
            this.clearAllTriggersToolStripMenuItem.Name = "clearAllTriggersToolStripMenuItem";
            this.clearAllTriggersToolStripMenuItem.Size = new System.Drawing.Size(181, 22);
            this.clearAllTriggersToolStripMenuItem.Text = "Clear all triggers";
            this.clearAllTriggersToolStripMenuItem.Click += new System.EventHandler(this.clearAllTriggersToolStripMenuItem_Click);
            // 
            // aboutToolStripMenuItem
            // 
            this.aboutToolStripMenuItem.Name = "aboutToolStripMenuItem";
            this.aboutToolStripMenuItem.Size = new System.Drawing.Size(52, 20);
            this.aboutToolStripMenuItem.Text = "About";
            this.aboutToolStripMenuItem.Click += new System.EventHandler(this.aboutToolStripMenuItem_Click);
            // 
            // archivoToolStripMenuItem
            // 
            this.archivoToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.nuevoToolStripMenuItem,
            this.abrirToolStripMenuItem,
            this.guardarComoToolStripMenuItem,
            this.toolStripSeparator1,
            this.salirToolStripMenuItem});
            this.archivoToolStripMenuItem.Name = "archivoToolStripMenuItem";
            this.archivoToolStripMenuItem.Size = new System.Drawing.Size(55, 20);
            this.archivoToolStripMenuItem.Text = "Archivo";
            // 
            // nuevoToolStripMenuItem
            // 
            this.nuevoToolStripMenuItem.Name = "nuevoToolStripMenuItem";
            this.nuevoToolStripMenuItem.Size = new System.Drawing.Size(161, 22);
            this.nuevoToolStripMenuItem.Text = "Nuevo";
            this.nuevoToolStripMenuItem.Click += new System.EventHandler(this.nuevoToolStripMenuItem_Click);
            // 
            // abrirToolStripMenuItem
            // 
            this.abrirToolStripMenuItem.Name = "abrirToolStripMenuItem";
            this.abrirToolStripMenuItem.Size = new System.Drawing.Size(161, 22);
            this.abrirToolStripMenuItem.Text = "Abrir...";
            this.abrirToolStripMenuItem.Click += new System.EventHandler(this.abrirToolStripMenuItem_Click);
            // 
            // guardarComoToolStripMenuItem
            // 
            this.guardarComoToolStripMenuItem.Name = "guardarComoToolStripMenuItem";
            this.guardarComoToolStripMenuItem.Size = new System.Drawing.Size(161, 22);
            this.guardarComoToolStripMenuItem.Text = "Guardar Como...";
            this.guardarComoToolStripMenuItem.Click += new System.EventHandler(this.guardarComoToolStripMenuItem_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(158, 6);
            // 
            // salirToolStripMenuItem
            // 
            this.salirToolStripMenuItem.Name = "salirToolStripMenuItem";
            this.salirToolStripMenuItem.Size = new System.Drawing.Size(161, 22);
            this.salirToolStripMenuItem.Text = "Salir";
            // 
            // saveFileDialog
            // 
            this.saveFileDialog.DefaultExt = "oil";
            this.saveFileDialog.Filter = "Ozone iPhone Level (*.oil)|*.oil|All files (*.*)|*.*";
            this.saveFileDialog.Title = "Save Level...";
            this.saveFileDialog.FileOk += new System.ComponentModel.CancelEventHandler(this.saveFileDialog_FileOk);
            // 
            // textBoxCubos
            // 
            this.textBoxCubos.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.textBoxCubos.Enabled = false;
            this.textBoxCubos.Location = new System.Drawing.Point(127, 27);
            this.textBoxCubos.Name = "textBoxCubos";
            this.textBoxCubos.ReadOnly = true;
            this.textBoxCubos.Size = new System.Drawing.Size(45, 20);
            this.textBoxCubos.TabIndex = 18;
            // 
            // labelCubos
            // 
            this.labelCubos.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.labelCubos.AutoSize = true;
            this.labelCubos.Location = new System.Drawing.Point(128, 11);
            this.labelCubos.Name = "labelCubos";
            this.labelCubos.Size = new System.Drawing.Size(40, 13);
            this.labelCubos.TabIndex = 19;
            this.labelCubos.Text = "Cubes:";
            // 
            // groupBox
            // 
            this.groupBox.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.groupBox.Controls.Add(this.textBoxElements);
            this.groupBox.Controls.Add(this.label5);
            this.groupBox.Controls.Add(this.labelGemas);
            this.groupBox.Controls.Add(this.textBoxCubos);
            this.groupBox.Controls.Add(this.labelCubos);
            this.groupBox.Controls.Add(this.textBoxGemas);
            this.groupBox.Controls.Add(this.labelTeleport);
            this.groupBox.Controls.Add(this.textBoxTeleport);
            this.groupBox.Controls.Add(this.textBoxX);
            this.groupBox.Controls.Add(this.labelX);
            this.groupBox.Controls.Add(this.labelY);
            this.groupBox.Controls.Add(this.textBoxY);
            this.groupBox.Location = new System.Drawing.Point(5, 817);
            this.groupBox.Name = "groupBox";
            this.groupBox.Size = new System.Drawing.Size(224, 92);
            this.groupBox.TabIndex = 20;
            this.groupBox.TabStop = false;
            // 
            // textBoxElements
            // 
            this.textBoxElements.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.textBoxElements.Enabled = false;
            this.textBoxElements.Location = new System.Drawing.Point(127, 66);
            this.textBoxElements.Name = "textBoxElements";
            this.textBoxElements.ReadOnly = true;
            this.textBoxElements.Size = new System.Drawing.Size(45, 20);
            this.textBoxElements.TabIndex = 21;
            // 
            // label5
            // 
            this.label5.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(125, 50);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(53, 13);
            this.label5.TabIndex = 20;
            this.label5.Text = "Elements:";
            // 
            // numericUpDownCursorX
            // 
            this.numericUpDownCursorX.Location = new System.Drawing.Point(9, 32);
            this.numericUpDownCursorX.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numericUpDownCursorX.Name = "numericUpDownCursorX";
            this.numericUpDownCursorX.Size = new System.Drawing.Size(40, 20);
            this.numericUpDownCursorX.TabIndex = 21;
            this.numericUpDownCursorX.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numericUpDownCursorX.ValueChanged += new System.EventHandler(this.numericUpDownCursorX_ValueChanged);
            // 
            // numericUpDownCursorY
            // 
            this.numericUpDownCursorY.Location = new System.Drawing.Point(69, 32);
            this.numericUpDownCursorY.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numericUpDownCursorY.Name = "numericUpDownCursorY";
            this.numericUpDownCursorY.Size = new System.Drawing.Size(40, 20);
            this.numericUpDownCursorY.TabIndex = 22;
            this.numericUpDownCursorY.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.numericUpDownCursorY.ValueChanged += new System.EventHandler(this.numericUpDownCursorY_ValueChanged);
            // 
            // labelCursorX
            // 
            this.labelCursorX.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.labelCursorX.AutoSize = true;
            this.labelCursorX.Location = new System.Drawing.Point(6, 31);
            this.labelCursorX.Name = "labelCursorX";
            this.labelCursorX.Size = new System.Drawing.Size(55, 13);
            this.labelCursorX.TabIndex = 23;
            this.labelCursorX.Text = "Repeat X:";
            // 
            // labelCursorY
            // 
            this.labelCursorY.AutoSize = true;
            this.labelCursorY.Location = new System.Drawing.Point(66, 17);
            this.labelCursorY.Name = "labelCursorY";
            this.labelCursorY.Size = new System.Drawing.Size(55, 13);
            this.labelCursorY.TabIndex = 24;
            this.labelCursorY.Text = "Repeat Y:";
            // 
            // imageListItems
            // 
            this.imageListItems.ColorDepth = System.Windows.Forms.ColorDepth.Depth24Bit;
            this.imageListItems.ImageSize = new System.Drawing.Size(32, 32);
            this.imageListItems.TransparentColor = System.Drawing.Color.Transparent;
            // 
            // openFileDialog
            // 
            this.openFileDialog.DefaultExt = "oil";
            this.openFileDialog.Filter = "Ozone iPhone Level (*.oil)|*.oil|All files (*.*)|*.*";
            this.openFileDialog.Title = "Open Level...";
            this.openFileDialog.FileOk += new System.ComponentModel.CancelEventHandler(this.openFileDialog_FileOk);
            // 
            // imageListEnems
            // 
            this.imageListEnems.ColorDepth = System.Windows.Forms.ColorDepth.Depth24Bit;
            this.imageListEnems.ImageSize = new System.Drawing.Size(32, 32);
            this.imageListEnems.TransparentColor = System.Drawing.Color.Transparent;
            // 
            // checkBoxFondo
            // 
            this.checkBoxFondo.AutoSize = true;
            this.checkBoxFondo.Location = new System.Drawing.Point(9, 162);
            this.checkBoxFondo.Name = "checkBoxFondo";
            this.checkBoxFondo.Size = new System.Drawing.Size(84, 17);
            this.checkBoxFondo.TabIndex = 26;
            this.checkBoxFondo.Text = "Background";
            this.checkBoxFondo.UseVisualStyleBackColor = true;
            this.checkBoxFondo.CheckedChanged += new System.EventHandler(this.checkBoxFondo_CheckedChanged);
            // 
            // comboBoxFondo
            // 
            this.comboBoxFondo.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxFondo.FormattingEnabled = true;
            this.comboBoxFondo.Location = new System.Drawing.Point(150, 67);
            this.comboBoxFondo.Name = "comboBoxFondo";
            this.comboBoxFondo.Size = new System.Drawing.Size(66, 21);
            this.comboBoxFondo.TabIndex = 27;
            this.comboBoxFondo.SelectedIndexChanged += new System.EventHandler(this.comboBoxFondo_SelectedIndexChanged);
            // 
            // imageListTrans
            // 
            this.imageListTrans.ColorDepth = System.Windows.Forms.ColorDepth.Depth24Bit;
            this.imageListTrans.ImageSize = new System.Drawing.Size(32, 32);
            this.imageListTrans.TransparentColor = System.Drawing.Color.Transparent;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(118, 70);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(35, 13);
            this.label1.TabIndex = 28;
            this.label1.Text = "Bgnd:";
            // 
            // comboBoxPiso
            // 
            this.comboBoxPiso.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxPiso.FormattingEnabled = true;
            this.comboBoxPiso.Items.AddRange(new object[] {
            "Floor #0",
            "Floor #1",
            "Floor #2"});
            this.comboBoxPiso.Location = new System.Drawing.Point(43, 67);
            this.comboBoxPiso.Name = "comboBoxPiso";
            this.comboBoxPiso.Size = new System.Drawing.Size(66, 21);
            this.comboBoxPiso.TabIndex = 29;
            this.comboBoxPiso.SelectedIndexChanged += new System.EventHandler(this.comboBoxPiso_SelectedIndexChanged);
            // 
            // saveFileDialog1
            // 
            this.saveFileDialog1.DefaultExt = "nhe";
            this.saveFileDialog1.Filter = "Ozone Level (*.nhe)|*.nhe|All files (*.*)|*.*";
            this.saveFileDialog1.Title = "Exportar Para Ozone";
            this.saveFileDialog1.FileOk += new System.ComponentModel.CancelEventHandler(this.saveFileDialog1_FileOk);
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(4, 70);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(33, 13);
            this.label2.TabIndex = 30;
            this.label2.Text = "Floor:";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(122, 32);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(50, 13);
            this.label3.TabIndex = 31;
            this.label3.Text = "Rotation:";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(4, 107);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(37, 13);
            this.label4.TabIndex = 32;
            this.label4.Text = "Script:";
            // 
            // comboBoxScripts
            // 
            this.comboBoxScripts.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxScripts.FormattingEnabled = true;
            this.comboBoxScripts.Location = new System.Drawing.Point(43, 104);
            this.comboBoxScripts.Name = "comboBoxScripts";
            this.comboBoxScripts.Size = new System.Drawing.Size(82, 21);
            this.comboBoxScripts.TabIndex = 33;
            this.comboBoxScripts.SelectedIndexChanged += new System.EventHandler(this.comboBoxScripts_SelectedIndexChanged);
            // 
            // buttonScripts
            // 
            this.buttonScripts.Location = new System.Drawing.Point(131, 104);
            this.buttonScripts.Name = "buttonScripts";
            this.buttonScripts.Size = new System.Drawing.Size(85, 23);
            this.buttonScripts.TabIndex = 34;
            this.buttonScripts.Text = "Reload Scripts";
            this.buttonScripts.UseVisualStyleBackColor = true;
            this.buttonScripts.Click += new System.EventHandler(this.buttonScripts_Click);
            // 
            // radioDecoration
            // 
            this.radioDecoration.AutoSize = true;
            this.radioDecoration.Location = new System.Drawing.Point(62, 65);
            this.radioDecoration.Name = "radioDecoration";
            this.radioDecoration.Size = new System.Drawing.Size(77, 17);
            this.radioDecoration.TabIndex = 35;
            this.radioDecoration.TabStop = true;
            this.radioDecoration.Text = "Decoration";
            this.radioDecoration.UseVisualStyleBackColor = true;
            this.radioDecoration.CheckedChanged += new System.EventHandler(this.radioDecoration_CheckedChanged);
            // 
            // checkBoxRects
            // 
            this.checkBoxRects.AutoSize = true;
            this.checkBoxRects.Checked = true;
            this.checkBoxRects.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBoxRects.Location = new System.Drawing.Point(9, 185);
            this.checkBoxRects.Name = "checkBoxRects";
            this.checkBoxRects.Size = new System.Drawing.Size(102, 17);
            this.checkBoxRects.TabIndex = 36;
            this.checkBoxRects.Text = "Bounding Rects";
            this.checkBoxRects.UseVisualStyleBackColor = true;
            this.checkBoxRects.CheckedChanged += new System.EventHandler(this.checkBoxRects_CheckedChanged);
            // 
            // imageListDeco
            // 
            this.imageListDeco.ColorDepth = System.Windows.Forms.ColorDepth.Depth24Bit;
            this.imageListDeco.ImageSize = new System.Drawing.Size(32, 32);
            this.imageListDeco.TransparentColor = System.Drawing.Color.Transparent;
            // 
            // timerScripts
            // 
            this.timerScripts.Interval = 700;
            this.timerScripts.Tick += new System.EventHandler(this.timerScripts_Tick);
            // 
            // checkBoxScripts
            // 
            this.checkBoxScripts.AutoSize = true;
            this.checkBoxScripts.Location = new System.Drawing.Point(122, 139);
            this.checkBoxScripts.Name = "checkBoxScripts";
            this.checkBoxScripts.Size = new System.Drawing.Size(87, 17);
            this.checkBoxScripts.TabIndex = 37;
            this.checkBoxScripts.Text = "Script Flicker";
            this.checkBoxScripts.UseVisualStyleBackColor = true;
            this.checkBoxScripts.CheckedChanged += new System.EventHandler(this.checkBoxScripts_CheckedChanged);
            // 
            // checkBoxScriptLabels
            // 
            this.checkBoxScriptLabels.AutoSize = true;
            this.checkBoxScriptLabels.Location = new System.Drawing.Point(9, 139);
            this.checkBoxScriptLabels.Name = "checkBoxScriptLabels";
            this.checkBoxScriptLabels.Size = new System.Drawing.Size(87, 17);
            this.checkBoxScriptLabels.TabIndex = 38;
            this.checkBoxScriptLabels.Text = "Script Labels";
            this.checkBoxScriptLabels.UseVisualStyleBackColor = true;
            this.checkBoxScriptLabels.CheckedChanged += new System.EventHandler(this.checkBoxScriptLabels_CheckedChanged);
            // 
            // checkBoxSelector
            // 
            this.checkBoxSelector.AutoSize = true;
            this.checkBoxSelector.Checked = true;
            this.checkBoxSelector.CheckState = System.Windows.Forms.CheckState.Checked;
            this.checkBoxSelector.Location = new System.Drawing.Point(122, 185);
            this.checkBoxSelector.Name = "checkBoxSelector";
            this.checkBoxSelector.Size = new System.Drawing.Size(65, 17);
            this.checkBoxSelector.TabIndex = 39;
            this.checkBoxSelector.Text = "Selector";
            this.checkBoxSelector.UseVisualStyleBackColor = true;
            // 
            // comboBoxEstilos
            // 
            this.comboBoxEstilos.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxEstilos.FormattingEnabled = true;
            this.comboBoxEstilos.Location = new System.Drawing.Point(141, 64);
            this.comboBoxEstilos.Name = "comboBoxEstilos";
            this.comboBoxEstilos.Size = new System.Drawing.Size(86, 21);
            this.comboBoxEstilos.TabIndex = 40;
            this.comboBoxEstilos.SelectedIndexChanged += new System.EventHandler(this.comboBoxEstilos_SelectedIndexChanged);
            // 
            // buttonSave
            // 
            this.buttonSave.Location = new System.Drawing.Point(5, 36);
            this.buttonSave.Name = "buttonSave";
            this.buttonSave.Size = new System.Drawing.Size(109, 23);
            this.buttonSave.TabIndex = 41;
            this.buttonSave.Text = "Save in current file";
            this.buttonSave.UseVisualStyleBackColor = true;
            this.buttonSave.Click += new System.EventHandler(this.buttonSave_Click);
            // 
            // checkBoxWireframe
            // 
            this.checkBoxWireframe.AutoSize = true;
            this.checkBoxWireframe.Location = new System.Drawing.Point(9, 208);
            this.checkBoxWireframe.Name = "checkBoxWireframe";
            this.checkBoxWireframe.Size = new System.Drawing.Size(74, 17);
            this.checkBoxWireframe.TabIndex = 42;
            this.checkBoxWireframe.Text = "Wireframe";
            this.checkBoxWireframe.UseVisualStyleBackColor = true;
            this.checkBoxWireframe.CheckedChanged += new System.EventHandler(this.checkBoxWireframe_CheckedChanged);
            // 
            // checkBox1
            // 
            this.checkBox1.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new System.Drawing.Point(121, 208);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(94, 17);
            this.checkBox1.TabIndex = 43;
            this.checkBox1.Text = "Show Triggers";
            this.checkBox1.UseVisualStyleBackColor = true;
            this.checkBox1.CheckedChanged += new System.EventHandler(this.checkBox1_CheckedChanged);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusLabel2,
            this.toolStripStatusLabel1});
            this.statusStrip1.Location = new System.Drawing.Point(0, 921);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(1190, 22);
            this.statusStrip1.TabIndex = 44;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel2
            // 
            this.toolStripStatusLabel2.IsLink = true;
            this.toolStripStatusLabel2.Name = "toolStripStatusLabel2";
            this.toolStripStatusLabel2.Size = new System.Drawing.Size(114, 17);
            this.toolStripStatusLabel2.Tag = "http://www.geardome.com";
            this.toolStripStatusLabel2.Text = "Visit Geardome.com";
            this.toolStripStatusLabel2.Click += new System.EventHandler(this.toolStripStatusLabel2_Click);
            // 
            // toolStripStatusLabel1
            // 
            this.toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            this.toolStripStatusLabel1.Size = new System.Drawing.Size(0, 17);
            // 
            // buttonRotacion
            // 
            this.buttonRotacion.Image = global::Editor.Properties.Resources.flecha1;
            this.buttonRotacion.Location = new System.Drawing.Point(172, 26);
            this.buttonRotacion.Name = "buttonRotacion";
            this.buttonRotacion.Size = new System.Drawing.Size(44, 25);
            this.buttonRotacion.TabIndex = 25;
            this.buttonRotacion.UseVisualStyleBackColor = true;
            this.buttonRotacion.Click += new System.EventHandler(this.buttonRotacion_Click);
            // 
            // pictureBoxRendering
            // 
            this.pictureBoxRendering.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom)
                        | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.pictureBoxRendering.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(104)))), ((int)(((byte)(112)))), ((int)(((byte)(122)))));
            this.pictureBoxRendering.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.pictureBoxRendering.Location = new System.Drawing.Point(235, 36);
            this.pictureBoxRendering.Name = "pictureBoxRendering";
            this.pictureBoxRendering.Size = new System.Drawing.Size(925, 861);
            this.pictureBoxRendering.TabIndex = 1;
            this.pictureBoxRendering.TabStop = false;
            this.pictureBoxRendering.MouseLeave += new System.EventHandler(this.pictureBoxRendering_MouseLeave);
            this.pictureBoxRendering.PreviewKeyDown += new System.Windows.Forms.PreviewKeyDownEventHandler(this.pictureBoxRendering_PreviewKeyDown);
            this.pictureBoxRendering.MouseMove += new System.Windows.Forms.MouseEventHandler(this.pictureBoxRendering_MouseMove);
            this.pictureBoxRendering.Click += new System.EventHandler(this.pictureBoxRendering_Click);
            this.pictureBoxRendering.MouseDown += new System.Windows.Forms.MouseEventHandler(this.pictureBoxRendering_MouseDown);
            this.pictureBoxRendering.Paint += new System.Windows.Forms.PaintEventHandler(this.pictureBoxRendering_Paint);
            this.pictureBoxRendering.MouseUp += new System.Windows.Forms.MouseEventHandler(this.pictureBoxRendering_MouseUp);
            this.pictureBoxRendering.MouseEnter += new System.EventHandler(this.pictureBoxRendering_MouseEnter);
            // 
            // groupBox1
            // 
            this.groupBox1.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.groupBox1.Controls.Add(this.checkBoxDecorations);
            this.groupBox1.Controls.Add(this.checkBoxWireframe);
            this.groupBox1.Controls.Add(this.checkBoxPantalla);
            this.groupBox1.Controls.Add(this.checkBox1);
            this.groupBox1.Controls.Add(this.numericUpDownCursorX);
            this.groupBox1.Controls.Add(this.numericUpDownCursorY);
            this.groupBox1.Controls.Add(this.labelCursorX);
            this.groupBox1.Controls.Add(this.labelCursorY);
            this.groupBox1.Controls.Add(this.checkBoxSelector);
            this.groupBox1.Controls.Add(this.buttonRotacion);
            this.groupBox1.Controls.Add(this.checkBoxScriptLabels);
            this.groupBox1.Controls.Add(this.checkBoxFondo);
            this.groupBox1.Controls.Add(this.checkBoxScripts);
            this.groupBox1.Controls.Add(this.comboBoxFondo);
            this.groupBox1.Controls.Add(this.checkBoxRects);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Controls.Add(this.comboBoxPiso);
            this.groupBox1.Controls.Add(this.buttonScripts);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.comboBoxScripts);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Location = new System.Drawing.Point(5, 550);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(224, 261);
            this.groupBox1.TabIndex = 45;
            this.groupBox1.TabStop = false;
            // 
            // checkBoxDecorations
            // 
            this.checkBoxDecorations.Anchor = System.Windows.Forms.AnchorStyles.None;
            this.checkBoxDecorations.AutoSize = true;
            this.checkBoxDecorations.Location = new System.Drawing.Point(9, 231);
            this.checkBoxDecorations.Name = "checkBoxDecorations";
            this.checkBoxDecorations.Size = new System.Drawing.Size(113, 17);
            this.checkBoxDecorations.TabIndex = 44;
            this.checkBoxDecorations.Text = "Show Decorations";
            this.checkBoxDecorations.UseVisualStyleBackColor = true;
            this.checkBoxDecorations.CheckedChanged += new System.EventHandler(this.checkBoxDecorations_CheckedChanged);
            // 
            // checkBoxLock
            // 
            this.checkBoxLock.AutoSize = true;
            this.checkBoxLock.Location = new System.Drawing.Point(120, 40);
            this.checkBoxLock.Name = "checkBoxLock";
            this.checkBoxLock.Size = new System.Drawing.Size(114, 17);
            this.checkBoxLock.TabIndex = 46;
            this.checkBoxLock.Text = "Locked for editting";
            this.checkBoxLock.UseVisualStyleBackColor = true;
            this.checkBoxLock.CheckedChanged += new System.EventHandler(this.checkBox2_CheckedChanged);
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1190, 943);
            this.Controls.Add(this.checkBoxLock);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.buttonSave);
            this.Controls.Add(this.comboBoxEstilos);
            this.Controls.Add(this.radioDecoration);
            this.Controls.Add(this.groupBox);
            this.Controls.Add(this.verticalScrollBar);
            this.Controls.Add(this.horizontalScrollBar);
            this.Controls.Add(this.listViewTextures);
            this.Controls.Add(this.radioTransport);
            this.Controls.Add(this.radioEnemigos);
            this.Controls.Add(this.radioItems);
            this.Controls.Add(this.pictureBoxRendering);
            this.Controls.Add(this.radioCubos);
            this.Controls.Add(this.menuStrip);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Ozone iPhone Editor";
            this.Load += new System.EventHandler(this.MainForm_Load);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MainForm_FormClosed);
            this.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.MainForm_KeyPress);
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.MainForm_FormClosing);
            this.KeyDown += new System.Windows.Forms.KeyEventHandler(this.MainForm_KeyDown);
            this.menuStrip.ResumeLayout(false);
            this.menuStrip.PerformLayout();
            this.groupBox.ResumeLayout(false);
            this.groupBox.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownCursorX)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.numericUpDownCursorY)).EndInit();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBoxRendering)).EndInit();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        public System.Windows.Forms.RadioButton radioCubos;
        public System.Windows.Forms.PictureBox pictureBoxRendering;
        public System.Windows.Forms.RadioButton radioItems;
        public System.Windows.Forms.RadioButton radioEnemigos;
        public System.Windows.Forms.RadioButton radioTransport;
        public System.Windows.Forms.ListView listViewTextures;
        public System.Windows.Forms.Label labelGemas;
        public System.Windows.Forms.TextBox textBoxGemas;
        public System.Windows.Forms.Label labelTeleport;
        public System.Windows.Forms.TextBox textBoxTeleport;
        public System.Windows.Forms.Label labelX;
        public System.Windows.Forms.TextBox textBoxX;
        public System.Windows.Forms.Label labelY;
        public System.Windows.Forms.TextBox textBoxY;
        public System.Windows.Forms.HScrollBar horizontalScrollBar;
        public System.Windows.Forms.VScrollBar verticalScrollBar;
        public System.Windows.Forms.ImageList imageListCubos;
        public System.Windows.Forms.CheckBox checkBoxPantalla;
        public System.Windows.Forms.MenuStrip menuStrip;
        public System.Windows.Forms.ToolStripMenuItem archivoToolStripMenuItem;
        public System.Windows.Forms.ToolStripMenuItem abrirToolStripMenuItem;
        public System.Windows.Forms.ToolStripMenuItem guardarComoToolStripMenuItem;
        public System.Windows.Forms.ToolStripMenuItem salirToolStripMenuItem;
        public System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.SaveFileDialog saveFileDialog;
        private System.Windows.Forms.ToolStripMenuItem nuevoToolStripMenuItem;
        public System.Windows.Forms.TextBox textBoxCubos;
        public System.Windows.Forms.Label labelCubos;
        private System.Windows.Forms.GroupBox groupBox;
        public System.Windows.Forms.NumericUpDown numericUpDownCursorX;
        public System.Windows.Forms.NumericUpDown numericUpDownCursorY;
        private System.Windows.Forms.Label labelCursorX;
        private System.Windows.Forms.Label labelCursorY;
        public System.Windows.Forms.ImageList imageListItems;
        private System.Windows.Forms.Button buttonRotacion;
        private System.Windows.Forms.OpenFileDialog openFileDialog;
        public System.Windows.Forms.ImageList imageListEnems;
        private System.Windows.Forms.ToolStripMenuItem archivoToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem abrirToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem guardarComoToolStripMenuItem1;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripMenuItem salirToolStripMenuItem1;
        private System.Windows.Forms.ToolStripMenuItem nuevoToolStripMenuItem1;
        private System.Windows.Forms.CheckBox checkBoxFondo;
        public System.Windows.Forms.ComboBox comboBoxFondo;
        public System.Windows.Forms.ImageList imageListTrans;
        private System.Windows.Forms.Label label1;
        public System.Windows.Forms.ComboBox comboBoxPiso;
        private System.Windows.Forms.SaveFileDialog saveFileDialog1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button buttonScripts;
        public System.Windows.Forms.RadioButton radioDecoration;
        public System.Windows.Forms.CheckBox checkBoxRects;
        public System.Windows.Forms.ImageList imageListDeco;
        public System.Windows.Forms.ComboBox comboBoxScripts;
        public System.Windows.Forms.TextBox textBoxElements;
        public System.Windows.Forms.Label label5;
        private System.Windows.Forms.Timer timerScripts;
        public System.Windows.Forms.CheckBox checkBoxScripts;
        public System.Windows.Forms.CheckBox checkBoxScriptLabels;
        public System.Windows.Forms.CheckBox checkBoxSelector;
        public System.Windows.Forms.ComboBox comboBoxEstilos;
        public System.Windows.Forms.Button buttonSave;
        public System.Windows.Forms.CheckBox checkBoxWireframe;
        public System.Windows.Forms.CheckBox checkBox1;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusLabel2;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem actionsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem clearAllDecorationsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem clearAllItesmToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem clearAllEntitiesToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem clearAllTeleportsToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem clearAllTriggersToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem clearAllCubesToolStripMenuItem;
        private System.Windows.Forms.GroupBox groupBox1;
        public System.Windows.Forms.CheckBox checkBoxLock;
        public System.Windows.Forms.CheckBox checkBoxDecorations;
    }
}

