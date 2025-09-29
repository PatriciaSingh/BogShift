# Download fractional tree cover at 30-sec resolution:
# Please note that you have to set download=T if you haven't downloaded the data before:
getwd()
setwd("scripts/2_Enviromental_variable/data")
?geodata::landcover
wetland_30sec <- geodata::landcover(var='wetland', path='data', download=F)
writeRaster(wetland_30sec, "filename.tif")

# map the tree cover
plot(wetland_30sec)
