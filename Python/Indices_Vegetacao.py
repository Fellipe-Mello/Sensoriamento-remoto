# -*- coding: utf-8 -*-
"""
Created on Tue Jun 22 11:14:39 2021

@author: fellipe.alcantara
"""

# Lista de tarefas para cálculo de índices de vegetação em Imagens de Landsat 8 
# Sequencia
# 1. Abrir um shape e extrair o extent;
# 2. Abrir shapefile WRS das cenas Landsat;
# 3. Utilizar o extent para criar uma regra para baixar as imagens;
# 4. Código para baixar as imagens do site da Amazon;
# 5. Abrir os rasters e transformar o sistema de coordenadas para 3857;
# 6. Fazer o mosaico das duas cenas do Landsat e Salvar no Diretório;
# 7. Abrir os Mosaicos e Cortar os rasters para o limite (polígono) da usina;
# 8. Abrir as bandas 1 a 7 do Landsat cortadas;
# 9. Calcular os índices. Bandas do Landsat 8;
# 10. Alterar a resolução para 10 metros;
# 11. Criar tabela de cores para cada Índice;
# 12. Criara um RGB a partir de um Tif;


# Importando os pacotes necessários
import numpy as np
import pandas as pd 
import geopandas as gpd
import pyproj
import folium
from shapely import geometry
import os, shutil
from glob import glob
import matplotlib.pyplot as plt
import seaborn as sns
from shapely.geometry import box, mapping
import rioxarray as rxr
import xarray as xr
import earthpy as et
import earthpy.plot as ep
from osgeo import gdal
from osgeo import ogr
import fiona
import rasterio as rio
import geopandas as gpd
from shapely.geometry import Polygon, LineString, Point, mapping
################################################################################ 1. Abrir um shape e extrair o extent e Salvar como SHP;
pts = gpd.read_file(r'C:\Dados_Espaciais\NDVI_Usinas\Adeco\SHP_03052021.shp')
# Change CRS of each shapefile
pts.to_crs(epsg = 4326, inplace = True)
# Check CRS
pts.crs
# Unary Union -> Returns a geometry containing the union of all geometries in the GeoSeries.
pts1 = pts.unary_union
# Check Geometry Values
bounds = pts1.envelope
# Change WD to save new Extent Shapefile
os.chdir(r'DIRETORIO/Adeco')
# Define a polygon feature geometry with one attribute
schema = {
    'geometry': 'Polygon',
    'properties': {'id': 'int'},
}

# Write a new Shapefile
with fiona.open('Extent_Study_Area.shp', 'w', 'ESRI Shapefile', schema) as c:
    ## If there are multiple geometries, put the "for" loop here
    c.write({
        'geometry': mapping(bounds),
        'properties': {'id': 1},
    })
############################################################################## 2. Abrir shapefile WRS das cenas Landsat;
# Importando o shape de cenas do Landsat baixado do site https://www.usgs.gov/media/files/landsat-wrs-2-descending-path-row-shapefile 
wrs = gpd.GeoDataFrame.from_file(r'C:\Users\fellipe.alcantara\Documents\Treinamento_NDVI\wrs2_descending.shp')
wrs.head()
wrs_intersection = wrs[wrs.intersects(bounds)]# Checando quais cenas intersectam com Bounds
WRS_PATH = './wrs2_descending.zip'
LANDSAT_PATH = os.path.dirname(WRS_PATH)
#put the calculated paths and rows in a variable.
paths, rows = wrs_intersection['PATH'].values, wrs_intersection['ROW'].values
paths = paths[0:3]
paths
rows =rows[0:3]
rows
######################################################  3. Utilizar o extent para criar uma regra para baixar as imagens;
# Leitura de lista CSV das Cenas Landsat da Internet
LS_scenes = pd.read_csv('http://landsat-pds.s3.amazonaws.com/c1/L8/scene_list.gz', compression='gzip')
LS_scenes.head(3)
LS_scenes.columns
# Empty list to add the images
bulk_list = []
# A partir de agora serão baixadas as imagens Landsat do sistema da Amazon
os.chdir(r"DIRETORIO/Imagens_2")#Mudar
# Mudar coluna das datas com função datetime
LS_scenes["parsedAcquisitionDate"] = pd.to_datetime(LS_scenes.acquisitionDate)

import datetime
start_date = datetime.datetime(2021, 5, 1)
end_date = datetime.datetime(2021, 6, 1)

# Iterate through paths and rows
for path, row in zip(paths, rows):

    print('Path:',path, 'Row:', row)

    # Filter the Landsat Amazon S3 table for images matching path, row, cloudcover and processing state.
    scenes = LS_scenes[(LS_scenes.path == path) & (LS_scenes.row == row) & 
                       (LS_scenes.parsedAcquisitionDate >= start_date) &
                       (LS_scenes.parsedAcquisitionDate < end_date) & #menos de 1% de cloud coverage
                       (~LS_scenes.productId.str.contains('_T2')) &
                       (~LS_scenes.productId.str.contains('_RT'))]
    print(' Found {} images\n'.format(len(scenes)))

    # If any scenes exists, select the one that have the minimum cloudCover.
    if len(scenes):
        scene = scenes.sort_values('cloudCover').iloc[0]

    # Add the selected scene to the bulk download list.
    bulk_list.append(scene)

bulk_frame = pd.concat(bulk_list, 1).T
bulk_frame

# Import requests and beautiful soup
import requests
from bs4 import BeautifulSoup

#################################################################  4. Código para baixar as imagens do site da Amazon;
# Esse é o código para baixar.
for i, row in bulk_frame.iterrows():

    # Print some the product ID
    print('\n', 'EntityId:', row.productId, '\n')
    print(' Checking content: ', '\n')

    # Request the html text of the download_url from the amazon server. 
    # download_url example: https://landsat-pds.s3.amazonaws.com/c1/L8/139/045/LC08_L1TP_139045_20170304_20170316_01_T1/index.html
    response = requests.get(row.download_url)

    # If the response status code is fine (200)
    if response.status_code == 200:

        # Import the html to beautiful soup
        html = BeautifulSoup(response.content, 'html.parser')

        # Create the dir where we will put this image files.
        entity_dir = os.path.join(LANDSAT_PATH, row.productId)
        os.makedirs(entity_dir, exist_ok=True)

        # Second loop: for each band of this image that we find using the html <li> tag
        for li in html.find_all('li'):

            # Get the href tag
            file = li.find_next('a').get('href')

            print('  Downloading: {}'.format(file))

            # Download the files
            # code from: https://stackoverflow.com/a/18043472/5361345

            response = requests.get(row.download_url.replace('index.html', file), stream=True)

            with open(os.path.join(entity_dir, file), 'wb') as output:
                shutil.copyfileobj(response.raw, output)
            del response
################################################### 5. Abrir os rasters e transformar o sistema de coordenadas para 3857;
import gdal
import os
#Listar arquivos na pasta
os.listdir(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1")
# Testar se precisa extrair uma Array de cada imagem....
# Abrir imagens da Cena 1
Cena1_Band1 = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_B1.tif")
Cena1_Band2 = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_B2.tif")
Cena1_Band3 = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_B3.tif")
Cena1_Band4 = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_B4.tif")
Cena1_Band5 = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_B5.tif")
Cena1_Band6 = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_B6.tif")
Cena1_Band7 = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_B7.tif")
Cena1_Band8 = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_B8.tif")
Cena1_BandQA = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224076_20210302_20210311_01_T1\LC08_L1TP_224076_20210302_20210311_01_T1_BQA.tif")

os.chdir(r"DIRETORIO/Landsat_3857")
# Trocar o sistema e Salvar no Diretório
S1_3857_B1  = gdal.Warp("S1_3857_B1.tif", Cena1_Band1, dstSRS = "EPSG:3857")
S1_3857_B2  = gdal.Warp("S1_3857_B2.tif", Cena1_Band2, dstSRS = "EPSG:3857")
S1_3857_B3  = gdal.Warp("S1_3857_B3.tif", Cena1_Band3, dstSRS = "EPSG:3857")
S1_3857_B4  = gdal.Warp("S1_3857_B4.tif", Cena1_Band4, dstSRS = "EPSG:3857")
S1_3857_B5  = gdal.Warp("S1_3857_B5.tif", Cena1_Band5, dstSRS = "EPSG:3857")
S1_3857_B6  = gdal.Warp("S1_3857_B6.tif", Cena1_Band6, dstSRS = "EPSG:3857")
S1_3857_B7  = gdal.Warp("S1_3857_B7.tif", Cena1_Band7, dstSRS = "EPSG:3857")
S1_3857_B8  = gdal.Warp("S1_3857_B8.tif", Cena1_Band8, dstSRS = "EPSG:3857")
S1_3857_BQA  = gdal.Warp("S1_3857_BQA.tif", Cena1_BandQA, dstSRS = "EPSG:3857")

# Abrir imagens da Cena 2
Cena2_Band1  = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_B1.tif")
Cena2_Band2  = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_B2.tif")
Cena2_Band3  = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_B3.tif")
Cena2_Band4  = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_B4.tif")
Cena2_Band5  = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_B5.tif")
Cena2_Band6  = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_B6.tif")
Cena2_Band7  = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_B7.tif")
Cena2_Band8  = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_B8.tif")
Cena2_BandQA = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Imagens\LC08_L1TP_224075_20210302_20210311_01_T1\LC08_L1TP_224075_20210302_20210311_01_T1_BQA.tif")

# Trocar o sistema e Salvar no Diretório

S2_3857_B1  = gdal.Warp("S2_3857_B1.tif", Cena2_Band1, dstSRS = "EPSG:3857")
S2_3857_B2  = gdal.Warp("S2_3857_B2.tif", Cena2_Band2, dstSRS = "EPSG:3857") 
S2_3857_B3  = gdal.Warp("S2_3857_B3.tif", Cena2_Band3, dstSRS = "EPSG:3857")
S2_3857_B4  = gdal.Warp("S2_3857_B4.tif", Cena2_Band4, dstSRS = "EPSG:3857")
S2_3857_B5  = gdal.Warp("S2_3857_B5.tif", Cena2_Band5, dstSRS = "EPSG:3857")
S2_3857_B6  = gdal.Warp("S2_3857_B6.tif", Cena2_Band6, dstSRS = "EPSG:3857")
S2_3857_B7  = gdal.Warp("S2_3857_B7.tif", Cena2_Band7, dstSRS = "EPSG:3857")
S2_3857_B8  = gdal.Warp("S2_3857_B8.tif", Cena2_Band8, dstSRS = "EPSG:3857")
S2_3857_BQA  = gdal.Warp("S2_3857_BQA.tif", Cena2_BandQA, dstSRS = "EPSG:3857")

##################################################### 6. Fazer o mosaico das duas cenas do Landsat e Salvar no Diretório;
# Esse processo será feito para várias cenas, Assim o código não será repetido. 
# Para cada operação precisa alterar o código;
from osgeo import gdal
import glob
import subprocess
import rasterio as rio
from rasterio.merge import merge
from rasterio.plot import show
os.chdir(r"DIRETORIO/Mosaico")

# File and folder paths [definir dois caminhos para importar e salvar o Mosaico]
dirpath = r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Landsat_3857"
out_fp =  r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_BQA_Teste.tif"
# Make a search criteria to select the Raster files
search_criteria = "*_BQA.tif"
q = os.path.join(dirpath, search_criteria)
print(q)
# List all  files with glob() function
Lista = glob.glob(q)
Lista.reverse()
# Let’s first create an empty list for the datafiles that will be part of the mosaic.
files_to_mosaic = []
# Now we open all those files in read mode with raterio and add those files 
# into a our source file list.
for fp in Lista:
    src = rio.open(fp)
    files_to_mosaic.append(src)

files_to_mosaic
# Merge function returns a single mosaic array and the transformation info
mosaic, out_trans = merge(files_to_mosaic, method='max')
show(mosaic)
#mosaic2 = mosaic.astype(np.float32)
# Exportar o Moisaico para o Drive
# Copy the metadata
out_meta = src.meta.copy()
# Update the metadata
out_meta.update({"driver": "GTiff",
                 "height": mosaic.shape[1],
                 "width": mosaic.shape[2],
                 "transform": out_trans,
                 }
                )

with rio.open(out_fp, "w", **out_meta) as dest:
    dest.write(mosaic)
############################################## 7. Abrir os Mosaicos e Cortar os rasters para o limite (polígono) da usina;
# https://www.earthdatascience.org/courses/use-data-open-source-python/intro-raster-data-python/raster-data-processing/crop-raster-data-with-shapefile-in-python/
import os
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from shapely.geometry import mapping
import rioxarray as rxr
import xarray as xr
import geopandas as gpd
import earthpy as et
import earthpy.plot as ep

os.chdir(r"DIRETORIO/Indices")
# Open the raster file (Raster que serão cortados por que contém nuvens)
Mosaic_B1 = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B1.tif", masked=True).squeeze()
Mosaic_B2 = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B2.tif", masked=True).squeeze()
Mosaic_B3 = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B3.tif", masked=True).squeeze()
Mosaic_B4 = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B4.tif", masked=True).squeeze()
Mosaic_B5 = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B5.tif", masked=True).squeeze()
Mosaic_B6 = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B6.tif", masked=True).squeeze()
Mosaic_B7 = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B7.tif", masked=True).squeeze()
Mosaic_B8 = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B8.tif", masked=True).squeeze()
Mosaic_BQA = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_BQA_Teste.tif", masked=True).squeeze()

# Open the raster file (Raster que serão cortados por que contém nuvens)
#Mosaic_B1_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B1.tif", masked=True).squeeze()
Mosaic_B2_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B2_Rep.tif", masked=True).squeeze()
Mosaic_B3_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B3_Rep.tif", masked=True).squeeze()
Mosaic_B4_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B4_Rep.tif", masked=True).squeeze()
Mosaic_B5_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B5_Rep.tif", masked=True).squeeze()
#Mosaic_B6_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B6_Rep.tif", masked=True).squeeze()
#Mosaic_B7_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B7_Rep.tif", masked=True).squeeze()
#Mosaic_B8_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_B8_Rep.tif", masked=True).squeeze()
Mosaic_BQA_Rep = rxr.open_rasterio(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Mosaico\Mosaico_BQA_Rep.tif", masked=True).squeeze()

# Open crop extent (your study area extent boundary)
Adeco = gpd.read_file(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Extent_Study_Area.shp")
teste = Adeco.set_crs('epsg:4326')
Adeco_3857  = teste.to_crs(epsg=3857)
# Adeco_3857  = gdal.Warp("Adeco_3857.tif", Adeco, dstSRS = "EPSG:3857")

# Extract by mask
Adeco_B1 = Mosaic_B1.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B2 = Mosaic_B2.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B3 = Mosaic_B3.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B4 = Mosaic_B4.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B5 = Mosaic_B5.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B6 = Mosaic_B6.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B7 = Mosaic_B7.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B8 = Mosaic_B8.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_BQA= Mosaic_BQA.rio.clip(Adeco_3857.geometry.apply(mapping))

# Extract by mask 
Adeco_B2_Rep = Mosaic_B2_Rep.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B3_Rep = Mosaic_B3_Rep.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B4_Rep = Mosaic_B4_Rep.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_B5_Rep = Mosaic_B5_Rep.rio.clip(Adeco_3857.geometry.apply(mapping))
#Adeco_B6_Rep = Mosaic_B6_Rep.rio.clip(Adeco_3857.geometry.apply(mapping))
#Adeco_B7_Rep = Mosaic_B7_Rep.rio.clip(Adeco_3857.geometry.apply(mapping))
#Adeco_B8_Rep = Mosaic_B8_Rep.rio.clip(Adeco_3857.geometry.apply(mapping))
Adeco_BQA_Rep = Mosaic_BQA_Rep.rio.clip(Adeco_3857.geometry.apply(mapping))

# Export the clipped raster
Adeco_B1.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B1.tif")
Adeco_B2.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B2.tif")
Adeco_B3.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B3.tif")
Adeco_B4.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B4.tif")
Adeco_B5.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B5.tif")
Adeco_B6.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B6.tif")
Adeco_B7.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B7.tif")
Adeco_B8.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B8.tif")
Adeco_BQA.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_BQA_Teste.tif")


Adeco_B2_Rep.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_Rep_B2.tif")
Adeco_B3_Rep.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_Rep_B3.tif")
Adeco_B4_Rep.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_Rep_B4.tif")
Adeco_B5_Rep.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_Rep_B5.tif")
#Adeco_B6_Rep.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B6_Rep.tif")
#Adeco_B7_Rep.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B7_Rep.tif")
#Adeco_B8_Rep.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_B8_Rep.tif")
Adeco_BQA_Rep.rio.to_raster(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Rasters_Extent_Adeco\Adeco_BQA_Rep.tif")

############################################################################ 8. Abrir as bandas 1 a 7 do Landsat cortadas;
import rasterio as rio
import numpy as np
import matplotlib.pyplot as plt
import os

# Importando a Cena 1
B1 = rio.open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Landsat_Adeco_30m\Adeco_B1.tif")
B2 = rio.open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Landsat_Adeco_30m\Adeco_B2.tif")
B3 = rio.open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Landsat_Adeco_30m\Adeco_B3.tif")
B4 = rio.open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Landsat_Adeco_30m\Adeco_B4.tif")
B5 = rio.open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Landsat_Adeco_30m\Adeco_B5.tif")
B6 = rio.open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Landsat_Adeco_30m\Adeco_B6.tif")
B7 = rio.open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Landsat_Adeco_30m\Adeco_B7.tif")

# Transformar as bandas do satélite em formato float
Band1 = B1.read(1).astype('float64')
Band2 = B2.read(1).astype('float64')
Band3 = B3.read(1).astype('float64')
Band4 = B4.read(1).astype('float64')
Band5 = B5.read(1).astype('float64')
Band6 = B6.read(1).astype('float64')
Band7 = B7.read(1).astype('float64')

############################################################################# 9. Calcular os índices. Bandas do Landsat 8; 
# B1 (); B2 (Blue); B3 (Green); B4 (Red); B5 (NIR) ; B6 (SWIR1); B7 (SWIR2)
##############################################   NDVI   ##########################################################
# Função para calcular o NDVI
def NDVI(RED, NIR):

    #LS8 = B2,B4,B5    LS57 = B1,B3,B4

    ndvi = (NIR - RED) / (NIR + RED)
    
    ndvi = ndvi.astype(np.float64)

    return ndvi

NDVI_Adeco = NDVI(Band4, Band5)
#plt.imshow(NDVI_Adeco)

ndviImage = rio.open(r'C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao/NDVI_Adeco.tiff','w',driver='Gtiff',
                          width=B1.width, 
                          height = B1.height, 
                          count=1, crs=B1.crs, 
                          transform=B1.transform, 
                          dtype='float64')
ndviImage.write(NDVI_Adeco,1)
ndviImage.close()

##################################################################################################################
##############################################   SAVI   ##########################################################
# Fórmula para calcular o SAVI 
def SAVI(RED, NIR):

    #LS8 = B2,B4,B5    LS57 = B1,B3,B4

    savi = ((NIR - RED)/(NIR + RED + 0.5))*(2.5)
    
    savi = savi.astype(np.float64)

    return savi

SAVI_Adeco = SAVI(Band4, Band5)

SAVI_ = rio.open(r'C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao/SAVI_Adeco.tiff','w',driver='Gtiff',
                          width = B1.width, 
                          height = B1.height, 
                          count=1, crs=B1.crs, 
                          transform=B1.transform, 
                          dtype='float64')
SAVI_.write(SAVI_Adeco,1)
SAVI_.close()
############################################################################################################
##################################################   NBR2       ############################################
# Função para calcular NBR2
def NBR2(SWIR1, SWIR2):

    #LS8 = B2,B4,B5    LS57 = B1,B3,B4

    nbr2 = (SWIR1 - SWIR2) / (SWIR1 + SWIR2)
    
    nbr2 = nbr2.astype(np.float64)

    return nbr2

NBR2_Adeco = NBR2(Band4, Band5)             

NBR2_ = rio.open(r'C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao/NBR2_Adeco.tiff','w',driver='Gtiff',
                          width = B1.width, 
                          height = B1.height, 
                          count=1, crs=B1.crs, 
                          transform=B1.transform, 
                          dtype='float64')
NBR2_.write(NBR2_Adeco,1)
NBR2_.close()
############################################################################################################
################################   GLI (Green Leaf Index)       ############################################
# GLI = 2×Green–Red–Blue / 2×Green+Red+Blue

# Função para calcular GLI
def GLI(Blue, Green, Red):

    #LS8 = B2,B4,B5    LS57 = B1,B3,B4

    gli = 2*(Green - Red - Blue) / 2*(Green + Red + Blue)
    
    gli = gli.astype(np.float64)

    return gli

GLI_Adeco = GLI(Band2, Band3, Band4)     

GLI_ = rio.open(r'C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao/GLI_Adeco.tiff','w',driver='Gtiff',
                          width = B1.width, 
                          height = B1.height, 
                          count=1, crs=B1.crs, 
                          transform=B1.transform, 
                          dtype='float64')
GLI_.write(GLI_Adeco,1)
GLI_.close()
############################################################################################################
################################   Green Chlorophyll Index      ############################################
# Formula para calcular o GCI
def GCI(NIR, Green):
    
    gci = (NIR / Green) - 1
    
    gci = gci.astype(np.float64)
    
    return gci

GCI_Adeco = GCI(Band5, Band3)

GCI_ = rio.open(r'C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao/GCI_Adeco.tiff','w',driver='Gtiff',
                          width = B1.width, 
                          height = B1.height, 
                          count=1, crs=B1.crs, 
                          transform=B1.transform, 
                          dtype='float64')
GCI_.write(GCI_Adeco,1)
GCI_.close()

################################################################################## 10. Alterar a resolução para 10 metros;
from osgeo import gdal
import numpy as np
import matplotlib.pyplot as plt

os.listdir(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao")

# Abrir os Índices
GCI_Adeco = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\GCI_Adeco.tiff")
GLI_Adeco = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\GLI_Adeco.tiff")
NBR2_Adeco = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\NBR2_Adeco.tiff")
NDVI_Adeco = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\NDVI_Adeco.tiff")
SAVI_Adeco = gdal.Open(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\SAVI_Adeco.tiff")

# resample

GCI_Adeco_10m = gdal.Warp("GCI_Adeco_10m.tif", GCI_Adeco, xRes = 10, yRes = 10, resampleAlg= "bilinear")
GLI_Adeco_10m = gdal.Warp("GLI_Adeco_10m.tif", GLI_Adeco, xRes = 10, yRes = 10, resampleAlg= "bilinear")
NBR2_Adeco_10m = gdal.Warp("NBR2_Adeco_10m.tif", NBR2_Adeco, xRes = 10, yRes = 10, resampleAlg= "bilinear")
NDVI_Adeco_10m = gdal.Warp("NDVI_Adeco_10m.tif", NDVI_Adeco, xRes = 10, yRes = 10, resampleAlg= "bilinear")
SAVI_Adeco_10m = gdal.Warp("SAVI_Adeco_10m.tif", SAVI_Adeco, xRes = 10, yRes = 10, resampleAlg= "bilinear")


################################################################################## 11. Criar tabela de cores para cada Índice;
import gdal
import numpy as np
import os

# Paleta de cores
# <0,4 Muito Baixa (vermelho)
# 0,4 - 0,5 Baixa (laranja)
# 0,5 - 0,7 Média (amarelo)
# 0,7 - 0,8 Alta (verde)
# >0,8 Muito Alta (azul)
os.listdir(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\Indices_10m")

# specify GeoTIFF file name, open it using GDAL and get the first band
fn = r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\Indices_10m\SAVI_Adeco_10m.tif"
ds = gdal.Open(fn, 1)
band = ds.GetRasterBand(1)
array = band.ReadAsArray()

max_val = np.max(array[~np.isnan(array)])
min_val = np.min(array[~np.isnan(array)])
array = (array - min_val)/(max_val - min_val)


dst_array = array.copy()

# Definição das classes para cada intervalo de valores do NDVI
dst_array[np.isnan(array)] = 0
dst_array[array < 0.4] = 1
dst_array[(array >= 0.4) & (array < 0.5)] = 2
dst_array[(array >= 0.5) & (array < 0.7)] = 3
dst_array[(array >= 0.7) & (array < 0.8)] = 4
dst_array[array > 0.8] = 5


# get parameters
geotransform = ds.GetGeoTransform()
spatialreference = ds.GetProjection()
ncol = ds.RasterXSize
nrow = ds.RasterYSize
nband = 1
 
# create dataset for output
fmt = 'GTiff'
driver = gdal.GetDriverByName(fmt)
dst_ds = driver.Create(r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\RGB_10m\SAVI_Classes.tif", ncol, nrow, nband, gdal.GDT_Byte)
dst_ds.SetGeoTransform(geotransform)
dst_ds.SetProjection(spatialreference)
dst_ds.GetRasterBand(1).WriteArray(dst_array)
dst_ds.GetRasterBand(1).SetNoDataValue(0)
dst_ds = None


# create color table
colors = gdal.ColorTable()

# set color for each value
colors.SetColorEntry(0, (0, 0, 0))
colors.SetColorEntry(1, (255, 32, 0	))
colors.SetColorEntry(2, (255, 128, 0))
colors.SetColorEntry(3, (255, 255, 0))
colors.SetColorEntry(4, (139, 197, 115))
colors.SetColorEntry(5, (0, 128, 255))

# set color table and color interpretation
fn = r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\RGB_10m\SAVI_Classes.tif"
ds = gdal.Open(fn, 1)
band = ds.GetRasterBand(1)
band.SetRasterColorTable(colors)
band.SetRasterColorInterpretation(gdal.GCI_PaletteIndex)

# close and save file
del band, ds


################################################################################### 12. Criar um RGB a partir de um Tif;
try:
    from osgeo import gdal
    gdal.TermProgress = gdal.TermProgress_nocb
except ImportError:
    import gdal

try:
    import numpy as Numeric
    Numeric.arrayrange = Numeric.arange
except ImportError:
    import Numeric


import sys
import os.path

def Usage():
    print('Usage: pct2rgb.py [-of format] [-b <band>] source_file dest_file')
    sys.exit(1)

# =============================================================================
# 	Mainline
# =============================================================================

format = 'GTiff'
src_filename = r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\RGB_10m\NDVI_Classes.tif"
dst_filename = r"C:\Dados_Espaciais\NDVI_Usinas\Adeco\Indices\Indices_Vegetacao\RGB_10m\NDVI_RGB.tif"
out_bands = 3
band_number = 1

gdal.AllRegister()
argv = gdal.GeneralCmdLineProcessor( sys.argv )
if argv is None:
    sys.exit( 0 )

# Parse command line arguments.
i = 1
while i < len(argv):
    arg = argv[i]

    if arg == '-of':
        i = i + 1
        format = argv[i]

    elif arg == '-b':
        i = i + 1
        band_number = int(argv[i])

    elif arg == '-rgba':
        out_bands = 4

    elif src_filename is None:
        src_filename = argv[i]

    elif dst_filename is None:
        dst_filename = argv[i]

    else:
        Usage()

    i = i + 1

if dst_filename is None:
    Usage()
    
# ----------------------------------------------------------------------------
# Open source file

src_ds = gdal.Open( src_filename )
if src_ds is None:
    print('Unable to open ', src_filename)
    sys.exit(1)

src_band = src_ds.GetRasterBand(band_number)

# ----------------------------------------------------------------------------
# Ensure we recognise the driver.

dst_driver = gdal.GetDriverByName(format)
if dst_driver is None:
    print('"%s" driver not registered.' % format)
    sys.exit(1)

# ----------------------------------------------------------------------------
# Build color table.

lookup = [ Numeric.arrayrange(256), 
           Numeric.arrayrange(256), 
           Numeric.arrayrange(256), 
           Numeric.ones(256)*255 ]

ct = src_band.GetRasterColorTable()

if ct is not None:
    for i in range(min(256,ct.GetCount())):
        entry = ct.GetColorEntry(i)
        for c in range(4):
            lookup[c][i] = entry[c]

# ----------------------------------------------------------------------------
# Create the working file.

if format == 'GTiff':
    tif_filename = dst_filename
else:
    tif_filename = 'temp.tif'

gtiff_driver = gdal.GetDriverByName( 'GTiff' )

tif_ds = gtiff_driver.Create( tif_filename,
                              src_ds.RasterXSize, src_ds.RasterYSize, out_bands )


# ----------------------------------------------------------------------------
# We should copy projection information and so forth at this point.

tif_ds.SetProjection( src_ds.GetProjection() )
tif_ds.SetGeoTransform( src_ds.GetGeoTransform() )
if src_ds.GetGCPCount() > 0:
    tif_ds.SetGCPs( src_ds.GetGCPs(), src_ds.GetGCPProjection() )

# ----------------------------------------------------------------------------
# Do the processing one scanline at a time. 

gdal.TermProgress( 0.0 )
for iY in range(src_ds.RasterYSize):
    src_data = src_band.ReadAsArray(0,iY,src_ds.RasterXSize,1)

    for iBand in range(out_bands):
        band_lookup = lookup[iBand]

        dst_data = Numeric.take(band_lookup,src_data)
        tif_ds.GetRasterBand(iBand+1).WriteArray(dst_data,0,iY)

    gdal.TermProgress( (iY+1.0) / src_ds.RasterYSize )
    

tif_ds = None

# ----------------------------------------------------------------------------
# Translate intermediate file to output format if desired format is not TIFF.

if tif_filename != dst_filename:
    tif_ds = gdal.Open( tif_filename )
    dst_driver.CreateCopy( dst_filename, tif_ds )
    tif_ds = None

    gtiff_driver.Delete( tif_filename )
############################################################################################################
