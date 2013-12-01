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
using XtraceLib;

namespace OzoneAseConverter
{
    public partial class Form1 : Form
    {
        private const float SCALE_FACTOR = 10.0f;
        struct VerticeFinal
        {
            public float x, y, z;
            public float nx, ny, nz;
            public float u, v;
        }
        
        struct VerticeTemporal
        {
            public float x, y, z;
        }

        struct TexturaTemporal
        {
            public float u, v;
        }

        struct NormalTemporal
        {
            public float nx, ny, nz;
        }

        struct Triangulo
        {
            public VerticeTemporal[] vert;

            public TexturaTemporal[] tex;

            public NormalTemporal[] nor;

            public Triangulo(int a)
            {
                vert = new VerticeTemporal[3];
                tex = new TexturaTemporal[3];
                nor = new NormalTemporal[3];

                for (int i = 0; i < 3; i++)
                {
                    vert[i] = new VerticeTemporal();
                    tex[i] = new TexturaTemporal();
                    nor[i] = new NormalTemporal();
                }
            }

            public Triangulo(VerticeTemporal v1, VerticeTemporal v2, VerticeTemporal v3)
            {
                vert = new VerticeTemporal[3];
                tex = new TexturaTemporal[3];
                nor = new NormalTemporal[3];

                vert[0] = v1;
                vert[1] = v2;
                vert[2] = v3;


                for (int i=0; i<3; i++)
                {
                    tex[i] = new TexturaTemporal();
                    nor[i] = new NormalTemporal();
                }
            }
        }

        private bool m_bHasNormals;

        private bool m_bIsValidFile;
        private VerticeTemporal[] m_VerticesArrayTemp;
        private TexturaTemporal[] m_VerticesTexTemp;

        private List<VerticeFinal> m_ListaVerticesFinal = new List<VerticeFinal>();
        private List<ushort> m_ListaIndicesFinal = new List<ushort>();

        private System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo("en-US");

        private Triangulo[] m_ArrayTriangulos;


        //--------------------------------------------------------------------
        // Función:    Form1
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 20:07:36
        //--------------------------------------------------------------------
        public Form1()
        {          
            InitializeComponent();
        }


        //--------------------------------------------------------------------
        // Función:    button1_Click
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 20:06:48
        //--------------------------------------------------------------------
        private void button1_Click(object sender, EventArgs e)
        {
            openFileDialog1.ShowDialog();
        }




        //--------------------------------------------------------------------
        // Función:    openFileDialog1_FileOk
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 20:07:12
        //--------------------------------------------------------------------
        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            m_bIsValidFile = true;

            StreamReader sr = new StreamReader(openFileDialog1.FileName);

            String currentLine = sr.ReadLine();

            Xtrace.Log("#_Iniciando lectura {0}", openFileDialog1.FileName);

            try
            {
                while (currentLine.CompareTo("*GEOMOBJECT {") != 0)
                {
                    currentLine = sr.ReadLine();
                }

            }
            catch (Exception ex)
            {
                m_bIsValidFile = false;
                MessageBox.Show("The file is not valid", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                //textBox1.Text = "Archivo no válido";
                Xtrace.Log("#!No se pudo encontrar un GEOMOBJECT");
                sr.Close();
                return;
            }           

            ReadObject(sr);

            sr.Close();

            if (m_bIsValidFile)
            {
                string path = Path.ChangeExtension(openFileDialog1.FileName, "o3d");

                SaveObject(new FileStream(path, FileMode.Create), path);

                MessageBox.Show("File converted!\n" + path + "\n\nVertex count: " + m_ListaVerticesFinal.Count + "\nFace count: " + (m_ListaIndicesFinal.Count / 3) + "\nNormals: " + ((m_bHasNormals && !checkBoxNormals.Checked) ? "YES" : "NO"), "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
        
            }          
        }




        private void ComputeIndices()
        {
            foreach (Triangulo t in m_ArrayTriangulos)
            {
                for (int i=0; i<3; i++)
                {
                    bool encontrado = false;

                    foreach (VerticeFinal vf in m_ListaVerticesFinal)
                    {
                        if (vf.x == t.vert[i].x &&
                            vf.y == t.vert[i].y &&
                            vf.z == t.vert[i].z &&
                            vf.nx == t.nor[i].nx &&
                            vf.ny == t.nor[i].ny &&
                            vf.nz == t.nor[i].nz &&
                            vf.u == t.tex[i].u &&
                            vf.v == t.tex[i].v)
                        {
                            encontrado = true;
                            break;
                        }
                    }

                    if (!encontrado)
                    {
                        VerticeFinal temp = new VerticeFinal();
                        temp.x = t.vert[i].x;
                        temp.y = t.vert[i].y;
                        temp.z = t.vert[i].z;
                        temp.nx = t.nor[i].nx;
                        temp.ny = t.nor[i].ny;
                        temp.nz = t.nor[i].nz;
                        temp.u = t.tex[i].u;
                        temp.v = t.tex[i].v;

                        m_ListaVerticesFinal.Add(temp);

                        int a = m_ListaVerticesFinal.Count - 1;

                        Xtrace.Log("O3D Ver {0}: ({1}, {2}, {3})", a, temp.x, temp.y, temp.z);
                        Xtrace.Log("O3D Tex {0}: ({1}, {2})", a, temp.u, temp.v);
                        Xtrace.Log("O3D Nor {0}: ({1}, {2}, {3})", a, temp.nx, temp.ny, temp.nz);
                    }    
                }
            }



            foreach (Triangulo t in m_ArrayTriangulos)
            {
                for (int i = 0; i < 3; i++)
                {
                    bool encontrado = false;

                    ushort verticeID = 0;

                    foreach (VerticeFinal vf in m_ListaVerticesFinal)
                    {
                        if (vf.x == t.vert[i].x &&
                            vf.y == t.vert[i].y &&
                            vf.z == t.vert[i].z &&
                            vf.nx == t.nor[i].nx &&
                            vf.ny == t.nor[i].ny &&
                            vf.nz == t.nor[i].nz &&
                            vf.u == t.tex[i].u &&
                            vf.v == t.tex[i].v)
                        {
                            encontrado = true;
                            break;
                        }

                        verticeID++;
                    }

                    if (encontrado)
                    {
                        m_ListaIndicesFinal.Add(verticeID);
                    }
                    else
                    {
                        ///--- algo va mal
                        Xtrace.Log("!**** Error: no se encontró un vértice al computar índices");
                    }
                }

                Xtrace.Log("O3D Ind {0}: ({1}, {2}, {3})", m_ListaIndicesFinal.Count / 3,
                    m_ListaIndicesFinal[m_ListaIndicesFinal.Count - 3],
                    m_ListaIndicesFinal[m_ListaIndicesFinal.Count - 2],
                    m_ListaIndicesFinal[m_ListaIndicesFinal.Count - 1]);
            }
        }

        //--------------------------------------------------------------------
        // Función:    SaveObject
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 22:58:23
        //--------------------------------------------------------------------
        private void SaveObject(Stream st, string file)
        {


            
            BinaryWriter br = new BinaryWriter(st);

            Xtrace.Log("#_Grabando el fichero {0}", file);

            if (m_bHasNormals && !checkBoxNormals.Checked)  ///--- normales
            {
                br.Write((uint)(0));
                br.Write((uint)(0));
            }

            br.Write((uint)(m_ListaVerticesFinal.Count));
            br.Write((uint)(m_ListaIndicesFinal.Count / 3));

            foreach (VerticeFinal vf in m_ListaVerticesFinal)
            {
                br.Write((short)(vf.x * 16.0f * SCALE_FACTOR));
                br.Write((short)(vf.z * 16.0f * SCALE_FACTOR));
                br.Write((short)((-vf.y) * 16.0f * SCALE_FACTOR));
                short v_padding = 0;
                br.Write(v_padding);

                if (m_bHasNormals && !checkBoxNormals.Checked)
                {
                    double length = Math.Sqrt((vf.nx * vf.nx) + (vf.ny * vf.ny) + (vf.nz * vf.nz));
                    double x = vf.nx / length;
                    double y = vf.nz / length;
                    double z = (-vf.ny) / length;

                    sbyte nx = (sbyte)(x * 127.0f);
                    sbyte ny = (sbyte)(y * 127.0f);
                    sbyte nz = (sbyte)(z * 127.0f);
                    sbyte n_padding = 0;

                    br.Write(nx);
                    br.Write(ny);
                    br.Write(nz);
                    br.Write(n_padding);
                }

                br.Write((short)(vf.u * 512.0f));
                br.Write((short)(vf.v * 512.0f));                      
            }

            foreach (ushort ind in m_ListaIndicesFinal)
            {
                br.Write(ind);                
            }

            

           
            br.Close();

            if (m_ListaIndicesFinal.Count % 3 != 0)
                Xtrace.Log("!Error: El número de índices no es múltiplo de 3: {0}", m_ListaIndicesFinal.Count);
            if (m_bHasNormals && !checkBoxNormals.Checked)
                Xtrace.Log("Las normales se han incluido");
            else
                Xtrace.Log("No se han incluido normales");
            Xtrace.Log("Vértices: {0}", m_ListaVerticesFinal.Count);
            Xtrace.Log("Triángulos: {0}", m_ListaIndicesFinal.Count / 3);

            Xtrace.Log("#_Fichero grabado");
        }


        //--------------------------------------------------------------------
        // Función:    ReadObject
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 21:01:35
        //--------------------------------------------------------------------
        private void ReadObject(StreamReader sr)
        {
            m_bHasNormals = false;

            m_ListaVerticesFinal.Clear();
            m_ListaIndicesFinal.Clear(); 


            String currentLine = sr.ReadLine();
            
            while (!currentLine.Contains("*MESH_NUMVERTEX"))
            {
                currentLine = sr.ReadLine();
            }

            currentLine = FormatString(currentLine);
            String[] parse = currentLine.Split(' ');

            m_VerticesArrayTemp = new VerticeTemporal[Int32.Parse(parse[1])];

            Xtrace.Log("ASE Vértices: {0}", m_VerticesArrayTemp.Length);

            while (!currentLine.Contains("*MESH_NUMFACES"))
            {
                currentLine = sr.ReadLine();
            }

            currentLine = FormatString(currentLine);
            parse = currentLine.Split(' ');

            m_ArrayTriangulos = new Triangulo[Int32.Parse(parse[1])];

            for (int h=0; h<m_ArrayTriangulos.Length; h++)
                m_ArrayTriangulos[h] = new Triangulo(0);


            Xtrace.Log("ASE Triángulos: {0}", m_ArrayTriangulos.Length);

            while (!currentLine.Contains("*MESH_VERTEX "))
            {
                currentLine = sr.ReadLine();
            }            

            int i = 0;

            while (currentLine.Contains("*MESH_VERTEX "))
            {
                currentLine = FormatString(currentLine);
                parse = currentLine.Split(' ');
                m_VerticesArrayTemp[i].x = float.Parse(parse[2], System.Globalization.NumberStyles.Float, ci);
                m_VerticesArrayTemp[i].y = float.Parse(parse[3], System.Globalization.NumberStyles.Float, ci);
                m_VerticesArrayTemp[i].z = float.Parse(parse[4], System.Globalization.NumberStyles.Float, ci);
                Xtrace.Log("ASE Vert {0}: ({1}, {2}, {3})", i, m_VerticesArrayTemp[i].x, m_VerticesArrayTemp[i].y,
                   m_VerticesArrayTemp[i].z);
                currentLine = sr.ReadLine();
                i++;
            }

            while (!currentLine.Contains("*MESH_FACE "))
            {
                currentLine = sr.ReadLine();
            }

            i = 0;
            
            while (currentLine.Contains("*MESH_FACE "))
            {
                currentLine = FormatString(currentLine);
                parse = currentLine.Split(' ');
                int a = Int32.Parse(parse[3]);
                int b = Int32.Parse(parse[5]);
                int c = Int32.Parse(parse[7]);

                m_ArrayTriangulos[i].vert[0] = m_VerticesArrayTemp[a];
                m_ArrayTriangulos[i].vert[1] = m_VerticesArrayTemp[b];
                m_ArrayTriangulos[i].vert[2] = m_VerticesArrayTemp[c];

                Xtrace.Log("ASE Tri {0}: ({1}, {2}, {3})", i, a, b, c);
                currentLine = sr.ReadLine();
                i++;
            }

            while (!currentLine.Contains("*MESH_NUMTVERTEX"))
            {
                currentLine = sr.ReadLine();
            }

            currentLine = FormatString(currentLine);
            parse = currentLine.Split(' ');

            m_VerticesTexTemp = new TexturaTemporal[Int32.Parse(parse[1])];
            

            while (!currentLine.Contains("*MESH_TVERT "))
            {
                currentLine = sr.ReadLine();
            }


            i = 0;

            while (currentLine.Contains("*MESH_TVERT "))
            {
                currentLine = FormatString(currentLine);
                parse = currentLine.Split(' ');
                m_VerticesTexTemp[i].u = float.Parse(parse[2], System.Globalization.NumberStyles.Float, ci);
                m_VerticesTexTemp[i].v = float.Parse(parse[3], System.Globalization.NumberStyles.Float, ci);
                Xtrace.Log("ASE Tex {0}: ({1}, {2})", i, m_VerticesTexTemp[i].u, m_VerticesTexTemp[i].v);
                currentLine = sr.ReadLine();
                i++;
            }


            while (!currentLine.Contains("*MESH_TFACE "))
            {
                currentLine = sr.ReadLine();
            }

            i = 0;

            while (currentLine.Contains("*MESH_TFACE "))
            {
                currentLine = FormatString(currentLine);
                parse = currentLine.Split(' ');

                m_ArrayTriangulos[i].tex[0] = m_VerticesTexTemp[Int32.Parse(parse[2])];
                m_ArrayTriangulos[i].tex[1] = m_VerticesTexTemp[Int32.Parse(parse[3])];
                m_ArrayTriangulos[i].tex[2] = m_VerticesTexTemp[Int32.Parse(parse[4])];
                currentLine = sr.ReadLine();
                i++;
            }

            //if (this.checkBoxSubdirs.Checked)
            {
                while (!currentLine.Contains("*MESH_VERTEXNORMAL "))
                {
                    currentLine = sr.ReadLine();

                    if (currentLine == null)
                        break;
                }

                if (currentLine != null)
                {
                    i = 0;
                    int t = 0;

                    while (currentLine.Contains("*MESH_VERTEXNORMAL ") || currentLine.Contains("*MESH_FACENORMAL "))
                    {
                        if (currentLine.Contains("*MESH_FACENORMAL "))
                        {
                            currentLine = sr.ReadLine();
                            continue;
                        }

                        currentLine = FormatString(currentLine);
                        parse = currentLine.Split(' ');

                        NormalTemporal n = new NormalTemporal();

                        n.nx = float.Parse(parse[2], System.Globalization.NumberStyles.Float, ci);
                        n.ny = float.Parse(parse[3], System.Globalization.NumberStyles.Float, ci);
                        n.nz = float.Parse(parse[4], System.Globalization.NumberStyles.Float, ci);

                        Xtrace.Log("ASE Nor {0}: ({1}, {2}, {3})", (i * 3) + t, n.nx, n.ny, n.nz);

                        m_bHasNormals = true;

                        m_ArrayTriangulos[i].nor[t] = n;

                        t++;

                        if (t == 3)
                        {
                            i++;
                            t = 0;
                        }

                        currentLine = sr.ReadLine();
                    }
                }
            }

            ComputeIndices();
        }


        //--------------------------------------------------------------------
        // Función:    saveFileDialog1_FileOk
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 20:07:16
        //--------------------------------------------------------------------
       

        //--------------------------------------------------------------------
        // Función:    FormatString
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 22:15:17
        //--------------------------------------------------------------------
        private String FormatString(String str)
        {
            str = str.Replace('\t', ' ');

            while (str.Contains("  "))
            {
                str = str.Replace("  ", " ");
            }

            return str.Trim();
        }

        //--------------------------------------------------------------------
        // Función:    Form1_Load
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 21:09:54
        //--------------------------------------------------------------------
        private void Form1_Load(object sender, EventArgs e)
        {
            Xtrace.Init("ASE Converter", true);         

            m_bIsValidFile = false;
        }


        //--------------------------------------------------------------------
        // Función:    Form1_FormClosing
        // Propósito:  
        // Fecha:      miércoles, 08 de noviembre de 2006, 21:12:58
        //--------------------------------------------------------------------
        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            Xtrace.End();
        }


        //--------------------------------------------------------------------
        // Función:    Clamp
        // Creador:    Nacho (AMD)
        // Fecha:      Saturday  10/02/2007  17:21:26
        //--------------------------------------------------------------------
        private float Clamp(float value)
        {
            if (value < 0.0f)
                return 0.0f;
            else if (value > 1.0f)
                return 1.0f;
            else
                return value;
        }

        private void button2_Click_1(object sender, EventArgs e)
        {
            folderBrowserDialog1.ShowDialog();

            if (folderBrowserDialog1.SelectedPath != "")
            {
                ficheros_convertidos = 0;
                scan_dirs(folderBrowserDialog1.SelectedPath);

                Xtrace.Log("#*Ficheros convertidos: {0}", ficheros_convertidos);

                MessageBox.Show("Finished!\n\n" + ficheros_convertidos + " files converted.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
        }

        private int ficheros_convertidos;

        private void scan_dirs(string dir)
        {
            Xtrace.Log("#*Escaneando {0}", dir);

            string[] files = Directory.GetFiles(dir, "*.ase");

            foreach (string f in files)
            {
                m_bIsValidFile = true;

                StreamReader sr = new StreamReader(f);

                String currentLine = sr.ReadLine();

                Xtrace.Log("#_Iniciando lectura {0}", f);

                try
                {
                    while (currentLine.CompareTo("*GEOMOBJECT {") != 0)
                    {
                        currentLine = sr.ReadLine();
                    }

                }
                catch (Exception ex)
                {
                    m_bIsValidFile = false;
                    //MessageBox.Show("The file is not valid", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    //textBox1.Text = "Archivo no válido";
                    Xtrace.Log("#!No se pudo encontrar un GEOMOBJECT");
                    sr.Close();
                    continue;
                }

                ReadObject(sr);

                sr.Close();

                if (m_bIsValidFile)
                {
                    string path = Path.ChangeExtension(f, "o3d");

                    SaveObject(new FileStream(path, FileMode.Create), path);

                    ficheros_convertidos++;

                    //MessageBox.Show("File converted!\n" + path + "\n\nVertex count: " + m_ListaVerticesFinal.Count + "\nFace count: " + (m_ListaIndicesFinal.Count / 3) + "\nNormals: " + ((m_bHasNormals && !checkBoxNormals.Checked) ? "YES" : "NO"), "Success", MessageBoxButtons.OK, MessageBoxIcon.Information);

                }          
            }

            if (checkBoxSubdirs.Checked)
            {

                string[] dirs = Directory.GetDirectories(dir);

                foreach (string d in dirs)
                {
                    scan_dirs(d);
                }
            }
        }
    }
}