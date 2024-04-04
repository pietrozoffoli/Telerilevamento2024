# spectral indeces

library(terra)
library(imageRy)

#list of files within imageRy

im.list()

# extract and assign the needed file

mato92<-im.import("matogrosso_l5_1992219_lrg.jpg") # picture taken from earth obesrvator by NASA
                                                   # this is a landst image (false colour image)
                                                   # Bands: 1=NIR; 2=R; 3=G)

# plotting the data
im.plotRGB(mato92, r=1, g=2, b=3)

# NIR on green
im.plotRGB(mato92, 2, 1, 3)

# to see the naked soil we use color yeallow, NIR on blue

im.plotRGB(mato92,2,3,1)  # water appears yeallow just like soil because it's full of sediments

# comparing 1992 and 2006

mato06<-im.import("matogrosso_ast_2006209_lrg.jpg") # aster satellite 

par(mfrow=c(1,2))
im.plotRGB(mato92,1,2,3)
im.plotRGB(mato06,1,2,3)

dev.off()

# 06 NIR on green

im.plotRGB(mato06,2,1,3)

# 06 NIR on blu

im.plotRGB(mato06,3,2,1)


par(mfrow=c(2,3))
im.plotRGB(mato92,1,2,3) # 92 NIR on red
im.plotRGB(mato92,2,1,3) # 92 NIR on green
im.plotRGB(mato92,3,2,1) # 92 NIR on blue
im.plotRGB(mato06,1,2,3) # 06 NIR on red
im.plotRGB(mato06,2,1,3) # 06 NIR on green
im.plotRGB(mato06,3,2,1) # 06 NIR on blue

plot(mato06[[1]]) # plotting NIR


# Calculating the DVI (Difference Vegetation Index)
# DVI = NIR - RED --> simply subtract bands
# bands: 1=NIR, 2=RED, 3=GREEN

dvi92 = mato92[[1]] - mato92[[2]]  # subtracting RED to NIR
# alternative way of coding:
# dvi92 = mato92$matogrosso~2219_lrg_1 - mato92$matogrosso~2219_lrg_2

# plotting the DVI
cl <- colorRampPalette(c("darkblue", "yellow", "red", "black")) (100) # creating the colour palette
plot(dvi92, col=cl) # plotting the difference
dvi92 # this line prints the index's values

# 2006
# mato06 <- im.import("matogrosso_ast_2006209_lrg.jpg") # importing the image
# dvi 2006
dvi06 = mato06[[1]] - mato06[[2]]  # subtracting bands 
plot(dvi06, col=cl) # plotting the difference

# Exercise: plot the dvi1992 beside the dvi2006
par(mfrow=c(1,2))
plot(dvi92, col=cl)
plot(dvi06, col=cl)

# Normalized Difference Vegetation Index (NDVI)
# this is used instead of the DVI when working with images that have a different number of bits. 
# This way it is possible to make a comparison after ythe normalization
ndvi92 = dvi92 / (mato92[[1]]+mato92[[2]]) # an extend version would be ndvi92=(mato92[[1]]-mato92[[2]])/(mato92[[1]]+mato92[[2]])
ndvi06 = dvi06 / (mato06[[1]]+mato06[[2]]) # same as above but for 2006

dev.off()
# plotting the two images together
par(mfrow=c(1,2))
plot(ndvi92, col=cl)
plot(ndvi06, col=cl)
