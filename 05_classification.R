
# 05_classification

# quantifying land cover variability
# first install package "ggplot2"

# I already had it installed
# install.packages("ggplot2")

library(ggplot2)
library(imageRy)
library(terra)

#listing images
im.list()
# importing data (mato grosso 1992 and the sun)                       # cool book "Nella quarta dimensione", same author of "Il problema dei tre corpi"
m92<-im.import("matogrosso_l5_1992219_lrg.jpg")
m06<-im.import("matogrosso_ast_2006209_lrg.jpg")
sun<-im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

# classifying three energetic levels of the sun image

sunc<-im.classify(sun, 3)  # requires the image and the number of classes 

# classifying Mato Grosso immages 

# class 1 = forest
# class 2 = naked soil

m92c<-im.classify(m92, 2)
m06c<-im.classify(m06, 2)

# calculating frequencies (number of pixels) of each class to do further analisys 
# "frequencies" is the number of elements belonging to a class

f92<-freq(m92c)
f92
f06<-freq(m06c)
f06

# calculating proportions and percentages

tot92<-ncell(m92c) # calculating the total number of pixels of the image
tot06<-ncell(m06c)

prop92=f92/tot92
perc92=prop92*100

prop06=f06/tot06
perc06=prop06*100

# printing the values
prop92
perc06
perc92
perc06

# percentages 92: 17% human - 83% forest
# percentages 06: 55% human - 45% forest

#building a dataset and creating graphs 



class<-c("forest","human")
y1992<-c(83,17)
y2006<-c(45,55)

tabout<-data.frame(class,y1992,y2006)  #builds a dataframe (table) with columns (class, % 1992, % 2006)
tabout

# using ggplot2 for graphs
# it creates a graph and it needs: the table we are using; aestetics (how do you want it?) i.e. the axes
# the I add the geometry stat=identity means "just use the value I don't need any statistics"

ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white")
ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white")                                                   

# installing patchwork to compare graphs 

install.packages("patchwork")
library(patchwork)

# comparing graphs

p1<-ggplot(tabout, aes(x=class, y=y1992, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,90))
p2<-ggplot(tabout, aes(x=class, y=y2006, color=class)) + geom_bar(stat="identity", fill="white") + ylim(c(0,90))

p1+p2







