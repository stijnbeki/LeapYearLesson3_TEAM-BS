CitBUF = function(x) 
{
#Create a 1000 meter buffer around the industrial railway
buff_railways = gBuffer(railways_ind[1,], width = x, byid=TRUE)

#Check which place is located which is in the buffer created around the industrial railways
City_buff_coords = gIntersection(places_RD, buff_railways, id=as.character(places_RD$osm_id), byid = T)

#Collect the place names and other attributes of the intersection(s)
placesnames <- places_RD[places_RD$osm_id == rownames(City_buff_coords@coords),]

plot(buff_railways, axes=T, xlab='m', ylab='m', main =paste("Buffer around", railways_ind$type, "railway near", placesnames$name) , col="turquoise")
plot(railways_ind, add=T)
text(railways_ind@bbox[1], railways_ind@bbox[2], labels = paste(railways_ind$type, "railway"), pos=4, col="black")
plot(placesnames, add=T)
text(City_buff_coords@coords, labels = placesnames$name, pos=4, col="red")
legendtext <- "Buffer"
legend("right", "Buffer", fill = "turquoise", cex = 1)
grid(col=300)

return(placesnames)
} 