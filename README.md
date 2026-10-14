# Sensoriamento Remoto — Processamento de Imagens Orbitais para Estudos de Solo e Vegetação

Este repositório reúne scripts em **Python** e **R** para o processamento de imagens de satélite aplicadas ao estudo de **solos e vegetação em áreas agrícolas**. Os códigos cobrem as etapas de aquisição e preparação de imagens, cálculo de índices espectrais, obtenção da **Imagem sintética de solo exposto (ISSE)** — em inglês, *Synthetic Soil Image* —, integração de covariáveis ambientais e delimitação de **zonas de manejo** por agrupamento não supervisionado.

---

## Objetivo e escopo

O objetivo do repositório é documentar e disponibilizar rotinas de processamento geoespacial utilizadas em pesquisa com sensoriamento remoto de solos. O escopo abrange:

- **Sensores:** Landsat 5, Landsat 8 (Coleção 2, Nível 2) e Sentinel-2 (L2A);
- **Dados de entrada:** imagens multiespectrais, índices de vegetação, modelos digitais de elevação e derivados de relevo, atributos do solo e limites vetoriais das áreas de estudo;
- **Produtos gerados:** índices espectrais, máscaras de solo exposto, Imagem sintética de solo exposto, stacks de covariáveis, rasters agrupados e conversões raster → pontos.

Os scripts são roteiros de análise vinculados a áreas e datas de estudo específicas. Os caminhos de diretório foram substituídos por marcadores genéricos (`DIRETORIO/SUBPASTA`) e precisam ser ajustados antes da execução, conforme descrito nos READMEs de cada pasta.

---

## Organização do repositório

```
Sensoriamento-remoto/
├── README.md        ← este documento (visão geral)
├── Python/          ← 25 scripts .py + README.md
│   └── README.md
└── R/               ← 9 scripts .R + README.md
    └── README.md
```

| Pasta | Linguagem | Foco principal | Documentação |
|---|---|---|---|
| [`Python/`](Python/) | Python 3 | Aquisição, pré-processamento, índices de vegetação, máscaras de solo exposto, filtragem, agrupamento e conversão de formatos | [Python/README.md](Python/README.md) |
| [`R/`](R/) | R | Composição multitemporal da Imagem sintética de solo exposto, interpolação espacial, empilhamento de covariáveis e zonas de manejo | [R/README.md](R/README.md) |

---

## Conteúdo por linguagem

### Python — aquisição, pré-processamento e índices espectrais

Detalhes de cada script, dependências e instruções de execução: **[Python/README.md](Python/README.md)**.

| Grupo | Aplicações |
|---|---|
| Aquisição de imagens | Busca e download de cenas Landsat 8 e Sentinel-2 via STAC (Microsoft Planetary Computer), com filtro de cobertura de nuvens; fluxo legado baseado no bucket AWS `landsat-pds` |
| Pré-processamento | Mosaico, recorte por shapefile, reprojeção, empilhamento de rasters e substituição de valores NA |
| Índices espectrais | NDVI, SAVI, EVI, NBR2, GLI e GCI, com aplicação do fator de escala da Coleção 2 do Landsat |
| Solo exposto | Geração da Imagem sintética de solo exposto por máscaras de NDVI (vegetação) e NBR2 (palha) em cenas Landsat 5 |
| Máscaras e filtros | Máscara por limiar de NDVI e filtro Gaussiano em bandas Sentinel-2 |
| Agrupamento | K-Means sobre raster multibanda; PCA + DBSCAN sobre pontos derivados de pixels |
| Conversão de formatos | Raster multibanda ↔ rasters de banda única, raster → pontos (shapefile) e shapefile → DataFrame |

**Principais bibliotecas:** `rasterio`, `rioxarray`/`xarray`, `gdal`, `geopandas`, `numpy`, `scikit-learn`, `scikit-image`, `pystac-client` e `planetary-computer`.

### R — Imagem sintética de solo exposto e zonas de manejo

Detalhes de cada script, dependências e instruções de execução: **[R/README.md](R/README.md)**.

| Grupo | Aplicações |
|---|---|
| Composição temporal | Mosaico multitemporal de imagens de solo exposto pela mediana, gerando a Imagem sintética de solo exposto |
| Separação de bandas | Exportação de cada banda de uma imagem multibanda em GeoTIFF individual |
| Interpolação espacial | Preenchimento de falhas da Imagem sintética de solo exposto por IDW (`gstat`), com suavização por média focal |
| Empilhamento de covariáveis | Reamostragem para a grade da Imagem sintética de solo exposto de índices de vegetação, derivados de relevo (DEM, declividade, TWI, entre outros), atributos do solo e temperatura de superfície (LST) |
| Zonas de manejo | Agrupamento não supervisionado por CLARA (k-medoides) e por Random Forest não supervisionado combinado com k-means |

**Principais pacotes:** `raster`, `terra`, `sp`, `sf`, `gstat`, `caret`, `cluster` e `randomForest`.

---

## Fluxo geral de trabalho

As duas pastas são complementares. Os scripts em Python concentram a obtenção e o pré-processamento das imagens e o cálculo dos índices; os scripts em R concentram a composição da Imagem sintética de solo exposto e a análise integrada de covariáveis.

```
Python                                         R
──────────────────────────────────────────     ──────────────────────────────────────────
Download (STAC) → mosaico → recorte
        ↓
Índices de vegetação → máscaras
        ↓
Imagem sintética de solo exposto (por cena) →  Composição pela mediana → interpolação IDW
                                                       ↓
Recorte / substituição de NA dos índices    →  Stack de covariáveis
                                                       ↓
K-Means sobre o stack (raster_stack3.tif)   ←  Stack_Raster.R
                                               Zonas de manejo (CLARA / Random Forest)
```

Há correspondências diretas entre arquivos das duas pastas. Por exemplo, `Land_Comp (3).R` lê índices com o prefixo `modified_clipped_`, gerado por `Clip_Multiple_Rasters.py` e `Replace_NA_Values_in_Raster.py`. Já `Kmeans_Cluster.py` lê o arquivo `raster_stack3.tif`, exportado por `Stack_Raster.R`. A ordem de execução sugerida dentro de cada linguagem está descrita nos READMEs individuais.

---

## Requisitos

| Ambiente | Versão | Observação |
|---|---|---|
| Python | 3.8 ou superior | Recomenda-se instalar via **conda** (`conda-forge`), principalmente por causa do GDAL no Windows |
| R | 4.0 ou superior | Recomenda-se usar o **RStudio**. O pacote `rgdal` foi retirado do CRAN; as alternativas estão no README da pasta R |

As listas completas de dependências e os comandos de instalação estão em [Python/README.md](Python/README.md) e [R/README.md](R/README.md).

---

## Observações

- Os scripts foram escritos para execução interativa, por blocos (Spyder ou RStudio), e não como pacotes ou funções reutilizáveis.
- Os nomes de arquivos de dados citados nos códigos (ex.: `SYSI_*.tif`, `L8_2019_*`) correspondem aos conjuntos de dados originais, que não estão incluídos no repositório.
- Os pontos de atenção identificados em cada script (inconsistências de variáveis, fórmulas e dependências descontinuadas) estão listados nas seções de observações dos READMEs individuais.
