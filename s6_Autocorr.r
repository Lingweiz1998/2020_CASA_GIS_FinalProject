st_crs(CDMap1boro)


tmap_mode("view")
tm_shape(CDMap1boro) +
  tm_polygons(col = NA, alpha = 0.5) +
  tm_shape(nbday_start) +
  tm_dots(col = "blue")

points_sf_joined <- CDMap1boro%>%
  st_join(nbday_start)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  #calculate area
  mutate(area=st_area(.))%>%
  #then density of the points per ward
  mutate(density=n/area)%>%
  #select density and some other variables 
  dplyr::select(density, borocd, n)




points_sf_joined<- points_sf_joined %>%                    
  group_by(borocd) %>%         
  summarise(density = first(density),
            borocd= first(borocd),
            count= first(n))

points_sf_joined<- points_sf_joined %>%  
  filter(count != 1)

tm_shape(points_sf_joined) +
  tm_polygons("density",
              style="jenks",
              palette="PuOr",
              midpoint=NA,
              popup.vars=c("borocd", "density"),
              title="share bike density")

#First calculate the centroids of all Wards in London

coordsW <- points_sf_joined%>%
  st_centroid()%>%
  st_geometry()

plot(coordsW,axes=TRUE)

#create a neighbours list

LWard_nb <- points_sf_joined %>%
  poly2nb(., queen=T)

#plot them
plot(LWard_nb, st_geometry(coordsW), col="red")
#add a map underneath
plot(points_sf_joined$geometry, add=T)

#create a spatial weights object from these weights
Lward.lw <- LWard_nb %>%
  nb2listw(., style="C")
head(Lward.lw$neighbours)

## Testing
I_CD_Global_Density  <- points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  moran.test(., Lward.lw)
I_CD_Global_Density

C_CD_Global_Density <- 
  points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  geary.test(., Lward.lw)
C_CD_Global_Density

G_CD_Global_Density <- 
  points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  globalG.test(., Lward.lw)
G_CD_Global_Density

#use the localmoran function to generate I for each ward in the city

I_CD_Local_count <- points_sf_joined %>%
  pull(count) %>%
  as.vector()%>%
  localmoran(., Lward.lw)%>%
  as_tibble()

I_CD_Local_Density <- points_sf_joined %>%
  pull(density) %>%
  as.vector()%>%
  localmoran(., Lward.lw)%>%
  as_tibble()

#what does the output (the localMoran object) look like?
slice_head(I_CD_Local_Density, n=5)

points_sf_joined <- points_sf_joined %>%
  mutate(bike_count_I = as.numeric(I_CD_Local_count$Ii))%>%
  mutate(bike_count_Iz =as.numeric(I_CD_Local_count$Z.Ii))%>%
  mutate(density_I =as.numeric(I_CD_Local_Density$Ii))%>%
  mutate(density_Iz =as.numeric(I_CD_Local_Density$Z.Ii))

breaks1<-c(-1000,-2.58,-1.96,-1.65,1.65,1.96,2.58,1000)
MoranColours<- rev(brewer.pal(8, "RdGy"))

tm_shape(points_sf_joined) +
  tm_polygons("bike_count_Iz",
              style="fixed",
              breaks=breaks1,
              palette=MoranColours,
              midpoint=NA,
              title="Local Moran's I, Share bike in NYC")