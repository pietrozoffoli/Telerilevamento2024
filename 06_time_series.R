# time series analysis

library(imageRy)
library(terra)

im.list()

# importing and plotting data (Nitrogen dioxide in Europe)

EN01<-im.import("EN_01.png")
EN13<-im.import("EN_13.png")

par(mfrow=c(2,1))
im.plotRGB.auto(EN01) # plots the 1st 2nd and 3rd band of colour
im.plotRGB.auto(EN13)

dev.off()

# difference between two layers (I can only make the difference of the same band)

difEN=EN01[[1]]-EN13[[1]] 
cl<-colorRampPalette(c("blue","white","red"))(100)
plot(difEN,col=cl)

# measuring the ammopunt of lost ice mass in Greenlan




