#now set a window as the borough boundary
window <- as.owin(CDMap1boro)
#plot(window)
#create a ppp object
nycmorningstartsub<- nycmorningstart %>%
  as(., 'Spatial')
nycmorningendsub<- nycmorningend %>%
  as(., 'Spatial')
nycnightstartsub<- nycnightstart %>%
  as(., 'Spatial')
nycnightendsub<- nycnightend %>%
  as(., 'Spatial')
nycmorningstartsub.ppp <- ppp(x=nycmorningstartsub@coords[,1],
                              y=nycmorningstartsub@coords[,2],
                              window=window)
nycmorningendsub.ppp <- ppp(x=nycmorningendsub@coords[,1],
                            y=nycmorningendsub@coords[,2],
                            window=window)
nycnightstartsub.ppp <- ppp(x=nycnightstartsub@coords[,1],
                            y=nycnightstartsub@coords[,2],
                            window=window)
nycnightendsub.ppp <- ppp(x=nycnightendsub@coords[,1],
                          y=nycnightendsub@coords[,2],
                          window=window)

nycmorningstartsub.ppp %>%
  plot(.,pch=16,cex=0.5, 
       main="bike start location")

#Kernel Density Estimation
nycmorningstartsub.ppp %>%
  density(., sigma=1500) %>%
  plot(main="morning peak time start")
nycmorningendsub.ppp %>%
  density(., sigma=1000) %>%
  plot(main="morning peak time end")
nycnightstartsub.ppp %>%
  density(., sigma=1000) %>%
  plot(main="night peak time start")
nycnightendsub.ppp %>%
  density(., sigma=1000) %>%
  plot(main="night peak time start")

