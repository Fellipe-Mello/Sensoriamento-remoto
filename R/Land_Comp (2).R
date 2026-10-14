library(raster)

list.files()
# Abrir ISSE
setwd("DIRETORIO/SUBPASTA")
ISSE <- stack("SYSI_BENRI_Clip.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA  
crs(ISSE)

setwd("DIRETORIO2/SUBPASTA")
list.files()
# Open SAVI
LST = list.files(paste(getwd()), pattern = "LST_C_UTM.tif$")
LST <- raster(LST)
LST <- resample(LST, ISSE, method = "ngb")

# Open NDVI
setwd("DIRETORIO3/SUBPASTA")
list.files(pattern = "\\.tif$")

NDVI_03 = list.files(paste(getwd()), pattern = "NDVI_2019_02_Fill.tif$")
NDVI_03 <- raster(NDVI_03)
NDVI_03 <- resample(NDVI_03, ISSE, method = "ngb")

NDVI_04 = list.files(paste(getwd()), pattern = "NDVI_2019_04_Fill.tif$")
NDVI_04 <- raster(NDVI_04)
NDVI_04 <- resample(NDVI_04, ISSE, method = "ngb")

NDVI_05 = list.files(paste(getwd()), pattern = "NDVI_2019_044_Fill.tif$")
NDVI_05 <- raster(NDVI_05)
NDVI_04 <- resample(NDVI_05, ISSE, method = "ngb")

NDVI_06 = list.files(paste(getwd()), pattern = "NDVI_2019_05_Fill.tif$")
NDVI_06 <- raster(NDVI_06)
NDVI_06 <- resample(NDVI_06, ISSE, method = "ngb")

NDVI_07 = list.files(paste(getwd()), pattern = "NDVI_2019_06_Fill.tif$")
NDVI_07 <- raster(NDVI_07)
NDVI_07 <- resample(NDVI_07, ISSE, method = "ngb")

# Open EVI
EVI_03 = list.files(paste(getwd()), pattern = "EVI_2019_02_Fill.tif$")
EVI_03 <- raster(EVI_03)
EVI_03 <- resample(EVI_03, ISSE, method = "ngb")

EVI_04 = list.files(paste(getwd()), pattern = "EVI_2019_04_Fill.tif$")
EVI_04 <- raster(EVI_04)
EVI_04 <- resample(EVI_04, ISSE, method = "ngb")

EVI_05 = list.files(paste(getwd()), pattern = "EVI_2019_044_Fill.tif$")
EVI_05 <- raster(EVI_05)
EVI_05 <- resample(EVI_05, ISSE, method = "ngb")

EVI_06 = list.files(paste(getwd()), pattern = "EVI_2019_05_Fill.tif$")
EVI_06 <- raster(EVI_06)
EVI_06 <- resample(EVI_06, ISSE, method = "ngb")

EVI_07 = list.files(paste(getwd()), pattern = "EVI_2019_06_Fill.tif$")
EVI_07 <- raster(EVI_07)
EVI_07 <- resample(EVI_07, ISSE, method = "ngb")


# Open NBR2
NBR2_03 = list.files(paste(getwd()), pattern = "NBR2_2019_02_Fill.tif$")
NBR2_03 <- raster(NBR2_03)
NBR2_03 <- resample(NBR2_03, ISSE, method = "ngb")

NBR2_04 = list.files(paste(getwd()), pattern = "NBR2_2019_04_Fill.tif$")
NBR2_04 <- raster(NBR2_04)
NBR2_04 <- resample(NBR2_04, ISSE, method = "ngb")

NBR2_05 = list.files(paste(getwd()), pattern = "NBR2_2019_044_Fill.tif$")
NBR2_05 <- raster(NBR2_05)
NBR2_05 <- resample(NBR2_05, ISSE, method = "ngb")

NBR2_06 = list.files(paste(getwd()), pattern = "NBR2_2019_05_Fill.tif$")
NBR2_06 <- raster(NBR2_06)
NBR2_06 <- resample(NBR2_06, ISSE, method = "ngb")

NBR2_07 = list.files(paste(getwd()), pattern = "NBR2_2019_06_Fill.tif$")
NBR2_07 <- raster(NBR2_07)
NBR2_07 <- resample(NBR2_07, ISSE, method = "ngb")

# Open SAVI
SAVI_03 = list.files(paste(getwd()), pattern = "SAVI_2019_02_Fill.tif$")
SAVI_03 <- raster(SAVI_03)
SAVI_03 <- resample(SAVI_03, ISSE, method = "ngb")

SAVI_04 = list.files(paste(getwd()), pattern = "SAVI_2019_04_Fill.tif$")
SAVI_04 <- raster(SAVI_04)
SAVI_04 <- resample(SAVI_04, ISSE, method = "ngb")

SAVI_05 = list.files(paste(getwd()), pattern = "SAVI_2019_044_Fill.tif$")
SAVI_05 <- raster(SAVI_05)
SAVI_05 <- resample(SAVI_05, ISSE, method = "ngb")

SAVI_06 = list.files(paste(getwd()), pattern = "SAVI_2019_05_Fill.tif$")
SAVI_06 <- raster(SAVI_06)
SAVI_06 <- resample(SAVI_06, ISSE, method = "ngb")

SAVI_07 = list.files(paste(getwd()), pattern = "SAVI_2019_06_Fill.tif$")
SAVI_07 <- raster(SAVI_07)
SAVI_07 <- resample(SAVI_07, ISSE, method = "ngb")


# Construir o Raster Stack
raster_stack <- stack(NDVI_03,NDVI_04,NDVI_05,NDVI_06,NDVI_07,
                      EVI_03,EVI_04,EVI_05,EVI_06,EVI_07,
                      NBR2_03,NBR2_04,NBR2_03,NBR2_04,NBR2_04,
                      SAVI_03,SAVI_04,SAVI_03,SAVI_04,SAVI_04,
                      ISSE)
plot(raster_stack)

# Exportar Raster Stack
setwd("DIRETORIO4/SUBPASTA")
myStack <- writeRaster(raster_stack,"Stack_Zonas_Manejo.tif", format="GTiff", overwrite = TRUE)
################################################################################
################################################################################
# Bandas do Raster Stack
'
1	  - NDVI_03
2	  - NDVI_04
3   - EVI_03
4	  - EVI_04
5	  - NBR2_03
6	  - NBR2_04
7	  - SAVI_03
8	  - SAVI_04
9	  - LST
10	- ISSE B1
11	- ISSE B2
12	- ISSE B3
13	- ISSE B4
14	- ISSE B5
15	- ISSE B6
'
################################################################################
################################################################################
library(cluster)
library(randomForest)

valores <- getValues(raster_stack)
index <- which(!is.na(valores))
valores <- na.omit(valores)

resultadoClara <- clara(valores, k = 10, samples = 500, metric = "manhattan", pamLike = FALSE)
imagemClara <- raster(raster_stack)
imagemClara[index] <- resultadoClara$clustering

plot(imagemClara)

setwd("DIRETORIO4/SUBPASTA")
writeRaster(imagemClara,   "ZM_K10.tif",   overwrite=TRUE)
################################################################################
imagemAmostra <- valores[sample(nrow(valores), 500),]
rf <- randomForest(imagemAmostra)
rf_prox <- randomForest(imagemAmostra, ntree=1000, proximity = TRUE)$proximity

E_rf <- kmeans(rf_prox, 5)
rf <- randomForest(imagemAmostra, as.factor(E_rf$cluster), ntree = 500)
rf_raster <- predict(raster_stack, rf)

plot(rf_raster)
setwd("DIRETORIO5/SUBPASTA")
writeRaster(rf_raster,   "ZM_RF_5.tif",   overwrite=TRUE)
################################################################################
