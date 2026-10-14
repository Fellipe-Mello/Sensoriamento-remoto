library(raster)
library(terra)

list.files()
# Abrir ISSE
setwd("DIRETORIO/SUBPASTA")
ISSE <- stack("SYSI_Capuava_32722.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA  

# RELEVO

setwd("DIRETORIO2/SUBPASTA")
list.files()
#Leitura das Covariáveis
DEM <- list.files(paste(getwd()), pattern = "DEM.tif$")
DEM <- raster(DEM)
DEM <- resample(DEM, ISSE, method = "ngb")

AHS <- list.files(paste(getwd()), pattern = "AHS.tif$")
AHS <- raster(AHS)
AHS <- resample(AHS, ISSE, method = "ngb")

CVX <- list.files(paste(getwd()), pattern = "CVX.tif$")
CVX <- raster(CVX)
CVX <- resample(CVX, ISSE, method = "ngb")

PCV <- list.files(paste(getwd()), pattern = "PCV.tif$")
PCV <- raster(PCV)
PCV <- resample(PCV, ISSE, method = "ngb")
        
SLP <- list.files(paste(getwd()), pattern = "SLP.tif$")
SLP <- raster(SLP)
SLP <- resample(SLP, ISSE, method = "ngb")
             
TCV <- list.files(paste(getwd()), pattern = "TCV.tif$")
TCV <- raster(TCV)
TCV <- resample(TCV, ISSE, method = "ngb")

TRI <- list.files(paste(getwd()), pattern = "TRI.tif$")
TRI <- raster(TRI)
TRI <- resample(TRI, ISSE, method = "ngb")               
  
TWI <- list.files(paste(getwd()), pattern = "TWI.tif$")
TWI <- raster(TWI)
TWI <- resample(TWI, ISSE, method = "ngb") 


# VEGETAÇÃO

EVI_02 <- list.files(paste(getwd()), pattern = "modified_clipped_EVI_02.tif$")
EVI_02 <- raster(EVI_02)
EVI_02 <- resample(EVI_02, ISSE, method = "ngb") 

EVI_03 <- list.files(paste(getwd()), pattern = "modified_clipped_EVI_03.tif$")
EVI_03 <- raster(EVI_03)
EVI_03 <- resample(EVI_03, ISSE, method = "ngb") 

EVI_04 <- list.files(paste(getwd()), pattern = "modified_clipped_EVI_04.tif$")
EVI_04 <- raster(EVI_04)
EVI_04 <- resample(EVI_04, ISSE, method = "ngb") 

EVI_05 <- list.files(paste(getwd()), pattern = "modified_clipped_EVI_05.tif$")
EVI_05 <- raster(EVI_05)
EVI_05 <- resample(EVI_05, ISSE, method = "ngb") 

EVI_06 <- list.files(paste(getwd()), pattern = "modified_clipped_EVI_06.tif$")
EVI_06 <- raster(EVI_06)
EVI_06 <- resample(EVI_06, ISSE, method = "ngb") 

EVI_07 <- list.files(paste(getwd()), pattern = "modified_clipped_EVI_07.tif$")
EVI_07 <- raster(EVI_07)
EVI_07 <- resample(EVI_07, ISSE, method = "ngb")

NBR2_02 <- list.files(paste(getwd()), pattern = "modified_clipped_NBR2_02.tif$")
NBR2_02 <- raster(NBR2_02)
NBR2_02 <- resample(NBR2_02, ISSE, method = "ngb")

NBR2_03 <- list.files(paste(getwd()), pattern = "modified_clipped_NBR2_03.tif$")
NBR2_03 <- raster(NBR2_03)
NBR2_03 <- resample(NBR2_03, ISSE, method = "ngb")

NBR2_04 <- list.files(paste(getwd()), pattern = "modified_clipped_NBR2_04.tif$")
NBR2_04 <- raster(NBR2_04)
NBR2_04 <- resample(NBR2_04, ISSE, method = "ngb")

NBR2_05 <- list.files(paste(getwd()), pattern = "modified_clipped_NBR2_05.tif$")
NBR2_05 <- raster(NBR2_05)
NBR2_05 <- resample(NBR2_05, ISSE, method = "ngb")

NBR2_06 <- list.files(paste(getwd()), pattern = "modified_clipped_NBR2_06.tif$")
NBR2_06 <- raster(NBR2_06)
NBR2_06 <- resample(NBR2_06, ISSE, method = "ngb")

NBR2_07 <- list.files(paste(getwd()), pattern = "modified_clipped_NBR2_07.tif$")
NBR2_07 <- raster(NBR2_07)
NBR2_07 <- resample(NBR2_07, ISSE, method = "ngb")

NDVI_02 <- list.files(paste(getwd()), pattern = "modified_clipped_NDVI_02.tif$")
NDVI_02 <- raster(NDVI_02)
NDVI_02 <- resample(NDVI_02, ISSE, method = "ngb")

NDVI_03 <- list.files(paste(getwd()), pattern = "modified_clipped_NDVI_03.tif$")
NDVI_03 <- raster(NDVI_03)
NDVI_03 <- resample(NDVI_03, ISSE, method = "ngb")

NDVI_04 <- list.files(paste(getwd()), pattern = "modified_clipped_NDVI_04.tif$")
NDVI_04 <- raster(NDVI_04)
NDVI_04 <- resample(NDVI_04, ISSE, method = "ngb")

NDVI_05 <- list.files(paste(getwd()), pattern = "modified_clipped_NDVI_05.tif$")
NDVI_05 <- raster(NDVI_05)
NDVI_05 <- resample(NDVI_05, ISSE, method = "ngb")

NDVI_06 <- list.files(paste(getwd()), pattern = "modified_clipped_NDVI_06.tif$")
NDVI_06 <- raster(NDVI_06)
NDVI_06 <- resample(NDVI_06, ISSE, method = "ngb")

NDVI_07 <- list.files(paste(getwd()), pattern = "modified_clipped_NDVI_07.tif$")
NDVI_07 <- raster(NDVI_07)
NDVI_07 <- resample(NDVI_07, ISSE, method = "ngb")

SAVI_02 <- list.files(paste(getwd()), pattern = "modified_clipped_SAVI_02.tif$")
SAVI_02 <- raster(SAVI_02)
SAVI_02 <- resample(SAVI_02, ISSE, method = "ngb")

SAVI_03 <- list.files(paste(getwd()), pattern = "modified_clipped_SAVI_03.tif$")
SAVI_03 <- raster(SAVI_03)
SAVI_03 <- resample(SAVI_03, ISSE, method = "ngb")

SAVI_04 <- list.files(paste(getwd()), pattern = "modified_clipped_SAVI_04.tif$")
SAVI_04 <- raster(SAVI_04)
SAVI_04 <- resample(SAVI_04, ISSE, method = "ngb")

SAVI_05 <- list.files(paste(getwd()), pattern = "modified_clipped_SAVI_05.tif$")
SAVI_05 <- raster(SAVI_05)
SAVI_05 <- resample(SAVI_05, ISSE, method = "ngb")

SAVI_06 <- list.files(paste(getwd()), pattern = "modified_clipped_SAVI_06.tif$")
SAVI_06 <- raster(SAVI_06)
SAVI_06 <- resample(SAVI_06, ISSE, method = "ngb")

SAVI_07 <- list.files(paste(getwd()), pattern = "modified_clipped_SAVI_07.tif$")
SAVI_07 <- raster(SAVI_07)
SAVI_07 <- resample(SAVI_07, ISSE, method = "ngb")


raster_stack <- stack(DEM, AHS, CVX, PCV, SLP, TCV, TRI, TWI,
                      EVI_02,EVI_03,EVI_04,EVI_05,EVI_06,EVI_07,
                      NBR2_02,NBR2_03,NBR2_04,NBR2_05,NBR2_05,NBR2_06,NBR2_07,
                      NDVI_02,NDVI_03,NDVI_04,NDVI_05,NDVI_06,NDVI_07,
                      SAVI_02,SAVI_03,SAVI_04,SAVI_05,SAVI_06,SAVI_07,
                      ISSE)


plot(raster_stack)

# Exportar Raster Stack
setwd("DIRETORIO2/SUBPASTA")
myStack <- writeRaster(raster_stack,"Cov_Stack1.tif", format="GTiff", overwrite = TRUE)

test <- rast(raster_stack)
terra::writeRaster(test, "Cov_Stack2.tif")

