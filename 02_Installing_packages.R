# installing new packages in R

install.packages("terra") # without further instructions, it will look for the package in the CRAN repo by default. If the needed package comes from a different source then there are a few more steps to take
# to update a package it's good habit to first remove it and then re-install it, to do ss use the function: remove.packages()
library("terra") # loads the package in R

