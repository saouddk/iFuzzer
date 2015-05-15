require_relative '../core/data_stream'

# Book: Bitmap Binary File Format
# References: http://www.dragonwins.com/domains/getteched/bmp/bmpfileformat.htm

class FileHeader < DataStream
  data :bfType, 2, "BM"
  data :bfSize, 4, :total_file_size #4 byte int
  data :bfReserved1, 2, :zero #has to be zero
  data :bfReserved2, 2, :zero #has to be zero
  data :bfOffBits, 4, :random
end