# satellite data visualisation in R by imageRy

library(terra)
library(imageRy)

# all functions begin with 'im.'

im.list() # lists all the data loaded in the package imageRy

# im.import()  imports data from the list 
mato <- im.import("matogrosso_ast_2006209_lrg.jpg") # I assigned it to the object 'mato'
                                                    # Image comes from Earth Observatory by NASA
                                                    # https://earthobservatory.nasa.gov/ you may use this website to gather images for your project
                                                    
# plotting the data
plot(mato)

#importing another image to see different bands
b2 <- im.import("sentinel.dolomites.b2.tif")    # sentinel-2's band 2 corresponds to the wavelength of the colour blue
                                                # this place is Le Tofane

# changing colour palette
clg <- colorRampPalette(c("black", "grey", "white"))(100) # the number outside the main argument defines how many shades will be shown
plot(b2, col=clg)                                         # you can use as many colours as you want

# changing colour palette again
clcyan <- colorRampPalette(c("magenta", "cyan", "yellow"))(300) # the number outside the main argument defines how many shades will be shown
plot(b2, col=clcyan)


# changing colour palette yet again
clch <- colorRampPalette(c("magenta", "cyan", "chartreuse", "yellow"))(300) # the number outside the main argument defines how many shades will be shown
plot(b2, col=clch)

# importing additional bands
# import the green band from Sentinel-2 (band 3) (560 nm)
b3 <- im.import("sentinel.dolomites.b3.tif")
plot(b3, col=clch)

# import the red band from Sentinel-2 (band 4) (665 nm)
b4 <- im.import("sentinel.dolomites.b4.tif")
plot(b4, col=clch)

# import the NIR band from Sentinel-2 (band 8) (842)
b8 <- im.import("sentinel.dolomites.b8.tif")
plot(b8, col=clch)

# creating a multiframe. It works like a matrix (rows and columns), this one woulb be 2x2 matrix

par(mfrow=c(2,2)) 
plot(b2, col=clch)
plot(b3, col=clch)
plot(b4, col=clch)
plot(b8, col=clch)

# another way to get the same result but a bit better

stacksent <- c(b2, b3, b4, b8)
plot(stacksent, col=clch)

# Exercise: plot the four bands in a single raw

par(mfrow=c(1,4)) 
plot(b2, col=clch)
plot(b3, col=clch)
plot(b4, col=clch)
plot(b8, col=clch)

# overlapping the four bands creating a stack (making of a satellite image)
# it uses metadata to gice names to the plots using the names of the images

stacksent<-c(b2, b3, b4, b8)
plot(stacksent, col=clch)

dev.off() #deletes the previous device
plot(stacksent[[4]], col=clch) # I'm using two square parenthesis because stacksent is 2-dimensional object, if it were an array I would have used one set of parenthesis


# RGB plotting
# stacksent[[1]] = b2 = blue
# stacksent[[2]] = b3 = green
# stacksent[[3]] = b4 = red
# stacksent[[4]] = b8 = NIR       

d1<-im.plotRGB(stacksent, r=3, g=2, b=1)
# im.plotRGB(stacksent, 3, 2, 1)   it's the same as above

# NIR makes vegetaion easier to visualise so I replace other colours with it

d2<-im.plotRGB(stacksent, 4, 2, 1)  

# Exercise: make a plot with the natural colour and the false colour images

par(mfrow=c(1,2))
im.plotRGB(stacksent, r=3, g=2, b=1)
im.plotRGB(stacksent, 4, 2, 1)

# for some reason this is what is done in the remote sensing world. If you wanna change a colour you have to shift all other colours as well
par(mfrow=c(1,3))
im.plotRGB(stacksent, r=3, g=2, b=1)
im.plotRGB(stacksent, 4, 2, 1)
im.plotRGB(stacksent, 4, 3, 2)

# NIR on green
im.plotRGB(stacksent, 3, 4, 2)

# NIR on blue, this makes soil appear as yeallow
im.plotRGB(stacksent, 3, 2, 4)

# Exercise: put the 4 images all together
par(mfrow=c(2,2))
im.plotRGB(stacksent, r=3, g=2, b=1) # natural colour
im.plotRGB(stacksent, 4, 2, 1)       # NIR on red
im.plotRGB(stacksent, 3, 4, 2)       # NIR on green
im.plotRGB(stacksent, 3, 2, 4)       # NIR on blue

# correlate variables, it also calculates Pearson's Correlation Index and data frequency
pairs(stacksent)




