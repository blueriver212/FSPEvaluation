## This script can be ran after the master script and will produce density plots for satellite altitudes
library(dplyr)
library(lubridate)
require(gridExtra)
library(ggplot2)
library(ggpubr)
library(here)



## FSP
fsp_above_2019$LAUNCH_DATE <- as.Date(fsp_above_2019$LAUNCH_DATE)
fsp_above_2019$count <- 1

## AIM IS TO GET A DF WITH TIME, ALTITUDE AND COUNT
alti_breaks <- seq(0, by = 100, length.out = ceiling(2000 / 100) + 1)
alti_labs <- paste(head(alti_breaks, -1), tail(alti_breaks, -1), sep = "-")

fsp_by_altidude <- fsp_above_2019 %>%
  count(
    LAUNCH_DATE = floor_date(LAUNCH_DATE, 'month'),
    PERIGEE = cut(PERIGEE, alti_breaks, alti_labs),
    name = "COUNT"
  )


p <- ggplot(fsp_by_altidude, aes(LAUNCH_DATE, PERIGEE)) +
  #geom_point(aes(size = COUNT), color = blues9[[6]], show.legend = TRUE) +
  geom_point(aes(size = COUNT,  colour = COUNT)) +
  scale_color_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) +
  theme_minimal() +
  theme(panel.grid.minor.x = element_blank()) +
  labs(x = 'FSP Launches') +
  guides(color= guide_legend(), size=guide_legend()) +
  scale_size_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50))

## AIM IS TO GET A DF WITH TIME, ALTITUDE AND COUNT
satcat_above_2019$LAUNCH_DATE <- as.Date(satcat_above_2019$LAUNCH_DATE)
#alti_breaks <- seq(0, by = 100, length.out = ceiling(satcat_above_2019$PERIGEE / 100) + 1)
alti_breaks <- seq(0, by = 100, length.out = ceiling(1600 / 100) + 1)
alti_labs <- paste(head(alti_breaks, -1), tail(alti_breaks, -1), sep = "-")

satcat_by_altidude <- satcat_above_2019 %>%
  count(
    LAUNCH_DATE = floor_date(LAUNCH_DATE, 'month'),
    PERIGEE = cut(PERIGEE, alti_breaks, alti_labs),
    name = "COUNT"
  )


p2 <- ggplot(satcat_by_altidude, aes(LAUNCH_DATE, PERIGEE)) +
  geom_point(aes(size = COUNT,  colour = COUNT)) +
  scale_color_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) +
  theme_minimal() +
  theme(panel.grid.minor.x = element_blank()) +
  labs(x = 'SATCAT Launches', y = "Perigee") +
  guides(color= guide_legend(), size=guide_legend()) +
  scale_size_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50))

ggarrange(p2, p, common.legend = TRUE, legend = "right")

ggsave(filename = here("Plots", "Satcat and FSP Launches by Altitude and Month.png"))
