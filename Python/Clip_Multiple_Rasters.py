# -*- coding: utf-8 -*-
"""
Created on Tue Aug 29 08:30:55 2023

@author: fellipe.alcantara
"""
import os
import geopandas as gpd
import rasterio as rio
from rasterio.mask import mask

# Extract Raster By Mask
# Open crop extent (your study area extent boundary)
shp = gpd.read_file(r"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\ESTER\Shapefile\Boundary_AOI_32722.shp")
shapefile = shp.set_crs('epsg:32722')

# Specify the directory path and the desired suffix
directory_path = "C:/Users/fellipe.alcantara/OneDrive - GATEC S A GESTAO AGROINDUSTRIAL/Fellipe_OneDriver/ESTER/Pred_Maps"
desired_suffix = ".tif"  # CHANGE THIS VARIABLE

# Get a list of all files in the directory
all_files = os.listdir(directory_path)

# Create a list of full paths to files that match the desired suffix
os.chdir("DIRETORIO/Pred_Maps")
matching_files = [file for file in all_files if file.endswith(desired_suffix)]

# Define output directory to save results
output_directory = 'C:/Users/fellipe.alcantara/OneDrive - GATEC S A GESTAO AGROINDUSTRIAL/Fellipe_OneDriver/ESTER/Landsat/Indices_clip'

# Define the NoData value
no_data_value = 0

for file_path in matching_files:
    with rio.open(file_path) as src:
        out_image, out_transform = mask(src, shapefile.geometry, crop=True)
        
        out_meta = src.meta.copy()
        out_meta.update({"driver": "GTiff",
                         "height": out_image.shape[1],
                         "width": out_image.shape[2],
                         "transform": out_transform,
                         "nodata": no_data_value})
        
        output_path = os.path.join(output_directory, f"clipped_{os.path.basename(file_path)}")
        
        with rio.open(output_path, "w", **out_meta) as dest:
            dest.write(out_image)
        
        print(f"Clipped and saved {output_path}")
