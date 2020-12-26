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
colnames(nycdistricts)

colnames(nysbssData0) <- colnames(nysbssData0) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
colnames(nysbssData0)
## unique value
nysbssData0 <- distinct(nysbssData0)

##choose the observation area
CDMap1boro <- nycdistricts %>%  
  filter(borocd < "199") %>% 
  `colnames<-`(str_to_lower(colnames(nycdistricts)))

qtm(CDMap1boro)

'''
# split the date and time
nysbssData0 <- nysbssData0 %>%
  mutate(
    startday = date(starttime),
  )
nysbssData0$starttime <-strftime(nysbssData0$starttime, format="%H:%M:%S")
nysbssData0$starttime <- chron(times=nysbssData0$starttime)
'''

# filter date 
nysbssData3 <- nysbssData0 %>%
  filter(starttime >= ymd_hms('20190908 00:00:00') & starttime <= ymd_hms('20190912 00:00:00'))

nysbssData4 <-nysbssData0 %>%
  filter(starttime >= ymd_hms('20190910 00:00:00') & starttime <= ymd_hms('20190911 00:00:00'))

## Time Series Analysis
nysbssData1 <- nysbssData4 %>% select(starttime,start_station_latitude,start_station_longitude)
nysbssData2 <- nysbssData4 %>% select(starttime,end_station_latitude,end_station_longitude)

nysbssData1 %>% 
  ggplot(aes(starttime)) + 
  geom_freqpoly(binwidth = 600)


## st to sf
nysbssData1 <- st_as_sf(nysbssData0, coords = c("start_station_longitude", "start_station_latitude"), crs = "WGS84")
nysbssData2 <- st_as_sf(nysbssData0, coords = c("end_station_longitude", "end_station_latitude"),crs = "WGS84")

nysbssData1 <- nysbssData1 %>% st_transform(.,crs="epsg:2263")
nysbssData2 <- nysbssData2 %>% st_transform(.,crs="epsg:2263")

##Change CRS for boro shp
CDMap1boro <- CDMap1boro %>% 
  st_transform(.,crs = "epsg:2263")



##limit the data in the Manhattan boro
nysbssData1sub <- nysbssData1[CDMap1boro,]



##compare data in map
tmap_mode("view")
tm_shape(CDMap1boro) +
  tm_polygons(col = NA, alpha = 0.5) +
tm_shape(nysbssData1sub) +
  tm_dots()



#now set a window as the borough boundary
window <- as.owin(CDMap1boro)
#plot(window)

#create a ppp object
nysbssData1sub<- nysbssData1sub %>%
  as(., 'Spatial')

nysbssData1sub.ppp <- ppp(x=nysbssData1sub@coords[,1],
                          y=nysbssData1sub@coords[,2],
                          window=window)

nysbssData1sub.ppp %>%
  plot(.,pch=16,cex=0.5, 
       main="bike start location")

#Kernel Density Estimation
nysbssData1sub.ppp %>%
  density(., sigma=1000) %>%
  plot()
