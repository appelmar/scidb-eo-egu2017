install.packages(c("devtools"), repos="http://cran.rstudio.com/")
install.packages(c("bfast","raster","sp","gdalUtils", "rgdal", "plyr","xts"), repos="http://cran.rstudio.com/")
devtools::install_github("Paradigm4/SciDBR", ref="419a8968149fca9a72fbd55a3dd8d4e8897181a3") 
devtools::install_github("flahn/scidbst", ref="dev")
