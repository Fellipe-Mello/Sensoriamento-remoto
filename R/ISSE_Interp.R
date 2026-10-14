library(sp)
library(rgdal)
library(raster)
library(gstat)
library(caret)
#source('mapFunctions.R') # Adapted from from http://www.jstatsoft.org/v19/c01/paper
#source('http://www.math.mcmaster.ca/bolker/R/misc/legendx.R')


# Abrir ISSE
setwd("DIRETORIO/SUBPASTA")
list.files()
ISSE <- stack("SYSI_A2.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA 

# Mudança para DF com XY
b1 <- as.data.frame(ISSE$SYSI_A2.1, xy=TRUE)
b2 <- as.data.frame(ISSE$SYSI_A2.2, xy=TRUE)
b3 <- as.data.frame(ISSE$SYSI_A2.3, xy=TRUE)
b4 <- as.data.frame(ISSE$SYSI_A2.4, xy=TRUE)
b5 <- as.data.frame(ISSE$SYSI_A2.5, xy=TRUE)
b6 <- as.data.frame(ISSE$SYSI_A2.6, xy=TRUE)

# Renomear variáveis
colnames(b1) <- c('x', 'y', 'b1')
colnames(b2) <- c('x', 'y', 'b2')
colnames(b3) <- c('x', 'y', 'b3')
colnames(b4) <- c('x', 'y', 'b4')
colnames(b5) <- c('x', 'y', 'b5')
colnames(b6) <- c('x', 'y', 'b6')


# na.omit - Remover NA das variáveis
b1 <- na.omit(b1)
b2 <- na.omit(b2)
b3 <- na.omit(b3)
b4 <- na.omit(b4)
b5 <- na.omit(b5)
b6 <- na.omit(b6)


'#partition data frame into training and testing sets
train_indices <- createDataPartition(b1$x, times=1, p=.6, list=FALSE)


#create training set
b1_ <- b1[train_indices , ]
b1_ <- as.data.frame(b1_)
str(b1)
str(b1_)'


spdat2 <- sp::SpatialPointsDataFrame(
  coords=b6[,c('x', 'y')],
  data=b6,
  proj4string = CRS("+init=epsg:4326"))



dem <- raster::raster('C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_2/R1.tif')
spdat <- sp::spTransform(spdat2, CRS(proj4string(dem)))
vt <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_2/A2.shp')#, layer='Adeco_Subarea_1.shp')


vt <- sp::spTransform(vt, CRS(proj4string(dem)))
counties <- rgdal::readOGR(dsn='C:/Dados_Espaciais/Adeco/ISSE_Subareas/Area_2/A2.shp')#, layer='Boundary_CNTYBNDS_poly')

#plot(counties)

counties <- sp::spTransform(counties, CRS(proj4string(dem)))
#plot(dem, col=terrain.colors(255))
#plot(vt, add=TRUE)
#plot(spdat2, add=TRUE)



fitmax <- gstat::gstat(formula = b6 ~ 1, data = spdat2, nmax = 4, set = list(idp = .5))
maxint <- raster::interpolate(dem, model=fitmax, ext=vt)
#plot(maxint, col=rev(heat.colors(255)), ext=vt)
#plot(vt, add=TRUE)


# smooth with a local average that automatically removes NA values
fmean <- function(x) mean(x, na.rm=TRUE)
# pad allows the function to run all of the way to the edges
vtmaxsm <- raster::focal(maxint, w=matrix(1, 101, 101), fmean, pad=TRUE)
#plot(vtmaxsm, col=rev(heat.colors(255)), ext=vt)
#plot(vt, add=TRUE)



setwd("DIRETORIO2/SUBPASTA")
writeRaster(vtmaxsm, "./B6", format = "GTiff", datatype = "FLT4S", overwrite = T)

