# -*- coding: utf-8 -*-
"""
Created on Mon Jul 17 15:17:30 2023

@author: fellipe.alcantara
"""

import os
import rioxarray as rxr
#########################################################################################################
os.chdir(r"DIRETORIO/Indices")
os.listdir()
################### Abrir os Rasters  #####################
# NDVI
NDVI_2019_02  = rxr.open_rasterio('./NDVI_2019_02.tiff')
NDVI_2019_04  = rxr.open_rasterio('./NDVI_2019_04.tiff')
NDVI_2019_044 = rxr.open_rasterio('./NDVI_2019_044.tiff')
NDVI_2019_05  = rxr.open_rasterio('./NDVI_2019_05.tiff')
NDVI_2019_06  = rxr.open_rasterio('./NDVI_2019_06.tiff')

# EVI
EVI_2019_02  = rxr.open_rasterio('./EVI_2019_02.tiff')
EVI_2019_04  = rxr.open_rasterio('./EVI_2019_04.tiff')
EVI_2019_044 = rxr.open_rasterio('./EVI_2019_044.tiff')
EVI_2019_05  = rxr.open_rasterio('./EVI_2019_05.tiff')
EVI_2019_06  = rxr.open_rasterio('./EVI_2019_06.tiff')

# SAVI
SAVI_2019_02  = rxr.open_rasterio('./SAVI_2019_02.tiff')
SAVI_2019_04  = rxr.open_rasterio('./SAVI_2019_04.tiff')
SAVI_2019_044 = rxr.open_rasterio('./SAVI_2019_044.tiff')
SAVI_2019_05  = rxr.open_rasterio('./SAVI_2019_05.tiff')
SAVI_2019_06  = rxr.open_rasterio('./SAVI_2019_06.tiff')

# NBR2
NBR2_2019_02  = rxr.open_rasterio('./NBR2_2019_02.tiff')
NBR2_2019_04  = rxr.open_rasterio('./NBR2_2019_04.tiff')
NBR2_2019_044 = rxr.open_rasterio('./NBR2_2019_044.tiff')
NBR2_2019_05  = rxr.open_rasterio('./NBR2_2019_05.tiff')
NBR2_2019_06  = rxr.open_rasterio('./NBR2_2019_06.tiff')

#########################################################################################################
# Mask the raster with the reference
EVI_2019_02_Filt    =   EVI_2019_02.where(NDVI_2019_02 >= 0.25)
EVI_2019_04_Filt    =   EVI_2019_04.where(NDVI_2019_04 >= 0.25)
EVI_2019_044_Filt   =   EVI_2019_044.where(NDVI_2019_044 >= 0.25)
EVI_2019_05_Filt    =   EVI_2019_05.where(NDVI_2019_05 >= 0.25)
EVI_2019_06_Filt    =   EVI_2019_06.where(NDVI_2019_06 >= 0.25)

EVI_2019_02_Filt.rio.to_raster("EVI_2019_02_Filt.tif")
EVI_2019_04_Filt.rio.to_raster("EVI_2019_04_Filt.tif")
EVI_2019_044_Filt.rio.to_raster("EVI_2019_044_Filt.tif")
EVI_2019_05_Filt.rio.to_raster("EVI_2019_05_Filt.tif")
EVI_2019_06_Filt.rio.to_raster("EVI_2019_06_Filt.tif")

SAVI_2019_02_Filt    =   SAVI_2019_02.where(NDVI_2019_02 >= 0.25)
SAVI_2019_04_Filt    =   SAVI_2019_04.where(NDVI_2019_04 >= 0.25)
SAVI_2019_044_Filt   =   SAVI_2019_044.where(NDVI_2019_044 >= 0.25)
SAVI_2019_05_Filt    =   SAVI_2019_05.where(NDVI_2019_05 >= 0.25)
SAVI_2019_06_Filt    =   SAVI_2019_06.where(NDVI_2019_06 >= 0.25)

SAVI_2019_02_Filt.rio.to_raster("SAVI_2019_02_Filt.tif")
SAVI_2019_04_Filt.rio.to_raster("SAVI_2019_04_Filt.tif")
SAVI_2019_044_Filt.rio.to_raster("SAVI_2019_044_Filt.tif")
SAVI_2019_05_Filt.rio.to_raster("SAVI_2019_05_Filt.tif")
SAVI_2019_06_Filt.rio.to_raster("SAVI_2019_06_Filt.tif")

NBR2_2019_02_Filt    =   NBR2_2019_02.where(NDVI_2019_02 >= 0.25)
NBR2_2019_04_Filt    =   NBR2_2019_04.where(NDVI_2019_04 >= 0.25)
NBR2_2019_044_Filt   =   NBR2_2019_044.where(NDVI_2019_044 >= 0.25)
NBR2_2019_05_Filt    =   NBR2_2019_05.where(NDVI_2019_05 >= 0.25)
NBR2_2019_06_Filt    =   NBR2_2019_06.where(NDVI_2019_06 >= 0.25)

NBR2_2019_02_Filt.rio.to_raster("NBR2_2019_02_Filt.tif")
NBR2_2019_04_Filt.rio.to_raster("NBR2_2019_04_Filt.tif")
NBR2_2019_044_Filt.rio.to_raster("NBR2_2019_044_Filt.tif")
NBR2_2019_05_Filt.rio.to_raster("NBR2_2019_05_Filt.tif")
NBR2_2019_06_Filt.rio.to_raster("NBR2_2019_06_Filt.tif")


