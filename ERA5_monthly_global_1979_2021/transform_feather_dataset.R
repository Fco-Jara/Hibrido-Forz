rm(list = ls())
gc()
library(feather)
library(dplyr)
library(lubridate)

# round and format with n decimals
redondear               <- function(x, n){x=format(round(x,n),nsmall = n)}

# transform all the columns with a function except for the date column

transform_all_but_dates <- function(dataset,FUN) {
  dates                 <- dataset$date
  matrix                <- dataset %>%  select(-date)
  dataset               <- FUN(matrix)  %>% transform(date=dates)
  return(dataset)
}

# read directory
path_dir                <- "/home/fco/git_workspace/Jupyter_projects/files_feather/"
list_filenames          <-
  c(paste0(path_dir,"geoH_1000hpa_global_monthly_era5_1979_2021.feather"),
    paste0(path_dir,"geoH_500hpa_global_monthly_era5_1979_2021.feather"),
    paste0(path_dir,"geoH_700hpa_global_monthly_era5_1979_2021.feather") ,
    paste0(path_dir,"pp_global_monthly_era5_1979_2021.feather") ,         
    paste0(path_dir,"t2m_global_monthly_era5_1979_2021.feather") )

#read specific file
filename                <- list_filenames[4]

# select only certain columns
col_names               <- names(read_feather("/home/fco/git_workspace/Jupyter_projects/files_nc/DIEGOS//era5_t2m_1979-2020_mes.feather"))

## read precipitation dataset and apply transformations

dataset                 <- read_feather(filename,columns = col_names) %>%
  transform_all_but_dates(function(x) sweep(x, MARGIN = 1,STATS =  days_in_month(.$date), FUN = `*`) ) %>%
  transform_all_but_dates(function(x) multiply_by(x,1000))  %>%
  transform_all_but_dates(function(x) redondear(x,3)) %>%
  select(date,everything())




  


