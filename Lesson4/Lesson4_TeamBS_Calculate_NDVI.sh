#!/bin/bash

echo "Team_BS"
echo "12 January 2017"
echo "Calculate LandSat NDVI, resample to pixel 60x60m and change projection"


fn=$(ls data/LE*.tif)

#Here you can give your final map a name#
echo "The input file: $fn"
outfn="data/Final_Resampled_Projected.tif"

echo "The output file: NDVI_Resampled_Projected.tif"
echo "calculate ndvi"
gdal_calc.py -A $fn --A_band=4 -B $fn --B_band=3 --outfile=data/NDVI.tif --calc="(A.astype(float)-B)/(A.astype(float)+B)" --type='Float32'


echo "Resample the NDVI to 60 by 60 meters"
gdalwarp -tr 60 60 data/NDVI.tif data/NDVI_Resampled.tif

echo "Change projection to EPSG:4326"
gdalwarp -t_srs EPSG:4326 data/NDVI_Resampled.tif $outfn

echo "Look at some histogram statistics"
gdalinfo -hist -stats $outfn

#remove the intermediate maps
rm data/NDVI.tif
rm data/NDVI_Resampled.tif

#So now only the final map is given in the map "Data".
