library(raster)

setwd("DIRETORIO/SUBPASTA")
list.files(pattern = "\\.tif$")


setwd("DIRETORIO2/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE1 <- stack("Bare_2002_04.tif") ##before the / is the folder name
ISSE1[ISSE1 == 0] <- NA  ##set 0 values as NA
ISSE1[ISSE1 < 0] <- NA  ##set 0 values as NA
#ISSE1 <- resample(ISSE_Ref, ISSE1, method = "ngb")

setwd("DIRETORIO3/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE2 <- stack("Bare_2002_07.tif") ##before the / is the folder name
ISSE2[ISSE2 == 0] <- NA  ##set 0 values as NA
ISSE2[ISSE2 < 0] <- NA  ##set 0 values as NA
#ISSE2 <- resample(ISSE_Ref, ISSE2, method = "ngb")

setwd("DIRETORIO4/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE3 <- stack("Bare_2003_10.tif") ##before the / is the folder name
ISSE3[ISSE3 == 0] <- NA  ##set 0 values as NA
ISSE3[ISSE3 < 0] <- NA  ##set 0 values as NA
#ISSE3 <- resample(ISSE3, ISSE, method = "ngb")

setwd("DIRETORIO5/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE4 <- stack("Bare_2004_03.tif") ##before the / is the folder name
ISSE4[ISSE4 == 0] <- NA  ##set 0 values as NA
ISSE4[ISSE4 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO6/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE5 <- stack("Bare_2004_04.tif") ##before the / is the folder name
ISSE5[ISSE5 == 0] <- NA  ##set 0 values as NA
ISSE5[ISSE5 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO7/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE6 <- stack("Bare_2004_08.tif") ##before the / is the folder name
ISSE6[ISSE6 == 0] <- NA  ##set 0 values as NA
ISSE6[ISSE6 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO8/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE7 <- stack("Bare_2005_04.tif") ##before the / is the folder name
ISSE7[ISSE7 == 0] <- NA  ##set 0 values as NA
ISSE7[ISSE7 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO9/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE8 <- stack("Bare_2005_06.tif") ##before the / is the folder name
ISSE8[ISSE8 == 0] <- NA  ##set 0 values as NA
ISSE8[ISSE8 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO10/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE9 <- stack("Bare_2005_07.tif") ##before the / is the folder name
ISSE9[ISSE9 == 0] <- NA  ##set 0 values as NA
ISSE9[ISSE9 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO11/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE10 <- stack("Bare_2005_08.tif") ##before the / is the folder name
ISSE10[ISSE10 == 0] <- NA  ##set 0 values as NA
ISSE10[ISSE10 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO12/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE11 <- stack("Bare_2005_11.tif") ##before the / is the folder name
ISSE11[ISSE11 == 0] <- NA  ##set 0 values as NA
ISSE11[ISSE11 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO13/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE12 <- stack("Bare_2006_04.tif") ##before the / is the folder name
ISSE12[ISSE12 == 0] <- NA  ##set 0 values as NA
ISSE12[ISSE12 < 0] <- NA  ##set 0 values as NA
#ISSE2 <- resample(ISSE_Ref, ISSE2, method = "ngb")

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE13 <- stack("Bare_Merge_2.tif") ##before the / is the folder name
ISSE13[ISSE13 == 0] <- NA  ##set 0 values as NA
ISSE13[ISSE13 < 0] <- NA  ##set 0 values as NA
#ISSE3 <- resample(ISSE3, ISSE, method = "ngb")


ISSE_Merge <- mosaic(ISSE1,ISSE2,ISSE3,ISSE4,ISSE5,ISSE6,ISSE7,ISSE8,ISSE9,ISSE10,ISSE11,
                     ISSE12,ISSE13, fun=median)

# Save the predicted map##
setwd("DIRETORIO/SUBPASTA")
# Salvar Resultados 25-50cm
writeRaster(ISSE_Merge, "Bare_Merge_3.tif", overwrite=TRUE)



















setwd("DIRETORIO14/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE14 <- stack("Bare_1995_09.tif") ##before the / is the folder name
ISSE14[ISSE14 == 0] <- NA  ##set 0 values as NA
ISSE14[ISSE14 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO15/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE15 <- stack("Bare_1995_11.tif") ##before the / is the folder name
ISSE15[ISSE15 == 0] <- NA  ##set 0 values as NA
ISSE15[ISSE15 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO16/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE16 <- stack("Bare_1996_05.tif") ##before the / is the folder name
ISSE16[ISSE16 == 0] <- NA  ##set 0 values as NA
ISSE16[ISSE16 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO17/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE17 <- stack("Bare_1996_08.tif") ##before the / is the folder name
ISSE17[ISSE17 == 0] <- NA  ##set 0 values as NA
ISSE17[ISSE17 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO18/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE18 <- stack("Bare_1996_11.tif") ##before the / is the folder name
ISSE18[ISSE18 == 0] <- NA  ##set 0 values as NA
ISSE18[ISSE18 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO19/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE19 <- stack("Bare_1997_06.tif") ##before the / is the folder name
ISSE19[ISSE19 == 0] <- NA  ##set 0 values as NA
ISSE19[ISSE19 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO20/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE20 <- stack("Bare_1997_07.tif") ##before the / is the folder name
ISSE20[ISSE20 == 0] <- NA  ##set 0 values as NA
ISSE20[ISSE20 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO21/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE21 <- stack("Bare_1997_08.tif") ##before the / is the folder name
ISSE21[ISSE21 == 0] <- NA  ##set 0 values as NA
ISSE21[ISSE21 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO22/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE22 <- stack("Bare_1997_09.tif") ##before the / is the folder name
ISSE22[ISSE22 == 0] <- NA  ##set 0 values as NA
ISSE22[ISSE22 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO23/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE23 <- stack("Bare_1998_07.tif") ##before the / is the folder name
ISSE23[ISSE23 == 0] <- NA  ##set 0 values as NA
ISSE23[ISSE23 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO24/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE24 <- stack("Bare_1999_03.tif") ##before the / is the folder name
ISSE24[ISSE24 == 0] <- NA  ##set 0 values as NA
ISSE24[ISSE24 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO25/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE25 <- stack("Bare_1999_08.tif") ##before the / is the folder name
ISSE25[ISSE25 == 0] <- NA  ##set 0 values as NA
ISSE25[ISSE25 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO26/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE26 <- stack("Bare_1999_09.tif") ##before the / is the folder name
ISSE26[ISSE26 == 0] <- NA  ##set 0 values as NA
ISSE26[ISSE25 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO27/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE27 <- stack("Bare_2000_06.tif") ##before the / is the folder name
ISSE27[ISSE27 == 0] <- NA  ##set 0 values as NA
ISSE27[ISSE27 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO28/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE28 <- stack("Bare_2000_09.tif") ##before the / is the folder name
ISSE28[ISSE28 == 0] <- NA  ##set 0 values as NA
ISSE28[ISSE28 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO29/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE29 <- stack("Bare_2000_10.tif") ##before the / is the folder name
ISSE29[ISSE29 == 0] <- NA  ##set 0 values as NA
ISSE29[ISSE29 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO30/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE30 <- stack("Bare_2001_06.tif") ##before the / is the folder name
ISSE30[ISSE30 == 0] <- NA  ##set 0 values as NA
ISSE30[ISSE30 < 0] <- NA  ##set 0 values as NA

ISSE_Merge <- mosaic(ISSE1,ISSE2,ISSE3,ISSE4,ISSE5,ISSE6,ISSE7,ISSE8,ISSE9,ISSE10,ISSE11,
                     ISSE12,ISSE13,ISSE14,ISSE15,ISSE16,ISSE17,ISSE18,ISSE19,ISSE20,ISSE21,
                     ISSE22,ISSE23,ISSE24,ISSE25,ISSE26,ISSE27,ISSE28,ISSE29,ISSE30,fun=median)

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE <- stack("Bare_Merge_1.tif") ##before the / is the folder name
ISSE[ISSE == 0] <- NA  ##set 0 values as NA
ISSE[ISSE < 0] <- NA  ##set 0 values as NA

ISSE_Merge2 <- mosaic(ISSE_Merge,ISSE, fun=median)


# Save the predicted map##
setwd("DIRETORIO/SUBPASTA")
# Salvar Resultados 25-50cm
writeRaster(ISSE_Merge, "Bare_Merge_2.tif", overwrite=TRUE)


















setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE31 <- stack("Bare_L8_2020_08.tif") ##before the / is the folder name
ISSE31[ISSE31 == 0] <- NA  ##set 0 values as NA
ISSE31[ISSE31 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE32 <- stack("Bare_L8_2020_10.tif") ##before the / is the folder name
ISSE32[ISSE32 == 0] <- NA  ##set 0 values as NA
ISSE32[ISSE32 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE33 <- stack("Bare_L8_2021_04.tif") ##before the / is the folder name
ISSE33[ISSE33 == 0] <- NA  ##set 0 values as NA
ISSE33[ISSE33 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE34 <- stack("Bare_L8_2021_05.tif") ##before the / is the folder name
ISSE34[ISSE34 == 0] <- NA  ##set 0 values as NA
ISSE34[ISSE34 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE35 <- stack("Bare_L8_2021_06.tif") ##before the / is the folder name
ISSE35[ISSE34 == 0] <- NA  ##set 0 values as NA
ISSE35[ISSE34 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE36 <- stack("Bare_L8_2021_07.tif") ##before the / is the folder name
ISSE36[ISSE36 == 0] <- NA  ##set 0 values as NA
ISSE36[ISSE36 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE37 <- stack("Bare_L8_2021_08.tif") ##before the / is the folder name
ISSE37[ISSE37 == 0] <- NA  ##set 0 values as NA
ISSE37[ISSE37 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE38 <- stack("Bare_L8_2021_10.tif") ##before the / is the folder name
ISSE38[ISSE38 == 0] <- NA  ##set 0 values as NA
ISSE38[ISSE38 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE39 <- stack("Bare_L8_2022_04.tif") ##before the / is the folder name
ISSE39[ISSE39 == 0] <- NA  ##set 0 values as NA
ISSE39[ISSE39 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE40 <- stack("Bare_L8_2022_06.tif") ##before the / is the folder name
ISSE40[ISSE40 == 0] <- NA  ##set 0 values as NA
ISSE40[ISSE40 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE41 <- stack("Bare_L8_2022_07.tif") ##before the / is the folder name
ISSE41[ISSE41 == 0] <- NA  ##set 0 values as NA
ISSE41[ISSE41 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE42 <- stack("Bare_L8_2022_09.tif") ##before the / is the folder name
ISSE42[ISSE42 == 0] <- NA  ##set 0 values as NA
ISSE42[ISSE42 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE43 <- stack("Bare_L8_2022_10.tif") ##before the / is the folder name
ISSE43[ISSE43 == 0] <- NA  ##set 0 values as NA
ISSE43[ISSE43 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE44 <- stack("Bare_Merge_8.tif") ##before the / is the folder name
ISSE44[ISSE44 == 0] <- NA  ##set 0 values as NA
ISSE44[ISSE44 < 0] <- NA  ##set 0 values as NA

ISSE_Merge <- mosaic(ISSE1,ISSE2,ISSE3,ISSE4,ISSE5,ISSE6,ISSE7,ISSE8,ISSE9,ISSE10,ISSE11,
                     ISSE12,ISSE13,ISSE14,ISSE15,ISSE16,ISSE17,ISSE18,ISSE19,ISSE20,ISSE21,
                     ISSE22,ISSE23,ISSE24,ISSE25,ISSE26,ISSE27,ISSE28,ISSE29,ISSE30,ISSE31,
                     ISSE32,ISSE33,ISSE34,ISSE35,ISSE36,ISSE37,ISSE38,ISSE39,ISSE40,ISSE41,
                     ISSE42,ISSE43,ISSE44,fun=median)


# Save the predicted map##
setwd("DIRETORIO31/SUBPASTA")
# Salvar Resultados 25-50cm
writeRaster(ISSE_Merge, "Bare_Merge_9.tif", overwrite=TRUE)





##############################################################################################################
##############################################################################################################
##############################################################################################################
##############################################################################################################
##############################################################################################################
##############################################################################################################
##############################################################################################################















setwd("DIRETORIO32/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE10 <- stack("Bare_L5_1995_05.tif") ##before the / is the folder name
ISSE10[ISSE10 == 0] <- NA  ##set 0 values as NA
ISSE10[ISSE10 < 0] <- NA  ##set 0 values as NA
#ISSE1 <- resample(ISSE_Ref, ISSE1, method = "ngb")

setwd("DIRETORIO33/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE12 <- stack("Bare_L5_1995_10.tif") ##before the / is the folder name
ISSE12[ISSE12 == 0] <- NA  ##set 0 values as NA
ISSE12[ISSE12 < 0] <- NA  ##set 0 values as NA
#ISSE2 <- resample(ISSE_Ref, ISSE2, method = "ngb")

setwd("DIRETORIO34/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE13 <- stack("Bare_L5_1996_03.tif") ##before the / is the folder name
ISSE13[ISSE13 == 0] <- NA  ##set 0 values as NA
ISSE13[ISSE13 < 0] <- NA  ##set 0 values as NA
#ISSE3 <- resample(ISSE3, ISSE, method = "ngb")

setwd("DIRETORIO35/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE14 <- stack("Bare_L5_1996_05.tif") ##before the / is the folder name
ISSE14[ISSE14 == 0] <- NA  ##set 0 values as NA
ISSE14[ISSE14 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO36/SUBPASTA")#
### Load raster covariates, in our case, satellite image ###
ISSE15 <- stack("Bare_L5_1996_07.tif") ##before the / is the folder name
ISSE15[ISSE15 == 0] <- NA  ##set 0 values as NA
ISSE15[ISSE15 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO37/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE16 <- stack("Bare_L5_1996_09.tif") ##before the / is the folder name
ISSE16[ISSE16 == 0] <- NA  ##set 0 values as NA
ISSE16[ISSE16 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO38/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE17 <- stack("Bare_L5_1997_03.tif") ##before the / is the folder name
ISSE17[ISSE17 == 0] <- NA  ##set 0 values as NA
ISSE17[ISSE17 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO39/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE18 <- stack("Bare_L5_1997_08.tif") ##before the / is the folder name
ISSE18[ISSE18 == 0] <- NA  ##set 0 values as NA
ISSE18[ISSE18 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO40/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE19 <- stack("Bare_L5_1997_10.tif") ##before the / is the folder name
ISSE19[ISSE19 == 0] <- NA  ##set 0 values as NA
ISSE19[ISSE19 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO41/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE20 <- stack("Bare_L5_1998_09.tif") ##before the / is the folder name
ISSE20[ISSE20 == 0] <- NA  ##set 0 values as NA
ISSE20[ISSE20 < 0] <- NA  ##set 0 values as NA

ISSE_Merge <- mosaic(ISSE1, ISSE2, ISSE3, ISSE4, ISSE5, ISSE6, ISSE7,ISSE8, ISSE9, ISSE10, ISSE11,
                     ISSE12, ISSE13, ISSE14, ISSE15, ISSE16, ISSE17,ISSE18, ISSE19, ISSE20, fun=median)



# Save the predicted map##
setwd("DIRETORIO31/SUBPASTA")
# Salvar Resultados 25-50cm
writeRaster(ISSE_Merge, "Bare_Merge_5.tif", overwrite=TRUE)


'









'















setwd("DIRETORIO42/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE7 <- stack("Bare_L5_1999_07.tif") ##before the / is the folder name
ISSE7[ISSE7 == 0] <- NA  ##set 0 values as NA
ISSE7[ISSE7 < 0] <- NA  ##set 0 values as NA


setwd("DIRETORIO43/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE8 <- stack("Bare_L5_1999_10.tif") ##before the / is the folder name
ISSE8[ISSE8 == 0] <- NA  ##set 0 values as NA
ISSE8[ISSE8 < 0] <- NA  ##set 0 values as NA


setwd("DIRETORIO44/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE9 <- stack("Bare_L5_2000_04.tif") ##before the / is the folder name
ISSE9[ISSE9 == 0] <- NA  ##set 0 values as NA
ISSE9[ISSE9 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO45/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE10 <- stack("Bare_L5_2000_08.tif") ##before the / is the folder name
ISSE10[ISSE10 == 0] <- NA  ##set 0 values as NA
ISSE10[ISSE10 < 0] <- NA  ##set 0 values as NA


setwd("DIRETORIO46/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE11 <- stack("Bare_L5_2001_06.tif") ##before the / is the folder name
ISSE11[ISSE11 == 0] <- NA  ##set 0 values as NA
ISSE11[ISSE11 < 0] <- NA  ##set 0 values as NA


setwd("DIRETORIO47/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE13 <- stack("Bare_L5_2001_08.tif") ##before the / is the folder name
ISSE13[ISSE13 == 0] <- NA  ##set 0 values as NA
ISSE13[ISSE13 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO48/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE14 <- stack("SYSI_BENRI_3.tif") ##before the / is the folder name
ISSE14[ISSE14 == 0] <- NA  ##set 0 values as NA
ISSE14[ISSE14 < 0] <- NA  ##set 0 values as NA


ISSE_Merge <- mosaic(ISSE1, ISSE2, ISSE3, ISSE4, ISSE5, ISSE6, ISSE7, ISSE8, ISSE9, ISSE10,
                     ISSE11,ISSE13,ISSE14,fun=median)


# Save the predicted map##
setwd("DIRETORIO48/SUBPASTA")
# Salvar Resultados 25-50cm
writeRaster(ISSE_Merge, "SYSI_BENRI_4.tif", overwrite=TRUE)






setwd("DIRETORIO48/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE14 <- stack("Bare_L5_1994_09.tif") ##before the / is the folder name
ISSE14[ISSE14 == 0] <- NA  ##set 0 values as NA
ISSE14[ISSE14 < 0] <- NA  ##set 0 values as NA

ISSE_Merge <- mosaic(ISSE1, ISSE2, ISSE3, ISSE4, ISSE5, ISSE6, ISSE7, ISSE8, ISSE9, ISSE10,
                     ISSE11,ISSE13,ISSE14,fun=median)


# Save the predicted map##
setwd("DIRETORIO48/SUBPASTA")
# Salvar Resultados 25-50cm
writeRaster(ISSE_Merge, "SYSI_BENRI_1.tif", overwrite=TRUE)















setwd("DIRETORIO49/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE14 <- stack("Bare_L8_2015_09.tif") ##before the / is the folder name
ISSE14[ISSE14 == 0] <- NA  ##set 0 values as NA
ISSE14[ISSE14 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO50/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE15 <- stack("Bare_L8_2016_04.tif") ##before the / is the folder name
ISSE15[ISSE15 == 0] <- NA  ##set 0 values as NA
ISSE15[ISSE15 < 0] <- NA  ##set 0 values as NA


setwd("DIRETORIO51/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE16 <- stack("Bare_L8_2016_06.tif") ##before the / is the folder name
ISSE16[ISSE16 == 0] <- NA  ##set 0 values as NA
ISSE16[ISSE16 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO52/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE17 <- stack("Bare_L8_2016_08.tif") ##before the / is the folder name
ISSE17[ISSE17 == 0] <- NA  ##set 0 values as NA
ISSE17[ISSE17 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO53/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE18 <- stack("Bare_L8_2017_05.tif") ##before the / is the folder name
ISSE18[ISSE18 == 0] <- NA  ##set 0 values as NA
ISSE18[ISSE18 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO54/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE19 <- stack("Bare_L8_2017_07.tif") ##before the / is the folder name
ISSE19[ISSE19 == 0] <- NA  ##set 0 values as NA
ISSE19[ISSE19 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO55/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE20 <- stack("Bare_L8_2017_09.tif") ##before the / is the folder name
ISSE20[ISSE20 == 0] <- NA  ##set 0 values as NA
ISSE20[ISSE20 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO56/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE21 <- stack("Bare_L8_2018_05.tif") ##before the / is the folder name
ISSE21[ISSE21 == 0] <- NA  ##set 0 values as NA
ISSE21[ISSE21 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO57/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE22 <- stack("Bare_L8_2018_07.tif") ##before the / is the folder name
ISSE22[ISSE22 == 0] <- NA  ##set 0 values as NA
ISSE22[ISSE22 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO58/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE23 <- stack("Bare_L8_2018_10.tif") ##before the / is the folder name
ISSE23[ISSE23 == 0] <- NA  ##set 0 values as NA
ISSE23[ISSE23 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO59/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE24 <- stack("Bare_L8_2019_08.tif") ##before the / is the folder name
ISSE24[ISSE24 == 0] <- NA  ##set 0 values as NA
ISSE24[ISSE24 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO60/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE25 <- stack("SYSI_A3.tif") ##before the / is the folder name
ISSE25[ISSE25 == 0] <- NA  ##set 0 values as NA
ISSE25[ISSE25 < 0] <- NA  ##set 0 values as NA

ISSE_Merge <- mosaic(ISSE1, ISSE2, ISSE3, ISSE4, ISSE5, ISSE6, ISSE7, ISSE8, ISSE9, ISSE10,
                     ISSE11,ISSE12,ISSE13,ISSE14,ISSE15,ISSE16,ISSE17,ISSE18,ISSE19,ISSE20,
                     ISSE21,ISSE22,ISSE23,ISSE24,ISSE25,fun=median)

# Save the predicted map##
setwd("DIRETORIO60/SUBPASTA")
# Salvar Resultados 25-50cm
writeRaster(ISSE_Merge, "SYSI_A3_2.tif", overwrite=TRUE)














setwd("DIRETORIO61/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE25 <- stack("Bare_L5_2000_09.tif") ##before the / is the folder name
ISSE25[ISSE25 == 0] <- NA  ##set 0 values as NA
ISSE25[ISSE25 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO62/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE26 <- stack("Bare_L5_2003_09.tif") ##before the / is the folder name
ISSE26[ISSE26 == 0] <- NA  ##set 0 values as NA
ISSE26[ISSE26 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO63/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE27 <- stack("Bare_L5_2003_10.tif") ##before the / is the folder name
ISSE27[ISSE27 == 0] <- NA  ##set 0 values as NA
ISSE27[ISSE27 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO64/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE28 <- stack("Bare_L5_2004_08.tif") ##before the / is the folder name
ISSE28[ISSE28 == 0] <- NA  ##set 0 values as NA
ISSE28[ISSE28 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO65/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE29 <- stack("Bare_L5_2005_05.tif") ##before the / is the folder name
ISSE29[ISSE29 == 0] <- NA  ##set 0 values as NA
ISSE29[ISSE29 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO66/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE30 <- stack("Bare_L5_2005_07.tif") ##before the / is the folder name
ISSE30[ISSE30 == 0] <- NA  ##set 0 values as NA
ISSE30[ISSE30 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO67/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE31 <- stack("Bare_L5_2005_08.tif") ##before the / is the folder name
ISSE31[ISSE31 == 0] <- NA  ##set 0 values as NA
ISSE31[ISSE31 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO68/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE32 <- stack("Bare_L5_2006_04.tif") ##before the / is the folder name
ISSE32[ISSE32 == 0] <- NA  ##set 0 values as NA
ISSE32[ISSE32 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO69/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE33 <- stack("Bare_L5_2006_06.tif") ##before the / is the folder name
ISSE33[ISSE33 == 0] <- NA  ##set 0 values as NA
ISSE33[ISSE33 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO70/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE34 <- stack("Bare_L5_2006_07.tif") ##before the / is the folder name
ISSE34[ISSE33 == 0] <- NA  ##set 0 values as NA
ISSE34[ISSE33 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO71/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE35 <- stack("Bare_L5_2007_06.tif") ##before the / is the folder name
ISSE35[ISSE35 == 0] <- NA  ##set 0 values as NA
ISSE35[ISSE35 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO72/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE36 <- stack("Bare_L5_2007_08.tif") ##before the / is the folder name
ISSE36[ISSE36 == 0] <- NA  ##set 0 values as NA
ISSE36[ISSE36 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO73/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE37 <- stack("Bare_L5_2008_06.tif") ##before the / is the folder name
ISSE37[ISSE37 == 0] <- NA  ##set 0 values as NA
ISSE37[ISSE37 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO74/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE38 <- stack("Bare_L5_2009_06.tif") ##before the / is the folder name
ISSE38[ISSE38 == 0] <- NA  ##set 0 values as NA
ISSE38[ISSE38 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO75/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE39 <- stack("Bare_L5_2009_08.tif") ##before the / is the folder name
ISSE39[ISSE39 == 0] <- NA  ##set 0 values as NA
ISSE39[ISSE39 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO76/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE40 <- stack("Bare_L5_2010_06.tif") ##before the / is the folder name
ISSE40[ISSE40 == 0] <- NA  ##set 0 values as NA
ISSE40[ISSE40 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO77/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE41 <- stack("Bare_L5_2010_07.tif") ##before the / is the folder name
ISSE41[ISSE41 == 0] <- NA  ##set 0 values as NA
ISSE41[ISSE41 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO78/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE42 <- stack("Bare_L5_2011_07.tif") ##before the / is the folder name
ISSE42[ISSE42 == 0] <- NA  ##set 0 values as NA
ISSE42[ISSE42 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO79/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE43 <- stack("Bare_L5_2011_08.tif") ##before the / is the folder name
ISSE43[ISSE43 == 0] <- NA  ##set 0 values as NA
ISSE43[ISSE43 < 0] <- NA  ##set 0 values as NA

setwd("DIRETORIO80/SUBPASTA")
### Load raster covariates, in our case, satellite image ###
ISSE44 <- stack("Bare_L5_2011_09.tif") ##before the / is the folder name
ISSE44[ISSE44 == 0] <- NA  ##set 0 values as NA
ISSE44[ISSE44 < 0] <- NA  ##set 0 values as NA



ISSE_Merge <- mosaic(ISSE1, ISSE2, ISSE3, ISSE4, ISSE5, ISSE6, ISSE7, ISSE8, ISSE9, ISSE10,
                     ISSE11,ISSE12,ISSE13,ISSE14,ISSE15,ISSE16,ISSE17,ISSE18,ISSE19,ISSE20,
                     ISSE21,ISSE22,ISSE23,ISSE24,ISSE25,ISSE26,ISSE27,ISSE28,ISSE29,ISSE30,
                     ISSE31,ISSE32,ISSE33,ISSE34,ISSE35,ISSE36,ISSE37,ISSE38,ISSE39,ISSE40,
                     ISSE41,ISSE42,ISSE43,ISSE44,fun=median)

# Save the predicted map##
setwd("DIRETORIO60/SUBPASTA")
# Salvar Resultados 25-50cm
writeRaster(ISSE_Merge, "SYSI_A3.tif", overwrite=TRUE)


setwd("DIRETORIO81/SUBPASTA")
list.files(pattern = "\\.tif$")
### Load raster covariates, in our case, satellite image ###
ISSE_merge2 <- stack("SySI_Merge.tif") ##before the / is the folder name
ISSE33[ISSE33 == 0] <- NA  ##set 0 values as NA
ISSE33[ISSE33 < 0] <- NA  ##set 0 values as NA




t<- approxNA(ISSE_merge2, method="constant", rule=2) 


plot(t)


library(meteo)

t <- rfillspgaps(p)

p <- ISSE_merge2$SySI_Merge.1

plot(p)

################
"L5_1984_10.tif"                         
"L5_1985_06.tif"                          
"L5_1986_07.tif"                         
"L5_1988_05.tif"                          
"L5_1988_07.tif"                         
"L5_1989_05.tif"                          
"L5_1989_07.tif"                         
"L5_1990_04.tif"                          
"L5_1993_05.tif"                         
"L5_1994_04.tif"                          
"L5_1994_08.tif"                         
################
"L5_1995_05"             
"L5_1996_07"         
"L8_2013_05"         
"L8_2014_05"        
"L8_2014_08"        
"L8_2015_06"        
"L8_2015_08"        
"L8_2017_08"        
"L8_2018_07"        
"L8_2018_08"        
"L8_2019_04"           
"L8_2019_08"           
"L8_2020_05"           
"L8_2020_06"           
"L8_2020_07"           
"L8_2020_09"           
"L8_2021_05"           
"L8_2021_07"           
"L8_2022_05"           
"L8_2022_07"           
"L8_2022_08"           
 
