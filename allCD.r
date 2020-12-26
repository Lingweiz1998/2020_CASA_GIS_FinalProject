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
nysbssDataweek <- nysbssData0 %>%
  filter(starttime >= ymd_hms('20190908 00:00:00') & starttime <= ymd_hms('20190912 00:00:00'))
nysbssDataday <-nysbssData0 %>%
  filter(starttime >= ymd_hms('20190910 00:00:00') & starttime <= ymd_hms('20190911 00:00:00'))


## Time Series Analysis
nysbssDataday %>% 
  ggplot(aes(starttime)) + 
  geom_freqpoly(binwidth = 1200)

nycmorning <- nysbssDataday %>%
  filter(starttime >= ymd_hms('20190910 07:00:00') & starttime <= ymd_hms('20190911 11:00:00'))
nycafternoon <- nysbssDataday %>%
  filter(starttime >= ymd_hms('20190910 16:00:00') & starttime <= ymd_hms('20190911 20:00:00'))

## st to sf
nycmorningstart <- st_as_sf(nycmorning, coords = c("start_station_longitude", "start_station_latitude"), crs = "WGS84")
nycmorningend <- st_as_sf(nycmorning, coords = c("end_station_longitude", "end_station_latitude"),crs = "WGS84")
nycnightstart <- st_as_sf(nycafternoon, coords = c("start_station_longitude", "start_station_latitude"), crs = "WGS84")
nycnightend <- st_as_sf(nycafternoon, coords = c("end_station_longitude", "end_station_latitude"),crs = "WGS84")

nycmorningstart <- nycmorningstart %>% st_transform(.,crs="epsg:2263")
nycmorningend <- nycmorningend %>% st_transform(.,crs="epsg:2263")
nycnightstart <- nycnightstart %>% st_transform(.,crs="epsg:2263")
nycnightend <- nycnightend %>% st_transform(.,crs="epsg:2263")

##choose the observation area
CDMap1boro <- nycdistricts %>%  
  filter(borocd < "500") %>% 
  `colnames<-`(str_to_lower(colnames(nycdistricts)))
qtm(CDMap1boro)
##Change CRS for boro shp
CDMap1boro <- CDMap1boro %>% 
  st_transform(.,crs = "epsg:2263")

##limit the data in the Manhattan boro
nycmorningstart <- nycmorningstart[CDMap1boro,]
nycmorningend <- nycmorningend[CDMap1boro,]
nycnightstart <- nycnightstart[CDMap1boro,]
nycnightend <- nycnightend[CDMap1boro,]

##compare data in map
tmap_mode("view")
tm_shape(CDMap1boro) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(nycmorningstart) +
  tm_dots()

tm_shape(CDMap1boro) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(nycmorningend) +
  tm_dots()

#now set a window as the borough boundary
window <- as.owin(CDMap1boro)
#plot(window)
#create a ppp object
nycmorningstartsub<- nycmorningstart %>%
  as(., 'Spatial')
nycmorningendsub<- nycmorningend %>%
  as(., 'Spatial')
nycnightstartsub<- nycnightstart %>%
  as(., 'Spatial')
nycnightendsub<- nycnightend %>%
  as(., 'Spatial')
nycmorningstartsub.ppp <- ppp(x=nycmorningstartsub@coords[,1],
                              y=nycmorningstartsub@coords[,2],
                              window=window)
nycmorningendsub.ppp <- ppp(x=nycmorningendsub@coords[,1],
                            y=nycmorningendsub@coords[,2],
                            window=window)
nycnightstartsub.ppp <- ppp(x=nycnightstartsub@coords[,1],
                            y=nycnightstartsub@coords[,2],
                            window=window)
nycnightendsub.ppp <- ppp(x=nycnightendsub@coords[,1],
                          y=nycnightendsub@coords[,2],
                          window=window)

nycmorningstartsub.ppp %>%
  plot(.,pch=16,cex=0.5, 
       main="bike start location")

#Kernel Density Estimation
nycmorningstartsub.ppp %>%
  density(., sigma=1500) %>%
  plot(main="morning peak time start")
nycmorningendsub.ppp %>%
  density(., sigma=1000) %>%
  plot(main="morning peak time end")
nycnightstartsub.ppp %>%
  density(., sigma=1000) %>%
  plot(main="night peak time start")
nycnightendsub.ppp %>%
  density(., sigma=1000) %>%
  plot(main="night peak time start")