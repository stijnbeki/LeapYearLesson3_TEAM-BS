##Team BS Geoscript##
##Lesson 6##
##16-01-2017##
rm(list=ls())

library(rgdal)
library(rgeos)

source("R_functions/LayerRD.R")
source("R_functions/CitBUF.R")

#Download and unzip the downloaded file #places of the Netherlands
download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip", destfile = "data/Neth_places", method = 'auto')
unzip("data/Neth_places", exdir="data")

#Download and unzip the downloaded file #railways of the Netherlands
download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip", destfile = "data/Neth_railways", method = 'auto')
unzip("data/Neth_railways", exdir="data")

# use the function called "LayerRD" to automatically preprocess the downloaded data and project it into RD
places_RD <- LayerRD("places")
railways_RD <- LayerRD("railways")

#Select only the railways of type industrial railways
railways_ind = railways_RD[railways_RD$type == "industrial",]

#This function called "CitBUF" is used to automatically check which cities are inside the given buffersize and give the name of this city.
#this function also plots the outcome of this request.

#the varibale here is the buffersize in (m).
CitiesInBuffer <- CitBUF(1000)

###Remarks###
# Our original plan was to do the calculation of the intersections etc seperately from the plot function.
# When doing this we found that it was very hard, because the variables needed were situated withing the function.

# We tried to improve the plot function to be able to handle large buffer sizes with multiple cities, but we didn get this working.
# Therefore now the plot will work, the buffer will increase and the location of the cities is visible, but only the lables wont work properly. 


#write name of the city and the population size.
paste(CitiesInBuffer$name,"is situated in the buffer. This city has",CitiesInBuffer$population, "inhabitants")


