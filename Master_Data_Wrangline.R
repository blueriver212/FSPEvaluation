## MASTER SCRIPT - Certain Plots were incorrect, so starting again. 
library(dplyr)
library(stringr)
library(RColorBrewer)
library(data.table)

# FUTURE SPACE POPULATIONS
fsp <- read.csv("Data/fspcat_20230101_v90721_nodeb.csv",na.strings=c("","NA"))
colnames(fsp) <- c('COSPARID', 'RSO_NAME', 'RSO_TYPE', 'PAYLOAD_OPERATIONAL_STATUS', 'ORBIT_TYPE', 
                  'APPLICATION', 'SOURCE', 'LAUNCH_SITE', 'LAUNCH_DATE', 'DECAY_DATE', 'ORBITAL_PERIOD', '12', '13', '14', 'INCLINATION', 'APOGEE', 'PERIGEE', '18', '19', '20', '21',
                  '22', '23', 'a', 'e', 'i', 'w', 'W', 'V', 'X_', 'Y_', 'Z_', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42')
fsp$LAUNCH_YEAR <- substr(fsp$LAUNCH_DATE, 1, 4)
fsp$LAUNCH_YEAR <- as.Date(fsp$LAUNCH_YEAR, "%Y")
fsp$LAUNCH_YEAR <- lubridate::floor_date(fsp$LAUNCH_YEAR, 'year')
fsp_launches_per_year <- fsp %>% count(LAUNCH_YEAR)
fsp_launches_per_year$sum <- ave(fsp_launches_per_year$n, FUN=cumsum)

fsp <- fsp %>%
  mutate_if(is.character, str_trim)


satcat_2019 <- satcat[satcat$LAUNCH_DATE < '2019-01-01',]

## FSP 2043
fsp_2043 <- read.csv("Data/fspcat_20430701_v280819_nodeb.csv",na.strings=c("","NA"))
colnames(fsp_2043) <- c('COSPARID', 'RSO_NAME', 'RSO_TYPE', 'PAYLOAD_OPERATIONAL_STATUS', 'ORBIT_TYPE', 
                   'APPLICATION', 'SOURCE', 'LAUNCH_SITE', 'LAUNCH_DATE', 'DECAY_DATE', 'ORBITAL_PERIOD', '12', '13', '14', 'INCLINATION', 'APOGEE', 'PERIGEE', '18', '19', '20', '21',
                   '22', '23', 'a', 'e', 'i', 'w', 'W', 'V')
fsp_2043$LAUNCH_YEAR <- substr(fsp_2043$LAUNCH_DATE, 1, 4)
fsp_2043$LAUNCH_YEAR <- as.Date(fsp_2043$LAUNCH_YEAR, "%Y")
fsp_2043$LAUNCH_YEAR <- lubridate::floor_date(fsp_2043$LAUNCH_YEAR, 'year')
fsp_2043_launches_per_year <- fsp_2043 %>% count(LAUNCH_YEAR)
fsp_2043_launches_per_year$sum <- ave(fsp_2043_launches_per_year$n, FUN=cumsum)

fsp <- fsp %>%
  mutate_if(is.character, str_trim)

# SATCAT
satcat <- read.csv("Data/satcat.csv", na.strings=c("","NA"))
satcat$LAUNCH_YEAR <- substr(satcat$OBJECT_ID, 1, 4)
satcat$LAUNCH_YEAR <- as.Date(satcat$LAUNCH_YEAR, "%Y")
satcat$LAUNCH_YEAR <- lubridate::floor_date(satcat$LAUNCH_YEAR, 'year')

# SATCAT also includes debris, so make sure to remove this 
satcat <- satcat[satcat$OBJECT_TYPE != "DEB", ]
satcat_launches_per_year <- satcat %>% count(LAUNCH_YEAR)
satcat_launches_per_year$sum <- ave(satcat_launches_per_year$n, FUN=cumsum)


## FOR ALL ANALYSIS THE 2019-2023 FILES SHOULD BE USED RATHER THAN THE ORIGINALS

satcat_below_2019 <- satcat[satcat$LAUNCH_DATE < '2019-01-01',] # 14, 562 ??
fsp_below_2019 <- fsp[fsp$LAUNCH_DATE < '2019-01-01', ] # 15, 356 ??

satcat_above_2019 <- satcat[satcat$LAUNCH_DATE >= '2019-01-01',] # 5, 854
fsp_above_2019 <- fsp[fsp$LAUNCH_DATE >= '2019-01-01', ] # 5, 290
write.csv(fsp_above_2019, 'fsp_above_2019.csv')
write.csv(satcat_above_2019, 'satcat_above_2019.csv')

fsp_above_2019_starlink <- fsp_above_2019[fsp_above_2019$RSO_NAME %like% 'Starlink',]
write.csv(fsp_above_2019_starlink, 'fsp_above_2019_starlink.csv')


# Firstly, run the boxscore scripts, this will produce two files, "Results/SATCAT_boxscore_2023.csv" and "Results/FSP_boxscore_2023.csv"
source('Satcat-BoxScore-2019-2023.R')


# Secondly, run total difference scripts, this will return altitude density difference plots
source('AltitudeDensity.R')

## analysis for the megaconstellations
source('AltitudeDensity_Starlink_Oneweb.R')