#now set a window as the borough boundary
window <- as.owin(CDMap1boro)
#plot(window)
#create a ppp object
nbday_start_sub<- nbday_start %>%
  as(., 'Spatial')
nbday_end_sub<- nbday_end %>%
  as(., 'Spatial')
nycmorningstart_sub<- nycmorningstart %>%
  as(., 'Spatial')
nycmorningend_sub<- nycmorningend %>%
  as(., 'Spatial')
nycnightstart_sub<- nycnightstart %>%
  as(., 'Spatial')
nycnightend_sub<- nycnightend %>%
  as(., 'Spatial')

nbday_start_sub.ppp <- ppp(x=nbday_start_sub@coords[,1],
                              y=nbday_start_sub@coords[,2],
                              window=window)
nbday_end_sub.ppp <- ppp(x=nbday_end_sub@coords[,1],
                           y=nbday_end_sub@coords[,2],
                           window=window)
nycmorningstart_sub.ppp <- ppp(x=nycmorningstart_sub@coords[,1],
                           y=nycmorningstart_sub@coords[,2],
                           window=window)
nycmorningend_sub.ppp <- ppp(x=nycmorningend_sub@coords[,1],
                           y=nycmorningend_sub@coords[,2],
                           window=window)
nycnightstart_sub.ppp <- ppp(x=nycnightstart_sub@coords[,1],
                           y=nycnightstart_sub@coords[,2],
                           window=window)
nycnightend_sub.ppp <- ppp(x=nycnightend_sub@coords[,1],
                           y=nycnightend_sub@coords[,2],
                           window=window)

#Kernel Density Estimation
nycmorningstart_sub.ppp %>%
  density(., sigma=1500) %>%
  plot(main="morning start location")

nycmorningend_sub.ppp %>%
  density(., sigma=1500) %>%
  plot(main="morning stop location")

nycnightstart_sub.ppp %>%
  density(., sigma=1500) %>%
  plot(main="night start location")

nycnightend_sub.ppp %>%
  density(., sigma=1500) %>%
  plot(main="night stop location")
