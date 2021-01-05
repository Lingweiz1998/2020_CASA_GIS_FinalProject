nyct <- st_read("https://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/NYC_Atomic_Polygons/FeatureServer/0/query?where=1=1&outFields=*&outSR=4326&f=geojson")

nyct <- nyct %>% 
  st_transform(.,crs = "epsg:2263")

nyctmap <- nyct[CDMap1boro,]
qtm(map1)

CDMap1boro_spatial<- CDMap1boro %>%
  as(., 'Spatial')
writeOGR(CDMap1boro_spatial, dsn=here::here("data", "map.GeoJSON"), layer="citibike", driver="GeoJSON")


grid_spacing <- 500  # size of squares, in units of the CRS (i.e. meters for 5514)

map1 <- st_make_grid(CDMap1boro, square = T, cellsize = c(grid_spacing, grid_spacing)) %>% # the grid, covering bounding box
  st_sf() # not really required, but makes the grid nicer to work with later
plot(map1, col = 'white')
plot(st_geometry(CDMap1boro), add = T)
