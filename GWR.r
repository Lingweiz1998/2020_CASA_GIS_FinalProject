## setting up the data!

nyfc <- read_csv(here::here("data", "rawdata","facilities_201912csv","facilities_201912.csv"),
                 na = c("", "NA", "n/a"), 
                 locale = locale(encoding = 'latin1'), 
                 col_names = TRUE)

colnames(nyfc) <- colnames(nyfc) %>% 
  str_to_lower() %>% 
  str_replace_all(" ", "_")
#check all of the columns have been read in correctly
Datatypelist <- nyfc %>% 
  summarise_all(class) %>%
  pivot_longer(everything(), 
               names_to="All_variables", 
               values_to="Variable_class")
Datatypelist
#select necessary rows
nyfc1 <- nyfc %>% 
  dplyr::select(factype,facsubgrp,facgroup,facdomain,latitude,longitude)
# remove na in r - remove rows - na.omit function / option
nyfc1 <- na.omit(nyfc1)
# change to spatial data frame
nyfc1 <- st_as_sf(nyfc1, coords = c("longitude", "latitude"), crs = "WGS84")
nyfc1 <- nyfc1 %>% 
  st_transform(.,crs="epsg:2263")
nyfc1 <- nyfc1[CDMap1boro,]

# making density map to standardize the variables.
fc_edu <- nyfc1 %>%  
  filter(facdomain == "EDUCATION, CHILD WELFARE, AND YOUTH" )
fc_heal <- nyfc1 %>%  
  filter(facdomain == "HEALTH AND HUMAN SERVICES" )
fc_park <- nyfc1 %>%  
  filter(facdomain == "PARKS, GARDENS, AND HISTORICAL SITES" )
fc_tran <- nyfc1 %>%  
  filter(facdomain == "CORE INFRASTRUCTURE AND TRANSPORTATION" )
fc_admin <- nyfc1 %>%  
  filter(facdomain == "ADMINISTRATION OF GOVERNMENT" )
fc_publi <- nyfc1 %>%  
  filter(facdomain == "PUBLIC SAFETY, EMERGENCY SERVICES, AND ADMINISTRATION OF JUSTICE" )
fc_lib <- nyfc1 %>%  
  filter(facdomain == "LIBRARIES AND CULTURAL PROGRAMS" )
## edu file
gwrfc_edu <- CDMap1boro%>%
  st_join(fc_edu)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_edu<- gwrfc_edu %>%                    
  group_by(borocd) %>%         
  summarise(density_edu = first(density),
            borocd= first(borocd),
            count_edu= first(n))
gwrfc_edu<- gwrfc_edu %>%
  st_drop_geometry()
  
## heal file
gwrfc_heal <- CDMap1boro%>%
  st_join(fc_heal)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_heal<- gwrfc_heal %>%                    
  group_by(borocd) %>%         
  summarise(density_heal = first(density),
            borocd= first(borocd),
            count_heal= first(n))
gwrfc_heal<- gwrfc_heal %>%
  st_drop_geometry()

## park file
gwrfc_park <- CDMap1boro%>%
  st_join(fc_park)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_park<- gwrfc_park %>%                    
  group_by(borocd) %>%         
  summarise(density_park = first(density),
            borocd= first(borocd),
            count_park= first(n))
gwrfc_park<- gwrfc_park %>%
  st_drop_geometry()

## admin file
gwrfc_admin <- CDMap1boro%>%
  st_join(fc_admin)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_admin<- gwrfc_admin %>%                    
  group_by(borocd) %>%         
  summarise(density_admin = first(density),
            borocd= first(borocd),
            count_admin= first(n))
gwrfc_admin<- gwrfc_admin %>%
  st_drop_geometry()

## public file
gwrfc_publi <- CDMap1boro%>%
  st_join(fc_publi)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_publi<- gwrfc_publi %>%                    
  group_by(borocd) %>%         
  summarise(density_publi = first(density),
            borocd= first(borocd),
            count_publi= first(n))
gwrfc_publi<- gwrfc_publi %>%
  st_drop_geometry()


## library file
gwrfc_lib <- CDMap1boro%>%
  st_join(fc_lib)%>%
  add_count(borocd)%>%
  janitor::clean_names()%>%
  mutate(area=st_area(.))%>%
  mutate(density=n/area)%>%
  dplyr::select(density, borocd, n)
gwrfc_lib<- gwrfc_lib %>%                    
  group_by(borocd) %>%         
  summarise(density_lib = first(density),
            borocd= first(borocd),
            count_lib= first(n))
gwrfc_lib<- gwrfc_lib %>%
  st_drop_geometry()

## join all data
gwrfc <- points_sf_joined%>%
  left_join(.,
            gwrfc_edu, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_heal, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_park, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_publi, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_admin, 
            by = c("borocd" = "borocd"))
gwrfc <- gwrfc%>%
  left_join(.,
            gwrfc_lib, 
            by = c("borocd" = "borocd"))
colnames(gwrfc)

#plot with a regression line - note, I've added some jitter here as the x-scale is rounded
q <- qplot(x = `count`, 
           y = `count_lib`, 
           data=gwrfc)
q + stat_smooth(method="lm", se=FALSE, size=1) + 
  geom_jitter()
  
  
