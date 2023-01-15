## script to create number of satellites in each altitude grouping

## first classify which group they are in
library(dplyr)
library(viridis)
library(hrbrthemes)

fsp <- fsp %>%
  mutate(AltitudeGroup = case_when(
    PERIGEE <= 2000 ~ "LEO", 
    PERIGEE > 2000 & PERIGEE <= 35786 ~ "MEO", 
    PERIGEE > 35786 ~ "GEO"
  ))

fsp_per_year <- aggregate(fsp$AltitudeGroup, by=list(fsp$year), NROW)
View(fsp_per_year)

ggplot(fsp_per_year, aes(x=Group.1, y=x)) +
  geom_line()


fsp_test <- fsp %>%
  group_by(fsp$year, fsp$AltitudeGroup, .drop = FALSE) %>%
  tally() %>%
  mutate(cumulative = cumsum(as.character(fsp$year)))
  


ggplot(fsp_test, aes(x=fsp_test$`fsp$year`, y=n, fill=fsp_test$`fsp$AltitudeGroup`)) +
  geom_area(alpha=0.6, size=1) +
  scale_fill_viridis(discrete = T, name="Altitude Group") +
  theme_ipsum() + 
  ggtitle("Launches per year based on Perigee (km)") +
  labs(x='Year')
