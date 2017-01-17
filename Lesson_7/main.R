####Team BS#############
####17-01-2017##########
####Geoscripting########
####Lesson_7 Exercise###


download.file(url = "https://raw.githubusercontent.com/GeoScripting-WUR/VectorRaster/gh-pages/data/MODIS.zip", destfile = "data/MODIS_Neth", method = 'auto')
unzip("data/MODIS_Neth", exdir="data")

Neth <- brick('data/MOD13A3.A2014001.h18v03.005.grd')


plot(Neth)

#Convert to 'normal' NDVI values
Neth_NDVI = 0.0001* Neth
plot(Neth_NDVI)


nlMunicipality <- getData('GADM',country='NLD', level=2)

#Get projection for both maps the same
nlMunicipality_proj <- spTransform(nlMunicipality, CRS(proj4string(Neth_NDVI)))

#Only select the area of the Netherlands
NDVI_mask <- mask(Neth_NDVI, mask = nlMunicipality_proj)
NDVI_mask

###### FIND the maximum NDVI for the municipality for January###
NDVI_Jan <- subset(NDVI_mask, 1)
NDVI_muni <- extract(NDVI_Jan, nlMunicipality_proj, sp=T, fun=mean, na.rm=TRUE)

plot(nlMunicipality_proj$NDVI_Jan)
tail(nlMunicipality_proj)
spplot(nlMunicipality_proj, zcol = "NDVI_Jan", col.regions= c("red", "blue", "green"))






test <- cbind(NDVI_muni,nlMunicipality_proj$NAME_2)










test2 <- data.frame(test)
colnames(test2) <- c("NDVI","Municipality")

subset(test2, test2$NDVI == max(as.numeric(as.character(test2$NDVI))))

#####Calculate NVDI for a whole year
NDVI_mask$Average <- as.numeric(rowMeans(NDVI_mask[,], na.rm=T))
NDVI_year <- extract(NDVI_mask$Average, nlMunicipality_proj, fun=mean, sp=T, na.rm=TRUE)



### to be able to plot the NDVI per municipality for the given month ###
#JointJan = merge (nlMunicipality_proj, test2, by=c("NAME_2", "Municipality"))
#JointJan


############################

nlMunicipality_proj$NDVI_Jan <- NDVI_muni





nlMunicipality_proj$NAME_2

plot(JointJan$Municipality)

plot(NDVI_mask[[1]])
plot(Neth_NDVI[[1]])
plot(nlMunicipality_proj, add=T)


str(Neth)
str(nlMunicipality@data)

