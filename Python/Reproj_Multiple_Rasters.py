# -*- coding: utf-8 -*-
"""
Created on Thu Aug 31 11:47:24 2023

@author: fellipe.alcantara
"""

import os
import rioxarray as rxr
from rasterio.crs import CRS

# Specify the directory path and the desired suffix
directory_path = "C:/Users/fellipe.alcantara/OneDrive - GATEC S A GESTAO AGROINDUSTRIAL/Fellipe_OneDriver/ESTER/Landsat/Indices_clip/relevo"
desired_suffix = ".tif"  # CHANGE THIS VARIABLE

# Specify the output directory where reprojected rasters will be saved
output_directory = "C:/Users/fellipe.alcantara/OneDrive - GATEC S A GESTAO AGROINDUSTRIAL/Fellipe_OneDriver/ESTER/Landsat/Indices_clip"

# Get a list of all files in the directory
all_files = os.listdir(directory_path)

# Create a list of full paths to files that match the desired suffix
file_paths = [os.path.join(directory_path, file) for file in all_files if file.endswith(desired_suffix)]

# List to store the opened datasets
opened_datasets = []

# Create a rasterio crs object for wgs 84 crs - lat / lon
crs_utm = CRS.from_string('EPSG:4326')

# Reproject and export the rasters
for file_path in file_paths:
    dataset = rxr.open_rasterio(file_path, masked=True)
    reproj = dataset.rio.reproject(crs_utm)

    # Get the original file name without the directory
    original_filename = os.path.basename(file_path)
    
    # Create the output file path in the output directory
    output_file_path = os.path.join(output_directory, original_filename)
    
    # Save the reprojected raster to the output directory
    reproj.rio.to_raster(output_file_path)

print("Reprojection and export complete.")
