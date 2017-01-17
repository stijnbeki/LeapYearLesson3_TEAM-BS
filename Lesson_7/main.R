####Team BS#############
####17-01-2017##########
####Geoscripting########
####Lesson_7 Exercise###

rm(list=ls())
library(raster)

source("R_functions/Download_Brick.R")

#download, unzip and brick the InputData#
Neth <- Download_Brick("https://raw.githubusercontent.com/GeoScripting-WUR/VectorRaster/gh-pages/data/MODIS.zip")

#Convert to 'normal' NDVI values
Neth_NDVI = 0.0001* Neth
nlMunicipality <- getData('GADM',country='NLD', level=2)

#Get projection for both maps the same
nlMunicipality_proj <- spTransform(nlMunicipality, CRS(proj4string(Neth_NDVI)))

#Only select the area of the Netherlands
NDVI_mask <- mask(Neth_NDVI, mask = nlMunicipality_proj)


###### HERE we find the maximum NDVI for every month ###

###### January###
NDVI_Jan <- subset(NDVI_mask, 1)
NDVI_Jan_Mun <- extract(NDVI_Jan, nlMunicipality_proj, fun=mean, na.rm=TRUE, sp=T)
max_NDVI_JAN <- subset(NDVI_Jan_Mun$NAME_2, NDVI_Jan_Mun$January == (max(NDVI_Jan_Mun$January, na.rm = T)))
max_NDVI_JAN
#plot
colfunc <- colorRampPalette(c("red", "green"))
spplot(NDVI_Jan_Mun, zcol = "January", col.regions= colfunc(30), main="NDVI in January")

###### Augustus###
NDVI_Aug <- subset(NDVI_mask, 8)
NDVI_Aug_Mun <- extract(NDVI_Aug, nlMunicipality_proj, fun=mean, na.rm=TRUE, sp=T)
max_NDVI_Aug <- subset(NDVI_Aug_Mun$NAME_2, NDVI_Aug_Mun$August == (max(NDVI_Aug_Mun$August, na.rm = T)))
max_NDVI_Aug
#plot

spplot(NDVI_Aug_Mun, zcol = "August", col.regions= colfunc(30),main="NDVI in August") 

#####whole year########
NDVI_mask$Average <- as.numeric(rowMeans(NDVI_mask[,], na.rm=T))
NDVI_year_Mun <- extract(NDVI_mask$Average, nlMunicipality_proj, sp=T, fun=mean, na.rm=TRUE)
max_NDVI_Year <- subset(NDVI_year_Mun$NAME_2, NDVI_year_Mun$Average == (max(NDVI_year_Mun$Average, na.rm = T)))
max_NDVI_Year
#plot

spplot(NDVI_year_Mun, zcol = "Average", col.regions= colfunc(30), main="NDVI for whole year")

#conclusion
print(paste("For January the greenest municipality:",max_NDVI_JAN,"For August:",max_NDVI_Aug,"and for the whole year:",max_NDVI_Year))


####NICE plot####
#Make nice plot
plot_mun_jan <- subset(nlMunicipality_proj, nlMunicipality_proj$NAME_2 == max_NDVI_JAN)
plot_mun_aug <- subset(nlMunicipality_proj, nlMunicipality_proj$NAME_2 == max_NDVI_Aug)
plot_mun_year <- subset(nlMunicipality_proj, nlMunicipality_proj$NAME_2 == max_NDVI_Year)

 

plot(NDVI_Jan, main="NDVI in the Netherlands", xlab= "m", ylab= "m")
lines(plot_mun_jan, col= "Red")
text(plot_mun_jan@bbox[1], plot_mun_jan@bbox[2], labels = paste(max_NDVI_JAN), pos=3, cex= 0.7, col="black")
lines(plot_mun_aug, col= "blue")
text(plot_mun_aug@bbox[1], plot_mun_aug@bbox[2], labels = paste(max_NDVI_Aug), pos=3, cex= 0.7, col="black")
lines(plot_mun_year, col= "black")
text(plot_mun_year@bbox[1], plot_mun_year@bbox[2], labels = paste(max_NDVI_Year), pos=3, cex= 0.7, col="black")
legend("bottomright", c("Max August","Max January", "Max year"),
       lty=c(1,1,1), # gives the legend appropriate symbols (lines)
       lwd=c(1,1,1),col=c("blue","red", "black")) # gives the legend lines the correct color and width



       
       
       
###PROVINCE#####
#Select at another level to get the boundaries of the provinces
nlProvince <- getData('GADM',country='NLD', level=1)

#Get projection for both maps the same
nlProvince_proj <- spTransform(nlProvince, CRS(proj4string(Neth_NDVI)))

 ###### FIND the maximum NDVI for the municipality for January###
NDVI_Jan_Prov <- extract(NDVI_Jan, nlProvince_proj, fun=mean, na.rm=TRUE, sp=T)
max_NDVI_Jan_Prov <- subset(NDVI_Jan_Prov$NAME_1, NDVI_Jan_Prov$January == (max(NDVI_Jan_Prov$January, na.rm = T)))

###### FIND the maximum NDVI for the municipality for Augustus###
NDVI_Aug_Prov <- extract(NDVI_Aug, nlProvince_proj, fun=mean, na.rm=TRUE, sp=T)
max_NDVI_Aug_Prov <- subset(NDVI_Aug_Prov$NAME_1, NDVI_Aug_Prov$August == (max(NDVI_Aug_Prov$August, na.rm = T)))

 #####Calculate NVDI for a whole year########
NDVI_year_Prov <- extract(NDVI_mask$Average, nlProvince_proj, sp=T, fun=mean, na.rm=TRUE)
max_NDVI_Year_Prov <- subset(NDVI_year_Prov$NAME_1, NDVI_year_Prov$Average == (max(NDVI_year_Prov$Average, na.rm = T)))

print(paste("To conclude, in January",max_NDVI_Jan_Prov, "is the greenest in August", max_NDVI_Aug_Prov, "for the whole year also", max_NDVI_Year_Prov))


#source("R_functions/Max_Muni_month.R") 
########### !!!! EXTRA !!!! #######
####### WE TRIED to build a function that would do the calculation for a month of choice. We didn get this running in time####
#####the script is given below, maybe someone can give feedback or tips how this could work?####
#Max_Muni_month = function(x, y, z)
#{ 
#  NDVI_month 		<- subset(y, x)
#  NDVI_month_muni 	<- extract(NDVI_month, z, fun=mean, na.rm=TRUE, sp=TRUE)
#  
#  mymonths <- c("January","February","March",
#
 #             "April","May","June",
#
 #             "July","August","September",
#
 #             "October","November","December")
#
 # month <- mymonths[x]
  ##give the name in the output#
  #
  #name_max_NDVI_muni	<- subset(NDVI_month_muni$NAME_2, eval(parse(text=paste0("NDVI_month_muni$",month))) == max(eval(parse(text=paste0("NDVI_month_muni$",month))), na.rm = TRUE))
  
  #plot
  #colfunc <- colorRampPalette(c("red", "green"))
  #spplot(NDVI_month_muni, zcol = "January", col.regions= colfunc(30))
  
  #return(name_max_NDVI_muni)
  
# }  
#NDVI_max_Jan <- Max_Muni_month(1, NDVI_mask, nlMunicipality_proj)
#NDVI_max_Jan

#NDVI_max_Aug <- Max_Muni_month(8, NDVI_mask, nlMunicipality_proj)
#NDVI_max_Aug
















