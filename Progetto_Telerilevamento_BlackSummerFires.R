# Pietro Zoffoli a.a. 2023-2024 
# Corso di laurea Geologia e Territorio - Alma Mater Studiorum, Università di Bologna
# Progetto d'esame di Telerilevamento Geoecologico 
# Docente Duccio Rocchini
#
# Black Summer Fires - Blue Mountains National Park - New South Wales - Australia 
# Analyzing the vegetation loss in the area of the Blue Mountains in Australia following the fires of 2019-2020 and the following recovery.
# I am suing the BAI (Burnt Area Index) and NBR (Normalized Burn Ratio) to quantify the amount of lost vegetation. 
#Then I am monitoring the recovery of the area using the same methods.

#----------------------------------------------------PHASE 1: STARTING THE PROJECT---------------------------------------------------#
# First to start working in RStudio I need to load the packages (i.e. groups of functions) that are going to be used in this project
# I do this using the function "library()". 
# I already had all these packages installed by the time I started this project but if needed a package can be downloaded like shown in the following exaple
# install.packages("package name here")

library(terra)                             # Spatial data analysis.
library(ggplot2)                           # Creating statistical data visualization.
library(imageRy)                           # Images management, sharing and editing.
library(raster)                            # Geographic data analysis.
library(patchwork)                         # Composing plots created with ggplot2 into a single visualization.
library(viridis)                           # Producing colorblind-friendly color maps.

# Then I'm setting the working directory to the directory. This is the place where RStudio can find the materials I need for the project and where exported files and productions will be saved into
                                           # Starting the project by setting and calling the working directory containing all the data that are going to be used from here on
setwd("C:/Users/HP/Documents/EsameDuccio") # this function sets the path R has to take to access the data
getwd()                                    # this function prints the name of the working directory I'm in. I do this to make sure that everything is at it should be

#----------------------------------------------------PHASE 2: IMPORTING DATA-------------------------------------------------------------------------------------------------------------------#
# Using the function "raster()" I can import images into RStudio in the form of spatial raster
 # Importing false color images to see what we are working with
pre<-rast("prefirefalseflip1.jpg")      # Importing a .jpg image and turning it into a spatial raster
post<-rast("postfirefalseflip1.jpg")    # Importing a .jpg image and turning it into a spatial raster
                                        # Issue 1: while importing a .jpg, the plot would come out flipped on the x axis.
                                        #          I tried solving this with functions already existing in R but it wouldn't work.
                                        #          At the end of the day I fixed this problem by flipping the image myself before importing it into R studio.
# Plotting each image individually with the function "plot()"

plot(pre)   # plotting the pre-fire image
plot(post)  # plotting the post-fire image
print(pre)  # displaying all the information about the imported image
print(post) # displaying all the information about the imported image
# # This is the result of the print
# class       : SpatRaster 
# dimensions  : 1007, 2500, 3  (nrow, ncol, nlyr)
# resolution  : 1, 1  (x, y)
# extent      : 0, 2500, 0, 1007  (xmin, xmax, ymin, ymax)
# coord. ref. :  
#   source      : prefirefalseflip1.jpg 
# colors RGB  : 1, 2, 3 
# names       : prefirefalseflip1_1, prefirefalseflip1_2, prefirefalseflip1_3 

# Plotting the two images side by side to see the difference using the function "par()" 
conf_pre_post_fire <- par(mfrow=c(1,2))
plot(pre, main="05-05-2018")
plot(post, main="09-05-2020")

dev.off()   # closing all plots generated so far to let my old clunky computer breath a bit

# Importing and grouping each band into a single object
# This is an alternative way to importing the already-made false colour image

## This time I'm using .tiff files instead of .jpg for a few different reasons.
##  They preserve geo-spatial metadata (such as coordinate system)
##  They work with 16 bits rather than 8 per pixel, this allows for more precision 
##  They do not suffer quality loss unlike .jpg files
##  More bands are available, especially NIR and SWIR that are going to be used for this exercise

# Pre-Fire (2018-05-05)                    [color - wavelength (nm) - spatial resolution (m)]
ab2<-rast("1855b2.tiff")                 # blue   -       490       -          10             #
ab3<-rast("1855b3.tiff")                 # green  -       560       -          10             #
ab4<-rast("1855b4.tiff")                 # red    -       665       -          10             #
ab8<-rast("1855b8.tiff")                 # NIR    -       842       -          10             #
ab12<-rast("1855b12.tiff")               # SWIR   -      2190       -          20             #

# Post-fire (2020-05-09)                   [color - wavelength (nm) - spatial resolution (m)]
pb2<-rast("2059b2.tiff")                 # blue   -       490       -          10             #
pb3<-rast("2059b3.tiff")                 # green  -       560       -          10             #
pb4<-rast("2059b4.tiff")                 # red    -       665       -          10             #
pb8<-rast("2059b8.tiff")                 # NIR    -       842       -          10             #
pb12<-rast("2059b12.tiff")               # SWIR   -      2190       -          20             #

# Stacking the blue, green, red and NIR bands into a single object. I use the function "c()" to group objects together
stackpre<-c(ab2,ab3,ab4,ab8)        
stackpost<-c(pb2,pb3,pb4,pb8)            
# Plotting the stack using a colorblind-friendly color palette
plot(stackpre,col=viridis(100))          
plot(stackpost,col=viridis(100))
# Making my own false color images. The function "im.plotRGB()" allows me to chenge the bands used in an image, this lets me create false color images to highlight the burned areas
im.plotRGB(stackpre, 4, 2, 1)            
im.plotRGB(stackpost, 4, 2, 1)          

dev.off()  # Again, give this old boy a break

#----------------------------------------------------PHASE 3:QUANTIFYING THE EXTENT OF THE BURNED AREA---------------------------------------------------------------------------------------------#
# In order to quantify the extent of the burnt area two approaches can be taken. The first one is using the Burned Area Index (BAI).
# This approach uses the red and NIR bands. Burned vegetation looses chlorophyll, this causes an increase in reflectance for red and decrease for NIR.
# BAI emphasizes this difference and makes burned areas easier to see. An high value of BAI indicates a most likely burned area
# The second approach is called Normalized Burn Ratio (NBR). Similarly to the BAI this method uses the reflectance of NIR and SWIR bands to identify burned areas.
# Lower NBR values represent burned areas. Furthermore by calculating the differential NBR it is possible to get an esteem of the damage
# 1) Burned Area Index (BAI) = ((red-0.1)^2+(nir-0.06^2))/(red+nir)^2 
# 2) Normalized Burn Ratio (NBR) = (nir-swir)/(nir+swir)


#--------------------------------------------------BAI & NIR FUNCTIONS-------------------------------

# I am writing two functions to calculate the BAI and NIR and resample the two raster if they have have different resolution
# Higher values represent burnt areas
# Problem: this method might prove inefficient since it can produce false positives in shady areas

# Function to calculate the BAI with automatic resampling integrated
calcbai<-function(red,nir) {                                                      # create the function and define the variables required
  if (!all(dim(red)==dim(nir))) {                                                 # checking if the two variables are compatible for calculation
    print("Oops! Looks like these rasters have different resolution. Let me just...")  # if they are not compatible the function prints a message informing the user that it is going to resample them
    if (res(red)[1]>res(nir)[1]) {                                                # identifies the raster with the lower resolution as the one to be resampled
      red<-resample(red,nir)                                                      # resampling without specifying the resampling method this way it will use nearest neighbor if the first layer of the raster to resample is categorical; a bilinear interpolation if it is numeric
    } else {                                                                      #
      nir<-resample(nir,red)                                                      #
    }
    print("Here you go. Resampled and ready to go.")                              # once the resampling is complit a message will apear informing the user
  }
  else{
    print("No need to resample here, you are good to go!")                        # if no resampling is needed the user will be notified
  }
  bai<-((red-0.1)^2+(nir-0.06^2))/(red+nir)^2                                     # calculating the BAI after resampling if needed
  return(bai)                                                                     # returning the result to the object it is being assigned to
}

# Calculating the BAI of the post-fire image
postbai<-calcbai(pb4,pb8)                                                         # using the function I have just written
plot(postbai)                                                                     # plotting the result to have a first look

# Comparing it to the false color image to see if it makes sense
compbai<-par(mfrow=c(2,1))
im.plotRGB(stackpost,4,2,1)
plot(postbai)

# WE can see how shadows produce an higher value of the BAI, this might get in the way of obtaining a realistic result

dev.off()      # Lots of plots means lots of work for this retiring PC 

# The NBR should get around the shadow and weather issue encountered earlier

# The architecture of the following function is the same as for the BAI one,
# the only things that differ are the arguments of the functions and the formula to calculate the NBR
calcnbr<-function(nir,swir) {
  if (!all(dim(nir)==dim(swir))) {
    print("Oops! Looks like these rasters have different resolution. Let me just...")
    if (res(nir)[1]>res(swir)[1]) {
      nir<-resample(nir,swir)
    } else {
      swir<-resample(swir,nir)
    }
    print("Here you go. Resampled and ready to go.")
  }
  else{
    print("No need to resample here, you are good to go!")
  }
  nbr<-((nir-swir)/(nir+swir))
  return(nbr)
}

# Calculating the NBR of the post-fire image
postnbr<-calcnbr(pb8,pb12)                                # Calculating the NBR value for each cell
plot(postnbr)                                             # Plotting to see the result 
nbr0<-writeRaster(postnbr,"nbr520.tiff",overwrite=TRUE)   # Creating a raster of the NBR map

# Comparing it to the false color image
compnbr<-par(mfrow=c(2,1))
im.plotRGB(stackpost,4,2,1)
plot(postnbr)

dev.off()

# Now this is more like it, shadows no longer represent an issue for our investigation
# Let's divide the plot in classes so that we can start quantifying
# From the NBR plot I see that the burned pixels have a value approximately below 0.3
# I'm creating a raster containing only true or false cells, 
# true cells are those that have value below 0.3 and are considered burned vegetation
burnt<-postnbr<0.3                                       # creating an object containing my threshold
plot(burnt)                                              # plotting the result 
writeRaster(burnt,"burned_area.tiff",overwrite=TRUE)     # creating the raster containing only true or false cells
burnt_rast<-rast("burned_area.tiff")                     # importing the raster I've just created
burnt_rast                                               # printing the raster to see what it is made of

# Each cell can either have a value of 1(burned) or 0(not burned). I can get the number of each class using the function freq()
class_num<-freq(burnt_rast)    # calculating the number of true and false cells
class_num                      # printing said numbers (1=TRUE=Burned, 0=FALSE=Healthy)
# The result is:
# layer value   count
# 1     1     0 1645929
# 2     1     1  871571
# This means that there are 871571 cells representing the burned area. Now, knowing that Sentinel-2 has a resolution of 10 meters per pixel I can easily calculate the total area
km2<-(871571*100)/10^6      # calculating the area in km^2
km2                         # printing the value
#[1] 87.1571

perc_burnt<-(871571/2517500)*100 # calculating the percentage of burned surface
perc_burnt                       # printing the value
#[1] 34.6205
dev.off()
#--------------------------------------------------------------------------dNBR---------------------------------------------
# Now to better comprehend the scope of the damage caused by the fire, I am going to calculate the differential Normalized Burn Ratio
# Higher values represent damaged areas and lower values represent recovering vegetation
# First I'm calculating the NBR before the fire
prenbr<-calcnbr(ab8,ab12)                        # calculating the NBR of the pre-fire image
plot(prenbr)                                     # plotting it to see if it makes sense (it does)
writeRaster(prenbr,"prenbr.tiff",overwrite=TRUE) # turning it into a raster and saving it 
rast_prenbr<-rast("prenbr.tiff")                 # importing the pre-fire NBR raster

# Now I'm subtracting the post-fire NBR to the pre-fire NBR to get a map of the differential NBR
dnbr0<-rast_prenbr-postnbr            # calculating the differential NBR
plot(dnbr,main=("dNBR 09-05-2020"))  # plotting the dNBR map

dev.off() # Enough already! My warranty is already expired and can't be extended

#----------------------------------------------------PHASE 4: RECOVERY ANALYSIS--------------------------------------------------------------------------------------------------------------------#
# To study the recovery of the vegetation in the are I will compare the percentage of burned area from the event up to three years later 
# then I will use the dNBR for each time stem to better visualize it.
# I will the proceed to compare the NBR of 2020, 2022, 2024 and 2025
# I will start by importing all the data necessary 

# Importing band 8 and 12 from November 20th 2020 
b8_1120<-rast("201120b8.tiff")                          # Importing band 8 (NIR)
b12_1120<-rast("201120b12.tiff")                        # Importing band 12 (SWIR)
# Calculating NBR and dNBR
nbr1120<-calcnbr(b8_1120,b12_1120)                      # Calculating NBR
writeRaster(nbr1120,"nbr1120.tiff",overwrite=TRUE)      # Creating NBR raster map
nbr1<-rast("nbr1120.tiff")                              # Importing NBR rater map
plot(nbr1)                                              # Plotting NBR raster map
dnbr1<-prenbr-nbr1                                      # Calculating dNBR

# Importing band 8 and 12 from May 14th 2021 
b8_521<-rast("140521b8.tiff")
b12_521<-rast("140521b12.tiff")
# Calculating NBR
nbr521<-calcnbr(b8_521,b12_521)
writeRaster(nbr1120,"nbr521.tiff",overwrite=TRUE)
nbr2<-rast("nbr521.tiff")
plot(nbr2)
dnbr2<-prenbr-nbr2

# Importing band 8 and 12 from September 11th 2021 
b8_1121<-rast("110921b8.tiff")
b12_1121<-rast("110921b12.tiff")
# Calculating NBR
nbr1121<-calcnbr(b8_1121,b12_1121)
writeRaster(nbr1120,"nbr1121.tiff",overwrite=TRUE)
nbr3<-rast("nbr1121.tiff")
plot(nbr3)
dnbr3<-prenbr-nbr3

# Importing band 8 and 12 from June 18th 2022 
b8_622<-rast("180622b8.tiff")
b12_622<-rast("180622b12.tiff")
# Calculating NBR
nbr622<-calcnbr(b8_622,b12_622)
writeRaster(nbr622,"nbr622.tiff",overwrite=TRUE)
nbr4<-rast("nbr622.tiff")
plot(nbr4)
dnbr4<-prenbr-nbr4

# Importing band 8 and 12 from May 4th 2023 
b8_523<-rast("040523b8.tiff")
b12_523<-rast("040523b12.tiff")
# Calculating NBR
nbr523<-calcnbr(b8_523,b12_523)
writeRaster(nbr523,"nbr523.tiff",overwrite=TRUE)
nbr5<-rast("nbr523.tiff")
plot(nbr5)
dnbr5<-prenbr-nbr5

# Confronting dNBRs from May 2020 to May 2023
confNBR<-par(mfrow=c(3,2))
plot(dnbr0,col=viridis(100),main="09-05-2020")
plot(dnbr1,col=viridis(100),main="20-09-2020")
plot(dnbr2,col=viridis(100),main="14-05-2021")
plot(dnbr3,col=viridis(100),main="11-09-2021")
plot(dnbr4,col=viridis(100),main="18-06-2022")
plot(dnbr5,col=viridis(100),main="04-05-2023")

dev.off() #Thank you! It couldn't take it any longer

# We can hardly see the recovery take place. It is clear that between September 2021 and June 2022 a strong recovery has taken place
# Now let's make numbers clarify what the eye can't fathom
# Just like earlier we are going to divide the raster in two classes (burned=TRUE, healthy=FALSE). To do this we have to decide on a standard threshold to use for all the images

lim<-0.3 # setting my threshold to 0.3 

# dividing each raster into two classes and calculating the frequency of each class and the percentage of the burned pixels
# Now I'm writing a function to calculate the percentage of pixels that are true in a raster
# Here I'm telling the function to take the number that is in the second row and third column of the output of the function "freq()" (this is the number of true pixels),
# divide that number by the x dimension of the raster multiplied by its y dimension and to multiply the result by 100.
# Finally by using the function "round()" I specify that I only want to keep the first two decimals of the result
bper<-function(x){                                                   # "x" is the raster already processed to be made of only true or false cells
  perc<-round(freq(x)[2,3]/(dim(x)[1]*dim(x)[2])*100,2) 
}

              # 09-05-2020
fr0<-nbr0<lim                                      # dividing my NBR map in true and false cells
writeRaster(fr0,"burnt0.tiff",overwrite=TRUE)      # creating the classified raster
burnt0<-rast("burnt0.tiff")                        # importing the classified raster
perc0<-bper(fr0)                                   # calculating the percentage of true/burned cells
perc0                                              # printig said percentage
              # 20-09-2020
fr1<-nbr1<lim
writeRaster(fr1,"burnt1.tiff",overwrite=TRUE)
burnt1<-rast("burnt1.tiff")
perc1<-bper(fr1)
perc1
              # 14-05-2021
fr2<-nbr2<lim
writeRaster(fr2,"burnt2.tiff",overwrite=TRUE)
burnt2<-rast("burnt2.tiff")
perc2<-bper(fr2)
perc2
              # 11-09-2021
fr3<-nbr3<lim
writeRaster(fr3,"burnt3.tiff",overwrite=TRUE)
burnt3<-rast("burnt3.tiff")
perc3<-bper(fr3)
perc3
              # 18-06-2022
fr4<-nbr4<lim
writeRaster(fr4,"burnt4.tiff",overwrite=TRUE)
burnt4<-rast("burnt4.tiff")
perc4<-bper(fr4)
perc4
              # 04-05-2023
fr5<-nbr5<lim
writeRaster(fr5,"burnt5.tiff",overwrite=TRUE)
burnt5<-rast("burnt5.tiff")
perc5<-bper(fr5)
perc5

#----------------------------------------------------PHASE 4: SUMMARY--------------------------------------------------------------------------------------------------------------------#
# Here I will summarize the data elaborated so far with plots and tables to highlight the most crucial aspects of this analysis.

# Creating a composite graph with the dNBR plots, date, and estimated percentage of burned area/exposed soil
confnbr<-par(mfrow=c(3,2))
plot(nbr0,col=viridis(100),main=paste("09-05-2020 burned area:",perc0,"%"))     # I'm using the function "paste" to put an object (ex. perc0) inside a line of text
plot(nbr1,col=viridis(100),main=paste("20-09-2020 burned area:",perc1,"%"))
plot(nbr2,col=viridis(100),main=paste("14-05-2021 burned area:",perc2,"%"))
plot(nbr3,col=viridis(100),main=paste("11-09-2021 burned area:",perc3,"%"))
plot(nbr4,col=viridis(100),main=paste("18-06-2022 burned area:",perc4,"%"))
plot(nbr5,col=viridis(100),main=paste("04-05-2023 burned area:",perc5,"%"))

# Creating pie charts to better visualize the percentage of burned area

# First I need to create a data frame with the percentage of healthy and burned soil for each time step
# Create vector containing the "qualities" 
legend<-c("Healthy","Burned")
# Create vector containing the percentage of each quality for May 2020
may2020<-c(round(freq(fr0)[1,3]/(dim(fr0)[1]*dim(fr0)[2])*100,2),
          round(freq(fr0)[2,3]/(dim(fr0)[1]*dim(fr0)[2])*100,2))
# Create vector containing the percentage of each quality for June 2022
june2022<-c(round(freq(fr4)[1,3]/(dim(fr4)[1]*dim(fr4)[2])*100,2),
           round(freq(fr4)[2,3]/(dim(fr4)[1]*dim(fr4)[2])*100,2))
# Creating the data frame
tab<-data.frame(cat,may2020,june2022)

# Creating a pie chart turned out to be quite a challenge and required some research to finally get it done.
# Ultimately it's a bar plot, but the bars are put on top of each other, there's no x or y axis and the length of the bars is transformed to polar coordinates

# Creating a pie chart for May 2020
pie2020<-ggplot(tab, aes(x="",y=may2020,fill=legend)) +                   # x="" makes it so the bars are on top of each other, I need to do this to turn the barplot into a pie
  geom_bar(stat="identity",width=1) +                                     # setting tupe of graph to a barplot
  coord_polar(theta="y") +                                                # Transform the value of the bars into polar coordinates
  theme_void() +                                                          # Deletes the axes
  geom_text(aes(label=paste(may2020, "%")),                               # Putting the percentage inside the corresponding slice
            position=position_stack(vjust=0.5)) +                         # Positioning the value at the center of the slice
  scale_fill_manual(values=c("Healthy"="blue", "Burned"="orange")) +      # Setting the colors to a colorblind-friendly pair
  ggtitle("Pie chart for the burned area in May 2020")                    # Title of the chart

plot(pie2020)

# Creating a pie chart for june 2022
pie2022<-ggplot(tab, aes(x="",y=june2022,fill=legend)) +                   
  geom_bar(stat="identity",width=1) +                                     
  coord_polar(theta="y") +                                                
  theme_void() +                                                          
  geom_text(aes(label=paste(june2022, "%")),                               
            position=position_stack(vjust=0.5)) +                         
  scale_fill_manual(values=c("Healthy"="blue", "Burned"="orange")) +      
  ggtitle("Pie chart for the burned area in June 2022")                    

plot(pie2022)
#plotting the two pie charts together 
plot(pie2020+pie2022)

dev.off() # That's all folks!

#???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????

