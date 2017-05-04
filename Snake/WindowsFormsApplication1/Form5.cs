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
    public partial class Form5 : Form
    {
        public Form5()
        {
            InitializeComponent();
        }
        public string temp1,temp2,temp3;
        public int num;
        private void button1_Click(object sender, EventArgs e)
        {
            if (textBox1.Text == "jiachengjun")
            {
                temp1 = textBox2.Text;
                temp2 = textBox3.Text;
                temp3 = textBox4.Text;
                num = 4;
            }
            else
            {
                num++;
                if (num == 3)
                {
                    this.Close();
                }
                MessageBox.Show("密码输入错误！");
            }

        }

        private void button2_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            dlg.CheckFileExists = true;
            dlg.Filter = "JPG files (*.jpg)|*.jpg";
            dlg.DefaultExt = ".jpg";
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                textBox2.Text=dlg.FileName;
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            dlg.CheckFileExists = true;
            dlg.Filter = "JPG files (*.jpg)|*.jpg";
            dlg.DefaultExt = ".jpg";
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                textBox3.Text=dlg.FileName;
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            dlg.CheckFileExists = true;
            dlg.Filter = "JPG files (*.jpg)|*.jpg";
            dlg.DefaultExt = ".jpg";
            if (dlg.ShowDialog() == DialogResult.OK)
            {
                textBox4.Text = dlg.FileName;
            }
        }
    }
}
