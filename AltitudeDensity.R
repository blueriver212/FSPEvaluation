## This script can be ran after the master script and will produce density plots for satellite altitudes
library(dplyr)
library(lubridate)
require(gridExtra)
library(ggplot2)
library(ggpubr)
library(here)
library(data.table)
library(tidyr)


## FSP + remove satellites higher than 1600

fsp_above_2019$LAUNCH_DATE <- as.Date(fsp_above_2019$LAUNCH_DATE)
fsp_above_2019$count <- 1
fsp_above_2019_leo <- fsp_above_2019[fsp_above_2019$PERIGEE <= 2000, ]

## AIM IS TO GET A DF WITH TIME, ALTITUDE AND COUNT
alti_breaks <- seq(0, by = 100, length.out = ceiling(2000 / 100) + 1)
alti_labs <- paste(head(alti_breaks, -1), tail(alti_breaks, -1), sep = "-")

fsp_by_altidude <- fsp_above_2019_leo %>%
  count(
    LAUNCH_DATE = floor_date(LAUNCH_DATE, 'month'),
    PERIGEE = cut(PERIGEE, alti_breaks, alti_labs),
    name = "Count"
  )

p <- ggplot(fsp_by_altidude, aes(LAUNCH_DATE, PERIGEE)) +
  geom_point(aes(size = Count,  colour = Count)) +
  scale_color_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) +
  theme_minimal() +
  theme(panel.grid.minor.x = element_blank()) +
  labs(x = 'FSP', y = "Perigee (km)") +
  guides(color= guide_legend(), size=guide_legend()) +
  scale_size_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) + 
  scale_y_discrete(limits = c("0-100", "100-200", "200-300", "300-400", "400-500", "500-600", "600-700", "700-800", "800-900", "900-1000", "1000-1100", "1100-1200", "1200-1300", "1300-1400", "1400-1500", "1500-1600"))


## AIM IS TO GET A DF WITH TIME, ALTITUDE AND COUNT
satcat_above_2019$LAUNCH_DATE <- as.Date(satcat_above_2019$LAUNCH_DATE)
alti_breaks <- seq(0, by = 100, length.out = ceiling(1600 / 100) + 1)
alti_labs <- paste(head(alti_breaks, -1), tail(alti_breaks, -1), sep = "-")

satcat_above_2019_pay = satcat_above_2019[satcat_above_2019$OBJECT_TYPE == "PAY", ]
satcat_above_2019_pay_leo = satcat_above_2019_pay[satcat_above_2019_pay$PERIGEE <= 2000, ]
satcat_by_altidude_payloads <- satcat_above_2019_pay_leo %>%
  count(
    LAUNCH_DATE = floor_date(LAUNCH_DATE, 'month'),
    PERIGEE = cut(PERIGEE, alti_breaks, alti_labs),
    name = "Count"
  )


p2 <- ggplot(satcat_by_altidude_payloads, aes(LAUNCH_DATE, PERIGEE)) +
  geom_point(aes(size = Count,  colour = Count)) +
  scale_color_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) +
  theme_minimal() +
  theme(panel.grid.minor.x = element_blank()) +
  labs(x = 'SATCAT', y = "Perigee (km)") +
  guides(color= guide_legend(), size=guide_legend()) +
  scale_size_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) + 
  scale_y_discrete(limits = c("0-100", "100-200", "200-300", "300-400", "400-500", "500-600", "600-700", "700-800", "800-900", "900-1000", "1000-1100", "1100-1200", "1200-1300", "1300-1400", "1400-1500", "1500-1600"))


ggarrange(p2, p, common.legend = TRUE, legend = "right")

ggsave(filename = here("Plots", "Satcat and FSP Launches by Altitude and Month.png"))

fsp_2043_by_altidude$PERIGEE <- as.character(fsp_2043_by_altidude$PERIGEE)
fsp_2043_by_altidude$PERIGEE <- fsp_2043_by_altidude$PERIGEE %>% replace_na('> 1600')


## 2043 data
ggplot(fsp_2043_by_altidude, aes(LAUNCH_DATE, PERIGEE)) +
  geom_point(aes(size = COUNT,  colour = COUNT)) +
  scale_color_continuous(limits=c(0, 300), breaks=seq(0, 300, by=25)) +
  theme_minimal() +
  theme(panel.grid.minor.x = element_blank()) +
  labs(x = 'FSP Launches', title='FSP Launches from 2019 to 2043', y='Perigee') +
  guides(color= guide_legend(), size=guide_legend()) +
  scale_size_continuous(limits=c(0, 300), breaks=seq(0, 300, by=25))
