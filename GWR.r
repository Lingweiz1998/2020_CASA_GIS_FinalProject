## setting up the data!

nyfc <- read_csv(here::here("data", "rawdata","facilities_201912csv","facilities_201912.csv"),
                 na = c("", "NA", "n/a"), 
                 locale = locale(encoding = 'Latin1'), 
                 col_names = TRUE)

#check all of the columns have been read in correctly

Datatypelist <- nyfc %>% 
  summarise_all(class) %>%
  pivot_longer(everything(), 
               names_to="All_variables", 
               values_to="Variable_class")
Datatypelist


