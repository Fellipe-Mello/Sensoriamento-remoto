# -*- coding: utf-8 -*-
"""
Created on Thu Aug 31 13:32:28 2023

@author: fellipe.alcantara
"""

import os
import rioxarray as rxr
# import earthpy.spatial as es
import numpy as np
import xarray as xr

# Directory containing raster files
raster_directory = r"C:\Fellipe\Capuava\Raster\Covariates\Teste"

# List all raster files in the directory
raster_files = [file for file in os.listdir(raster_directory) if file.endswith(".tif")]

# List to store the opened datasets
opened_datasets = []

# Open the Rasters
for raster_file in raster_files:
    raster_path = os.path.join(raster_directory, raster_file)
    dataset = rxr.open_rasterio(raster_path, masked=True)
    opened_datasets.append(dataset)
    

# Select the reference raster to resample the others    
reference_dataset = opened_datasets[27]  

# List to store cropped and resampled datasets
cropped_resampled_datasets = []

# Crop and resample the other rasters using the reference dataset
for dataset in opened_datasets[1:]:
    cropped_resampled = dataset.rio.clip_box(*reference_dataset.rio.bounds())
    cropped_resampled = cropped_resampled.rio.reproject(reference_dataset.rio.crs)
    cropped_resampled_datasets.append(cropped_resampled)
    
    
# Convert the datasets to numpy arrays
cropped_resampled_arrays = [ds.values for ds in cropped_resampled_datasets]


# Use xr.concat to stack the DataArray objects along the 'band' dimension
stacked_dataset = xr.concat(cropped_resampled_datasets, dim='band')

# Optional: Save the stacked dataset as a raster file
stacked_path = os.path.join(raster_directory, "stacked_rasters.tif")
stacked_dataset.rio.to_raster(stacked_path)









###############################################################################
import matplotlib.pyplot as plt

# Index of the dataset you want to plot (e.g., the first dataset)
index_to_plot = 28  # Change this to the index of the dataset you want to plot

# Get the dataset to plot
dataset_to_plot = opened_datasets[index_to_plot]

# Squeeze the data to remove single-dimensional entries
raster_data = dataset_to_plot.squeeze()

# Plot the raster data
plt.figure(figsize=(8, 8))
plt.imshow(raster_data.values, cmap='viridis')  # You can change the colormap (cmap) to your preference
plt.colorbar(label='Pixel Value')
plt.title(f"Raster {index_to_plot + 1}")
plt.xlabel('X Coordinate')
plt.ylabel('Y Coordinate')
plt.show()

###############################################################################

'''



# Stack the arrays using earthpy
stacked_array = np.array(cropped_resampled_arrays)

# Create a stacked raster dataset using the reference dataset's metadata
stacked_dataset = rxr.DataArray(stacked_array, coords=reference_dataset.coords, dims=("band", "y", "x"))

# Optional: Save the stacked dataset as a raster file
stacked_path = os.path.join(raster_directory, "stacked_rasters.tif")
stacked_dataset.rio.to_raster(stacked_path)
   
    '''
   