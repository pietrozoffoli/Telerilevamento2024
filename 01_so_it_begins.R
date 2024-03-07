# First R script

# R as a calculation tool
a<-6^3
b<-5*8
a+b

# R for arrays and matrix calculation

# this is an array, function "c" is used to group elements into a single object

flowers<-c(3,6,8,10,15,18)
insects<-c(10,16,25,42,61,73)

# plotting two arrays (thay have to be the same length)
# functions: "pch"=type of simbol on the plot; "col"=color; "cex"=point size (character exageration); "xlab and ylab"=names of the x and y axes
# plot(x,y,..)

> plot(flowers, insects, pch=19, col='blue', cex=.98, xlab='fiori', ylab='insetti')

