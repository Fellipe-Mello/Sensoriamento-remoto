# -*- coding: utf-8 -*-
"""
Created on Wed Aug 30 11:18:47 2023

@author: fellipe.alcantara
"""

import os
import rasterio
import pandas as pd
import geopandas as gpd

# Directory containing raster files
raster_directory = r"C:\Fellipe\Capuava\Raster\Vegetacao\Indices"

# Output directory for shapefiles
output_directory = r"C:\Fellipe\Capuava\Raster\Vegetacao\Interpolated\SHP"

# List all raster files in the directory
raster_files = [file for file in os.listdir(raster_directory) if file.endswith(".tif")]

for raster_file in raster_files:
    raster_path = os.path.join(raster_directory, raster_file)

    # Open the raster file
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
    output_shapefile = os.path.join(output_directory, f"{raster_file[:-4]}_output.shp")

    # Export the GeoDataFrame to a shapefile
    gdf.to_file(output_shapefile, driver="ESRI Shapefile")

    print(f"Shapefile exported for {raster_file}")

print("Shapefile export completed.")
