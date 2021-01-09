nycn <- st_read(here::here("data", "rawdata","NTA","geo_export_9696fb07-53a6-4541-b653-146159348413.shp"))

colnames(nycn) <- colnames(nycn) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")

cnmap1boro <- nycn %>%
  st_transform(.,crs = "epsg:2263")

CDMap1boro <- cnmap1boro[CDMap1boro,]
CDMap1boro <- cnmap1boro %>%
  as(., 'Spatial')
qtm(CDMap1boro)
writeOGR(CDMap1boro, here::here("data", "rawdata","NTA.GeoJSON"), layer="NTA_area", driver="GeoJSON")


points_sf_joined <- CDMap1boro%>%
  st_join(nbday_start)%>%
  add_count(bctcb2010)%>%
  janitor::clean_names()%>%
  #calculate area
  mutate(area=st_area(.))%>%
  #then density of the points per ward
  mutate(density=n/area)%>%
  #select density and some other variables 
  dplyr::select(density, bctcb2010, n)


points_sf_joined<- points_sf_joined %>%                    
  group_by(bctcb2010) %>%         
  summarise(density = first(density),
            bctcb2010= first(bctcb2010),
            count= first(n))


points_sf_joined$count.rescaled <- rescale(points_sf_joined$count)
