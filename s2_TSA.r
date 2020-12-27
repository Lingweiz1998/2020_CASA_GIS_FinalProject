## Time Series Analysis
nysbssDataday %>% 
  ggplot(aes(starttime)) + 
  geom_freqpoly(binwidth = 1200)

nycmorning <- nysbssDataday %>%
  filter(starttime >= ymd_hms('20190910 07:00:00') & starttime <= ymd_hms('20190911 11:00:00'))
nycafternoon <- nysbssDataday %>%
  filter(starttime >= ymd_hms('20190910 16:00:00') & starttime <= ymd_hms('20190911 20:00:00'))



