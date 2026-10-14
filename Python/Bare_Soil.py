# -*- coding: utf-8 -*-
"""
Created on Mon Jul 31 14:29:42 2023

@author: fellipe.alcantara
"""

'''
Bare soil mask application on Landsat 8 satellite images

To achieve the bare soil pixels, we will mask out of the images everythin that it is not soil.
We know the spectral behaviour of soil, so we will mask the areas with water, cloud, vegetation,
straw, rocks, urbanization, etc.

Data to mask the Landsat images

QA band -> To mask cloud, shadow, etc.
NDVI    -> To exclude all the vegetation
NBR2    -> To detect and exclude Straw 
B2 - B1 -> To Validate the soil spectra
B3 - B2 -> To Validate the soil spectra

The remaining raster will contain only pixels of bare (exposed) soil.

The script will address the following steps

Step 1: Import Data
- Open The Landsat 8 Bands (Red, Green, Blue, NIR, SWIR1, SWIR2)
- Read as Array

Step 2: Import Quality Assessment band
- Input the QA values for cloud, shadow and other into a list []
- Mask the Landsat bands with these values

Step 3: Normalized Difference Vegetation Index
- Use the masked images to calculate the NDVI
- Define the condition required for NDVI (0 < NDVI < 0.25)
- Exclude the pixels inside the condition
- Mask the Landsat bands with the resulting NDVI

Step 4: Mask through Band ratio
- 0 < B2 - B1 - Exclude the pixels that don't meet this condition
- 0 < B3 - B2 - Exclude the pixels that don't meet this condition

Step 5: Normalized Burn Ratio 2
- Calculate the NBR2 (NBR2= (SWIR1 - SWIR2) / (SWIR1 + SWIR2))
- Exclude the pixels where the NBR2 are:
0 < NBR2 < 0.025 or############
0 < NBR2 < 0.075 or
0 < NBR2 < 0.150 or
0 < NBR2 < 0.300 or
0 < NBR2 < 0.225 or
0 < NBR2 < 0.350

Step 6: Validate the pixels with Laboratory spectral data avaliable online
- Get Soil Spectral data available in web repositories 
- Resample the spectral data to satellite
- Correlation analysis between both data
'''

'''
Functions created to perform the tasks

Function 1: Stack Rasters
'''
###############################################################################
# Import Packages
import os
from glob import glob
import rioxarray as rxr
import xarray as xr
import earthpy.plot as ep
import matplotlib.pyplot as plt
import earthpy.mask as em
from numpy import ma
from shapely.geometry import box
import geopandas as gpd
import rasterio as rio
import numpy as np
###############################################################################
###############################################################################
def check_crs(fpath):
    """
    Returns the CRS of a raster file.

    Parameters
    ----------
    raster_path : string
        A path to a raster file that you wish to check the crs of. Assuming
        this is a tif file.

    Returns
    -------
    A crs object

    """

    with rio.open(fpath) as src:
        return src.crs


def open_clean_band(band_path, crop_layer=None, valid_range=None):
    """A function that opens a Landsat band as an (rio)xarray object

    Parameters
    ----------
    band_path : list
        A list of paths to the tif files that you wish to combine.

    clip_extent : geopandas geodataframe
        A geodataframe containing the clip extent of interest. NOTE: this will 
        fail if the clip extent is in a different CRS than the raster data.

    valid_range : tuple (optional)
        The min and max valid range for the data. All pixels with values outside
        of this range will be masked.

    Returns
    -------
    An single xarray object with the Landsat band data.

    """

    if crop_layer is not None:
        try:
            clip_bound = crop_layer.geometry
            cleaned_band = rxr.open_rasterio(band_path,
                                             masked=True).rio.clip(clip_bound,
                                                                   from_disk=True).squeeze()
        except Exception as err:
            print("Oops, I need a geodataframe object for this to work.")
            print(err)

    else:
        cleaned_band = rxr.open_rasterio(band_path,
                                     masked=True).squeeze()

    # Only mask the data if a valid range tuple is provided
    if valid_range:
        mask = ((landsat_post_xr_clip < valid_range[0]) | (
            landsat_post_xr_clip > valid_range[1]))
        cleaned_band = landsat_post_xr_clip.where(
            ~xr.where(mask, True, False))

    return cleaned_band


def process_bands(paths, crop_layer=None, stack=False):
    """
    Open, clean and crop a list of raster files using rioxarray.

    Parameters
    ----------
    paths : list
        A list of paths to raster files that could be stacked (of the same 
        resolution, crs and spatial extent).

    crop_layer : geodataframe
        A geodataframe containing the crop geometry that you wish to crop your
        data to.

    stack : boolean
        If True, return a stacked xarray object. If false will return a list
        of xarray objects.

    Returns
    -------
        Either a list of xarray objects or a stacked xarray object
    """

    all_bands = []
    for i, aband in enumerate(paths):
        cleaned = open_clean_band(aband, crop_layer)
        cleaned["band"] = i+1
        all_bands.append(cleaned)

    if stack:
        print("I'm stacking your data now.")
        return xr.concat(all_bands, dim="band")
    else:
        print("Returning a list of xarray objects.")
        return all_bands
###############################################################################
'''
# STEP 1 
# Open Landsat data
landsat_path  = os.path.join(r"C:\Dados_Espaciais\Goiasa\Goiasa1\Goiasa_B[1-6]*.tif")

# List files - Sort by name
landsat_paths  = sorted(glob(landsat_path))

# Stack the rasters with the pre defined functions
landsat_stack = process_bands(landsat_paths, stack=True)
landsat_stack

#Plot Stack 
#ep.plot_bands(landsat_stack[3])
#plt.show()
###############################################################################

# Open Landsat QA band
landsat_qa_path = os.path.join(r"C:\Dados_Espaciais\Capão_Cruz_2022\2144\Landsat_2\LE07_L2SP_220075_20020817_20200916_02_T1_QA_PIXEL.tif")
landsat_qa = rxr.open_rasterio(landsat_qa_path).squeeze()
landsat_qa
#ep.plot_bands(landsat_qa)
#plt.show()
###############################################################################
# Create a list with the QA values that represent cloud, cloud_shadow, etc.
all_masked_values = [5896, 7440, 7442]
# Mask the data using the pixel QA layer
landsat_masked = landsat_stack.where(~landsat_qa.isin(all_masked_values))
landsat_masked
# Plot the masked data
landsat_masked_plot = ma.masked_array(landsat_masked.values,landsat_masked.isnull())
# Plot
#ep.plot_rgb(landsat_masked_plot, rgb=[2, 1, 0], title = "Masked Data")
#plt.show()'''
###############################################################################
# Create bounds object to clip the cloud free data
'''landsat_stack_bounds = landsat_stack.rio.bounds()

df = {'id': [1],
      'geometry': box(*landsat_stack.rio.bounds())}
clip_gdf = gpd.GeoDataFrame(df, crs=landsat_stack.rio.crs)
clip_gdf.plot()
plt.show()'''
###############################################################################
'''
# Export the masked Landsat Scenes to Directory "Masked_Bands_QA"
out_img = landsat_masked
out_img.shape
out_transform = landsat_masked.rio.transform()

# Get a Band of the same Scene for reference
rastDat = rio.open(r"C:\Dados_Espaciais\Capão_Cruz_2022\2144\Landsat_2\SCALE\B3.tif")


#copying metadata from original raster
out_meta = rastDat.meta.copy()

#amending original metadata
out_meta.update({'nodata': 0,
                 'height' : out_img.shape[1],
                 'width' : out_img.shape[2],
                 'transform' : out_transform}) 

# writing and then re-reading the output data to see if it looks good
for i in range(out_img.shape[0]):
    with rio.open(rf"C:\Dados_Espaciais\Capão_Cruz_2022\2144\Landsat_2\SCALE\1_Landsat_QA_Clip\Band_{i+1}_masked.tif",'w',**out_meta) as dst:
        dst.write(out_img[i,:,:],1)'''
###############################################################################
# STEP 2
os.chdir(r"DIRETORIO/L5_2006_04")
os.listdir()
# Import Landsat Bands 4, 5, 6, 7 to calculate NDVI and NBR2
B3_Red   = rio.open(r"..\L5_Ferrari_2006_04\L5_Ferrari_2006_04_B3.tif")
B4_NIR   = rio.open(r"..\L5_Ferrari_2006_04\L5_Ferrari_2006_04_B4.tif")
B5_SWIR1 = rio.open(r"..\L5_Ferrari_2006_04\L5_Ferrari_2006_04_B5.tif")
B6_SWIR2 = rio.open(r"..\L5_Ferrari_2006_04\L5_Ferrari_2006_04_B6.tif")

# Transform the bands to float64 format to be able to calculate
B3_Red_   = B3_Red.read(1).astype('float64')
B4_NIR_   = B4_NIR.read(1).astype('float64')
B5_SWIR1_ = B5_SWIR1.read(1).astype('float64')
B6_SWIR2_ = B6_SWIR2.read(1).astype('float64')
############################################################################################
# Calculate NDVI 
NDVI = np.where(
    (B4_NIR_+B3_Red_)==0.,
    0,
    (B4_NIR_-B3_Red_)/(B4_NIR_+B3_Red_)
    )
# Plot
plt.imshow(NDVI)

# Export NDVI
os.chdir(r"DIRETORIO/4_NDVI_NBR2")
ndviImage = rio.open('../4_NDVI_NBR2/NDVI.tif','w',driver='Gtiff',
                          width=B3_Red.width, 
                          height = B3_Red.height, 
                          count=1, crs=B3_Red.crs, 
                          transform=B3_Red.transform, 
                          dtype='float64')
ndviImage.write(NDVI,1)
ndviImage.close()
############################################################################################
# Calculate NBR2 
NBR2 = np.where(
    (B5_SWIR1_+B6_SWIR2_)==0.,
    0,
    (B5_SWIR1_ - B6_SWIR2_)/(B5_SWIR1_ + B6_SWIR2_)
    )
# Plot
plt.imshow(NBR2)
# Export NBR2
os.chdir(r"DIRETORIO/4_NDVI_NBR2")
NBR2Image = rio.open('../4_NDVI_NBR2/NBR2.tif','w',driver='Gtiff',
                          width=B3_Red.width, 
                          height = B3_Red.height, 
                          count=1, crs=B3_Red.crs, 
                          transform=B3_Red.transform, 
                          dtype='float64')
NBR2Image.write(NBR2,1)
NBR2Image.close()
############################################################################################
# STEP 1 
# Open Landsat data
landsat_masked_path  = os.path.join(r"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Ferrari\Raster\L5_Ferrari_2006_04\L5_Ferrari_2006_04_B[1-6]*.tif")
    
# List files - Sort by name
landsat_masked_path  = sorted(glob(landsat_masked_path))

# Stack the rasters with the pre defined functions
landsat_masked = process_bands(landsat_masked_path, stack=True)
landsat_masked

#Plot Stack 
#ep.plot_bands(landsat_masked[3])
#plt.show()
############################################################################################
'''# Create a list of values to exclude from the NDVI Image
import decimal
from numpy import arange

def float_range(start, stop, step):
  while start < stop:
    yield float(start)
    start += decimal.Decimal(step)

#Create List of values to exclude
Msked_NDVI = list(float_range(0, 0.25, '0.0001'))'''

# Import the NDVI and Exclude the pixels with values between 0 < NDVI < 0.25
# Open NDVI
landsat_ndvi_path = os.path.join(r"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Ferrari\Raster\L5_Ferrari_2006_04\4_NDVI_NBR2\NDVI.tif")
landsat_ndvi = rxr.open_rasterio(landsat_ndvi_path).squeeze()
landsat_ndvi_trunc = np.trunc(1000 * landsat_ndvi) / 1000

# Mask the NDVI using the "Masked_NDVI" list
NDVI_Filtered =   landsat_masked.where(landsat_ndvi_trunc < 0.20)
NDVI_Filtered_2 = NDVI_Filtered.where(landsat_ndvi_trunc > 0)
NDVI_Filtered_2
# Plot the masked data
#NDVI_Filtered_plot = ma.masked_array(NDVI_Filtered.values,NDVI_Filtered.isnull())
############################################################################################
# Export the masked Landsat Scenes to Directory "Band_NDVI_Masked"
out_img = NDVI_Filtered_2
out_img.shape
out_transform = NDVI_Filtered_2.rio.transform()

# Get a Band of the same Scene for reference
rastDat = rio.open(r"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Ferrari\Raster\L5_Ferrari_2006_04\L5_Ferrari_2006_04_B3.tif")

#copying metadata from original raster
out_meta = rastDat.meta.copy()

#amending original metadata
out_meta.update({'nodata': 0,
                 'height' : out_img.shape[1],
                 'width' : out_img.shape[2],
                 'transform' : out_transform}) 

# writing and then re-reading the output data to see if it looks good
for i in range(out_img.shape[0]):
    with rio.open(rf"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Ferrari\Raster\L5_Ferrari_2006_04\2_Landsat_NDVI_Clip\Band_{i+1}_NDVI_masked.tif",'w',**out_meta) as dst:
        dst.write(out_img[i,:,:],1)

#########################################################################################
# STEP 2
# Open Landsat data
landsat_masked_NDVI_path  = os.path.join(r"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Ferrari\Raster\L5_Ferrari_2006_04\2_Landsat_NDVI_Clip\Band_[1-6]*_NDVI_masked.tif")

# List files - Sort by name
landsat_NDVI_masked_path = sorted(glob(landsat_masked_NDVI_path))

# Stack the rasters with the pre defined functions
landsat_NDVI_masked = process_bands(landsat_NDVI_masked_path, stack=True)
landsat_NDVI_masked

# Mask the NBR2 values
'''0 < NBR2 < 0.025'''

#Create List of values to exclude
#Msked_NBR2 = list(float_range(0, 0.025, '0.000001'))

# Import the NBR2 and Exclude the pixels with values between 0 < NBR2 < 0.25
# Open NBR2
landsat_nbr2_path = os.path.join(r"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Ferrari\Raster\L5_Ferrari_2006_04\4_NDVI_NBR2\NBR2.tif")
landsat_nbr2 = rxr.open_rasterio(landsat_nbr2_path).squeeze()
landsat_nbr2_trunc = np.trunc(1000 * landsat_nbr2) / 1000

# Mask the NDVI using the "Masked_NDVI" list
#NBR2_Filtered = landsat_NDVI_masked.where(landsat_nbr2_trunc.isin(Msked_NBR2))
NBR2_Filtered = landsat_NDVI_masked.where(landsat_nbr2_trunc < 0.055)
NBR2_Filtered
############################################################################################
# Export the masked Landsat Scenes to Directory "Band_NBR2_Masked"
out_img = NBR2_Filtered
out_img.shape
out_transform = NBR2_Filtered.rio.transform()

# Get a Band of the same Scene for reference
rastDat = rio.open(r"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Ferrari\Raster\L5_Ferrari_2006_04\L5_Ferrari_2006_04_B3.tif")

#copying metadata from original raster
out_meta = rastDat.meta.copy()

#amending original metadata
out_meta.update({'nodata': 0,
                 'height' : out_img.shape[1],
                 'width' : out_img.shape[2],
                 'transform' : out_transform}) 

# writing and then re-reading the output data to see if it looks good
for i in range(out_img.shape[0]):
    with rio.open(rf"C:\Users\fellipe.alcantara\OneDrive - GATEC S A GESTAO AGROINDUSTRIAL\Fellipe_OneDriver\Ferrari\Raster\L5_Ferrari_2006_04\3_Landsat_NBR2_Clip\Band_{i+1}_NBR2_masked.tif",'w',**out_meta) as dst:
        dst.write(out_img[i,:,:],1)