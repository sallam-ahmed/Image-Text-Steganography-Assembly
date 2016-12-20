using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Image_Text_Steganography_UI_Module
{
    public struct Pixel
    {
        public byte R, G, B;

        public Pixel(string[] rgbStrings)
        {
            R = Convert.ToByte(rgbStrings[0]);
            B = Convert.ToByte(rgbStrings[1]);
            G = Convert.ToByte(rgbStrings[2]);
        }

        public Color GetColor()
        {
            return Color.FromArgb(R, G, B);
        }
    } 
}
