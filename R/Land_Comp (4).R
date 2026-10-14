library(raster)

list.files()
# Abrir ISSE
setwd("DIRETORIO/SUBPASTA")
ISSE <- stack("SYSI.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  
ISSE[ISSE < 0] <- NA  
plot(ISSE)

# Get a list of raster files in the directory
raster_files <- list.files(pattern = "\\.tif$")

# Create an empty list to store resampled rasters
resampled_rasters <- list()

# Append ISSE to the list
resampled_rasters[["ISSE"]] <- ISSE

# Loop through each raster file
for (file in raster_files) {
  # Load raster
  current_raster <- raster(file)
  
  # Resample raster using ISSE as reference
  current_raster <- resample(current_raster, ISSE, method = "ngb")
  
  # Append resampled raster to the list
  resampled_rasters[[file]] <- current_raster
}

# Create a raster stack from the list of resampled rasters
resampled_stack <- stack(resampled_rasters)

plot(resampled_stack)

################################################################################
library(cluster)
library(randomForest)

valores <- getValues(resampled_stack)
index <- which(!is.na(valores))
valores <- na.omit(valores)

resultadoClara <- clara(valores, k = 5, samples = 500, metric = "manhattan", pamLike = FALSE)
imagemClara <- raster(resampled_stack)
imagemClara[index] <- resultadoClara$clustering

plot(imagemClara)

setwd("DIRETORIO2/SUBPASTA")
writeRaster(imagemClara,   "ZM_K10.tif",   overwrite=TRUE)
################################################################################
imagemAmostra <- valores[sample(nrow(valores), 500),]
rf <- randomForest(imagemAmostra)
rf_prox <- randomForest(imagemAmostra, ntree=1000, proximity = TRUE)$proximity

E_rf <- kmeans(rf_prox, 5)
rf <- randomForest(imagemAmostra, as.factor(E_rf$cluster), ntree = 500)
rf_raster <- predict(resampled_stack, rf)

plot(rf_raster)
setwd("DIRETORIO3/SUBPASTA")
writeRaster(rf_raster,   "ZM_Ester.tif",   overwrite=TRUE)
################################################################################
