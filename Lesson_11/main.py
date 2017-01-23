###Team BS#######
###Geoscripting##
###23-01-17######

#Loading the modules
import os
from osgeo import ogr, osr

#Create directory
#os.chdir('./data')

## Is the ESRI Shapefile driver available?
driverName = "GeoJSON"
drv = ogr.GetDriverByName( driverName )
if drv is None:
    print "%s driver not available.\n" % driverName
else:
    print  "%s driver IS available.\n" % driverName

#Create the names
fn = "points_les11.geojson"
layername = "layer_les11"

#Create a shapefile with the given name
ds = drv.CreateDataSource(fn)
print ds.GetRefCount()

#Set Spatial reference to WGS84
spatialReference = osr.SpatialReference()
spatialReference.ImportFromProj4('+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs')

#Create the layer
layer=ds.CreateLayer(layername, spatialReference, ogr.wkbPoint)

#Create points to put in the layer 
bart_home = ogr.Geometry(ogr.wkbPoint)
stijn_home = ogr.Geometry(ogr.wkbPoint)

#Set coordinates to the created points.

bart_home.SetPoint(0, 6.560159, 52.989536) 
stijn_home.SetPoint(0, 5.668627, 51.850923)

#Create two features to put the points in 
layerDefinition = layer.GetLayerDefn()
feature1 = ogr.Feature(layerDefinition)
feature2 = ogr.Feature(layerDefinition)

## Lets add the points to the feature
feature1.SetGeometry(bart_home)
feature2.SetGeometry(stijn_home)

## Lets store the feature in a layer
layer.CreateFeature(feature1)
layer.CreateFeature(feature2)
print "The new extent"
print layer.GetExtent()

ds.Destroy()

import folium
import os

pointsGeo=os.path.join("points_les11.geojson")
map_points = folium.Map(location=[52,5.7],tiles='Mapbox Bright', zoom_start=6)
map_points.choropleth(geo_path=pointsGeo)
map_points.save('points_les11.html')

bashCommand = "ogr2ogr -f kml -t_srs crs:84 points_les11.kml points_les11.geojson"
os.system(bashCommand)