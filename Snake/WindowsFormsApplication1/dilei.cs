using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace WindowsFormsApplication1
{
    public class mine:Button
    {
        public mine()
        {
            tag = false;
            Size = new System.Drawing.Size(20, 20);
            this.Text = "";
            judge = '0';
        }
        private int x,y,sign;
        private bool tag;
        private char judge;
        public int x0 { get { return x; } set { x = value; } }
        public int y0 { get { return y; } set { y = value; } }
        public bool open { get { return tag; } set { tag = value; } }
        public char judge0 { get { return judge; } set { judge = value; } }
        public int sign0 { get { return sign; } set { sign = value; } }
    }
}
