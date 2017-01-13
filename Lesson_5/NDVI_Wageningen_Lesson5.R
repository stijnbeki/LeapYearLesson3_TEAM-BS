##Team BS###
##Bart Middelburg & Stijn Beernink##
##13-01-2017##

#You can run everything, functions are located in map R_functions, the data will be written to a data folder.
rm(list=ls())

library(raster)
source("R_functions/ndvOver.R")
source("R_functions/cloud2NA.R")
source("R_functions/NDVI_diff.R")

#Calculate NDVI in the area of Wageningen at two different times. 
#Substract them for eachother to see the change of NDVI

#Download the two landsat files directly from Dropbox
download.file(url = 'https://www.dropbox.com/s/i1ylsft80ox6a32/LC81970242014109-SC20141230042441.tar.gz?dl=1', destfile="data/LC81970242014109-SC20141230042441.tar.gz", method='auto', mode = "wb")
download.file(url = 'https://www.dropbox.com/s/akb9oyye3ee92h3/LT51980241990098-SC20150107121947.tar.gz?dl=1',destfile="data/LT51980241990098-SC20150107121947.tar.gz", method='auto', mode = "wb")

#Unpack both packages
untar(tarfile="data/LC81970242014109-SC20141230042441.tar.gz", exdir = "data")
untar(tarfile="data/LT51980241990098-SC20150107121947.tar.gz", exdir = "data")

#List all the files in the data folder, split up for Landsat 5 and 8
List_LC8 <- list.files('data', pattern = glob2rx('LC8*.tif'), full.names = TRUE)#2014-day 109
List_LT5 <- list.files('data', pattern = glob2rx('LT5*.tif'), full.names = TRUE)#1990-day 98

# test if import worked correctly
plot(raster(List_LC8[1])) 
plot(raster(List_LT5[1]))

#Stack
LC8 <- stack(List_LC8)
LT5 <- stack(List_LT5)

#drop layers that are not needed for the calculation to speed up computation time

LC8_drop<- dropLayer(LC8, c(2:4,7:9))
LT5_drop<- dropLayer(LT5, c(2:5,8:15))

#Project to make sure that both raster are aligned correctly ##doesn't work
origin(LC8_drop) == origin(LT5_drop)
crs(LC8_drop)@projargs == crs(LT5_drop)@projargs

#So the origin is not the same. We thought that we need to project.
#This introduces strange one part of the map becomes NA's, extent stays the same.
#Dainius agreed that we don't run projectRaster in order to finish the exercise.
#Error maybe not that large, but we don't understand what went wrong
#LT5_drop_proj <- projectRaster(LT5_drop, LC8_drop)

#Crop both images to each other to end up with the extent where both images have values
LC8_crop <- crop(LC8_drop, LT5_drop)
LT5_crop <- crop(LT5_drop, LC8_crop)


#####Remove the clouds, water, cloudshadow using the mask layer#######
LC8_CloudFree <- overlay(x = LC8_crop[[c(2,3)]], y = LC8_crop[[1]], fun = cloud2NA)
LT5_CloudFree <- overlay(x = LT5_crop[[c(2,3)]], y = LT5_crop[[1]], fun = cloud2NA)


#Calculate the NDVI using a function
ndvi_LC8 <- overlay(x=LC8_CloudFree[[1]], y=LC8_CloudFree[[2]], fun=ndvOver)
ndvi_LT5 <- overlay(x=LT5_CloudFree[[1]], y=LT5_CloudFree[[2]], fun=ndvOver)

# This takes out strange high or low numbers #data filtering. NDVI should only have numbers between -1 <> 1.
ndvi_LT5[ndvi_LT5 > 1 | ndvi_LT5 < -1] <- NA
ndvi_LC8[ndvi_LC8 > 1 | ndvi_LC8 < -1] <- NA

#save files for later use
writeRaster(x=ndvi_LT5, filename='NDVI_1990_area_Wageningen.grd', datatype='FLT4S')
writeRaster(x=ndvi_LC8, filename='NDVI_2014_area_Wageningen.grd', datatype='FLT4S')

###Plot the NDVI for both landsat images.
plot(ndvi_LT5, main = "The Landsat 5 Image")
plot(ndvi_LC8, main = "The Landsat 8 Image")


###Calculate the difference of the NDVI in both years: 2014 minus 1990

NDVI_diff_Wageningen = overlay(x = ndvi_LC8, y = ndvi_LT5, fun = NDVI_diff)

writeRaster(x=NDVI_diff_Wageningen, filename='NDVI_diff_Wageningen_2014_1990.grd', datatype='FLT4S')

spplot(NDVI_diff_Wageningen, main ="Difference NDVI Wageningen 2014 minus 1990")


###Extra kml file to visualise the output of our small project. You can plot the outcome using GoogleEarth
NDVI_diff_wag_proj <- projectRaster(NDVI_diff_Wageningen, crs='+proj=longlat')
KML(x = NDVI_diff_wag_proj, filename='NDVI_diff_area_Wageningen.kml')
