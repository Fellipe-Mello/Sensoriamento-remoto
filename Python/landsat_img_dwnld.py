import pystac_client
import planetary_computer
from pystac.extensions.eo import EOExtension as eo
import os
os.environ['USE_PYGEOS'] = '0'

import geopandas as gpd

import rasterio
from rasterio import windows
from rasterio import features
from rasterio import warp

from rasterio.warp import reproject, Resampling, calculate_default_transform

import numpy as np

import time

t1 = time.time()

def _format(item):
    return f'{item.datetime.year:04}-{item.datetime.month:02}-{item.datetime.day:02}'

root_path = 'C:/Fellipe/BENRI/Interpolation/'

roi = gpd.read_file('C:/Fellipe/BENRI/Shapefiles/arapora_roi_4326.geojson', driver='GeoJSON')
roi = roi.geometry[0]

roi_32622 = gpd.read_file('C:/Fellipe/BENRI/Shapefiles/Extent_32622.geojson', driver='GeoJSON')
roi_32622 = roi_32622.geometry[0]

# Search all unique dates within a interval
catalog = pystac_client.Client.open(
    "https://planetarycomputer.microsoft.com/api/stac/v1",
    modifier=planetary_computer.sign_inplace)

time_of_interest = "2016-01-01/2017-12-01"

search = catalog.search(
    max_items=999,
    collections=["landsat-c2-l2"],
    intersects=roi,
    datetime=time_of_interest,
    query={"platform": {"in": ["landsat-8"]}})

item_collection = search.item_collection()

dates_list = np.unique(list(map(_format, item_collection)))

t2 = time.time()

print(f'Dates list returned {len(item_collection)} items in {round(t2-t1, 2)} seconds')

for date in dates_list:

    search = catalog.search(
        max_items=999,
        collections=["landsat-c2-l2"],
        intersects=roi,
        datetime=date,
        query={"platform": {"in": ["landsat-8"]}})
    
    items = search.item_collection()

    # if len(items) < 2:
    #     continue
    
    most_cloudy_item = max(items, key=lambda item: eo.ext(item).cloud_cover)

    if eo.ext(most_cloudy_item).cloud_cover > 30:
        continue

    print(f'Collecting data from {date}')

    for item in items: # Loop to download the data

        t1 = time.time()

        date_str = item.id.split('_')[3].split('T')[0]

        orbit = item.id.split('_')[2]

        platform = items[0].id.split('_')[0]

        # Check folder
        if not os.path.exists(root_path+date_str+'_'+platform):
            os.makedirs(root_path+date_str+'_'+platform)
    
        # Check files
        if os.path.exists(f'{root_path}{date_str}_{platform}/{platform}_{date_str}_{orbit}.tif'):
            print(f'File: {platform}_{date_str}_{orbit}.tif already exists')
            continue
        
        t2 = time.time()

        print(f'Checking data from {date} - Recognition took {round(t2-t1, 2)} seconds')
        
        bands = {}
        band_list = ['blue','red','nir08','swir16','swir22'] # 'B02','B03','B04','B05','B06','B08','B11'

        for band_name in band_list:

            t1 = time.time()

            asset = item.assets[band_name].href

            with rasterio.open(asset) as ds:

                proj_crs = {"init": "EPSG:32722"}
                
                aoi_bounds = features.bounds(roi_32622)
                #warped_aoi_bounds = warp.transform_bounds(dict_4326, dict_32622, *aoi_bounds)
                aoi_window = windows.from_bounds(transform=ds.transform, *aoi_bounds)
                win_transform = ds.window_transform(aoi_window) # The transform of the AOI window

                band_data = ds.read(window=aoi_window, boundless=True, masked=True)

                #proj_transform, proj_width, proj_height = calculate_default_transform(
                    #ds.crs, proj_crs, round(aoi_window.width), round(aoi_window.height), *aoi_bounds)
                
                #band_data_re = np.zeros((1, proj_height, proj_width))
                
                #reproject(source=band_data, destination=band_data_re, src_transform=win_transform, src_crs=ds.crs,
                                                       #dst_transform=proj_transform, dst_crs=proj_crs, resampling=Resampling.cubic)

            bands[band_name] = band_data

            t2 = time.time()
            print(f'Band {band_name} collected in {round(t2-t1, 2)} seconds')

        profile = ds.meta.copy()
        profile.update({
                'height': ds.height,
                'width': ds.width,
                'transform': win_transform,
                'count': len(band_list),
                'nodata': 0})
                # There is no need to set a crs here!

        with rasterio.open(f'{root_path}{date_str}_{platform}/{platform}_{date_str}_{orbit}.tif', 'w', **profile) as dest:
            for id, band_name in enumerate(bands.keys(), start=1):
                dest.write(bands[band_name][0], id)
        
        print(f'{date_str} - {orbit} done!')