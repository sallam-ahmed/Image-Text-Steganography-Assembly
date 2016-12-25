using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
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
            writer.WriteLine($"{inputEncryptionBitmap.Width}:{inputEncryptionBitmap.Height}");
            for (int i = 0; i < inputEncryptionBitmap.Width; i++)
            {
                for (int j = 0; j < inputEncryptionBitmap.Height; j++)
                {
                    var pixel = inputEncryptionBitmap.GetPixel(i, j);
                    writer.Write($"{pixel.R}{pixel.G}{pixel.B}");
                    
                }
            }
            writer.Flush();
            writer.Close();
            MessageBox.Show("Done.");
        }
        //TODO Implement New Decoding Method
        private  void DecodePixels(List<string>pixelsList,int imageWidth , int imageHeight)
        {
            //List<List<Pixel>> image =new List<List<Pixel>>();

            //Bitmap decodedBitmap = new Bitmap(imageWidth,imageHeight);

            //for (int i = 0; i < imageWidth; i++)
            //{
            //    var imgWidthData = pixelsList[i]; //P1,P2,P3,P4
            //    var pixels = imgWidthData.Split(";".ToCharArray(), StringSplitOptions.RemoveEmptyEntries); // Pixel(R,G,B)
            //    for (int j = 0; j < imageHeight; j++)
            //    {
            //        var pixelData = new Pixel(pixels[j].Split(',')); //RGB
            //        //  image[i][j] = pixelData;
            //        decodedBitmap.SetPixel(i, j, pixelData.GetColor());
            //    }
            //}

            //newImagePictureBox.Image = decodedBitmap;

            //MessageBox.Show("Done.");
            throw new NotImplementedException("Function not impelmented because of new decoding system.");
        }

        private void label5_Click(object sender, EventArgs e)
        {
            openFileDg.ShowDialog();
            using (var reader = new StreamReader(openFileDg.FileName))
            {
                string readLins = reader.ReadToEnd();
                var lines = Regex.Split(readLins, "\r\n|\r|\n");
                var width = int.Parse(lines[0].Split(':')[0]);
                var height = int.Parse(lines[0].Split(':')[1]);
                var linesList = lines.ToList();
                linesList.RemoveAt(0);
                DecodePixels(linesList, width, height);
            }
        }
    }
}
