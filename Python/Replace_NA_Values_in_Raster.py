# -*- coding: utf-8 -*-
"""
Created on Thu Aug 31 10:56:25 2023

@author: fellipe.alcantara
"""

import os
import rasterio
import numpy as np

# Directory containing raster files
raster_directory = r"C:\Fellipe\Capuava\Raster\Vegetacao\Indices"

# List all raster files in the directory
raster_files = [file for file in os.listdir(raster_directory) if file.endswith(".tif")]

for raster_file in raster_files:
    raster_path = os.path.join(raster_directory, raster_file)

    # Open the raster file
    with rasterio.open(raster_path) as src:
        # Read raster data as a NumPy array
        raster_data = src.read(1)  # Assuming you're working with a single-band raster

        # Replace NA values with zero
        raster_data[np.isnan(raster_data)] = 0.001 # Value to replace the NAs

        # Update the source raster with the modified data
        # You can create a copy of the source file and save the modified data to it
        modified_raster_path = os.path.join(raster_directory, "modified_" + raster_file)
        profile = src.profile  # Get the profile from the source raster
        with rasterio.open(modified_raster_path, 'w', **profile) as dst:
            dst.write(raster_data, 1)  # Write the modified data to the new raster file



