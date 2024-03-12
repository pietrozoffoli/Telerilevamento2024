# installing new packages in R

install.packages("terra") # without further instructions, it will look for the package in the CRAN repo by default. If the needed package comes from a different source then there are a few more steps to take
# to update a package it's good habit to first remove it and then re-install it, to do ss use the function: remove.packages()
library("terra") # loads the package in R, it can also be done with the function 'require()'


library(devtools) 
# function 'install_github' depends on function 'devtools' to work
# install the imageRy package from GitHub

devtools::install_github("ducciorocchini/imageRy") # the syntax :: means that the argument to the right is a function of the package to the left. It can  be omitted, it's to make others understand what you are doing
                                                  # this is a devtools function,
library(imageRy) #package containing functions for remote sensing

# always list the packages that are being used on top of the code
