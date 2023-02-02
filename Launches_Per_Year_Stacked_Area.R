## script to create number of satellites in each altitude grouping

## first classify which group they are in
library(dplyr)
library(viridis)
library(hrbrthemes)

names(fsp)[16] <- "APOGEE"
names(fsp)[17] <- "PERIGEE"
fsp <- fsp %>%
  mutate(AltitudeGroup = case_when(
    PERIGEE <= 2000 ~ "LEO", 
    PERIGEE > 2000 & PERIGEE <= 35786 ~ "MEO", 
    PERIGEE > 35786 ~ "GEO"
  ))

satcat <- satcat %>%
  mutate(AltitudeGroup = case_when(
    PERIGEE <= 2000 ~ "LEO", 
    PERIGEE > 2000 & PERIGEE <= 35786 ~ "MEO", 
    PERIGEE > 35786 ~ "GEO"
  ))


## create a year colummn
fsp$year <- substr(fsp$X.9., 1, 4)
fsp$year <- as.Date(fsp$year, "%Y")

satcat$year <- substr(satcat$LAUNCH_DATE, 1, 4)
satcat$year <- as.Date(satcat$year, "%Y")



fsp_per_year <- aggregate(fsp$AltitudeGroup, by=list(fsp$year), NROW)
View(fsp_per_year)

satcat_per_year <- aggregate(satcat$AltitudeGroup, by=list(satcat$year), NROW)

ggplot(fsp_per_year, aes(x=Group.1, y=x)) +
  geom_line(data = satcat_per_year, aes(x=Group.1, y=x))

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
