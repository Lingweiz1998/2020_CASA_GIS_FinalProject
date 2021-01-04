## Time Series Analysis
nbday %>% 
  ggplot(aes(starttime)) + 
  geom_freqpoly(binwidth = 600)+
  xlab("start time of using a citi bike") +
  ylab("Count") +
  ggtitle("CITI bike use frequency in Sep 10")

nbmorning <- nbday %>%
  filter(starttime >= ymd_hms('20190910 07:00:00') & starttime <= ymd_hms('20190911 11:00:00'))
nbnight <- nbday %>%
  filter(starttime >= ymd_hms('20190910 16:00:00') & starttime <= ymd_hms('20190911 20:00:00'))

