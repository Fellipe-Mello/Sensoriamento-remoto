# -*- coding: utf-8 -*-
"""
Created on Mon Sep  4 11:27:24 2023

@author: fellipe.alcantara
"""

import rasterio
import numpy as np
import os
from sklearn.cluster import KMeans
import geopandas as gpd
import rasterio.mask

os.chdir(r'DIRETORIO/Rasters') # Change This Directory

# Open the multiband raster stack
src = rasterio.open('raster_stack3.tif') # Change the file name

#    # Read the bands into a NumPy array
multiband_data = src.read()

# Reshape the Data:
n_bands, height, width = multiband_data.shape
data_reshaped = multiband_data.transpose(1, 2, 0).reshape(-1, n_bands)

# Create a mask to identify NA values
mask = ~np.isnan(data_reshaped).any(axis=1)

# Apply the mask to remove NA values
data_no_na = data_reshaped[mask]


# Perform K-Means Clustering:
# Number of clusters (you can change this)
n_clusters = 5

# Initialize K-Means
kmeans = KMeans(n_clusters=n_clusters, random_state=0)

# Fit the model to your data
kmeans.fit(data_no_na)

# Predict cluster labels for all pixels, including NaN values
cluster_labels = np.full(mask.shape, -1, dtype=int)
cluster_labels[mask] = kmeans.predict(data_no_na)

# Reshape labels to match raster shape
cluster_labels_reshaped = cluster_labels.reshape(height, width)


# Load the polygon shapefile or GeoJSON for clipping
clip_polygon = gpd.read_file(r'C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe OneDriver\Granelli\Shapefile\Boundaries_32722.shp')  # Replace with the path to your polygon

# Clip the clustered raster by the polygon
clipped_raster, _ = rasterio.mask.mask(src, clip_polygon.geometry, crop=True)
clipped_raster, _ = rasterio.mask.mask(src, clip_polygon.geometry, crop=True)


# Save the clustered raster
with rasterio.open('clustered_raster2.tif', 'w',
                   driver='GTiff', 
                   width=src.width, 
                   height=src.height, 
                   count=1, 
                   dtype=np.uint8, 
                   crs=src.crs,
                   transform=src.transform) as dst:
    dst.write(cluster_labels_reshaped, 1)