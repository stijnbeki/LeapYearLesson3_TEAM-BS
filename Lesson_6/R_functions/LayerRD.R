#the rd projection
prj_string_RD <- CRS("+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.2369,50.0087,465.658,-0.406857330322398,0.350732676542563,-1.8703473836068,4.0812 +units=m +no_defs")

LayerRD <- function(x)
  { 
  layerfile = file.path("data",paste0(x,".shp"))
  layerfile <- readOGR(layerfile, layer = ogrListLayers(layerfile))
  layer_RD <- spTransform(layerfile, prj_string_RD)
  
  return(layer_RD)
  }