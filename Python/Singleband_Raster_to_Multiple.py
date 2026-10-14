# -*- coding: utf-8 -*-
"""
Created on Tue Feb 20 14:29:04 2024

@author: fellipe.alcantara
"""

import rasterio
from rasterio.merge import merge
from rasterio.transform import from_origin
import os

# Directory where the smoothed bands are stored
smoothed_directory = r'C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Way\Raster\Teste2'

# Output path for the merged multiband raster
output_path = r'C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Way\Raster\Teste2\Sentinel_Filtered_Teste2.tif'

# Define the desired order and names for the bands
desired_band_order = ["Blue", "Green", "Red", "Red_Edge_1", "Red_Edge_2", "Red_Edge_3", "NIR", "B8A", "SWIR_1", "SWIR_2"]

# List to store the smoothed bands
smoothed_bands = []

# Iterate over the desired order and read each smoothed band
for band_name in desired_band_order:
    band_path = os.path.join(smoothed_directory, f'{band_name}_Smoothed.tif')

    with rasterio.open(band_path) as src:
        smoothed_band = src.read(1)  # Read only the first (and only) band
        smoothed_bands.append(smoothed_band)

# Stack the smoothed bands along a new dimension
stacked_smoothed_bands = np.stack(smoothed_bands)

# Get metadata from one of the smoothed bands for writing the output
meta = src.meta
meta.update(count=len(desired_band_order), dtype='float32', names=desired_band_order)  # Update count, data type, and set band names

# Write the stacked bands to a new multiband raster
with rasterio.open(output_path, 'w', **meta) as dst:
    dst.write(stacked_smoothed_bands)

print(f"Multiband smoothed raster exported to: {output_path}")

