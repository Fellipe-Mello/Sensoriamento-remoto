# -*- coding: utf-8 -*-
"""
Created on Fri Sep  1 15:32:34 2023

@author: fellipe.alcantara
"""

import os
import rasterio

# Path to the multiband raster dataset
multiband_raster_path = r"C:\Fellipe\Capuava\Raster\Covariates\ISSE_Capuava_32722.tif"

# Open the multiband raster dataset
with rasterio.open(multiband_raster_path) as src:
    # Loop through each band in the multiband dataset
    for band_idx in range(1, src.count + 1):
        # Read the band data
        band_data = src.read(band_idx)
        
        # Set zero values to NA (NoData)
        band_data[band_data == 0] = src.nodata
        
        # Create a new file name with the "B" suffix
        output_filename = f"output_band{band_idx}.tif"
        
        # Define the path to the output raster
        output_path = os.path.join(r"C:\Fellipe\Capuava\Raster\Covariates", output_filename)
        
        # Create a new single-band raster dataset for the current band
        with rasterio.open(
            output_path,
            'w',
            driver='GTiff',
            width=src.width,
            height=src.height,
            count=1,  # Set to 1 for a single band
            dtype=band_data.dtype,
            crs=src.crs,
            transform=src.transform,
            nodata=src.nodata
        ) as dst:
            # Write the band data to the new raster
            dst.write(band_data, 1)  # Use band index 1

# Replace "output_directory" with the desired output directory path.