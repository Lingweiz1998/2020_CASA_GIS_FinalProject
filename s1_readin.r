#set up for library
library(spatstat)
library(here)
library(sp)
library(rgeos)
library(maptools)
library(GISTools)
library(tmap)
library(sf)
library(geojson)
library(geojsonio)
library(tmaptools)
library(stringr)
library(tidyverse)
library(ggthemes)
library(mapview)
library(lubridate)
library(chron)
library(ggplot2)
library(raster)
library(fpc)
library(spdep)

# minimal theme for nice plots throughout the project
theme_set(theme_minimal())

##First, get the London Borough Boundaries
nb <- read_csv(here::here("data", "rawdata","201909-citibike-tripdata.csv"),
                        locale = locale(encoding = "latin1"))

nycd <- st_read("https://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/NYC_Community_Districts/FeatureServer/0/query?where=1=1&outFields=*&outSR=4326&f=pgeojson")

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
