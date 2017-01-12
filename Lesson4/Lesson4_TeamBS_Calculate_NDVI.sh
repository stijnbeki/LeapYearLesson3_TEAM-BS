#!/bin/bash

echo "Team_BS"
echo "12 January 2017"
echo "Calculate LandSat NDVI, resample to pixel 60x60m and change projection"

cd ../data
fn=$(ls LE*.tif)
echo "The input file: $fn"
outfn="ndvi.tif"

echo "The output file: $outfn"
echo "calculate ndvi"
gdal_calc.py -A $fn --A_band=4 -B $fn --B_band=3 --outfile=$outfn --calc="(A.astype(float)-B)/(A.astype(float)+B)" --type='Float32'


echo "Resample the NDVI to 60 by 60 meters"
gdalwarp -tr 60 60 $outfn NDVI_Resampled.tif

echo "Change projection to EPSG:4326"
gdalwarp -t_srs EPSG:4326 NDVI_Resampled.tif NDVI_Resampled_Projected.tif

echo "Look at some histogram statistics"
gdalinfo -hist -stats NDVI_Resampled_Projected.tif