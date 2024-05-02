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

pairs(sentdo)  # visualization of the correlation of the 4 bans

# PCA (principal components analysis)

pcimage<-im.pca(sentdo)

tot<-sum(1821.09157, 550.34592, 47.53659, 32.86343) # sum of the ranges of each axes

1821.09157*100/tot # divide tot by the number and multiply by 100 to see the percentage of variability of the axes
550.34592*100/tot
47.53659*100/tot
32.86343*100/tot

vir <- colorRampPalette(viridis(7))(100)  # "viridis(7)" is the depth
plot(pcimage, col=vir)

# plot(pcimage, col=viridis(100))   # this way we don't need to use the colour ramp palette
plot(pcimage, col=inferno(100)) 











