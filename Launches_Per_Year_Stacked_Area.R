## script to create number of satellites in each altitude grouping

## first classify which group they are in
library(dplyr)
library(viridis)
library(hrbrthemes)
library(jsonlite)

fsp_2043$e <- as.numeric(fsp_2043$e)
fsp_2043 <- fsp_2043 %>%
  mutate(AltitudeGroup = case_when(
    PERIGEE <= 2000 ~ "LEO", 
    PERIGEE > 2000 & PERIGEE <= 35786 ~ "MEO", 
    PERIGEE > 35786 ~ "GEO"
  ))

fsp_2043$AltitudeGroup[fsp_2043$e > 0.2] <- 'HEO'

satcat <- satcat %>%
  mutate(AltitudeGroup = case_when(
    PERIGEE <= 2000 ~ "LEO", 
    PERIGEE > 2000 & PERIGEE <= 35786 ~ "MEO", 
    PERIGEE > 35786 ~ "GEO"
  ))


## create a year colummn with just the year 
fsp_2043$year <- substr(fsp_2043$LAUNCH_DATE, 1, 4)
fsp_2043$year <- as.Date(fsp_2043$year, "%Y")
fsp_2043$year <- floor_date(fsp_2043$year)

fsp_stacked_graph <- fsp_2043[c('AltitudeGroup', 'year')]


fsp_by_group <- fsp_stacked_graph %>%
  count(
    LAUNCH_DATE = floor_date(year, 'year'),
    PERIGEE = AltitudeGroup,
    name = "COUNT"
  )

ggplot(fsp_by_group, aes(x=LAUNCH_DATE, y=COUNT, fill=PERIGEE)) +
  geom_area()


## to format into json, I need each of the groups seperately
fsp_leo <- fsp_by_group[fsp_by_group$PERIGEE %like% 'GEO',]

test <- jsonlite::toJSON(fsp_leo)
test


## create the json for the yearly stats
fsp_2043_onorbit <- fsp_2043[]
fsp_2043_active <- fsp_2043[fsp_2043$PAYLOAD_OPERATIONAL_STATUS %like% '+',]

count(fsp_2043_active_satellites[fsp_2043_active_satellites$RSO_NAME %like% 'STARLINK', ])
