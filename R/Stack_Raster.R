library(raster)
library(terra)

# Opening the rasters
# Abrir ISSE
setwd('DIRETORIO/SUBPASTA')
ISSE <- stack("SYSI_Pira_UTM.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  ##set 0 values as NA
ISSE[ISSE < 0] <- NA  ##set 0 values as NA


setwd('DIRETORIO/SUBPASTA')
list.files()
#Leitura do DEM
DEM <- list.files(paste(getwd()), pattern = "DEM.tif$")
DEM <- raster(DEM)
DEM <- resample(DEM, ISSE, method = "ngb")

#Leitura do  Slope
SLP <- list.files(paste(getwd()), pattern = "SLP.tif$")
SLP <- raster(SLP)
SLP <- resample(SLP, ISSE, method = "ngb")
plot(SLP)
#Leitura do  TWI
TWI <- list.files(paste(getwd()), pattern = "TWI.tif$")
TWI <- raster(TWI)
TWI <- resample(TWI, ISSE, method = "ngb")
plot(TWI)
#Leitura do  AHS
AHS <- list.files(paste(getwd()), pattern = "AHS.tif$")
AHS <- raster(AHS)
AHS <- resample(AHS, ISSE, method = "ngb")

#Leitura do  LSF
LSF <- list.files(paste(getwd()), pattern = "LSF.tif$")
LSF <- raster(LSF)
LSF <- resample(LSF, ISSE, method = "ngb")

#Leitura do  CNBL
CNBL <- list.files(paste(getwd()), pattern = "CNBL.tif$")
CNBL <- raster(CNBL)
CNBL <- resample(CNBL, ISSE, method = "ngb")

#Leitura do  RSP
RSP <- list.files(paste(getwd()), pattern = "RSP.tif$")
RSP <- raster(RSP)
RSP <- resample(RSP, ISSE, method = "ngb")

#Leitura do  TPI
TPI <- list.files(paste(getwd()), pattern = "TPI.tif$")
TPI <- raster(TPI)
TPI <- resample(TPI, ISSE, method = "ngb")

#Leitura do  MRI
MRI <- list.files(paste(getwd()), pattern = "MRI.tif$")
MRI <- raster(MRI)
MRI <- resample(MRI, ISSE, method = "ngb")

#Leitura do  LCV
LCV <- list.files(paste(getwd()), pattern = "LCV.tif$")
LCV <- raster(LCV)
LCV <- resample(LCV, ISSE, method = "ngb")

#Leitura do  FAC
FAC <- list.files(paste(getwd()), pattern = "FAC.tif$")
FAC <- raster(FAC)
FAC <- resample(FAC, ISSE, method = "ngb")

#Leitura do  CVI
CVI <- list.files(paste(getwd()), pattern = "CVI.tif$")
CVI <- raster(CVI)
CVI <- resample(CVI, ISSE, method = "ngb")

#Leitura do  CSC
CSC <- list.files(paste(getwd()), pattern = "CSC.tif$")
CSC <- raster(CSC)
CSC <- resample(CSC, ISSE, method = "ngb")


setwd('DIRETORIO2/SUBPASTA')
list.files()

# Leitura do EVI_05
EVI_05 <- list.files(paste(getwd()), pattern = "EVI_05.tif$")
EVI_05 <- raster(EVI_05)
EVI_05 <- resample(EVI_05, ISSE, method = "ngb")

# Leitura do EVI_07
EVI_07 <- list.files(paste(getwd()), pattern = "EVI_07.tif$")
EVI_07 <- raster(EVI_07)
EVI_07 <- resample(EVI_07, ISSE, method = "ngb")

# Leitura do EVI_08
EVI_08 <- list.files(paste(getwd()), pattern = "EVI_08.tif$")
EVI_08 <- raster(EVI_08)
EVI_08 <- resample(EVI_08, ISSE, method = "ngb")

# Leitura do EVI_12
EVI_12 <- list.files(paste(getwd()), pattern = "EVI_12.tif$")
EVI_12 <- raster(EVI_12)
EVI_12 <- resample(EVI_12, ISSE, method = "ngb")

# Leitura do NBR2_05
NBR2_05 <- list.files(paste(getwd()), pattern = "NBR2_05.tif$")
NBR2_05 <- raster(NBR2_05)
NBR2_05 <- resample(NBR2_05, ISSE, method = "ngb")

# Leitura do NBR2_07
NBR2_07 <- list.files(paste(getwd()), pattern = "NBR2_07.tif$")
NBR2_07 <- raster(NBR2_07)
NBR2_07 <- resample(NBR2_07, ISSE, method = "ngb")

# Leitura do NBR2_08
NBR2_08 <- list.files(paste(getwd()), pattern = "NBR2_08.tif$")
NBR2_08 <- raster(NBR2_08)
NBR2_08 <- resample(NBR2_08, ISSE, method = "ngb")

# Leitura do NBR2_12
NBR2_12 <- list.files(paste(getwd()), pattern = "NBR2_12.tif$")
NBR2_12 <- raster(NBR2_12)
NBR2_12 <- resample(NBR2_12, ISSE, method = "ngb")

# Leitura do NDVI_05
NDVI_05 <- list.files(paste(getwd()), pattern = "NDVI_05.tif$")
NDVI_05 <- raster(NDVI_05)
NDVI_05 <- resample(NDVI_05, ISSE, method = "ngb")

# Leitura do NDVI_07
NDVI_07 <- list.files(paste(getwd()), pattern = "NDVI_07.tif$")
NDVI_07 <- raster(NDVI_07)
NDVI_07 <- resample(NDVI_07, ISSE, method = "ngb")

# Leitura do NDVI_08
NDVI_08 <- list.files(paste(getwd()), pattern = "NDVI_08.tif$")
NDVI_08 <- raster(NDVI_08)
NDVI_08 <- resample(NDVI_08, ISSE, method = "ngb")

# Leitura do NDVI_12
NDVI_12 <- list.files(paste(getwd()), pattern = "NDVI_12.tif$")
NDVI_12 <- raster(NDVI_12)
NDVI_12 <- resample(NDVI_12, ISSE, method = "ngb")

# Leitura do SAVI_05
SAVI_05 <- list.files(paste(getwd()), pattern = "SAVI_05.tif$")
SAVI_05 <- raster(SAVI_05)
SAVI_05 <- resample(SAVI_05, ISSE, method = "ngb")

# Leitura do SAVI_07
SAVI_07 <- list.files(paste(getwd()), pattern = "SAVI_07.tif$")
SAVI_07 <- raster(SAVI_07)
SAVI_07 <- resample(SAVI_07, ISSE, method = "ngb")

# Leitura do SAVI_08
SAVI_08 <- list.files(paste(getwd()), pattern = "SAVI_08.tif$")
SAVI_08 <- raster(SAVI_08)
SAVI_08 <- resample(SAVI_08, ISSE, method = "ngb")

# Leitura do SAVI_12
SAVI_12 <- list.files(paste(getwd()), pattern = "SAVI_12.tif$")
SAVI_12 <- raster(SAVI_12)
SAVI_12 <- resample(SAVI_12, ISSE, method = "ngb")

setwd('DIRETORIO3/SUBPASTA')
list.files()

# Leitura do Clay
Clay <- list.files(paste(getwd()), pattern = "Clay.tif$")
Clay <- raster(Clay)
Clay <- resample(Clay, ISSE, method = "ngb")

# Leitura do CTC
CTC <- list.files(paste(getwd()), pattern = "CTC.tif$")
CTC <- raster(CTC)
CTC <- resample(CTC, ISSE, method = "ngb")

# Leitura do Sand
Sand <- list.files(paste(getwd()), pattern = "Sand.tif$")
Sand <- raster(Sand)
Sand <- resample(Sand, ISSE, method = "ngb")

# Leitura do Silt
Silt <- list.files(paste(getwd()), pattern = "Silt.tif$")
Silt <- raster(Silt)
Silt <- resample(Silt, ISSE, method = "ngb")

# Leitura do V
V <- list.files(paste(getwd()), pattern = "V.tif$")
V <- raster(V)
V <- resample(V, ISSE, method = "ngb")


#raster_stack <- stack(DEM,SLP,TWI,AHS,LSF,CNBL,RSP,TPI,MRI,LCV,FAC,CVI,CSC,EVI_05,EVI_07,EVI_08,EVI_12,NBR2_05,NBR2_07,NBR2_08,NBR2_12,NDVI_05,NDVI_07,
#                      NDVI_08,NDVI_12,SAVI_05,SAVI_07,SAVI_08,SAVI_12,Clay,CTC,Sand,Silt,V,ISSE)

raster_stack <- stack(EVI_05,EVI_07,EVI_08,EVI_12,NBR2_05,NBR2_07,NBR2_08,NBR2_12,NDVI_05,NDVI_07,
                      NDVI_08,NDVI_12,SAVI_05,SAVI_07,SAVI_08,SAVI_12,Clay,CTC,Sand,Silt,V,ISSE)
                      

plot(raster_stack)

setwd('DIRETORIO4/SUBPASTA')

x <- rast(raster_stack)
terra::writeRaster(x, "raster_stack3.tif")

