## Ripley’s K
K <- nbday_start_sub.ppp %>%
  Kest(., correction="border") %>%
  plot()

##DBSCAN
#first check the coordinate reference system of the Harrow spatial polygon:
st_geometry(CDMap1boro)

#first extract the points from the spatial points data frame
nbday_start_sub_Points <- nbday_start_sub %>%
  coordinates(.)%>%
  as.data.frame()

#now run the dbscan analysis
db <- nbday_start_sub_Points %>%
  fpc::dbscan(.,eps = 750, MinPts = 2)

#now plot the results
plot(db, nbday_start_sub_Points, main = "DBSCAN Output", frame = F)
plot(CDMap1boro$geometry, add=T)


