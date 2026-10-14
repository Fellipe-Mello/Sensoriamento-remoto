# -*- coding: utf-8 -*-
"""
Created on Wed Aug 30 10:47:38 2023

@author: fellipe.alcantara
"""

import rasterio
import pandas as pd
import geopandas as gpd

# Open the raster file
raster_path = r"C:\Fellipe\Capuava\Raster\Vegetacao\Indices\clipped_EVI_02.tif"
src = rasterio.open(raster_path)

# Get the raster data and coordinates
raster_data = src.read(1)  # Assuming it's a single-band raster
x_coords, y_coords, raster_values = [], [], []

for col in range(src.width):
    for row in range(src.height):
        x, y = src.xy(row, col)
        value = raster_data[row, col]

        # Filter out zero or NA values
        if pd.notna(value) and value != 0:
            x_coords.append(x)
            y_coords.append(y)
            raster_values.append(value)

# Create a DataFrame
data = {
    "x": x_coords,
    "y": y_coords,
    "raster_value": raster_values
}
df = pd.DataFrame(data)

# Close the raster file
src.close()

# Create a GeoDataFrame from the DataFrame
gdf = gpd.GeoDataFrame(df, geometry=gpd.points_from_xy(df["x"], df["y"]))

# Set the coordinate reference system (CRS) to EPSG 4326
gdf.crs = "EPSG:4326"

# Define the output shapefile path
output_shapefile = r"C:\Fellipe\Capuava\Raster\Vegetacao\Interpolated\SHP\EVI_02.shp"

# Export the GeoDataFrame to a shapefile
gdf.to_file(output_shapefile, driver="ESRI Shapefile")

print("Shapefile exported successfully.")
