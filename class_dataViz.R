#the following code had been as part of an assignment constructed in https://r4bio.devbioinformatics.org/

#this is a great platform to get to know Rstudio methodical, and application piece of the platform. 
#this will be great to complete as a baseline for bioinformatics approach. 

#this is an example of a pipline that uses 4 packages ggplot2, readr, devtools and patchwork. 
#we use many packages in coding to allow a simple way to distribute R code and documentations. 
#in this instance the packages we use are the 4 mentioned and thier uses are as the following: (and a one main usage)
# ggplot2 -> is a R package dedicated to data visualization. 
# readr -> is used to read "rectangle " data ((csv, tsv,fwf)) into our code, in multiple forms 
# devtools -> a package that holds R functions that simplify common tasks.  
# patchwork -> combines multiple ggplot graphs into the same graph 

#we start by installing relevent packages that might not be in our portfolio. if you work on the cluster you should be able to import into the session
#prior to begining it. 
install.packages("devtools")
install.packages("patchwork")

#after installation we than call the package in the form of a library
library(ggplot2)
library(readr)


# remember! you only need to install a package once, but you must call relevant libraries with each new session. or when you clean the environment. 


#------

#after the installation and importing/reading in the relevant packages we read a rectangler data format into the session 
trees <- read_tsv("https://ndownloader.figshare.com/files/5629536")

# ---- checkpoint-----
# look at the right-bottom section of the Rstudio window, and look for the files tab. than select files tab. 
# (you should see that there are 5 tabs :  <files> ; <plots> ; <packages> ; <help> ; <viewer> )
#-----------------------

# ---- checkpoint-----
#to check the table that you downloaded you can either print, or use head function to print the first 6 lines
head(trees)
print(trees)

#you can print a specific column of the table by using a dollar sign "$" after the table name, and than select the column name
head(trees$SURVEY)
#-----------------------

#now this is when we 
ggplot(trees, aes(x = HEIGHT, y = CIRC)) +
  geom_point()


# ---- checkpoint-----
# what other things can you do with ggplot function? what is geom_point() function does? 
# for questions like this, go to either the search button in the right-bottom section and type the function or library in the search tab.
# or use the following line:
?geom_point()
# read the documentation and apply one change to the function in line 33-34.
# were the two graphs different in how they looked? -> Now you know how to design the graph the way you want it!
#-----------------------



#we can look at the polts and see the plot we just created. but if we want to save the figure we can use one of the following options!
#once you do that , go to the files sections, and select the file to use as you please!

ggsave("acacia_size_scaling.png")
ggsave("acacia_size_scaling.svg")
ggsave("acacia_size_scaling.pdf")


ggsave("acacia_size_scaling.png", height = 7, width = 10)


ggsave("acacia_size_scaling.png", dpi = 300)
ggsave("acacia_size_scaling.png", dpi = 30)

# ---- checkpoint-----
# have a question about any of the ggsave() implimintations, go and run the next line and read the documentations.
#remmeber how? if not here you go in line 62
?ggsave()
# ----------------------


ggplot(trees, aes(x = HEIGHT, y = CIRC, color = SPECIES)) +
  geom_point() +
  scale_color_viridis_d()

ggplot(trees, aes(x = HEIGHT, y = CIRC, color = SPECIES)) +
  geom_point() +
  scale_color_viridis_d(option = "magma")


#you can also save the graph as a variable and use it in other functions. like the following. 

# first we populate species_scaling variable with our graph
species_scaling <- ggplot(trees, aes(x = HEIGHT, y = CIRC, color = SPECIES)) +
  geom_point() +
  scale_color_viridis_d()

species_scaling #this prints the graph in the plots tab in the buttom right tab.

#than secondly, use the variable name in a different function like ggsave, and see your file in files tab. 

ggsave("species_scaling.jpg", species_scaling)

# ---- checkpoint-----
#how did you do? any questions go to https://r4bio.devbioinformatics.org/assignments/r-datavis/
# ----------------------

library(devtools)
install_github('thomasp85/patchwork')

# ---- checkpoint-----
#the placements of the libraries that are called within a session can be all at the beggining of the code, or throughout the code. but they must 
# be loaded before one of the packages' functions are used
# some packages you would need to download from a platform such as github.
# we will load devtools package to use the install_github function

# you can read the documentation of the package on git! https://github.com/thomasp85/patchwork
# ----------------------

library(patchwork)

height_dist <- ggplot(trees, aes(x = HEIGHT, fill = SPECIES)) +
  geom_histogram() +
  scale_fill_viridis_d()

#---checkpoint---
#please notice that there is an errorn when you run the next line
height_dist
#you might ask, "why???" let us find out

#first print the dataframe 
print(trees)

#now notice how each column has the column name, and underneath it there is the type of data
#if you look at the height column it shows as a charachter type, even though we have numbers

# SURVEY  YEAR SITE  TREATMENT BLOCK PLOT    SPECIES ORIGINAL_TAG NEW_TAG DEAD  HEIGHT AXIS_1
# <dbl> <dbl> <chr> <chr>     <dbl> <chr>   <chr>          <dbl>   <dbl> <chr> <chr>   <dbl>

#so what should we do???
#we will transform the column type into a double type (since the numbers are in decimal)
#<dataframe>$<column name> <- as.double(#<dataframe>$<column name>)
trees$HEIGHT <- as.double(trees$HEIGHT)

#print again and see what changed
print(trees)

#notice how the column type for height has changed from chr to dbl.
# you did it!

# SURVEY  YEAR SITE  TREATMENT BLOCK PLOT    SPECIES ORIGINAL_TAG NEW_TAG DEAD  HEIGHT AXIS_1
# <dbl> <dbl> <chr> <chr>     <dbl> <chr>   <chr>          <dbl>   <dbl> <chr>  <dbl>  <dbl>

#now you can keep redo the graphing part as the following
#---

height_dist <- ggplot(trees, aes(x = HEIGHT, fill = SPECIES)) +
  geom_histogram() +
  scale_fill_viridis_d()

#now using patchwork we can combine the two graphs into one. 
species_scaling + height_dist

#we can set the graphs in one column , meaning vertically

species_scaling + height_dist +
  plot_layout(ncol = 1)

#we can also influance the layout of the graphs together. 
#run the next code, can you notice the changes?

species_scaling + height_dist +
  plot_layout(ncol = 1, heights = c(3, 1))

#we can add annotations
species_scaling + height_dist +
  plot_layout(ncol = 1, heights = c(3, 1)) +
  plot_annotation(tag_levels = "A")

#or control the themes of the graphs individually
height_dist <- height_dist +
  theme_void() +
  theme(legend.position='none')

# can you figure out what is special about this next one? how is it different?
height_dist + species_scaling + plot_layout(ncol = 1, heights = c(1, 5))



#-------------------------------------------------
# great job completing this workflow!
#   
# how did you do?????
#   
# check out https://r4bio.devbioinformatics.org/ for more practice and work in Rstudio. 
