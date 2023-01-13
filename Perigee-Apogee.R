## make sure that you have already loaded the data from satcat-fsp-data-wrangling.R file
library(tidyverse)
library(ggplot2)
library(ggtext)
library(dplyr)
library(ggalt)
library(ggridges)

options(scipen = 999)

ggplot(fsp, aes(x=X.16., y=X.17.)) +
  geom_point()

satcat_leo <- satcat_JUST_PAYLOAD[satcat_JUST_PAYLOAD$PERIGEE <= 2000 & satcat_JUST_PAYLOAD$APOGEE <= 2000,] 

names(fsp)[16] <- "APOGEE"
names(fsp)[17] <- "PERIGEE"
fsp_leo <- fsp[fsp$PERIGEE <= 2000 & fsp$APOGEE <= 2000,] 

ggplot(satcat_leo, aes(x=PERIGEE, y=APOGEE, fill="SATCAT")) +
  geom_point(size=0.05, alpha=0.2) +
  geom_point(data=fsp_leo, aes(x=PERIGEE, y=APOGEE, fill="FSP"), size=0.05, alpha=0.2, color="red") +
  theme(legend.position = "bottom") +
  scale_color_discrete(name = "ltitle")


ggplot(fsp_leo, aes(x=APOGEE, fill="FSP")) +
  geom_histogram(binwidth=10) +
  geom_histogram(binwidth=10, data=satcat_leo, aes(fill="SATCAT")) +
  theme(legend.position = "right")
  


## create a dumbbell chart
## first wrangle the data similar to a histogram

fsp_count_per_100 <- as.data.frame(table(cut(fsp_leo$PERIGEE, breaks=seq(0,1600, by=50)), dnn="Range"), scientific=F)
satcat_perigee_count_per_100 <- as.data.frame(table(cut(satcat_JUST_PAYLOAD$PERIGEE, breaks=seq(0,1600, by=50)), dnn="Range"), scientific=F)

dumbbell_data <- merge(x = fsp_count_per_100, y = satcat_perigee_count_per_100, by="Range", all.x = TRUE, scientific=F)
names(dumbbell_data)[2] <- "FSP"
names(dumbbell_data)[3] <- "SATCAT"

ggplot(dumbbell_data, aes(x=FSP, y=Range, fill=FSP)) +
  geom_density_ridges(scale=3) +
  theme_ridges()

p1 <- ggplot(dumbbell_data, aes(x=FSP, xend=SATCAT, y=Range))
p2 <- geom_segment(aes(x=FSP, 
                       xend=SATCAT, 
                       y=Range, 
                       yend=Range), 
                   color="#b2b2b2", size=1)
p3 <- geom_dumbbell(color="light blue",         
                    size_x=3,                  #size of circle1
                    size_xend =3,              #size of circle2
                    colour_x="#238b45",         #colour of circle1
                    colour_xend = "#fe9929")    #colour of cirlce2
TS <- labs(x="Count", y=NULL, 
           title="Difference in Perigee height")

plotlight <- p1 + p2 + p3 + TS
plotlight
