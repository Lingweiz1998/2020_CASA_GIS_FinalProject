library(tidyverse)
library(lubridate)

##First, get the London Borough Boundaries
nysbssData0 <- read_csv(here::here("data", "rawdata","202009-citibike-tripdata_0.csv"))
nycdistricts <- st_read("https://services5.arcgis.com/GfwWNkhOj9bNBqoJ/arcgis/rest/services/NYC_Community_Districts/FeatureServer/0/query?where=1=1&outFields=*&outSR=4326&f=pgeojson")


nysbssData0 <- nysbssData0 %>%
  mutate(
    startday = date(starttime),
  )

class(nysbssData0$starttime)


nysbssData0$starttime <-strftime(nysbssData0$starttime, format="%H:%M:%S")

nysbssData0$starttime <-(nysbssData0$starttime)

str(nysbssData1$startday)

nysbssData0 %>% 
  filter(startday > as.Date("2020-09-07"))
