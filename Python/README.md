# Scripts Python para Sensoriamento Remoto e Processamento de Rasters

Esta pasta reúne scripts em Python para processar imagens de satélite (Landsat 5, Landsat 8 e Sentinel-2) em estudos de solo e vegetação, principalmente em áreas agrícolas. Os scripts fazem desde o download das imagens até a geração de produtos finais, como índices de vegetação, máscaras de solo exposto, agrupamentos (clusters) e conversão de rasters em pontos.

---

## Métodos implementados

| Método | Descrição | Scripts |
|---|---|---|
| **Imagem sintética de solo exposto (ISSE)** | Isola os pixels de solo exposto em imagens Landsat. São mascarados vegetação (NDVI), palha (NBR2) e nuvens/sombras (banda QA). | `ISSE.py`, `Bare_Soil.py` |
| **Índices de vegetação** | Cálculo de NDVI, SAVI, EVI, NBR2, GLI e GCI a partir da reflectância de superfície | `Indices_Veg.py`, `Indices_Veg_Capuava.py`, `Ind_Veg_Opt.py`, `Indices_Vegetacao.py` |
| **Fator de escala Landsat Coleção 2** | Conversão de número digital para reflectância: `banda × 0.0000275 − 0.2` | `Indices_Veg*.py`, `Ind_Veg_Opt.py` |
| **Máscara por limiar (threshold)** | Mantém apenas os pixels com NDVI ≥ 0,25 | `Mask_Raster_threshold.py`, `Mask_Raster_threshold_Opt.py` |
| **Agrupamento K-Means** | Classificação não supervisionada de um raster multibanda | `Kmeans_Cluster.py` |
| **PCA + DBSCAN** | Agrupamento espacial de pontos a partir das coordenadas X/Y | `Pixel_to_Point.py` |
| **Filtro Gaussiano** | Suavização das bandas de uma imagem (Sentinel-2) | `Raster_Gaussian_Filter.py` |
| **Download via STAC** | Busca e download de cenas com até 30% de nuvens no Microsoft Planetary Computer | `landsat_img_dwnld.py`, `sentinel_img_dwnld.py` |
| **Mosaico, recorte e reprojeção** | Operações geoespaciais básicas em rasters | `mosaicking.py`, `Clip_Multiple_Rasters.py`, `Reproj_Multiple_Rasters.py` |

### Fórmulas dos índices

| Índice | Fórmula |
|---|---|
| NDVI | (NIR − Red) / (NIR + Red) |
| SAVI | (NIR − Red) / ((NIR + Red + 0,5) × 1,5) *(forma usada no código)* |
| EVI | 2,5 × (NIR − Red) / (NIR + 6·Red − 7,5·Blue + 1) |
| NBR2 | (SWIR1 − SWIR2) / (SWIR1 + SWIR2) |
| GLI | (2·Green − Red − Blue) / (2·Green + Red + Blue) |
| GCI | (NIR / Green) − 1 |

---

## Descrição dos scripts

### 1. Download e preparação de imagens

| Script | O que faz |
|---|---|
| `landsat_img_dwnld.py` | Busca no Microsoft Planetary Computer as cenas **Landsat 8 (Coleção 2, Nível 2)** que cruzam a área de interesse (GeoJSON) em um período definido. Descarta as datas com mais de 30% de nuvens, recorta as bandas `blue, red, nir08, swir16, swir22` pela área de interesse e salva um GeoTIFF multibanda por cena. |
| `sentinel_img_dwnld.py` | Faz o mesmo para o **Sentinel-2 L2A** (bandas B04 e B08), apenas para os tiles `KGE` e `KFE`. |
| `mosaicking.py` | Percorre as subpastas de cenas e junta os tiles de cada data em um mosaico (`*_S2.tif`, `*_L8.tif` ou `*_L9.tif`, conforme o sufixo da pasta). |
| `Clip_Multiple_Rasters.py` | Recorta todos os `.tif` de uma pasta pelo limite de um shapefile (EPSG:32722) e salva os resultados com o prefixo `clipped_`. |
| `Reproj_Multiple_Rasters.py` | Reprojeta todos os `.tif` de uma pasta para EPSG:4326 (WGS 84). |
| `Teste_Stack_Raster.py` | *(teste)* Abre vários rasters, recorta e reprojeta cada um com base em um raster de referência e empilha tudo em um único arquivo (`stacked_rasters.tif`). |

### 2. Imagem sintética de solo exposto (ISSE)

| Script | O que faz |
|---|---|
| `ISSE.py` | Gera a **Imagem sintética de solo exposto** a partir de uma cena Landsat 5 (`L5_2000_06`). Etapas: (1) lê as bandas Red, NIR, SWIR1 e SWIR2; (2) calcula e exporta o NDVI e o NBR2; (3) empilha as bandas B1–B6; (4) mantém só os pixels com **0 < NDVI < 0,20**, descartando a vegetação; (5) desses, mantém os pixels com **NBR2 < 0,055**, descartando a palha; (6) exporta as bandas mascaradas para `2_Landsat_NDVI_Clip/` e `3_Landsat_NBR2_Clip/`. O script também traz as funções `check_crs`, `open_clean_band` e `process_bands`, além de etapas comentadas de máscara por banda QA (nuvem e sombra). |
| `Bare_Soil.py` | Mesmo processamento do `ISSE.py`, aplicado a outra cena (`L5_2006_04`). |

### 3. Índices de vegetação

| Script | O que faz |
|---|---|
| `Ind_Veg_Opt.py` | **Versão otimizada.** Lê uma imagem Landsat 8 multibanda exportada do GEE, aplica o fator de escala e calcula NDVI, SAVI, EVI e NBR2 em um laço, exportando um GeoTIFF por índice. |
| `Indices_Veg.py` | Calcula NDVI, SAVI, EVI e NBR2 para 5 datas Landsat 8 de 2019 (`L8_2019_02`, `_04`, `_044`, `_05`, `_06`). Cada banda é lida separadamente. |
| `Indices_Veg_Capuava.py` | Variação do `Indices_Veg.py` para a área Capuava. |
| `Indices_Vegetacao.py` | **Fluxo completo e mais antigo (2021).** Gera a extensão da área a partir de um shapefile, identifica as cenas Landsat pelo grid WRS-2, baixa as imagens do bucket AWS `landsat-pds`, reprojeta para EPSG:3857, faz o mosaico das cenas, recorta pelo limite da usina, calcula NDVI, SAVI, NBR2, GLI e GCI, reamostra para 10 m e aplica uma paleta de cores em 5 classes, do vermelho ao azul. |

### 4. Máscaras e filtros

| Script | O que faz |
|---|---|
| `Mask_Raster_threshold.py` | Aplica a máscara NDVI ≥ 0,25 aos índices EVI, SAVI e NBR2 das 5 datas de 2019 e exporta os arquivos `*_Filt.tif`. |
| `Mask_Raster_threshold_Opt.py` | **Versão otimizada** do anterior. Abre automaticamente os índices com um sufixo definido (ex.: `07.tif`) e aplica a mesma máscara em um laço. |
| `Replace_NA_Values_in_Raster.py` | Substitui os valores NA por `0.001` em todos os `.tif` de uma pasta e salva os resultados com o prefixo `modified_`. |
| `Raster_Gaussian_Filter.py` | Aplica um filtro Gaussiano (σ = 1) em uma banda, com visualização antes e depois, ou em todas as 10 bandas de uma imagem Sentinel-2, salvando cada banda como `<Banda>_Smoothed.tif`. |

### 5. Conversão entre formatos

| Script | O que faz |
|---|---|
| `Multiple_Raster_to_Singleband.py` | Divide um raster multibanda (ex.: `ISSE_Capuava_32722.tif`) em vários rasters de uma banda (`output_band<N>.tif`). |
| `Singleband_Raster_to_Multiple.py` | Junta as bandas suavizadas (`*_Smoothed.tif`) em um único raster multibanda do Sentinel-2. |
| `Raster_to_Points.py` | Converte cada pixel válido (diferente de 0 e de NA) de um raster em um ponto, gerando um shapefile. |
| `Multiple_Raster_to_Points.py` | Faz o mesmo que o anterior para todos os `.tif` de uma pasta. |
| `Pixel_to_Point.py` | Gera pontos nos centroides dos pixels da classe 1 de um raster classificado, reprojeta para EPSG:32722, adiciona as colunas X/Y e agrupa os pontos com **PCA + DBSCAN** (eps = 50 m). |
| `Pt_SHP_to_DF.py` | Lê um shapefile de pontos e o converte em um DataFrame. |

### 6. Análise e utilitários

| Script | O que faz |
|---|---|
| `Kmeans_Cluster.py` | Agrupa por **K-Means** (5 clusters) os pixels de um raster multibanda (`raster_stack3.tif`), ignorando os NA, e salva o resultado como `clustered_raster2.tif`. |
| `Subset_DF.py` | Função `subset_dataframe(df, porcentagem)` que retorna uma amostra aleatória com a porcentagem indicada das linhas. |
| `My_Script.py` | Exemplo de script de linha de comando (`argparse`) que verifica se um caminho existe. |

---

## Pacotes e bibliotecas necessários

- **Python 3.8+**.
- O GDAL é mais fácil de instalar pelo **conda**.

| Pacote | Uso |
|---|---|
| `numpy`, `pandas` | Cálculos e tabelas |
| `rasterio` | Leitura e escrita de rasters, recorte, mosaico |
| `rioxarray`, `xarray` | Rasters como arrays rotulados, recorte e reprojeção |
| `gdal` (`osgeo`) | Reamostragem, reprojeção, tabela de cores |
| `geopandas`, `shapely`, `fiona`, `pyproj` | Dados vetoriais e sistemas de coordenadas |
| `matplotlib`, `seaborn`, `earthpy` | Visualização |
| `scikit-learn` | K-Means, PCA, DBSCAN |
| `scikit-image` | Filtro Gaussiano |
| `pystac-client`, `pystac`, `planetary-computer` | Busca e download de imagens via STAC |
| `requests`, `beautifulsoup4` | Download pelo AWS (`Indices_Vegetacao.py`) |
| `folium` | Mapas interativos (`Indices_Vegetacao.py`) |

### Instalação (conda, recomendado)

```bash
conda create -n sr python=3.10
conda activate sr
conda install -c conda-forge gdal rasterio rioxarray xarray geopandas shapely fiona pyproj \
    numpy pandas matplotlib seaborn earthpy scikit-learn scikit-image \
    pystac-client pystac planetary-computer requests beautifulsoup4 folium
```

### Instalação (pip)

```bash
pip install numpy pandas rasterio rioxarray xarray geopandas shapely fiona pyproj \
    matplotlib seaborn earthpy scikit-learn scikit-image \
    pystac-client pystac planetary-computer requests beautifulsoup4 folium
```
> No Windows, o `gdal` costuma dar erro quando instalado pelo pip. Nesse caso, use o conda.

---

## Instruções de execução

1. **Ajuste os diretórios.** Nos scripts, os caminhos de trabalho estão no formato genérico:
   ```python
   os.chdir(r"DIRETORIO/SUBPASTA")
   ```
   Troque `DIRETORIO` pelo caminho da pasta onde estão os seus dados. A subpasta indica qual pasta o script espera encontrar, por exemplo `DIRETORIO/L8_2019_04`. Revise também os outros caminhos fixos (shapefiles, pastas de saída) e as variáveis marcadas com `# CHANGE THIS VARIABLE` ou `# Change This Directory`.

2. **Confira os dados de entrada.** Verifique os nomes das bandas (ex.: `L8_2019_02_B4.tif`), o sistema de coordenadas (a maioria usa **EPSG:32722**, SIRGAS/WGS 84 UTM 22S) e se as pastas de saída já existem.

3. **Execute o script.**
   - No terminal:
     ```bash
     python Ind_Veg_Opt.py
     ```
   - No **Spyder** ou outra IDE: muitos scripts foram escritos para rodar por blocos (seleção ou células), principalmente o `Indices_Vegetacao.py` e o `ISSE.py`, que têm etapas comentadas entre `'''`.
   - O `My_Script.py` recebe um argumento:
     ```bash
     python My_Script.py --file-path "C:/caminho/arquivo.tif"
     ```

4. **Ordem sugerida para um fluxo completo:**
   ```
   landsat_img_dwnld.py / sentinel_img_dwnld.py   →  download
   mosaicking.py                                  →  mosaico
   Clip_Multiple_Rasters.py                       →  recorte pela área de estudo
   Ind_Veg_Opt.py                                 →  índices de vegetação
   Mask_Raster_threshold_Opt.py                   →  máscara NDVI ≥ 0,25
   ISSE.py                                        →  Imagem sintética de solo exposto
   Kmeans_Cluster.py / Raster_to_Points.py        →  análise e exportação
   ```

---

## Observações e limitações conhecidas

- `Singleband_Raster_to_Multiple.py` usa `np.stack` sem importar o `numpy`. É preciso adicionar `import numpy as np` no início.
- `Subset_DF.py` tem um marcador (`'INSERT DATAFRAME HERE'`) que precisa ser trocado por um DataFrame real.
- Em `Indices_Veg.py` e `Indices_Veg_Capuava.py`, as bandas da data `_06` são lidas a partir dos objetos `_05`. Revise esse trecho antes de usar.
- Em `ISSE.py` e `Bare_Soil.py`, o parâmetro `valid_range` da função `open_clean_band` faz referência a uma variável que não está definida.
- Em `Indices_Vegetacao.py`, a fórmula do SAVI usa o fator `× 2,5`, enquanto os outros scripts usam `(NIR + Red + 0,5) × 1,5`. A do GLI está escrita como `2*(G − R − B) / 2*(G + R + B)`, o que, pela precedência dos operadores, não equivale à fórmula do comentário. Revise antes de comparar resultados entre scripts.
- `Raster_to_Points.py` e `Multiple_Raster_to_Points.py` atribuem EPSG:4326 aos pontos sem reprojetar. Confirme o CRS do raster de origem.
- O bucket `landsat-pds` da AWS, usado em `Indices_Vegetacao.py`, foi descontinuado. Para baixar imagens, prefira `landsat_img_dwnld.py`.
- O raster `ISSE_Capuava_32722.tif`, usado em `Multiple_Raster_to_Singleband.py`, precisa existir com esse nome. Se o arquivo no disco ainda tiver o nome antigo, renomeie-o.
