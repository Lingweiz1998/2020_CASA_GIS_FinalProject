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


# minimal theme for nice plots throughout the project
theme_set(theme_minimal())

##First, get the London Borough Boundaries
nysbssData0 <- read_csv(here::here("data", "rawdata","201909-citibike-tripdata.csv"),
                        locale = locale(encoding = "latin1"))

nycdistricts <- st_read("https://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/NYC_Community_Districts/FeatureServer/0/query?where=1=1&outFields=*&outSR=4326&f=pgeojson")

## clean name
colnames(nycdistricts) <- colnames(nycdistricts) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
colnames(nysbssData0) <- colnames(nysbssData0) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
colnames(nycdistricts)
colnames(nysbssData0)
## unique value
nysbssData0 <- distinct(nysbssData0)
# choose columns
nysbssData0 <- nysbssData0 %>% 
  select(starttime,start_station_latitude,start_station_longitude,end_station_latitude,end_station_longitude)


# filter date 
nysbssDataweek <- nysbssData0 %>%
  filter(starttime >= ymd_hms('20190908 00:00:00') & starttime <= ymd_hms('20190912 00:00:00'))
nysbssDataday <-nysbssData0 %>%
  filter(starttime >= ymd_hms('20190910 00:00:00') & starttime <= ymd_hms('20190911 00:00:00'))