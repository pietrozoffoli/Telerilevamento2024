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
