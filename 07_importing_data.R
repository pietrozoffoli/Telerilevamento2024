# Importing external data

library(imageRy)
library(terra)

setwd("C:/Users/HP/Desktop/Magistrale/Telerilevamento Geo-Ecologico") # setting the working directory i.e. I'm telling R where to take files I'm gonna use
dir()  # verify what files are inside my current working directory    # use / and not \ even though Windows says the path is otherwies
eclissi<-rast("eclissi.png") # loads data from outside

# plotting the data

im.plotRGB(eclissi,1,2,3)
im.plotRGB(eclissi,3,2,1)
im.plotRGB(eclissi,2,3,1)
im.plotRGB(eclissi,2,1,3)

# band difference
dif<-eclissi[[1]]-eclissi[[2]]  # this does not make much sense, it's just an example of band differences
plot(dif)

# importing another image 
globnetrad<-rast("CERES_NETFLUX_M_2006-07.jpeg") # global net radiation from Earth Observatory by NASA
plot(globnetrad)


# importing data downloaded from copernicus

soil<-rast("c_gls_SSM1km_202404210000_CEURO_S1CSAR_V1.2.1.nc")
plot(soil) # SSM: soil moisture ; SSM_NOISE: estimated error
plot(soil[[1]])

# cropping the image using coordinates 

ext<-c(25,30,55,58)  # defining the extension of the crop (x min max; y min max)
soilcrop<-crop(soil,ext) # cropping the image using the extension defined above
plot(soilcrop)
plot(soilcrop[[1]])


