## This script can be ran after the master script and will produce density plots for satellite altitudes
library(dplyr)
library(lubridate)
require(gridExtra)
library(ggplot2)
library(ggpubr)
library(here)


fsp_2019_2043 <- read.csv("fspcat_20430701_v280819_nodeb.csv")
colnames(fsp_2019_2043) <- c('COSPARID', 'RSO_NAME', 'RSO_TYPE', 'PAYLOAD_OPERATIONAL_STATUS', 'ORBIT_TYPE', 
                   'APPLICATION', 'SOURCE', 'LAUNCH_SITE', 'LAUNCH_DATE', 'DECAY_DATE', 'ORBITAL_PERIOD', '12', '13', '14', 'INCLINATION', 'APOGEE', 'PERIGEE', '18', '19', '20', '21',
                   '22', '23', 'a', 'e', '26', '27', '28', '29')

fsp_2019_2043 <- fsp_2019_2043[fsp_2019_2043$LAUNCH_DATE > '2019-01-01',]
fsp_2019_2043$LAUNCH_DATE <- as.Date(fsp_2019_2043$LAUNCH_DATE)

alti_breaks <- seq(0, by = 100, length.out = ceiling(2000 / 100) + 1)
alti_labs <- paste(head(alti_breaks, -1), tail(alti_breaks, -1), sep = "-")


fsp_2043_by_altidude <- fsp_2019_2043 %>%
  count(
    LAUNCH_DATE = floor_date(LAUNCH_DATE, 'year'),
    PERIGEE = cut(PERIGEE, alti_breaks, alti_labs),
    name = "COUNT"
  )


ggplot(fsp_2043_by_altidude, aes(LAUNCH_DATE, PERIGEE)) +
  geom_point(aes(size = COUNT), color = blues9[[6]], show.legend = TRUE) +
  #geom_point(aes(size = COUNT,  colour = COUNT)) +
  #scale_color_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) +
  theme_minimal() +
  theme(panel.grid.minor.x = element_blank()) +
  labs(x = 'FSP Launches', y='Perigee Height (km)')
  #guides(color= guide_legend(), size=guide_legend()) +
  #scale_size_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50))
