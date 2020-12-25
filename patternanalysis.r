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
library(tibbletime)
library(ggplot2)


# minimal theme for nice plots throughout the project
theme_set(theme_minimal())

##First, get the London Borough Boundaries
nycdistricts <- st_read("https://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/NYC_Community_Districts/FeatureServer/0/query?where=1=1&outFields=*&outSR=4326&f=pgeojson")
nysbssData0 <- read_csv(here::here("data", "rawdata","20200917-citibike-tripdata.csv"),
                       locale = locale(encoding = "latin1"))


'''
LondonBoroughs <- st_read("https://opendata.arcgis.com/datasets/8edafbe3276d4b56aec60991cbddda50_4.geojson")
BoroughMap <- LondonBoroughs %>%
  dplyr::filter(str_detect(lad15cd, "^E09"))%>%
  st_transform(., 27700)
Harrow <- BoroughMap %>%
  filter(., lad15nm=="Harrow")
'''

nycdistricts %>% 
  ggplot() +
  geom_sf(color = "#1F77B4") +
  # nyc community districts outlines overlaid in orange
  geom_sf(data = nycdistricts, color = "#FF7F0E", size = 1, fill = NA) +
  ggtitle("NYC community districts") +
  xlab("Longitude") +
  ylab("Latitude")

summary(nysbssData)
summary(nycdistricts)


##Change CRS if necessary
CDMap <- nycdistricts %>% 
  st_transform(.,crs = "WGS84")

## data cleaning
nysbssData0<- nysbssData %>% slice(723457:776363)
write.csv(nysbssData0,here::here("data", "rawdata","20200917-citibike-tripdata.csv"), row.names = FALSE)

## clean name
colnames(CDMap) <- colnames(CDMap) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
colnames(CDMap)

colnames(nysbssData0) <- colnames(nysbssData0) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
colnames(nysbssData0)

CDMap4boro <- CDMap %>%  
  filter(borocd != "501"&borocd != "502"&borocd != "503"&borocd != "595") %>% 
  `colnames<-`(str_to_lower(colnames(CDMap)))

## unique value
nysbssData0 <- distinct(nysbssData0)

## st to sf
nysbssData1 <- st_as_sf(nysbssData0, coords = c("start_station_longitude", "start_station_latitude"), crs = "WGS84")
nysbssData2 <- st_as_sf(nysbssData0, coords = c("end_station_longitude", "end_station_latitude"),crs = "WGS84")

nysbssData1 <- st_transform(nysbssData1, crs = "WGS84")
nysbssData2 <- st_transform(nysbssData2, crs = "WGS84")

summary()

##compare data in map
tmap_mode("view")
tm_shape(CDMap4boro) +
  tm_polygons(col = NA, alpha = 0.5) +
tm_shape(nysbssData1) +
  tm_dots()

#now set a window as the borough boundary
window <- as.owin(nycbond)
plot(window)

summary()

