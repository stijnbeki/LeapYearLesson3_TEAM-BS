Download_Brick = function(x)
{ 

download.file(url = x, destfile = "data/MODIS_Neth", method = 'auto')
unzip("data/MODIS_Neth", exdir="data")

Neth <- brick('data/MOD13A3.A2014001.h18v03.005.grd')
return(Neth)

}