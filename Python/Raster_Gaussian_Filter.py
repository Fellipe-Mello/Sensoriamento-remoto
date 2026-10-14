# -*- coding: utf-8 -*-
"""
Created on Tue Feb 20 11:39:03 2024

@author: fellipe.alcantara
"""

# Scrip to Filter 1 Band
import rasterio
import matplotlib.pyplot as plt
from skimage import color, filters

# Load the Sentinel-2 satellite image using rasterio
image_path = r'C:\Users\fellipe.alcantara\Desktop\2019-04-20.tif'

with rasterio.open(image_path) as src:
    # Read all bands
    satellite_image = src.read()

# If Sentinel-2 data has multiple resolutions (bands have different shapes), you might need to choose a specific band
# In this example, using the first band (index 0)
satellite_image_band = satellite_image[0]

# Apply Gaussian filter
sigma_value = 1.0
smoothed_image = filters.gaussian(satellite_image_band, sigma=sigma_value)

# Display the original and smoothed images
plt.figure(figsize=(12, 6))

# Original image
plt.subplot(1, 2, 1)
plt.imshow(satellite_image_band, cmap='gray')  # Displaying one band for visualization
plt.title('Original Image')

# Smoothed image
plt.subplot(1, 2, 2)
plt.imshow(smoothed_image, cmap='gray')
plt.title(f'Smoothed Image (Gaussian Filter, sigma={sigma_value})')

plt.show()
########################################################################################
########################################################################################
########################################################################################
########################################################################################

# Script to Filter all the bands of a Multiband Raster And Export them all as Separate Files.
import rasterio
import os
from skimage import filters
import numpy as np

# Load the Sentinel-2 satellite image using rasterio
image_path = r'C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Way\Raster\Teste2\2019-04-20.tif'

with rasterio.open(image_path) as src:
    # Read all bands
    satellite_image = src.read()

# Original band names
band_names = ["Blue", "Green", "Red", "Red_Edge_1", "Red_Edge_2", "Red_Edge_3", "NIR", "B8A", "SWIR_1", "SWIR_2"]

# Create a directory to save the filtered images
output_directory = r'C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Way\Raster\Teste2'
os.makedirs(output_directory, exist_ok=True)

# Apply Gaussian filter to each band and export as separate files
sigma_value = 1.0

for band_idx, band_name in enumerate(band_names):
    # Extract one band
    satellite_image_band = satellite_image[band_idx]

    # Apply Gaussian filter
    smoothed_image = filters.gaussian(satellite_image_band, sigma=sigma_value)

    # Reshape the smoothed image to add a singleton dimension for the band
    smoothed_image_reshaped = smoothed_image.reshape(1, *satellite_image_band.shape)

    # Create output path for the smoothed band
    output_path = os.path.join(output_directory, f'{band_name}_Smoothed.tif')

    # Get image metadata for writing the output
    meta = src.meta
    meta.update(count=1, dtype='float32')

    # Write the smoothed band to a new file
    with rasterio.open(output_path, 'w', **meta) as dst:
        dst.write(smoothed_image_reshaped.astype('float32'))

    print(f"Smoothed band '{band_name}' exported to: {output_path}")