####################
##Team BS         ##
##lesson8         ##
##Bart Middelburg ##
##Stijn Beernink  ##
##18-01-17        ##
####################

##Clean Workspace
rm(list=ls())

##load packages
library(raster)
source("R_functions/RemoveOutliers.R")

#linkVariable
Git_L="https://github.com/GeoScripting-WUR/AdvancedRasterAnalysis/raw/gh-pages/data/"


### download
download.file(paste0(Git_L,"GewataB1.rda"), destfile = "data/GewataB1.rda", method = "auto")
download.file(paste0(Git_L,"GewataB2.rda"), destfile = "data/GewataB2.rda", method = "auto")
download.file(paste0(Git_L,"GewataB3.rda"), destfile = "data/GewataB3.rda", method = "auto")
download.file(paste0(Git_L,"GewataB4.rda"), destfile = "data/GewataB4.rda", method = "auto")
download.file(paste0(Git_L,"GewataB5.rda"), destfile = "data/GewataB5.rda", method = "auto")
download.file(paste0(Git_L,"GewataB7.rda"), destfile = "data/GewataB7.rda", method = "auto")
download.file(paste0(Git_L,"vcfGewata.rda"), destfile = "data/vcfGewata.rda", method = "auto")
download.file(paste0(Git_L,"trainingPoly.rda"), destfile = "data/trainingPoly.rda", method = "auto")

##load Data
load("data/GewataB1.rda")
load("data/GewataB2.rda")
load("data/GewataB3.rda")
load("data/GewataB4.rda")
load("data/GewataB5.rda")
load("data/GewataB7.rda")
load("data/vcfGewata.rda")

##Add data
alldata <- brick(GewataB1, GewataB2, GewataB3, GewataB4, GewataB5, GewataB7, vcfGewata)
names(alldata) <- c("band1", "band2", "band3", "band4", "band5", "band7", "VCF")

#clean plot window ##otherwise wont plot correctly##
dev.off()
##Inspect data for errors
hist(alldata)
##as can be seen there are large errors for allmost every band.

##use function "RemoveOutliers"
##to throw out outliers, we choose 4 std.dev as the maximum from the mean.For exact calculation see function
alldata = RemoveOutliers(alldata)

##now look again at the data
dev.off()
hist(alldata)
##yes looks much better!

pairs(alldata)

dev.off()
## Extract all data to a data.frame
alldata_df <- as.data.frame(alldata)
alldata_df <- na.omit(alldata_df)



model_vcf <- lm(VCF ~ band1 + band2 + band3 + band4 + band5 +band7, data = alldata_df)


## Use the model to predict land cover
#create file with only the bands (no vfc) for model input
alldata_bands <- alldata[[1:6]]
#run model
vcfMap <- predict(alldata_bands, model = model_vcf, na.rm=T)

#remove all wrong data (<0)
vcfMap[vcfMap<0] <- NA

#plot both maps
par(mfrow = c(1,2))
plot(vcfMap)
plot(alldata$VCF)
dev.off()

#Legend are not equal, so hard to compare. We want to see the differnce. 
#Therefore we substract the original from the modelled vcfmap 
Diff <- vcfMap - alldata$VCF

#look at the difference between the maps. this is the error#
par(mfrow = c(1,2))
plot(Diff)
hist(Diff)
dev.off()

###calculate RMSE = Root((diff^2)/n)
Diff_df <- as.data.frame(Diff)
Diff_df <- na.omit(Diff_df)     ##can not calculate with the NA's.
RMSE <- (mean(Diff_df**2))**0.5
RMSE
#RMSE for total area!!

###now look at the RMSE per Class########################################################
##thereofre the polygon data is needed##
###load from data##

load("data/trainingPoly.rda")

#converting code
trainingPoly@data$Code <- as.numeric(trainingPoly@data$Class)

##make the classes for the polygons, with rasterize
classes <- rasterize(trainingPoly, alldata, field='Code')

cols <- c("red", "dark blue", "orange")
plot(classes, col=cols, legend=FALSE)
# add a customized legend
labs <- c("Cropland", "Forest", "Wetland")
legend("topright", legend=labs, fill=cols, bg="white")

##first calculate the squared error for in the zonal function
Diff_sqrd <- Diff**2

#in the zonal funtion the square is needed of the DIFF, because in the zonal function we allready do the mean function(all part of calculating RMSE)
Zone_RMSE <- zonal(Diff_sqrd,classes, fun='mean', na.rm=TRUE)

##take the root of the mean's (column 2)
Zone_RMSE[,2] <- Zone_RMSE[,2]**0.5

RMSE_df <- as.data.frame(Zone_RMSE)
RMSE_df$zone <- labs

##barplot of the zones
rounded <- round(RMSE_df$mean, digits = 2) ##create numbers for plot
barplot_zones <- barplot(RMSE_df$mean, names.arg =c(labs),col=c("salmon","dark green","light blue"), main = "Barplot for the 3 zones")
text(barplot_zones, 3, label=c(rounded[1], rounded[2], rounded[3]), pos=3,cex=0.8)

##conlusion
print(paste("We can conclude that modelling forest is done relatively good by this model, the forest has a RMSE of",rounded[2], "The Cropland is in the middle with a RMSE of", rounded[1], "and the Wetland has the largest RMSE:", rounded[3],". Greetings Team BS"))

