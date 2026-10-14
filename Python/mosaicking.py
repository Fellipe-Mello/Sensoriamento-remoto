import os
from glob import glob
import rasterio as rio
from rasterio.merge import merge


def merge_raster(files, output_path):

    rasters = [rio.open(file) for file in files]

    mosaic, out_transform = merge(rasters)

    out_meta = rasters[0].meta.copy()
    out_meta.update({
        'height': mosaic.shape[1],
        'width': mosaic.shape[2],
        'transform': out_transform
    })

    with rio.open(output_path, 'w', **out_meta) as f:
        f.write(mosaic)


root_path = 'E:/GATEC/piloto_adeco/mpc/'

list_of_folders = glob('E:/GATEC/piloto_adeco/mpc/*')


for folder in list_of_folders:

    if os.path.isfile(folder):
        continue

    scene_date = os.path.split(folder)[1].split('_')[0]
    
    files = [os.path.join(folder, file) for file in os.listdir(folder)]

    if folder.endswith('S2'):
        outpath = os.path.join(folder, f'{scene_date}_S2.tif')

        if os.path.exists(outpath):
            print(f'File: {outpath} already exists')
            continue

        merge_raster(files, outpath)

    if folder.endswith('LC08'):
               
        outpath = os.path.join(folder, f'{scene_date}_L8.tif')

        if os.path.exists(outpath):
            print(f'File: {outpath} already exists')
            continue

        merge_raster(files, outpath)

    if folder.endswith('LC09'):   
        outpath = os.path.join(folder, f'{scene_date}_L9.tif')

        if os.path.exists(outpath):
            print(f'File: {outpath} already exists')
            continue
        
        merge_raster(files, outpath)
