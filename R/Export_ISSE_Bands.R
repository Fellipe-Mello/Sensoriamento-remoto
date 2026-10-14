library(raster)
# Importing RASTERs
setwd("DIRETORIO/SUBPASTA")
list.files()
list.files(pattern = "\\.tif$")

mosaico = list.files(paste(getwd()), pattern = "L5_Ferrari_2001_06.tif")
mosaico

#Spliting band of ISSE (Synthetic Soil Image)
ISSE_1 = raster(mosaico[[1]], band = 1)
ISSE_2 = raster(mosaico[[1]], band = 2)
ISSE_3 = raster(mosaico[[1]], band = 3)
ISSE_4 = raster(mosaico[[1]], band = 4)
ISSE_5 = raster(mosaico[[1]], band = 5)
ISSE_7 = raster(mosaico[[1]], band = 6)
#ISSE_8 = raster(mosaico[[1]], band = 7)

#Export splited rasters 
setwd("DIRETORIO2/SUBPASTA")
writeRaster(ISSE_1, "./L5_Ferrari_2001_06_B1", format = "GTiff", datatype = "FLT4S", overwrite = T)
writeRaster(ISSE_2, "./L5_Ferrari_2001_06_B2", format = "GTiff", datatype = "FLT4S", overwrite = T)
writeRaster(ISSE_3, "./L5_Ferrari_2001_06_B3", format = "GTiff", datatype = "FLT4S", overwrite = T)
writeRaster(ISSE_4, "./L5_Ferrari_2001_06_B4", format = "GTiff", datatype = "FLT4S", overwrite = T)
writeRaster(ISSE_5, "./L5_Ferrari_2001_06_B5", format = "GTiff", datatype = "FLT4S", overwrite = T)
writeRaster(ISSE_7, "./L5_Ferrari_2001_06_B6", format = "GTiff", datatype = "FLT4S", overwrite = T)
#writeRaster(ISSE_8, "./L5_2007_04_QA", format = "GTiff", datatype = "FLT4S", overwrite = T)
