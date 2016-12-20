using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Image_Text_Steganography_UI_Module
{
    public partial class MainForm : Form
    {
        private string InputEncryptionImagePath { get; set; }
        private string OutputEncryptionImagePath { get; set; }

        private Bitmap inputEncryptionBitmap { get; set; }
        public MainForm()
        {
            InitializeComponent();
        }

        private void groupBox3_Enter(object sender, EventArgs e)
        {

        }

        private void SelectFilesButtonClick(object sender, EventArgs e)
        {
            openFileDg.Title = "Select input encryption image.";
            openFileDg.RestoreDirectory = true;

            var dgResult = openFileDg.ShowDialog();
            if (dgResult == DialogResult.OK)
            {
                InputEncryptionImagePath = openFileDg.FileName;
                inputEncTextBox.Text = openFileDg.FileName;

                var sDgResult = saveFileDg.ShowDialog();

                if (sDgResult == DialogResult.OK)
                {
                    OutputEncryptionImagePath = saveFileDg.FileName;
                    encOutputPathTxtBox.Text = saveFileDg.FileName;

                    encryptionBtn.Enabled = true;
                  inputEncryptionBitmap = Bitmap.FromFile(InputEncryptionImagePath) as Bitmap;
                    oldImagePictureBox.Image = inputEncryptionBitmap;
                }
                else
                {
                    MessageBox.Show("Please specify input and output files.");
                    InputEncryptionImagePath = OutputEncryptionImagePath = string.Empty;
                    inputEncTextBox.Text = encOutputPathTxtBox.Text = string.Empty;
                }

            }
            else
            {
                MessageBox.Show("Please specify input files.");
            }

        }

        private void encryptionBtn_Click(object sender, EventArgs e)
        {
            StreamWriter writer = new StreamWriter(OutputEncryptionImagePath);
            for (int i = 0; i < inputEncryptionBitmap.Height; i++)
            {
                for (int j = 0; j < inputEncryptionBitmap.Width; j++)
                {
                    var pixel = inputEncryptionBitmap.GetPixel(i, j);
                    writer.Write($"{pixel.R},{pixel.G},{pixel.B};");
                    
                }
                writer.Write("#\n");
            }
            MessageBox.Show("Done.");
        }
        private  void decodePixels(List<string>pixelsList,int imageWidth , int imageHeight)
        {
            List<List<Pixel>> image=new List<List<Pixel>>();
            //Bitmap decodedBitmap;
            for (int i = 0; i < imageHeight; i++)
            {
                var imgWidthData = pixelsList[i]; //P1,P2,P3,P4
                var pixels = imgWidthData.Split(";".ToCharArray(), StringSplitOptions.RemoveEmptyEntries); // Pixel(R,G,B)
                for (int j = 0; j < imageWidth; j++)
                {
                    var pixelData = new Pixel(pixels[j].Split(',')); //RGB
                    image[i][j] = pixelData;
              //      decodedBitmap.SetPixel(i, j, pixelData.GetColor());
                }
            }
            MessageBox.Show("Done.");
        }
    }
}
