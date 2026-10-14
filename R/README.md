# Scripts em R para Sensoriamento Remoto de Solos (Imagem sintética de solo exposto)

Esta pasta reúne scripts em **R** para processar imagens de satélite (Landsat 5 / Landsat 8) com foco na **Imagem sintética de solo exposto** (em inglês, *Synthetic Soil Image*; abreviada nos scripts como **ISSE**). Os métodos implementados cobrem:

- **Composição temporal** de imagens de solo exposto pela mediana (mosaico multitemporal);
- **Separação de bandas** de uma imagem multibanda;
- **Interpolação espacial (IDW)** para preencher falhas da Imagem sintética de solo exposto;
- **Empilhamento (stack) de covariáveis** — Imagem sintética de solo exposto, índices de vegetação, relevo e atributos do solo — reamostradas para a mesma grade;
- **Delimitação de zonas de manejo** por agrupamento não supervisionado (CLARA e Random Forest não supervisionado + k-means).

---

## Visão geral dos scripts

| Script | Método | Entrada | Saída |
|---|---|---|---|
| `ExportISSE_Median.R` | Mosaico multitemporal pela mediana | Várias imagens `Bare_AAAA_MM.tif` | `Bare_Merge_*.tif`, `SYSI_*.tif` |
| `Export_ISSE_Bands.R` | Separação de bandas | Uma imagem multibanda (ex.: `L5_Ferrari_2001_06.tif`) | Um GeoTIFF por banda (`_B1` … `_B6`) |
| `ISSE_Interp.R` | Interpolação IDW + suavização (uma área, uma banda) | `SYSI_A2.tif`, raster de referência, shapefile da área | `B6.tif` |
| `ISSE_Interp_2.R` | Interpolação IDW + suavização (várias subáreas, todas as bandas) | `SYSI_A10.tif` … `SYSI_A35.tif`, rasters de referência, shapefiles | `B1.tif` … `B6.tif` por subárea |
| `Stack_Raster.R` | Empilhamento de covariáveis | Imagem sintética de solo exposto, relevo, índices de vegetação, atributos do solo | `raster_stack3.tif` |
| `Land_Comp.R` | Stack + zonas de manejo (índices de vegetação 2023 + relevo) | Imagem sintética de solo exposto (`Bare_Merge.tif`), NDVI/EVI/NBR2/SAVI, DEM, LSF, PCV, RSP, SLP, TWI | `Stack_Zonas_Manejo.tif`, `ZM_K10.tif`, `ZM_RF_5_relevo.tif` |
| `Land_Comp (2).R` | Stack + zonas de manejo (índices de vegetação 2019 + LST) | Imagem sintética de solo exposto, LST, NDVI/EVI/NBR2/SAVI | `Stack_Zonas_Manejo.tif`, `ZM_K10.tif`, `ZM_RF_5.tif` |
| `Land_Comp (3).R` | Stack de covariáveis (relevo + vegetação) | Imagem sintética de solo exposto, DEM, AHS, CVX, PCV, SLP, TCV, TRI, TWI, EVI/NBR2/NDVI/SAVI | `Cov_Stack1.tif`, `Cov_Stack2.tif` |
| `Land_Comp (4).R` | Stack automático (todos os `.tif` da pasta) + zonas de manejo | `SYSI.tif` + todos os `.tif` da pasta | `ZM_K10.tif`, `ZM_Ester.tif` |

---

## Descrição dos scripts

### 1. `ExportISSE_Median.R` — Composição da Imagem sintética de solo exposto pela mediana
Lê diversas imagens de solo exposto de datas diferentes (`Bare_1995_09.tif`, `Bare_2002_04.tif`, `Bare_L8_2020_08.tif`, …), converte valores `0` e negativos em `NA` e combina todas com `raster::mosaic(..., fun = median)`. Como cada data mostra solo exposto em lugares diferentes, a mediana gera uma imagem mais completa e representativa do solo.

O script é organizado em **blocos independentes** — cada bloco gera um mosaico diferente (`Bare_Merge_2.tif`, `Bare_Merge_3.tif`, `Bare_Merge_5.tif`, `Bare_Merge_9.tif`, `SYSI_BENRI_1.tif`, `SYSI_BENRI_4.tif`, `SYSI_A3.tif`, `SYSI_A3_2.tif`). Alguns blocos reaproveitam mosaicos anteriores (ex.: `Bare_Merge_2.tif` entra no `Bare_Merge_3.tif`).

No final há uma seção **experimental** de preenchimento de falhas (`approxNA` do `raster` e `rfillspgaps` do pacote `meteo`) e uma lista de cenas Landsat 5/8 usadas como referência.

### 2. `Export_ISSE_Bands.R` — Separação de bandas
Abre uma imagem multibanda e salva cada banda em um GeoTIFF separado (float 32 bits, `FLT4S`). Exemplo: `L5_Ferrari_2001_06.tif` → `L5_Ferrari_2001_06_B1.tif` … `_B6.tif`. A banda QA (7ª) está comentada.

### 3. `ISSE_Interp.R` — Interpolação IDW (versão simples)
Baseado em <http://jonkatz2.github.io/2017/11/15/interpolating-points-to-raster-in-r>.

1. Abre a Imagem sintética de solo exposto e converte cada banda em tabela de pontos (`x`, `y`, valor), removendo `NA`;
2. Cria um `SpatialPointsDataFrame` (EPSG:4326);
3. Ajusta um modelo **IDW** com `gstat` (`nmax = 4`, potência `idp = 0.5`) e interpola sobre a grade de um raster de referência, limitado à extensão do shapefile da área;
4. Suaviza o resultado com média móvel (`focal`, janela 101 × 101 pixels, ignorando `NA`);
5. Exporta o raster interpolado (nesta versão, apenas a banda 6).

### 4. `ISSE_Interp_2.R` — Interpolação IDW em lote
Mesmo método do item anterior, repetido para **todas as 6 bandas** e para **várias subáreas** (`SYSI_A10`, `SYSI_A14` … `SYSI_A35`). Antes de interpolar, usa `caret::createDataPartition` para **amostrar cerca de 0,12% dos pixels** (o script descarta a partição de 99,88% e mantém o restante), o que torna a interpolação viável em imagens grandes. Usa `xyOnly = TRUE` na interpolação.

### 5. `Stack_Raster.R` — Empilhamento de covariáveis
Usa a Imagem sintética de solo exposto como **grade de referência** e reamostra (`resample`, vizinho mais próximo `ngb`) todas as covariáveis para ela:

- **Relevo:** DEM, SLP (declividade), TWI, AHS, LSF, CNBL, RSP, TPI, MRI, LCV, FAC, CVI, CSC;
- **Vegetação:** EVI, NBR2, NDVI e SAVI dos meses 05, 07, 08 e 12;
- **Solo:** argila (Clay), CTC, areia (Sand), silte (Silt) e saturação por bases (V).

O stack ativo contém vegetação + solo + Imagem sintética de solo exposto (a versão com relevo está comentada) e é exportado com `terra::writeRaster` como `raster_stack3.tif`.

### 6. Scripts `Land_Comp*.R` — Zonas de manejo
Todos seguem a mesma lógica: (1) abrir a Imagem sintética de solo exposto e transformar `0`/negativos em `NA`; (2) reamostrar as covariáveis para a grade da Imagem sintética de solo exposto; (3) montar e exportar o stack; (4) — nos que fazem classificação — gerar as zonas de manejo por dois métodos:

- **CLARA** (`cluster::clara`): k-medoides para grandes volumes de dados, distância Manhattan, 500 amostras. Resultado em `ZM_K10.tif`.
- **Random Forest não supervisionado** (`randomForest`): sorteia 500 pixels, calcula a matriz de **proximidade** do RF (1000 árvores), agrupa essa matriz com **k-means (k = 5)**, treina um RF supervisionado (500 árvores) com esses grupos e prediz para a imagem inteira.

Diferenças entre as versões:

- **`Land_Comp.R`** — Imagem sintética de solo exposto `Bare_Merge.tif` + NDVI/EVI/NBR2/SAVI de 2023 (meses 03, 04, 05, 06 e 08) + relevo (DEM, LSF, PCV, RSP, SLP, TWI). CLARA com k = 5. Saída RF: `ZM_RF_5_relevo.tif`.
- **`Land_Comp (2).R`** — Imagem sintética de solo exposto `SYSI_BENRI_Clip.tif` + índices de vegetação de 2019 (arquivos `*_Fill.tif`) + LST (temperatura de superfície). CLARA com k = 10. Saída RF: `ZM_RF_5.tif`.
- **`Land_Comp (3).R`** — apenas monta o stack: Imagem sintética de solo exposto `SYSI_Capuava_32722.tif` + relevo (DEM, AHS, CVX, PCV, SLP, TCV, TRI, TWI) + EVI/NBR2/NDVI/SAVI dos meses 02 a 07. Exporta com `raster` (`Cov_Stack1.tif`) e com `terra` (`Cov_Stack2.tif`). Não faz agrupamento.
- **`Land_Comp (4).R`** — versão **genérica e mais enxuta**: em vez de listar arquivo por arquivo, lê **todos os `.tif` da pasta** em um laço `for`, reamostra para a Imagem sintética de solo exposto e empilha. CLARA com k = 5; saída RF: `ZM_Ester.tif`.

---

## Pacotes necessários

| Pacote | Uso | Scripts |
|---|---|---|
| `raster` | Leitura, reamostragem, mosaico, interpolação e escrita de rasters | Todos |
| `terra` | Exportação de stacks grandes | `Stack_Raster.R`, `Land_Comp (3).R`, `ISSE_Interp_2.R` |
| `sp` | Objetos espaciais de pontos | `ISSE_Interp*.R` |
| `rgdal` | Leitura de shapefiles (`readOGR`) | `ISSE_Interp*.R` |
| `gstat` | Modelo de interpolação IDW | `ISSE_Interp*.R` |
| `caret` | Amostragem dos pixels (`createDataPartition`) | `ISSE_Interp*.R` |
| `sf` | Dados vetoriais | `ISSE_Interp_2.R` |
| `cluster` | Agrupamento CLARA | `Land_Comp.R`, `(2)`, `(4)` |
| `randomForest` | Random Forest não supervisionado | `Land_Comp.R`, `(2)`, `(4)` |
| `meteo` | Preenchimento de falhas (seção experimental) | `ExportISSE_Median.R` |

Instalação:

```r
install.packages(c("raster", "terra", "sp", "gstat", "caret", "sf",
                   "cluster", "randomForest", "meteo"))
```

> **Atenção — `rgdal`:** o pacote foi **retirado do CRAN em 2023**. Para rodar os scripts de interpolação há duas opções:
> - instalar a versão arquivada: `install.packages("rgdal", repos = "https://r-forge.r-project.org")` (requer GDAL/PROJ no sistema); ou
> - substituir `rgdal::readOGR(dsn = "arquivo.shp")` por `as(sf::st_read("arquivo.shp"), "Spatial")`.
>
> Da mesma forma, `CRS("+init=epsg:4326")` pode gerar avisos nas versões recentes; prefira `CRS("EPSG:4326")`.

Requisitos: R ≥ 4.0 (recomenda-se usar o **RStudio**).

---

## Como executar

1. **Abra o script** no RStudio.
2. **Ajuste os caminhos.** Os scripts usam marcadores genéricos que precisam ser trocados pelos caminhos reais:
   ```r
   setwd("DIRETORIO/SUBPASTA")   # troque por, ex.: setwd("C:/Dados/ISSE")
   ```
   Cada `DIRETORIO`, `DIRETORIO2`, `DIRETORIO3`… corresponde a uma pasta diferente (de entrada ou de saída). Nos scripts de interpolação também há caminhos absolutos (ex.: `C:/Dados_Espaciais/Adeco/...`, `C:/Fellipe/BENRI/...`) para o raster de referência e o shapefile — ajuste-os também.
   > No Windows, use `/` ou `\\` nos caminhos, nunca uma barra invertida simples.
3. **Confira os nomes dos arquivos.** Os padrões em `list.files(pattern = ...)` e `stack("...")` devem corresponder exatamente aos nomes dos seus `.tif`.
   > Nos scripts, variáveis e comentários usam a sigla **ISSE**, mas os nomes dos arquivos de dados entre aspas (ex.: `"SYSI_A10.tif"`, `"SYSI_BENRI_Clip.tif"`) e os nomes de camadas derivados deles (ex.: `ISSE$SYSI_A10_1`) foram mantidos com `SYSI`, para continuarem batendo com os arquivos no disco. Se você renomear os arquivos `.tif`, atualize esses nomes também.
4. **Execute por blocos** (`Ctrl + Enter` linha a linha, ou selecionando o bloco). Os scripts não são funções prontas: são roteiros sequenciais, e o `ExportISSE_Median.R` e o `ISSE_Interp_2.R` contêm vários blocos independentes — rode apenas o bloco da área/período desejado.
5. **Fluxo sugerido:**
   ```
   ExportISSE_Median.R    → gera a Imagem sintética de solo exposto (mosaico pela mediana)
   ISSE_Interp(_2).R      → (opcional) preenche falhas por IDW
   Export_ISSE_Bands.R    → (opcional) separa as bandas
   Stack_Raster.R / Land_Comp (3).R → monta o stack de covariáveis
   Land_Comp.R / (2) / (4)          → gera as zonas de manejo
   ```

### Dicas
- Todas as covariáveis devem cobrir a área da Imagem sintética de solo exposto; o `resample(..., method = "ngb")` ajusta resolução e alinhamento, mas **não reprojeta**. Garanta que todos os rasters estejam no **mesmo sistema de coordenadas** (verifique com `crs()`).
- O Random Forest usa amostragem aleatória; para resultados reprodutíveis, adicione `set.seed(123)` antes de `sample(...)`.
- A interpolação e o `focal` com janela 101 × 101 podem ser demorados em áreas grandes.

---

## Observações e pontos de atenção no código

Encontrados durante a revisão; vale corrigir antes de usar os resultados:

- **`Land_Comp.R` e `Land_Comp (2).R`:** a linha `NDVI_04 <- resample(NDVI_05, ISSE, ...)` sobrescreve o `NDVI_04` com o NDVI do mês 05 (deveria ser `NDVI_05 <- ...`).
- **`Land_Comp.R` e `Land_Comp (2).R`:** o `stack()` repete camadas (`NBR2_03, NBR2_04, NBR2_03, NBR2_04, NBR2_04` e o mesmo para SAVI), em vez de usar os meses 05, 06 e 07. O comentário "Bandas do Raster Stack" também está desatualizado.
- **`Land_Comp (2).R`:** o `LST` é lido mas não entra no stack.
- **`Land_Comp (3).R`:** `NBR2_05` aparece duas vezes no stack.
- **`Land_Comp (4).R`:** o laço lê todos os `.tif` da pasta, **incluindo o próprio `SYSI.tif`** (só a banda 1), que entra duplicado. O arquivo de saída se chama `ZM_K10.tif`, mas o CLARA usa `k = 5`.
- **`ExportISSE_Median.R` (final):** o trecho experimental usa `ISSE33` em vez de `ISSE_merge2` e chama `rfillspgaps(p)` antes de `p` existir.
- **`ISSE_Interp_2.R`:** os comentários "ADECO SUBAREA" não correspondem aos arquivos (ex.: "SUBAREA 15" abre `SYSI_A10.tif`; vários blocos dizem "SUBAREA 20"). Um dos arquivos se chama `SYSI_32.tif` (sem o "A").
