# -*- coding: utf-8 -*-
"""
Created on Tue Jan 24 14:25:31 2017

@author: ubuntu
"""

#import the modules
from osgeo import gdal
from osgeo.gdalconst import GA_ReadOnly, GDT_Float32
import numpy as np
import os
import urllib2
import tarfile, sys

#Download the file from dropbox
landsat_tar = urllib2.urlopen("https://www.dropbox.com/s/zb7nrla6fqi1mq4/LC81980242014260-SC20150123044700.tar.gz?dl=1")
with open('landsat.tar.gz','wb') as output:
  output.write(landsat_tar.read())
  
#untar the file and extract in your current working directory
def untar(fname):
    if (fname.endswith("tar.gz")):
        tar = tarfile.open(fname)
        tar.extractall()
        tar.close()
        print "Extracted in Current Directory"
    else:
        print "Not a tar.gz file: '%s '" % sys.argv[0]
        
untar('landsat.tar.gz')       

#Open the two bands
band4= gdal.Open('LC81980242014260LGN00_sr_band4.tif', GA_ReadOnly)
band5= gdal.Open('LC81980242014260LGN00_sr_band5.tif', GA_ReadOnly)

# Read data into an array
band4Arr = band4.ReadAsArray(0,0,band4.RasterXSize, band4.RasterYSize)
band5Arr = band5.ReadAsArray(0,0,band5.RasterXSize, band5.RasterYSize)


# set the data type
band4Arr=band4Arr.astype(np.float32)
band5Arr=band5Arr.astype(np.float32)


# set np.errstate to avoid warning of invalid values (i.e. NaN values) in the divide 
def ndwi_calc(b4, b5):
    mask = np.greater(b4+b5,0)
    with np.errstate(invalid='ignore', divide = 'ignore'):
        ndwi = np.choose(mask,(-99,(b4-b5)/(b4+b5)))
        print "NDWI min and max values", ndwi.min(), ndwi.max()
        return ndwi 
    
ndwi = ndwi_calc(band4Arr, band5Arr)
 # Check the real minimum value
print(ndwi[ndwi>-99].min())  
ndwi[ndwi>1] = -99 
    
# Write the result to disk
driver = gdal.GetDriverByName('GTiff')
outDataSet=driver.Create('ndwi.tif', band4.RasterXSize, band4.RasterYSize, 1, GDT_Float32)
outBand = outDataSet.GetRasterBand(1)
outBand.WriteArray(ndwi,0,0)
outBand.SetNoDataValue(-99)
    
# set the projection and extent information of the dataset
outDataSet.SetProjection(band4.GetProjection())
outDataSet.SetGeoTransform(band4.GetGeoTransform())


# Finally let's save it... or like in the OGR example flush it
outBand.FlushCache()
outDataSet.FlushCache()

#reproject the file (via bashcommand)
bashCommand = 'gdalwarp -t_srs "EPSG:4326" ndwi.tif ndwi_ll.tif'
os.system(bashCommand)

from osgeo import gdal
import matplotlib.pyplot as plt

# Open image
dsll = gdal.Open("ndwi_ll.tif")

# Read raster data
ndwi = dsll.ReadAsArray(0, 0, dsll.RasterXSize, dsll.RasterYSize)

# Now plot the raster data using plt.cm.Blues pallette. Results in nice coloring
plt.imshow(ndwi, interpolation='nearest', vmin=0, cmap=plt.cm.Blues)
plt.title("NDWI western part of the Netherlands")
plt.colorbar()
plt.show()

dsll = None