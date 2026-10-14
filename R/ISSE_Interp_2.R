"Fonte do Script - http://jonkatz2.github.io/2017/11/15/interpolating-points-to-raster-in-r"

library(sp)
library(rgdal)
library(raster)
library(gstat)
library(caret)
library(sf)
library(terra)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################

# ADECO SUBAREA 15
# Abrir ISSE
setwd("DIRETORIO/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A10.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A10_1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A10_2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A10_3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A10_4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A10_5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A10_6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

b1_part <- createDataPartition(b1$b1, times=1, p=.9988, list=FALSE)
b2_part <- createDataPartition(b2$b2, times=1, p=.9988, list=FALSE)
b3_part <- createDataPartition(b3$b3, times=1, p=.9988, list=FALSE)
b4_part <- createDataPartition(b4$b4, times=1, p=.9988, list=FALSE)
b5_part <- createDataPartition(b5$b5, times=1, p=.9988, list=FALSE)
b6_part <- createDataPartition(b6$b6, times=1, p=.9988, list=FALSE)

str(b4)
b1  <- b1[-b1_part, ]
b2  <- b2[-b2_part, ]
b3  <- b3[-b3_part, ]
b4  <- b4[-b4_part, ]
b5  <- b5[-b5_part, ]
b6  <- b6[-b6_part, ]


# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Fellipe/BENRI/Interpolation/A10/R10.tif')
#spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))

vt <- rgdal::readOGR(dsn='C:/Fellipe/BENRI/Shapefiles/ARAPORA_2023_Dissolve.shp')#, layer='Adeco_Subarea_1.shp')
#vt <- sp::spTransform(vt, CRS(proj4string(dem)))

#counties <- rgdal::readOGR(dsn='C:/Fellipe/BENRI/Interpolation/A9/A9.shp')#, layer='Boundary_CNTYBNDS_poly')

#counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, xyOnly=TRUE, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax,xyOnly=TRUE, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################

# ADECO SUBAREA 14
# Abrir ISSE
setwd("DIRETORIO2/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A14.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A14.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A14.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A14.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A14.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A14.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A14.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_14/R14.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_14/A14.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_14/A14.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, xyOnly=TRUE, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO3/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO4/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO5/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO6/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO7/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO8/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)


###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################

# ADECO SUBAREA 16
# Abrir ISSE
setwd("DIRETORIO9/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A16.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A16.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A16.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A16.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A16.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A16.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A16.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_16/R16.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_16/A16.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_16/A16.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO10/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO11/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO12/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO13/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO14/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO15/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################

# ADECO SUBAREA 17
# Abrir ISSE
setwd("DIRETORIO16/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A17.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A17.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A17.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A17.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A17.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A17.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A17.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_17/R17.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_17/A17.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_17/A17.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO17/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO18/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO19/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO20/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO21/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO22/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 18
# Abrir ISSE
setwd("DIRETORIO23/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A18.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A18.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A18.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A18.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A18.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A18.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A18.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_18/R18.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_18/A18.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_18/A18.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO24/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO25/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO26/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO27/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO28/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO29/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 19
# Abrir ISSE
setwd("DIRETORIO30/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A19.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A19.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A19.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A19.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A19.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A19.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A19.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_19/R19.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_19/A19.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_19/A19.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO31/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO32/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO33/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO34/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO35/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO36/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO37/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A20.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A20.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A20.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A20.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A20.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A20.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A20.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_20/R20.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_20/A20.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_20/A20.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO38/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO39/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO40/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO41/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO42/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO43/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO44/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A21.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A21.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A21.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A21.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A21.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A21.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A21.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_21/R21.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_21/A21.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_21/A21.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO45/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO46/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO47/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO48/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO49/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO50/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 22
# Abrir ISSE
setwd("DIRETORIO51/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A22.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A22.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A22.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A22.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A22.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A22.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A22.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_22/R22.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_22/A22.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_22/A22.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO52/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO53/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO54/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO55/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO56/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO57/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)


###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20


###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO58/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A24.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A24.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A24.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A24.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A24.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A24.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A24.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_24/R24.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_24/A24.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_24/A24.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO59/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO60/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO61/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO62/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO63/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO64/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO65/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A25.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A25.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A25.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A25.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A25.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A25.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A25.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_25/R25.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_25/A25.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_25/A25.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO66/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO67/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO68/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO69/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO70/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO71/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO72/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A26.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A26.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A26.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A26.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A26.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A26.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A26.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_26/R26.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_26/A26.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_26/A26.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO73/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO74/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO75/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO76/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO77/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO78/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO79/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A27.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A27.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A27.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A27.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A27.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A27.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A27.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_27/R27.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_27/A27.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_27/A27.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO80/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO81/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO82/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO83/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO84/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO85/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO86/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A28.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A28.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A28.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A28.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A28.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A28.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A28.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_28/R28.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_28/A28.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_28/A28.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO87/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO88/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO89/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO90/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO91/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO92/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO93/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A29.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A29.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A29.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A29.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A29.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A29.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A29.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_29/R29.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_29/A29.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_29/A29.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO94/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO95/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO96/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO97/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO98/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO99/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO100/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A30.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A30.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A30.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A30.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A30.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A30.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A30.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_30/R30.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_30/A30.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_30/A30.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO101/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO102/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO103/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO104/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO105/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO106/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO107/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A31.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A31.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A31.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A31.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A31.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A31.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A31.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_31/R31.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_31/A31.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_31/A31.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO108/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO109/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO110/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO111/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO112/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO113/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO114/SUBPASTA")
list.files()
ISSE <- stack("SYSI_32.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_32.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_32.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_32.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_32.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_32.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_32.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_32/R32.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_32/A32.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_32/A32.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO115/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO116/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO117/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO118/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO119/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO120/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO121/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A33.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A33.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A33.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A33.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A33.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A33.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A33.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_33/R33.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_33/A33.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_33/A33.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO122/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO123/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO124/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO125/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO126/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO127/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO128/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A34.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A34.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A34.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A34.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A34.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A34.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A34.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_34/R34.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_34/A34.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_34/A34.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO129/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO130/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO131/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO132/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO133/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO134/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)


###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################
###################################################################################################################################################


# ADECO SUBAREA 20
# Abrir ISSE
setwd("DIRETORIO135/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A35.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudan?a para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A35.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A35.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A35.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A35.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A35.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A35.6, xy=TRUE)

# Renomear vari?veis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')

# na.omit - Remover NA das vari?veis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)

# B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1B1
spdat2 <- sp::SpatialPointsDataFrame(
  coords=b1[,c('x', 'y')],
  data=b1,
  proj4string = CRS("+init=epsg:4326"))

dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_35/R35.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_35/A35.shp')#, layer='Adeco_Subarea_1.shp')

vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_35/A35.shp')#, layer='Boundary_CNTYBNDS_poly')

counties <- sp::spTransform(counties, CRS(proj4string(dem)))

fitmax <- gstat::gstat(formula = b1 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO136/SUBPASTA")
writeRaster(vtmaxsm, "./B1", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2B2

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b2[,c('x', 'y')],
  data=b2,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b2 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO137/SUBPASTA")
writeRaster(vtmaxsm, "./B2", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3B3

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b3[,c('x', 'y')],
  data=b3,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b3 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO138/SUBPASTA")
writeRaster(vtmaxsm, "./B3", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4B4

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b4[,c('x', 'y')],
  data=b4,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b4 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO139/SUBPASTA")
writeRaster(vtmaxsm, "./B4", format = "GTiff", datatype = "FLT4S", overwrite = T)


# B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5B5

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b5[,c('x', 'y')],
  data=b5,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b5 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO140/SUBPASTA")
writeRaster(vtmaxsm, "./B5", format = "GTiff", datatype = "FLT4S", overwrite = T)

# B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6B6

spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))

fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)

# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)

setwd("DIRETORIO141/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)
