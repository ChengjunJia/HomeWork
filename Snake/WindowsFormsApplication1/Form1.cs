using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Media;

namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            for(int i=0;i<20;i++)
                for(int j=0;j<20;j++)
                    leizhen[i,j]=new mine();
            SoundPlayer sd1 = new SoundPlayer(@sound1);
        }

        private void 游戏规则ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Form2 form0=new Form2();
            form0.Show();
        }

        private void 联系ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Form3 form0=new Form3();
            form0.Show();
        }
       
        private void 退出ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Thanks For your visit");
            this.Close();
        }        
       
        private int startorstop=0,row=10,column=10,num=10,time=0;
        public int judgeqiang = 0; private bool game;
        private mine[,] leizhen = new mine[20, 20];
        private string picture1 = @"D:\temp\flag.jpg", picture2 = @"D:\temp\question.jpg";
        private string picture3 = @"D:\temp\背景.jpg";
        private string sound1=@"D:\temp\backgroud.wav";
 
        private void button1_Click(object sender, EventArgs e)
        {
            if (game)
            {
                if (startorstop == 0)
                {
                    this.button1.Text = "开始";
                    startorstop = 1;
                    for (int i = 0; i < row; i++)
                        for (int j = 0; j < column; j++)
                            enable(false);
                    timer1.Enabled = false;
                }
                else
                {
                    this.button1.Text = "暂停";
                    startorstop = 0;
                    for (int i = 0; i < row; i++)
                        for (int j = 0; j < column; j++)
                            enable(true);
                    timer1.Enabled = true;
                }
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
       
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            time++;
            string temp1 = Convert.ToString(time / 600) + "分";
            string temp2=Convert.ToString((time % 600) / 10) + "秒" + Convert.ToString(time % 10);
            if(time<600) 
                label4.Text=temp2;
            else 
                label4.Text=temp1+temp2;
        }

        private void bt_mouse(object sender, EventArgs e)
        {
            mine temp = (mine)sender;
            MouseEventArgs e0 = (MouseEventArgs)e;
            if (game)
            {
                if (e0.Button == MouseButtons.Left && temp.sign0 == 0)
                {
                    temp.BackgroundImage = null;
                    if (temp.judge0 != '*')
                    {
                        show(temp.x0, temp.y0);
                        if (restnum() == 0)
                        {
                            timer1.Enabled = false;
                            showall();
                            game = false;
                            MessageBox.Show("You win!\n用时:" + label4.Text);
                        }
                    }
                    if (temp.judge0 == '*')
                    {
                        timer1.Enabled = false;
                        showall();
                        temp.ForeColor = Color.Red;
                        game = false;
                        MessageBox.Show("You lose!");
                    }
                    this.label2.Text = Convert.ToString(restnum());

                }
                if (e0.Button == MouseButtons.Right&&temp.open==false)
                {
                    temp.sign0++;
                    if (temp.sign0 == 3) temp.sign0 = 0;
                    switch (temp.sign0)
                    {
                        case 1: temp.Image = Image.FromFile(@picture1); break;
                        case 0: temp.Image = null; break;
                        case 2: temp.Image = Image.FromFile(@picture2); break;
                    }
                }
            }
        }
        //click the button 

        private void show(int xx, int yy)
        {
            if (xx < 0 || xx >= row || yy < 0 || yy >= column||leizhen[xx, yy].open == true) 
                return;
            leizhen[xx, yy].open = true;
            leizhen[xx,yy].Image= null;
            if(leizhen[xx,yy].judge0!='0') 
            {
                leizhen[xx,yy].Text=Convert.ToString(leizhen[xx,yy].judge0);
                return;
            }
            if (leizhen[xx, yy].judge0 == '0')
            {
                leizhen[xx, yy].Visible = false;
                for (int i = xx - 1; i < xx + 2; i++)
                    for (int j = yy - 1; j < yy + 2; j++)
                        show(i, j);
            }
        }
        //show a button's content

        private void showall()
        {
            for(int i=0;i<row;i++)
                for(int j=0;j<column;j++)
                    show(i,j);
        }
       //shoa all buttons'content

        private void bulei()
        {
            for (int i = 0; i < row; i++)
            {
                for (int j = 0; j < column; j++)
                {
                    leizhen[i, j].Location = new Point(3 + i * 20, 6 + j * 20);
                    leizhen[i, j].x0 = i; leizhen[i, j].y0 = j;
                    leizhen[i, j].Visible = true;
                }
            }
            //button location
            for (int i = 0; i < num; )
            {
                int temp1,temp2;
                Random ra = new Random();
                temp1 = ra.Next(row);
                temp2 = ra.Next(column);
                if (leizhen[temp1, temp2].judge0 != '*')
                {
                    leizhen[temp1, temp2].judge0 = '*';
                    i++;                
                }
            }
            //mine location
            for (int i = 0; i < row; i++)
            {
                for (int j = 0; j < column; j++)
                {
                    if (leizhen[i, j].judge0 == '*') continue;
                    for (int i0 = i - 1; i0 <= i + 1; i0++)
                        for (int j0 = j - 1; j0 <= j + 1; j0++)
                            if (i0 >= 0 && i0 < row && j0 >= 0 && j0 < column && leizhen[i0, j0].judge0 == '*')
                                leizhen[i, j].judge0++;
                }
            }
            //under the button,number 
            for(int i=0;i<row;i++)
                for (int j = 0; j < column; j++)
                {
                    groupBox1.Controls.Add(leizhen[i, j]);
                    leizhen[i, j].MouseUp += new MouseEventHandler(bt_mouse);
                }
            //show all the button
        }
        //set the buttons

        private void 新游戏ToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Form4 shezhi = new Form4();
            shezhi.ShowDialog();
            row = shezhi.row0;
            column = shezhi.column0;
            num = shezhi.num0;
            fuyuan();
            bulei();
            timer1.Enabled = true;
        }

        private void fuyuan()
        {
            for (int i = 0; i < 20; i++)
                for (int j = 0; j < 20; j++)
                {
                    leizhen[i, j].open = false;
                    leizhen[i, j].judge0 = '0';
                    leizhen[i, j].Text = "";
                    leizhen[i, j].x0 = 0;
                    leizhen[i, j].y0 = 0;
                    leizhen[i, j].ForeColor = Color.Black;
                    leizhen[i, j].BackColor = Color.WhiteSmoke;
                    leizhen[i, j].Visible = false;
                    leizhen[i, j].sign0 = 0;
                    leizhen[i, j].Image = null;
                }
            enable(true);
            game = true;
            time = 0;
            timer1.Enabled = false;
            this.BackgroundImage = Image.FromFile(@picture3);
            int temp1=20*row,temp2=20*column;
            this.Size = new System.Drawing.Size(temp1 + 200, temp2 + 100);
            groupBox1.Location = new Point(26, 26);
            groupBox1.Text = "";
            groupBox1.Size = new System.Drawing.Size(temp1+20,temp2+20);
            groupBox1.FlatStyle = FlatStyle.Standard;
            button1.Location = new Point(50 + temp1, 26);
            label1.Location = new Point(50 + temp1, 55);
            label2.Location = new Point(150 + temp1, 55);
            label3.Location = new Point(50 + temp1, 80);
            label4.Location = new Point(50 + temp1, 105);
            label4.Text = "0秒";
            label2.Text = Convert.ToString(restnum());
        }
        //reset the buttons and controls
        
        private void enable(bool x)
        {
            for(int i=0;i<row;i++)
                    for(int j=0;j<column;j++)
                        leizhen[i,j].Enabled=x;
        }
            
        private int restnum()
        {
            int number = 0;
            for (int i = 0; i < row; i++)
                for (int j = 0; j < column; j++)
                    if (leizhen[i, j].open == false) number++;
            number=number-num;
            if (number >= 0) return number;
            else return 0;
        }
        //count the rest buttons needed to conveal

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void toolStripMenuItem1_Click(object sender, EventArgs e)
        {
            Form5 temp=new Form5();
            temp.ShowDialog();
            if (temp.num == 4)
            {
                string result="";
                if (temp.temp1 != "")
                {
                    picture1 = temp.temp1;
                    result += " 旗子";
                }
                if (temp.temp2 != "")
                {
                    picture2 = temp.temp2;
                    result += " 问号";
                }
                if(temp.temp3!="")
                {
                    picture3=temp.temp3;
                    result += " 背景";
                }
                MessageBox.Show(result+"图片修改成功！");
            }
            if (temp.num == 3)
            {
                MessageBox.Show("密码错误多次！");
                this.Close();
            }
        }
    }
}
