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

import numpy as np

import time

t1 = time.time()

def _format(item):
    return f'{item.datetime.year:04}-{item.datetime.month:02}-{item.datetime.day:02}'

root_path = 'C:/Fellipe/BENRI/Interpolation/'

roi = gpd.read_file('C:/Fellipe/BENRI/Shapefiles/arapora_roi_4326.geojson', driver='GeoJSON')
roi = roi.geometry[0]

# Search all unique dates within a interval
catalog = pystac_client.Client.open(
    "https://planetarycomputer.microsoft.com/api/stac/v1",
    modifier=planetary_computer.sign_inplace)

time_of_interest = "2016-01-01/2023-01-07"

search = catalog.search(
    max_items=999,
    collections=["sentinel-2-l2a"],
    intersects=roi,
    datetime=time_of_interest)

item_collection = search.item_collection()

dates_list = np.unique(list(map(_format, item_collection)))

t2 = time.time()

print(f'Dates list returned {len(item_collection)} items in {round(t2-t1, 2)} seconds')

for date in dates_list:

    t1 = time.time()

    search = catalog.search(
        max_items=999,
        collections=["sentinel-2-l2a"],
        intersects=roi,
        datetime=date)
    
    items = search.item_collection()

    # if len(items) < 9:
    #     continue
    
    most_cloudy_item = max(items, key=lambda item: eo.ext(item).cloud_cover)

    if eo.ext(most_cloudy_item).cloud_cover > 30:
        continue

    t2 = time.time()

    print(f'Collecting data from {date} - Recognition took {round(t2-t1, 2)} seconds')

    for item in items: # Loop to download the data

        date_str = item.id.split('_')[2].split('T')[0]

        orbit = item.id.split('_')[4]

        # Check folder
        if not os.path.exists(root_path+date_str+'_S2'):
            os.makedirs(root_path+date_str+'_S2')
    
        # Check files
        if os.path.exists(f'{root_path}{date_str}_S2/S2_{date_str}_{orbit}.tif'):
            print(f'File: {date_str}_{orbit}.tif already exists')
            continue
        
        if orbit.endswith(('KGE', 'KFE')):

            bands = {}
            band_list = ['B04','B08'] # 'B02','B03','B04','B05','B06','B08','B11'

            for band_name in band_list:

                t1 = time.time()

                asset = item.assets[band_name].href

                with rasterio.open(asset) as ds:

                    aoi_bounds = features.bounds(roi)
                    warped_aoi_bounds = warp.transform_bounds('epsg:4326', ds.crs, *aoi_bounds)
                    aoi_window = windows.from_bounds(transform=ds.transform, *warped_aoi_bounds)
                    win_transform = ds.window_transform(aoi_window) # The transform of the AOI window

                    band_data = ds.read(window=aoi_window, boundless=True, masked=True)

                bands[band_name] = band_data

                t2 = time.time()
                print(f'Band {band_name} collected in {round(t2-t1, 2)} seconds')

            t1 = time.time()

            profile = ds.meta.copy()
            profile.update({
                    'height': aoi_window.height,
                    'width': aoi_window.width,
                    'transform': win_transform,
                    'count': len(band_list),
                    'nodata': 0})
                    # There is no need to set a crs here!

            with rasterio.open(f'{root_path}{date_str}_S2/S2_{date_str}_{orbit}.tif', 'w', **profile) as dest:
                for id, band_name in enumerate(bands.keys(), start=1):
                    dest.write(bands[band_name][0], id)
            
            t2 = time.time()

            print(f'Writing {date_str} - {orbit} took {round(t2-t1, 2)} seconds')
            
            print(f'{date_str} - {orbit} done!')
