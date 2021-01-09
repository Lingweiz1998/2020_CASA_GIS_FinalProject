##GWR
par(mfrow=c(1,1))    #plot to 1 by 1 array
plot(nyccd_nb, st_geometry(coordsW), col="red")

gwrfc_1SP <- gwrfc_1 %>%
  as(., "Spatial")

st_crs(coordsW) = 'epsg:2263'
coordsWSP <- coordsW %>%
  as(., "Spatial")
#calculate kernel bandwidth
GWRbandwidth <- gwr.sel(density_scaled ~  
                          density_edu_scaled+
                          density_heal_scaled+
                          density_tran_scaled+
                          density_park_scaled+
                          density_admin_scaled,
                        data = gwrfc_1SP, 
                        coords=coordsWSP,
                        adapt=T)
#run the gwr model
gwr.model = gwr(density_scaled ~ 
                  density_edu_scaled+
                  density_heal_scaled+
                  density_tran_scaled+
                  density_park_scaled+
                  density_admin_scaled, 
                data = gwrfc_1SP, 
                coords=coordsWSP, 
                adapt=GWRbandwidth, 
                hatmatrix=TRUE, 
                se.fit=TRUE)
gwr.model
anova(gwr.model)
LMZ.F2GWR.test(gwr.model)
LMZ.F3GWR.test(gwr.model)

results <- as.data.frame(gwr.model$SDF)
names(results)

#attach coefficients to original SF
gwrfc_2 <- gwrfc_1 %>%
  mutate(coefheal = results$density_heal_scaled,
         coeftran = results$density_tran_scaled,
         coefpar = results$density_park_scaled,
         coefadmin = results$density_admin_scaled)
tm_shape(gwrfc_2) +
  tm_polygons(col = "coeftran", 
              palette = "RdBu", 
              alpha = 0.5)

#run the significance test
sigTest = abs(gwr.model$SDF$"density_lib_scaled")-2 * gwr.model$SDF$"density_lib_scaled_se"


#store significance results
gwrfc_2 <- gwrfc_2 %>%
  mutate(GWRsig = sigTest)
tm_shape(gwrfc_2) +
  tm_polygons(col = "GWRsig", 
              palette = "RdYlBu",
              alpha = 0.5)
