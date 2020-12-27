#now set a window as the borough boundary
window <- as.owin(CDMap1boro)
#plot(window)
#create a ppp object
nbday_start_sub<- nbday_start %>%
  as(., 'Spatial')

nbday_start_sub.ppp <- ppp(x=nbday_start_sub@coords[,1],
                              y=nbday_start_sub@coords[,2],
                              window=window)


nbday_start_sub.ppp %>%
  plot(.,pch=16,cex=0.5, 
       main="bike start location")

#Kernel Density Estimation
nbday_start_sub.ppp %>%
  density(., sigma=1500) %>%
  plot(main="bike start location")
