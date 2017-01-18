###########
##Team BS##
##lesson8##
##BartM  ##
##StijnB ##
##18-01-17#
###########

##Clean Workspace
rm(list=ls())

##load packages
library(raster)

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

##Inspect data for errors
hist(alldata)

##as can be seen there are large errors for allmost every band.
##to throw out outliers, we choose 3 std.dev as the maximum from the mean.
mean <- cellStats(x = alldata, stat = 'mean')
std_dev4 <- 4*(cellStats(x = alldata, stat = 'sd'))
lowerbound <- mean - std_dev4
upperbound <- mean + std_dev4
alldata[alldata > upperbound] <- NA
alldata[alldata < lowerbound] <- NA

alldata_bands <- alldata[[1:6]]
##now look again at the data
hist(alldata)
##yes looks much better!

pairs(alldata)

dev.off()
## Extract all data to a data.frame
alldata_df <- as.data.frame(alldata)
alldata_df <- na.omit(alldata_df)

model_vcf <- lm(VCF ~ band1 + band2 + band3 + band4 + band5 +band7, data = alldata_df)
## Use the model to predict land cover
vcfMap <- predict(alldata_bands, model = model_vcf, na.rm=T)

vcfMap[vcfMap<0] <- NA

par(mfrow = c(1,2))
plot(vcfMap)
plot(alldata$VCF)
dev.off()

#Legend are not equal, so hard to compare. We want to see the differnce. 
#Therefore we substract the original from the modelled vcfmap 
Diff <- vcfMap - alldata$VCF

par(mfrow = c(1,2))
plot(Diff)
hist(Diff)
dev.off()

###calculate RMSE = Root((diff^2)/n)
Diff_df <- as.data.frame(Diff)
Diff_df <- na.omit(Diff_df)     ##can not calculate with the NA's.
RMSE <- (mean(Diff_df**2))**0.5
RMSE



###now look at the RMSE per Class###
##thereofre the polygon data is needed##
###load from data##

load("data/trainingPoly.rda")

#converting code
trainingPoly@data$Code <- as.numeric(trainingPoly@data$Class)

##make the classes for the polygons, with rasterize
classes <- rasterize(trainingPoly, alldata, field='Code')
classes

cols <- c("red", "dark blue", "orange")

plot(classes, col=cols, legend=FALSE)
# add a customized legend
labs <- c("Cropland", "Forest", "Wetland")
legend("topright", legend=labs, fill=cols, bg="white")


Diff_sqrd <- Diff**2
plot(Diff_sqrd)

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

print(paste("We can conclude that modelling forest is done relatively good by this model, the forest has a RMSE of",rounded[2], "The Cropland is in the middle with a RMSE of", rounded[1], "and the Wetland has the largest RMSE:", rounded[3],". Greetings Team BS"))

