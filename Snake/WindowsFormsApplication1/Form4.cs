using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public partial class Form4 : Form
    {
        public Form4()
        {
            InitializeComponent();
        }

        private void Form4_Load(object sender, EventArgs e)
        {

        }

        private int row=0, column=0, num=0;

        public int row0 { get { return row; } set { row = value; } }
        public int column0 { get { return column; } set { column = value; } }
        public int num0 { get { return num; } set { num = value; } }

        private void button1_Click(object sender, EventArgs e)
        {
            row=Convert.ToInt32(textBox1.Text);
            column=Convert.ToInt32(textBox2.Text);
            num=Convert.ToInt32(textBox3.Text);
            if (row < 5 || row > 20 || column < 5 || row > 20 || num < 10 || num > 50 || num > row * column)
            {
                MessageBox.Show("ERROR!INPUT AGAIN!");
                row = 0; column = 0; num = 0;
            }
            this.Close();
        }
    }
}
