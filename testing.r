nysbssData0 <- nysbssData0 %>% 
  slice(559804:972468)


class(nysbssData0$startday)

# make columns time object1
nysbssData1$starttime <- as.POSIXct(nysbssData1$starttime, format = "%Y/%m/%d %H:%M")  %>% 
  transform(df, time = format(nysbssData1$starttime, "%T"), date = format(nysbssData1$starttime, "Y/%m/%d"))

# make columns time object2
nysbssData3 <- nysbssData1 %>% as_datetime(nysbssData1$starttime)

# filter date 
nysbssData3 <- nysbssData0 %>%
  filter(starttime >= ymd_hms('20190908 00:00:00') & starttime <= ymd_hms('20190912 00:00:00'))

nysbssData0 %>% write.csv(nysbssData0,here::here("data", "rawdata","202009-citibike-tripdata08_12.csv", row.names = FALSE))


nysbssData0 <- nysbssData0 %>%
  hms(nysbssData0$starth)



RawData_Date$X__1 <- as.Date(RawData_Date$X__1, format = "%Y-%m-%d")

nysbssData0<-as.data.frame(nysbssData0)



nysbssData1 %>%
  ymd(`nysbssData1$starttime`)
