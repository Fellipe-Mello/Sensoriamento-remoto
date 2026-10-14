# -*- coding: utf-8 -*-
"""
Created on Wed Feb 21 15:13:06 2024

@author: fellipe.alcantara
"""

import rasterio
import numpy as np
from rasterio.features import geometry_mask
from rasterio.transform import from_origin
import geopandas as gpd
from shapely.geometry import Point
import matplotlib.pyplot as plt
import pyproj
from sklearn.cluster import DBSCAN
from sklearn.decomposition import PCA

# Step 1: Open the raster
raster_path = r'C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Way\Raster\Teste2\Pred_Ruas_2.tif'

with rasterio.open(raster_path) as src:
    # Read the raster as a numpy array
    raster_array = src.read(1)
    # Get the transformation and crs information
    transform = src.transform
    crs = src.crs

# Step 2: Exclude pixels of class "2" and keep only pixels of class "1"
class_to_keep = 1
masked_array = np.where(raster_array == class_to_keep, 1, 0)

# Step 3: Generate point vectors from the centroid of each remaining pixel
geometry = [Point(transform * (col + 0.5, row + 0.5)) for row, col in zip(*np.where(masked_array))]

# Create a GeoDataFrame
gdf = gpd.GeoDataFrame(geometry=geometry, crs=crs)

# Step 4: Plot the points for visualization
fig, ax = plt.subplots(figsize=(8, 8))
gdf.plot(ax=ax, color='blue', markersize=5)
plt.title('Points from Class 1 in Raster')
plt.show()

# Step 5: Transform the data to EPSG 32722 (UTM)
utm_crs = 'EPSG:32722'
gdf_utm = gdf.to_crs(utm_crs)

# Step 6: Add X and Y columns in meters to the attribute table
gdf_utm['X'] = gdf_utm.geometry.x
gdf_utm['Y'] = gdf_utm.geometry.y

# Output path for the shapefile
output_shapefile_path = r'C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Way\Shapefile\points_shapefile2_xy.shp'

# Step 7: Export the points to a shapefile
gdf_utm.to_file(output_shapefile_path)
#############################################################################################################

""" In This Next part You will Perform PCA Analysis based on the X and Y Coordinates to Create Cluster Groups
    Between the points. The Assigned Cluster will be Added to the Attribute Table of the Shapefile and Exported
"""

# Assuming you have a GeoDataFrame gdf_utm with 'X' and 'Y' columns in meters
X = gdf_utm[['X', 'Y']]

# Perform PCA to reduce dimensionality
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X)

your_desired_eps = 50

# Perform DBSCAN clustering
dbscan = DBSCAN(eps=your_desired_eps, min_samples=5)  # Adjust parameters as needed
gdf_utm['Cluster'] = dbscan.fit_predict(X_pca)

# Update the shapefile with the PCA components and cluster information
gdf_utm.to_file(output_shapefile_path)

# Plot the clustered points
fig, ax = plt.subplots(figsize=(8, 8))
gdf_utm.plot(ax=ax, column='Cluster', cmap='viridis', markersize=30, legend=True)
plt.title('Clustering of Points Based on PCA')
plt.show()

# Output path for the updated shapefile
output_shapefile_path = r'C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Way\Shapefile\PCA_Teste.shp'

# Export the GeoDataFrame to a shapefile
gdf_utm.to_file(output_shapefile_path)
