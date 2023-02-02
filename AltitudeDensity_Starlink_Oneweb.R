library(data.table)
library(dplyr)
library(lubridate)
require(gridExtra)
library(ggplot2)
library(ggpubr)
library(here)
library(hrbrthemes)



starlink_above_2019_fsp <- fsp_above_2019[fsp_above_2019$RSO_NAME %like% 'Starlink',]
starlink_above_2019_satcat <- satcat_above_2019[satcat_above_2019$OBJECT_NAME %like% 'STARLINK',]
starlink_oneweb_fsp <- fsp_above_2019[fsp_above_2019$RSO_NAME %like% 'Starlink' | fsp_above_2019$RSO_NAME 
                                        %like% 'OneWeb',]
starlink_oneweb_satcat <- satcat_above_2019[satcat_above_2019$OBJECT_NAME %like% 'STARLINK' | satcat_above_2019$OBJECT_NAME 
                                        %like% 'ONEWEB',]
write.csv(starlink_oneweb_fsp, "Results/starlink_oneweb_fsp.csv")
write.csv(starlink_oneweb_satcat, "Results/starlink_oneweb_satcat.csv")


alti_breaks <- seq(0, by = 100, length.out = ceiling(2000 / 100) + 1)
alti_labs <- paste(head(alti_breaks, -1), tail(alti_breaks, -1), sep = "-")

starlink_by_altidude <- starlink_above_2019_fsp %>%
  count(
    LAUNCH_DATE = floor_date(LAUNCH_DATE, 'month'),
    PERIGEE = cut(PERIGEE, alti_breaks, alti_labs),
    name = "COUNT"
  )

starlink_by_altidude_SATCAT <- starlink_above_2019_satcat %>%
  count(
    LAUNCH_DATE = floor_date(LAUNCH_DATE, 'month'),
    PERIGEE = cut(PERIGEE, alti_breaks, alti_labs),
    name = "COUNT"
  )

 ggplot(starlink_by_altidude_SATCAT, aes(LAUNCH_DATE, PERIGEE)) +
  #geom_point(aes(size = COUNT), color = blues9[[6]], show.legend = TRUE) +
  geom_point(aes(size = COUNT,  colour = COUNT)) +
  scale_color_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) +
  theme_minimal() +
  theme(panel.grid.minor.x = element_blank()) +
  labs(x = 'FSP Launches') +
  guides(color= guide_legend(), size=guide_legend()) +
  scale_size_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50))
 
 ggplot(starlink_by_altidude, aes(LAUNCH_DATE, PERIGEE)) +
   #geom_point(aes(size = COUNT), color = blues9[[6]], show.legend = TRUE) +
   geom_point(aes(size = COUNT,  colour = COUNT)) +
   scale_color_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50)) +
   theme_minimal() +
   theme(panel.grid.minor.x = element_blank()) +
   labs(x = 'FSP Launches') +
   guides(color= guide_legend(), size=guide_legend()) +
   scale_size_continuous(limits=c(0, 300), breaks=seq(0, 300, by=50))
 
 
 p1 <- ggplot(data = starlink_above_2019_fsp, aes(INCLINATION)) +
   geom_histogram( binwidth=1, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
   geom_histogram(data=starlink_above_2019_satcat, aes(x=INCLINATION), fill="Red", alpha=0.5, binwidth=1) +
   scale_color_brewer(palette="Accent") + 
   theme_minimal()+theme(legend.position="top") +
   xlim(0, 180)+
   labs(x='Perigee (km)', y='Number of Satellites', title= "Starlink")
 
 #ggsave(filename = here("Plots", "Starlink Perigee Comparison.png"))
 
 oneweb_above_2019_fsp <- fsp_above_2019[ fsp_above_2019$RSO_NAME %like% 'OneWeb',]
   oneweb_above_2019_satcat <- satcat_above_2019[ satcat_above_2019$OBJECT_NAME %like% 'ONEWEB',]
 
p2 <-  ggplot(data = oneweb_above_2019_fsp, aes(INCLINATION)) +
   geom_histogram(binwidth=1, fill="#69b3a2", color="#e9ecef", alpha=0.9) +
   geom_histogram(data=oneweb_above_2019_satcat, aes(x=INCLINATION), fill="Red", alpha=0.5, binwidth=1) +
   scale_color_brewer(palette="Accent") + 
   theme_minimal()+theme(legend.position="bottom") +
   xlim(0, 180)+
   labs(x='Perigee (km)', y='Number of Satellites', title = "OneWeb")
 
 #ggsave(filename = here("Plots", "OneWeb Perigee Comparison.png"))

grid.arrange(p1, p2, ncol=2)

#ggsave(filename = here("Plots", "OneWeb and Starlink Perigee Comparison.png"))

ggplot() +
  geom_histogram(data = fsp_above_2019, aes(INCLINATION, fill="Data 1"), binwidth=1, color="#e9ecef", alpha=0.9) +
  geom_histogram(data=satcat_above_2019, aes(x=INCLINATION, fill="Data 2"), alpha=0.5, binwidth=1) +
  scale_fill_discrete(name = "Data Source", labels= c("FSP", "SATCAT")) +
  theme(legend.position = "bottom") +
  xlim(0, 100)+
  labs(x='Perigee (km)', y='Number of Satellites', title="A comparison of inclination of all catalogued objects in FSP and SATCAT")
