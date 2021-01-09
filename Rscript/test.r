nycd <- st_read(here::here("data", "rawdata","nyccitibikearea1.geojson"))

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


nycd <- nycd %>%
  dplyr::select(poly_id,geometry,area)
CDMap1boro <- nycd %>% 
  dplyr::rename(borocd = poly_id)
CDMap1boro <- CDMap1boro %>% 
  mutate(area = scale(area,center = FALSE))

CDMap1boro <- CDMap1boro%>%
  filter(borocd >= "251")
tmap_mode("view")
qtm(CDMap1boro)
