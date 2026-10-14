# -*- coding: utf-8 -*-
"""
Created on Mon Aug 28 16:02:21 2023

@author: fellipe.alcantara
"""

import os
import rioxarray as rxr
import rasterio as rio
#########################################################################################################

# Specify the directory path and the desired suffix
directory_path = "C:/Fellipe/Capuava/Raster/Vegetacao/Indices"
desired_suffix = "07.tif"  # CHANGE THIS VARIABLE

# Get a list of all files in the directory
all_files = os.listdir(directory_path)

# Create a list of full paths to files that match the desired suffix
file_paths = [os.path.join(directory_path, file) for file in all_files if file.endswith(desired_suffix)]

# List to store the opened datasets
opened_datasets = []

# Open the Rasters
for file_path in file_paths:
    dataset = rxr.open_rasterio(file_path, masked=True)  # Set masked=True to create a masked array
    opened_datasets.append(dataset)

# Mask the raster with the reference value from NDVI
# Create a list of indexes
index_list = [opened_datasets[0], 
            opened_datasets[1], 
            opened_datasets[2], 
            opened_datasets[3]]

# Create a list to store the results
index_clip = []

# Filter the pixels with nor vegetation (NDVI <= 0.25)
for index in index_list:
    result = index.where(index_list[2] >= 0.25)
    index_clip.append(result)

# Define a list of xarray.DataArray objects representing your rasters:
raster_data_arrays = [index_clip[0], 
                      index_clip[1],
                      index_clip[2],
                      index_clip[3]]  # Replace with your actual DataArray objects


# Define a list of file paths for the rasters you want to save:
os.chdir("DIRETORIO/Filtrado/")
output_file_paths = ["./EVI_07.tif", 
                     "./NBR2_07.tif",
                     "./NDVI_07.tif",
                     "./SAVI_07.tif"]  # Replace with desired output paths

# Export the rasters to directory
for data_array, output_path in zip(raster_data_arrays, output_file_paths):
    data_array.rio.to_raster(output_path)
    print(f"Saved raster to {output_path}")

