# -*- coding: utf-8 -*-
"""
Created on Tue Apr 18 10:05:30 2023

@author: fellipe.alcantara
"""

import os
import rasterio as rio
import numpy as np
import matplotlib.pyplot as plt
from osgeo import gdal
import osgeo

#########################################################################################################
os.chdir(r"DIRETORIO/L8_2019_02")
os.listdir()
################### Abrir os Rasters  #####################
# Imagem L5_2006_04
Blue_03 = rio.open('./L8_2019_02_B1.tif')
Blue_03_Float = Blue_03.read(1).astype('float64')

Red_03 = rio.open("./L8_2019_02_B3.tif")
Red_03_Float = Red_03.read(1).astype('float64')

NIR_03 = rio.open("./L8_2019_02_B4.tif")
NIR_03_Float = NIR_03.read(1).astype('float64')

SWIR1_03 = rio.open("./L8_2019_02_B5.tif")
SWIR1_03_Float = SWIR1_03.read(1).astype('float64')

SWIR2_03 = rio.open("./L8_2019_02_B6.tif")
SWIR2_03_Float = SWIR2_03.read(1).astype('float64')

##########################################################################
os.chdir(r"DIRETORIO/L8_2019_04")
os.listdir()
# Imagem L5_2006_05
Blue_04 = rio.open("./L8_2019_04_B1.tif")
Blue_04_Float = Blue_04.read(1).astype('float64')

Red_04 = rio.open("./L8_2019_04_B3.tif")
Red_04_Float = Red_04.read(1).astype('float64')

NIR_04 = rio.open("./L8_2019_04_B4.tif")
NIR_04_Float = NIR_04.read(1).astype('float64')

SWIR1_04 = rio.open("./L8_2019_04_B5.tif")
SWIR1_04_Float = SWIR1_04.read(1).astype('float64')

SWIR2_04 = rio.open("./L8_2019_04_B6.tif")
SWIR2_04_Float = SWIR2_04.read(1).astype('float64')

##########################################################################
os.chdir(r"DIRETORIO/L8_2019_05")
os.listdir()
# Imagem L5_2006_05
Blue_05 = rio.open("./L8_2019_05_B1.tif")
Blue_05_Float = Blue_05.read(1).astype('float64')

Red_05 = rio.open("./L8_2019_05_B3.tif")
Red_05_Float = Red_05.read(1).astype('float64')

NIR_05 = rio.open("./L8_2019_05_B4.tif")
NIR_05_Float = NIR_05.read(1).astype('float64')

SWIR1_05 = rio.open("./L8_2019_05_B5.tif")
SWIR1_05_Float = SWIR1_05.read(1).astype('float64')

SWIR2_05 = rio.open("./L8_2019_05_B6.tif")
SWIR2_05_Float = SWIR2_05.read(1).astype('float64')

##########################################################################
os.chdir(r"DIRETORIO/L8_2019_06")
os.listdir()
# Imagem L5_2006_05
Blue_06 = rio.open("./L8_2019_06_B1.tif")
Blue_06_Float = Blue_05.read(1).astype('float64')

Red_06 = rio.open("./L8_2019_06_B3.tif")
Red_06_Float = Red_05.read(1).astype('float64')

NIR_06 = rio.open("./L8_2019_06_B4.tif")
NIR_06_Float = NIR_05.read(1).astype('float64')

SWIR1_06 = rio.open("./L8_2019_06_B5.tif")
SWIR1_06_Float = SWIR1_05.read(1).astype('float64')

SWIR2_06 = rio.open("./L8_2019_06_B6.tif")
SWIR2_06_Float = SWIR2_05.read(1).astype('float64')

##########################################################################
os.chdir(r"DIRETORIO/L8_2019_044")
os.listdir()
# Imagem L5_2006_05
Blue_044 = rio.open("./L8_2019_044_B1.tif")
Blue_044_Float = Blue_044.read(1).astype('float64')

Red_044 = rio.open("./L8_2019_044_B3.tif")
Red_044_Float = Red_044.read(1).astype('float64')

NIR_044 = rio.open("./L8_2019_044_B4.tif")
NIR_044_Float = NIR_044.read(1).astype('float64')

SWIR1_044 = rio.open("./L8_2019_044_B5.tif")
SWIR1_044_Float = SWIR1_044.read(1).astype('float64')

SWIR2_044 = rio.open("./L8_2019_044_B6.tif")
SWIR2_044_Float = SWIR2_044.read(1).astype('float64')

##########################################################################

# Correção Das Imagens (Scale Factor (Banda * 0.0000275) - 0.2)
Blue_03_Scale   = (Blue_03_Float*0.0000275)-0.2
Red_03_Scale    = (Red_03_Float*0.0000275)-0.2
NIR_03_Scale    = (NIR_03_Float*0.0000275)-0.2
SWIR1_03_Scale  = (SWIR1_03_Float*0.0000275)-0.2
SWIR2_03_Scale  = (SWIR2_03_Float*0.0000275)-0.2

Blue_04_Scale   = (Blue_04_Float*0.0000275)-0.2
Red_04_Scale    = (Red_04_Float*0.0000275)-0.2
NIR_04_Scale    = (NIR_04_Float*0.0000275)-0.2
SWIR1_04_Scale  = (SWIR1_04_Float*0.0000275)-0.2
SWIR2_04_Scale  = (SWIR2_04_Float*0.0000275)-0.2

Blue_05_Scale   = (Blue_05_Float*0.0000275)-0.2
Red_05_Scale    = (Red_05_Float*0.0000275)-0.2
NIR_05_Scale    = (NIR_05_Float*0.0000275)-0.2
SWIR1_05_Scale  = (SWIR1_05_Float*0.0000275)-0.2
SWIR2_05_Scale  = (SWIR2_05_Float*0.0000275)-0.2

Blue_06_Scale   = (Blue_06_Float*0.0000275)-0.2
Red_06_Scale    = (Red_06_Float*0.0000275)-0.2
NIR_06_Scale    = (NIR_06_Float*0.0000275)-0.2
SWIR1_06_Scale  = (SWIR1_06_Float*0.0000275)-0.2
SWIR2_06_Scale  = (SWIR2_06_Float*0.0000275)-0.2

Blue_044_Scale   = (Blue_044_Float*0.0000275)-0.2
Red_044_Scale    = (Red_044_Float*0.0000275)-0.2
NIR_044_Scale    = (NIR_044_Float*0.0000275)-0.2
SWIR1_044_Scale  = (SWIR1_044_Float*0.0000275)-0.2
SWIR2_044_Scale  = (SWIR2_044_Float*0.0000275)-0.2

##########################################################################
# Índices de Vegetação
NDVI_03 = np.where((NIR_03_Scale+Red_03_Scale)==0.,0, (NIR_03_Scale-Red_03_Scale)/(NIR_03_Scale+Red_03_Scale))
NDVI_04 = np.where((NIR_04_Scale+Red_04_Scale)==0.,0, (NIR_04_Scale-Red_04_Scale)/(NIR_04_Scale+Red_04_Scale))
NDVI_05 = np.where((NIR_05_Scale+Red_05_Scale)==0.,0, (NIR_05_Scale-Red_05_Scale)/(NIR_05_Scale+Red_05_Scale))
NDVI_06 = np.where((NIR_06_Scale+Red_06_Scale)==0.,0, (NIR_06_Scale-Red_06_Scale)/(NIR_06_Scale+Red_06_Scale))
NDVI_044 = np.where((NIR_044_Scale+Red_044_Scale)==0.,0, (NIR_044_Scale-Red_044_Scale)/(NIR_044_Scale+Red_044_Scale))


# Exportar o NDVI
os.chdir(r"DIRETORIO/Indices")
ndvi03 = rio.open('../NDVI_2019_02o.tiff','w',driver='Gtiff',
                  width=Red_03.width,
                  height = Red_03.height,count=1,
                  crs=Red_03.crs,
                  transform=Red_03.transform,
                  dtype='float64')
ndvi03.write(NDVI_03,1)
ndvi03.close()

ndvi04 = rio.open('../NDVI_2019_04.tiff','w',driver='Gtiff',width=Red_04.width,height = Red_04.height,count=1, crs=Red_04.crs,transform=Red_04.transform, dtype='float64')
ndvi04.write(NDVI_04,1)
ndvi04.close()

ndvi05 = rio.open('../NDVI_2019_05.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
ndvi05.write(NDVI_05,1)
ndvi05.close()

ndvi06 = rio.open('../NDVI_2019_06.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
ndvi06.write(NDVI_06,1)
ndvi06.close()

ndvi044 = rio.open('../NDVI_2019_044.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
ndvi044.write(NDVI_044,1)
ndvi044.close()

#############################################################################################################
# Calcular o SAVI  - In Landsat 8-9, SAVI = ((Band 5 – Band 4) / (Band 5 + Band 4 + 0.5)) * (1.5)
SAVI_03 = np.where((NIR_03_Scale+Red_03_Scale)==0.,0, (NIR_03_Scale-Red_03_Scale)/(((NIR_03_Scale+Red_03_Scale)+0.5)*1.5))
SAVI_04 = np.where((NIR_04_Scale+Red_04_Scale)==0.,0, (NIR_04_Scale-Red_04_Scale)/(((NIR_04_Scale+Red_04_Scale)+0.5)*1.5))
SAVI_05 = np.where((NIR_05_Scale+Red_05_Scale)==0.,0, (NIR_05_Scale-Red_05_Scale)/(((NIR_05_Scale+Red_05_Scale)+0.5)*1.5))
SAVI_06 = np.where((NIR_06_Scale+Red_06_Scale)==0.,0, (NIR_06_Scale-Red_06_Scale)/(((NIR_06_Scale+Red_06_Scale)+0.5)*1.5))
SAVI_044 = np.where((NIR_044_Scale+Red_044_Scale)==0.,0, (NIR_044_Scale-Red_044_Scale)/(((NIR_044_Scale+Red_044_Scale)+0.5)*1.5))


# Exportar o SAVI
os.chdir(r"DIRETORIO/Indices")
savi03 = rio.open('../SAVI_2019_02.tiff','w',driver='Gtiff',width=Red_03.width,height = Red_03.height,count=1, crs=Red_03.crs,transform=Red_03.transform, dtype='float64')
savi03.write(SAVI_03,1)
savi03.close()

savi04 = rio.open('../SAVI_2019_04.tiff','w',driver='Gtiff',width=Red_04.width,height = Red_04.height,count=1, crs=Red_04.crs,transform=Red_04.transform, dtype='float64')
savi04.write(SAVI_04,1)
savi04.close()

savi05 = rio.open('../SAVI_2019_05.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
savi05.write(SAVI_05,1)
savi05.close()

savi06 = rio.open('../SAVI_2019_06.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
savi06.write(SAVI_06,1)
savi06.close()

savi044 = rio.open('../SAVI_2019_044.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
savi044.write(SAVI_044,1)
savi044.close()

#############################################################################################################

# Calcular o EVI - EVI = 2.5 * ((Band 5 – Band 4) / (Band 5 + 6 * Band 4 – 7.5 * Band 2 + 1))
EVI_03 = np.where((NIR_03_Scale+Red_03_Scale)==0.,0, 2.5*((NIR_03_Scale-Red_03_Scale)/(NIR_03_Scale + 6 * Red_03_Scale - 7.5 * Blue_03_Scale + 1)))
EVI_04 = np.where((NIR_04_Scale+Red_04_Scale)==0.,0, 2.5*((NIR_04_Scale-Red_04_Scale)/(NIR_04_Scale + 6 * Red_04_Scale - 7.5 * Blue_04_Scale + 1)))
EVI_05 = np.where((NIR_05_Scale+Red_05_Scale)==0.,0, 2.5*((NIR_05_Scale-Red_05_Scale)/(NIR_05_Scale + 6 * Red_05_Scale - 7.5 * Blue_05_Scale + 1)))
EVI_06 = np.where((NIR_06_Scale+Red_06_Scale)==0.,0, 2.5*((NIR_06_Scale-Red_06_Scale)/(NIR_06_Scale + 6 * Red_06_Scale - 7.5 * Blue_06_Scale + 1)))
EVI_044 = np.where((NIR_044_Scale+Red_044_Scale)==0.,0, 2.5*((NIR_044_Scale-Red_044_Scale)/(NIR_044_Scale + 6 * Red_044_Scale - 7.5 * Blue_044_Scale + 1)))


# Exportar o EVI
os.chdir(r"DIRETORIO/Indices")
evi03 = rio.open('../EVI_2019_02.tiff','w',driver='Gtiff',width=Red_03.width,height = Red_03.height,count=1, crs=Red_03.crs,transform=Red_03.transform, dtype='float64')
evi03.write(EVI_03,1)
evi03.close()

evi04 = rio.open('../EVI_2019_04.tiff','w',driver='Gtiff',width=Red_04.width,height = Red_04.height,count=1, crs=Red_04.crs,transform=Red_04.transform, dtype='float64')
evi04.write(EVI_04,1)
evi04.close()

evi05 = rio.open('../EVI_2019_05.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
evi05.write(EVI_05,1)
evi05.close()

evi06 = rio.open('../EVI_2019_06.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
evi06.write(EVI_06,1)
evi06.close()

evi044 = rio.open('../EVI_2019_044.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
evi044.write(EVI_044,1)
evi044.close()

#############################################################################################################
# Calcular o NBR2 - 
NBR2_03 = np.where((SWIR1_03_Scale+SWIR2_03_Scale)==0.,0, (SWIR1_03_Scale-SWIR2_03_Scale)/(SWIR1_03_Scale+SWIR2_03_Scale))
NBR2_04 = np.where((SWIR1_04_Scale+SWIR2_04_Scale)==0.,0, (SWIR1_04_Scale-SWIR2_04_Scale)/(SWIR1_04_Scale+SWIR2_04_Scale))
NBR2_05 = np.where((SWIR1_05_Scale+SWIR2_05_Scale)==0.,0, (SWIR1_05_Scale-SWIR2_05_Scale)/(SWIR1_05_Scale+SWIR2_05_Scale))
NBR2_06 = np.where((SWIR1_06_Scale+SWIR2_06_Scale)==0.,0, (SWIR1_06_Scale-SWIR2_06_Scale)/(SWIR1_06_Scale+SWIR2_06_Scale))
NBR2_044 = np.where((SWIR1_044_Scale+SWIR2_044_Scale)==0.,0, (SWIR1_044_Scale-SWIR2_044_Scale)/(SWIR1_044_Scale+SWIR2_044_Scale))

# Exportar o NBR2
os.chdir(r"DIRETORIO/Indices")
nbr03 = rio.open('../NBR2_2019_02.tiff','w',driver='Gtiff',width=Red_03.width,height = Red_03.height,count=1, crs=Red_03.crs,transform=Red_03.transform, dtype='float64')
nbr03.write(NBR2_03,1)
nbr03.close()

nbr04 = rio.open('../NBR2_2019_04.tiff','w',driver='Gtiff',width=Red_04.width,height = Red_04.height,count=1, crs=Red_04.crs,transform=Red_04.transform, dtype='float64')
nbr04.write(NBR2_04,1)
nbr04.close()

nbr05 = rio.open('../NBR2_2019_05.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
nbr05.write(NBR2_05,1)
nbr05.close()

nbr06 = rio.open('../NBR2_2019_06.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
nbr06.write(NBR2_06,1)
nbr05.close()

nbr044 = rio.open('../NBR2_2019_044.tiff','w',driver='Gtiff',width=Red_05.width,height = Red_05.height,count=1, crs=Red_05.crs,transform=Red_05.transform, dtype='float64')
nbr044.write(NBR2_044,1)
nbr044.close()

