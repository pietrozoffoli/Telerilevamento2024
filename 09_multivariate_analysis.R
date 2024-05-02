# multivariate analysis

library(imageRy)
library(terra)
library(viridis)

im.list()

b2 <- im.import("sentinel.dolomites.b2.tif")  # blue
b3 <- im.import("sentinel.dolomites.b3.tif")  # green
b4 <- im.import("sentinel.dolomites.b4.tif")  # red
b8 <- im.import("sentinel.dolomites.b8.tif")  # NIR

sentdo <- c(b2, b3, b4, b8) # stacking the bands together 

im.plotRGB(sentdo, 4, 3, 2) # plotting NIR on red
im.plotRGB(sentdo, 3, 4, 2) # plotting NIR on green

pairs(sentdo)  
