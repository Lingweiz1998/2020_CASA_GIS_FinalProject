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
library(here)
library(janitor)
library(lubridate)
library(maptools)
library(mapview)
library(plotly)
library(raster)
library(rgdal)
library(rgeos)
library(scales)
library(sf)
library(stringr)
library(sp)
library(spatstat)
library(spdep)
library(spgwr)
library(tidyverse)
library(tmap)
library(tmaptools)

# minimal theme for nice plots throughout the project
theme_set(theme_bw)

##First, get the London Borough Boundaries
nycd <- st_read(here::here("data", "rawdata","dividedmap_citibike.geojson"))


nb <- read_csv(here::here("data", "rawdata","201909-citibike-tripdata.csv"),
               locale = locale(encoding = "latin1"))
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
nycd <- nycd %>%
  dplyr::select(poly_id,geometry)
nycd <- nycd %>%
  rename(borocd = poly_id)


# filter date 
nbweek <- nb %>%
  filter(starttime >= ymd_hms('20190908 00:00:00') & starttime <= ymd_hms('20190914 00:00:00'))
nbday <-nb %>%
  filter(starttime >= ymd_hms('20190910 00:00:00') & starttime <= ymd_hms('20190911 00:00:00'))
