# -*- coding: utf-8 -*-
"""
Created on Thu Aug 31 10:47:49 2023

@author: fellipe.alcantara
"""

import geopandas as gpd

# Path to the shapefile
shapefile_path = r"C:\Fellipe\Capuava\Raster\Vegetacao\Interpolated\SHP\clipped_EVI_02_output.shp"

# Read the shapefile into a GeoDataFrame
gdf = gpd.read_file(shapefile_path)

# Convert the GeoDataFrame to a DataFrame
df = gdf.copy(deep=True)