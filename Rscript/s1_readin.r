#set up for library

library(broom)
library(car)
library(chron)
library(corrr)
library(crosstalk)
library(fs)
library(fpc)
library(geojson)
library(geojsonio)
library(ggplot2)
library(ggthemes)
library(GISTools)
library(GWmodel)
library(here)
library(janitor)
library(lubridate)
library(maptools)
library(mapview)
library(plotly)
library(qpcR)
library(raster)
library(rgdal)
library(rgeos)
library(scales)
library(sf)
library(stringr)
library(sp)
library(spatstat)
library(spatialreg)
library(spdep)
library(spgwr)
library(tidyverse)
library(tmap)
library(tmaptools)



##First, get the London Borough Boundaries
nycd <- st_read("https://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/NYC_Community_Districts/FeatureServer/0/query?where=1=1&outFields=*&outSR=4326&f=pgeojson")


nb <- read_csv(here::here("data", "rawdata","201909-citibike-tripdata.csv"),
               locale = locale(encoding = "utf-8"))

nb <- read_csv(unz(here::here("data", "rawdata","201909-citibike-tripdata.zip"),
                     "201909-citibike-tripdata.csv"),
               locale = locale(encoding = "utf-8")
                 )

id <- "0B-wuZ2XMFIBUd09Ob0pKVkRzQTA" # google file ID
read.csv(sprintf("https://docs.google.com/uc?id=%s&export=download", id))

## clean name
colnames(nycd) <- colnames(nycd) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
colnames(nb) <- colnames(nb) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
colnames(nycd)
colnames(nb)
## unique value
nb <- distinct(nb)
# choose columns
nb <- nb %>% 
  dplyr::select(starttime,start_station_latitude,start_station_longitude,end_station_latitude,end_station_longitude)



# filter date 
nbweek <- nb %>%
  filter(starttime >= ymd_hms('20190908 00:00:00') & starttime <= ymd_hms('20190914 00:00:00'))
nbday <-nb %>%
  filter(starttime >= ymd_hms('20190910 00:00:00') & starttime <= ymd_hms('20190911 00:00:00'))
