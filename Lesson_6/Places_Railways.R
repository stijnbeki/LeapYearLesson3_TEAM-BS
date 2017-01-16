##Team BS Geoscript##
##Lesson 6##
##16-01-2017##

rm(list=ls())

library(rgdal)
library(rgeos)
#Download and unzip the downloaded file #places of the Netherlands
download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-places-shape.zip", destfile = "data/Neth_places", method = 'auto')
unzip("data/Neth_places", exdir="data")

#Download and unzip the downloaded file #railways of the Netherlands
download.file(url = "http://www.mapcruzin.com/download-shapefile/netherlands-railways-shape.zip", destfile = "data/Neth_railways", method = 'auto')
unzip("data/Neth_railways", exdir="data")


#Define projection string RD_new
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")

#Read in places file in global environment
places = file.path("data","places.shp")
places <- readOGR(places, layer = ogrListLayers(places))
places_RD <- spTransform(places, prj_string_RD)

#Read in railways file in global environment
railways = file.path("data","railways.shp")
railways <- readOGR(railways, layer = ogrListLayers(railways))
railways_RD <- spTransform(railways, prj_string_RD)

#Select only the railways of type industrial railways
railways_ind = railways_RD[railways_RD$type == "industrial",]

#Create a 1000 meter buffer around the industrial railway
buff_railways = gBuffer(railways_ind[1,], width = 1000, byid=TRUE)

#Check which place is located which is in the buffer created around the industrial railways
City_buff_coords = gIntersection(places_RD, buff_railways, id=as.character(places_RD$osm_id), byid = T)

#Collect the place names and other attributes of the intersection(s)
placesnames <- places_RD[places_RD$osm_id == rownames(City_buff_coords@coords),]

plot(buff_railways)
plot(railways_ind, add=T)
plot(placesnames, add=T)

