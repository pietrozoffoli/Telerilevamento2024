# satellite data visualisation in R by imageRy

library(terra)
library(imageRy)

# all fuctions begin with 'im.'

im.list() # lists all the data loaded in the package imageRy

# im.import()  imports data from the list 
mato <- im.import("matogrosso_ast_2006209_lrg.jpg") #then I assigned it to the object 'mato'
