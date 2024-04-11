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

# we are using temperature as a proxy to quantify the ice melt
clg<-colorRampPalette(c("black","blue","white","red"))(100)

g2000<-im.import("greenland.2000.tif")
g2005<-im.import("greenland.2005.tif")
g2010<-im.import("greenland.2010.tif")
g2015<-im.import("greenland.2015.tif")

par(mfrow=c(2,2))
plot(g2000,col=clg)
plot(g2005,col=clg)
plot(g2010,col=clg)
plot(g2015,col=clg)

dev.off()

par(mfrow=c(1,2))
plot(g2000,col=clg)
plot(g2015,col=clg)

# stacking

greenland<-c(g2000,g2005,g2010,g2015)
plot(greenland,col=clg)

dev.off()
# quantifying the difference
clgreen<-colorRampPalette(c("red","white","blue"))(100)
difg=greenland[[1]]-greenland[[4]]  # 2000-2005 
plot(difg,col=clgreen)                   # blue=higer Temperature; red=lower Temperature (melting)


# this is to show in which year there is a higer temperature in a certain area
im.plotRGB(greenland, r=1, g=2, b=4) # g2000 on red, g2005 on green, g2015 on blue






