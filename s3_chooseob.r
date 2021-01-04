##choose the observation area (No Staten island because of long bridge and no observation there)
CDMap1boro <- nycd %>%  
  filter(borocd >= "355" & borocd <= "402" & borocd != "356"| borocd >= "301" & borocd <= "309" & borocd != "305"| borocd <= "164" & borocd != "112" ) %>% 
  `colnames<-`(str_to_lower(colnames(nycd)))

#qtm(CDMap1boro)

##Change CRS for boro shp
CDMap1boro <- CDMap1boro %>% 
  st_transform(.,crs = "epsg:2263")

## st to sf
nbday_start <- st_as_sf(nbday, coords = c("start_station_longitude", "start_station_latitude"), crs = "WGS84")
nycmorningstart <- st_as_sf(nbmorning, coords = c("start_station_longitude", "start_station_latitude"),crs = "WGS84")
nycmorningend <- st_as_sf(nbmorning, coords = c("end_station_longitude", "end_station_latitude"),crs = "WGS84")
nycnightstart <- st_as_sf(nbnight, coords = c("start_station_longitude", "start_station_latitude"), crs = "WGS84")
nycnightend <- st_as_sf(nbnight, coords = c("end_station_longitude", "end_station_latitude"),crs = "WGS84")
nbday_start <- nbday_start %>% st_transform(.,crs="epsg:2263")
nycmorningstart <- nycmorningstart %>% st_transform(.,crs="epsg:2263")
nycmorningend <- nycmorningend %>% st_transform(.,crs="epsg:2263")
nycnightstart <- nycnightstart %>% st_transform(.,crs="epsg:2263")
nycnightend <- nycnightend %>% st_transform(.,crs="epsg:2263")

##limit the data in the Manhattan boro
nbday_start <- nbday_start[CDMap1boro,]
nycmorningstart <- nycmorningstart[CDMap1boro,]
nycmorningend <- nycmorningend[CDMap1boro,]
nycnightstart <- nycnightstart[CDMap1boro,]
nycnightend <- nycnightend[CDMap1boro,]

##compare data in map
tmap_mode("plot")
tm_shape(CDMap1boro) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(nbday_start) +
  tm_dots()
