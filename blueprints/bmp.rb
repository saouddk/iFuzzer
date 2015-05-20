require_relative '../core/blueprint'
require_relative '../core/data_stream'

# Blueprint: Bitmap Binary File Format
# ----------------------------------------------------------------------------------------
# References: http://www.dragonwins.com/domains/getteched/bmp/bmpfileformat.htm
# ----------------------------------------------------------------------------------------

class BMP < Blueprint
  class FileHeader < DataStream
    data :bfType, 2, "BM" #Cannot be modified, static field.
    data :bfSize, 4, :total_file_size #4 byte int, fuzzer will know modifying this is trouble some
    data :bfReserved1, 2, :zero #has to be zero, modifying this will result in nothing
    data :bfReserved2, 2, :zero #has to be zero, modifying this will result in nothing
    data :bfOffBits, 4, :offset #4 byte int
  end

  class ImageHeader < FileHeader
    data :biSize, 4, :self_size #Size returned will be size of ImageHeader
    data :biWidth, 4, :numeric
    data :biHeight, 4, :numeric
    data :biPlanes, 2, :numeric
    data :biBitCount, 2, [1, 4, 8, 16, 24, 32] #Has to be one of these values
    data :biCompression, 4, :numeric
    data :biSizeImage, 4, :numeric
    data :biXPelsPerMeter, 4, :numeric
    data :biYPelsPerMeter, 4, :numeric
    data :biClrUsed, 4, :numeric
    data :biClrImportant, 4, :numeric
  end

end