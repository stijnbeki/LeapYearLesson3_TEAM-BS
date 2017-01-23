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

dir.create("data")
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
#As can be seen there are large outliers for allmost every band. It is hard to really say which points are outliers and which are not. The reflectance can be between 0 and 10000, which could be a good filtering technique. We decided to focus on the largest population of datapoints by using four times the standard deviation.

#use function "RemoveOutliers"
#to throw out outliers, we choose 4 std.dev as the maximum and minimum from the mean. For exact calculation see function!

alldata = RemoveOutliers(alldata)

##now look again at the data
dev.off()
hist(alldata)
##yes looks much better!

pairs(alldata)
dev.off()

##As can be seen that band 1 and 2 are correlated. Therefore it possible an good idea to leave one of these band out of the calculation. Furthermore, band 4 doesn't show any relationship with VCF and could therefore be left out.
## Extract all data to a data.frame
alldata_df <- as.data.frame(alldata)
alldata_df <- na.omit(alldata_df)

#The Linear Model is made here. One model with all the explanatory variables and one model where band 2 and 4 are left out. We will continue making maps with the model using all the explanatory variables but reflect on using less bands in the conclusion!

model_vcf <- lm(VCF ~ band1 + band2 + band3 + band4 + band5 +band7, data = alldata_df)
model_vcf_small <- lm(VCF ~ band1 + band3 + band5 +band7, data = alldata_df)
model_vcf_time <- system.time(lm(VCF ~ band1 + band2 + band3 + band4 + band5 +band7, data = alldata_df))
model_vcf_small_time <- system.time(lm(VCF ~ band1 + band3 + band5 +band7, data = alldata_df))
model_vcf_time-model_vcf_small_time

## Use the model to predict land cover
#create file with only the bands (no vfc) for model input
alldata_bands <- alldata[[1:6]]
#run model
alldata_bands <- alldata[[1:6]]
vcfMap <- predict(alldata_bands, model = model_vcf, na.rm=T)
vcfMap_small <- predict(alldata_bands, model = model_vcf_small, na.rm=T)

vcfMap_time <- system.time(predict(alldata_bands, model = model_vcf, na.rm=T))
vcfMap_small_time <- system.time(predict(alldata_bands, model = model_vcf_small, na.rm=T))
vcfMap_time - vcfMap_small_time

#remove all wrong data (<0)
vcfMap[vcfMap<0] <- NA
vcfMap_small[vcfMap_small<0] <- NA

#plot both maps
par(mfrow = c(1,2))
plot(vcfMap, main = "Modelled VCF using all bands")
plot(alldata$VCF, main = "Original VCF map")
dev.off()

#Legend are not equal, so hard to compare. We want to see the differnce. 
#Therefore we substract the original from the modelled vcfmap 
Diff <- vcfMap - alldata$VCF
Diff_less_bands <- vcfMap_small - alldata$VCF

#look at the difference between the maps. this is the error#
par(mfrow = c(1,2))
plot(Diff, main = "Difference VCF_MOD - Org_VCF")
hist(Diff)
dev.off()

###calculate RMSE = Root((diff^2)/n)
Diff_df <- as.data.frame(Diff)
Diff_df <- na.omit(Diff_df)     ##can not calculate with the NA's.
RMSE <- (mean(Diff_df**2))**0.5
RMSE
#RMSE for total area!!

#Doing exactly the same but using less bands. 

Diff_df_less_bands <- as.data.frame(Diff_less_bands)
Diff_df_less_bands <- na.omit(Diff_df_less_bands)     ##can not calculate with the NA's.
RMSE_less_bands <- (mean(Diff_df_less_bands**2))**0.5
RMSE_less_bands


#This is the RMSE for total area!! As can be seen is the RMSE using less bands higher than using all the bands. Also the impact on running time is minor. This could be an issue using models for large areas or maps with a higher resolution. We should try it using more combination of bands, but as we showed the idea behind using less bands we continued.
#
#ow look at the RMSE for predicting VCF per Class using all bands as this had the lowest overall RMSE.
#herefore the polygon data used in the tutorial of lesson 8 is needed
###now look at the RMSE per Class##
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

