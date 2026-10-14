# -*- coding: utf-8 -*-
"""
Created on Mon Aug 28 11:22:42 2023

@author: fellipe.alcantara
"""

import os
import rasterio as rio
import numpy as np
import matplotlib.pyplot as plt

# Band Description for Landsat 8 Downloaded from GEE
# Band 1 - Blue	
# Band 2 - Green	
# Band 3 - Red	
# Band 4 - Near Infrared (NIR)	
# Band 5 - Shortwave Infrared (SWIR1) 	
# Band 6 - Shortwave Infrared (SWIR2)

#########################################################################################################
os.chdir(r"DIRETORIO/Landsat")
os.listdir()
################### Abrir os Rasters  #####################
# Imagem L5_2006_04
src = rio.open('./L8-09-23-Ester.tif') # CHANGE THIS VARIABLE 

# Get the number of bands in the raster
num_bands = src.count

# List to store band objects
band_objects = []

# Create a separate band object for each band
for band_index in range(1, num_bands + 1):
    band = src.read(band_index)
    band_objects.append(band)

###############################################################################
# Landsat Image Scale Factor (Band * 0.0000275) - 0.2)
# Empty List for Corrected Bands
band = []

# Apply Scale Factor
for obj in band_objects:
    result = (obj * 0.0000275) - 0.2
    band.append(result)

# Band description
# band[0]-Blue; band[1]-Green; band[2]-Red; band[3]-NIR; band[4]-SWIR1; band[5]-SWIR2
# Índices de Vegetação
NDVI = np.where((band[3]+band[2])==0.,0, (band[3]-band[2])/(band[3]+band[2]))
SAVI = np.where((band[3]+band[2])==0.,0, (band[3]-band[2])/(((band[3]+band[2])+0.5)*1.5))
EVI  = np.where((band[3]+band[2])==0.,0, 2.5*((band[3]-band[2])/(band[3] + 6 * band[2] - 7.5 * band[0] + 1)))
NBR2 = np.where((band[4]+band[5])==0.,0, (band[4]-band[5])/(band[4]+band[5]))

# Dictionary where keys are original object names and values are the objects themselves
objects_to_export = {
    "NDVI": NDVI,
    "SAVI": SAVI,
    "EVI": EVI,
    "NBR2": NBR2,
   }

# Path to the directory where you want to save the raster files
output_directory = "C:/Users/fellipe.alcantara/OneDrive - GATEC S A GESTAO AGROINDUSTRIAL/Fellipe_OneDriver/ESTER/Landsat/L8-09-23-Ester/"

# Loop through the objects and export them as raster files
for obj_name, obj in objects_to_export.items():
    output_filename = f"{obj_name}.tif"  # Change the filename format as needed - Insert Sufix
    output_path = output_directory + output_filename
    
    # Assuming obj is a NumPy array representing the raster data
    with rio.open(output_path, 'w', 
                       driver='GTiff', 
                       height    = src.height, 
                       width     = src.width, 
                       crs       = src.crs,
                       transform = src.transform,
                       count=1, 
                       dtype     = 'float64') as dst:
        dst.write(obj, 1)
    
    print(f"Exported {obj_name} to {output_path}")


#############################################################################
'''
# Loop through each band and plot it
for band_index, band_data in enumerate(scaled_bands, start=1):
    plt.figure(figsize=(8, 8))
    plt.imshow(band_data, cmap='gray')  # Use a colormap suitable for your data
    plt.title(f"Band {band_index}")
    plt.colorbar()
    plt.show()

# Plot the individual band to check
plt.figure(figsize=(8, 8))
plt.imshow(band_1, cmap='gray')  # Use a colormap suitable for your data
plt.title(f"Band {band_index}")
plt.colorbar()
plt.show()
'''