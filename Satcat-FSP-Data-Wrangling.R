library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(stringr)
# first take in the script
fsp <- read.csv("C:\\Users\\someg\\Downloads\\fspcat_20230101_v90721_nodeb.csv",na.strings=c("","NA"))
names(fsp)[1] <- "launch_date"
names(fsp)[3] <- "object_type"
fsp$year <- substr(fsp$launch_date, 1, 4)
fsp$year <- as.Date(fsp$year, "%Y")
fsp_launches_per_year <- fsp %>% count(year)
fsp_launches_per_year$sum <- ave(fsp_launches_per_year$n, FUN=cumsum)
count(fsp)

# satcat includes debris, whereas fsp does not, so this should be removed
satcat <- read.csv("C:\\Users\\someg\\Downloads\\satcat.csv", na.strings=c("","NA"))
satcat$year <- substr(satcat$OBJECT_ID, 1, 4)
satcat <- satcat[satcat$OBJECT_TYPE != "DEB", ]
satcat_launches_per_year <- satcat %>% count(year)
satcat_launches_per_year$year <- as.Date(satcat_launches_per_year$year, "%Y")
satcat_launches_per_year$sum <- ave(satcat_launches_per_year$n, FUN=cumsum)




## launch site comparison
launchsite_satcat <- as.data.frame(table(satcat$LAUNCH_SITE))
launchsite_fsp <- as.data.frame(table(fsp$X.8.))

## strip white space from column before merge
launchsite_fsp <- launchsite_fsp %>%
  mutate_if(is.factor, str_trim)

launchsite_satcat$LaunchSite <- as.character(launchsite_satcat$LaunchSite)

launchsite_satcat <- launchsite_satcat %>% 
  mutate_if(is.character, str_trim)


launchsite_satcat <- merge(x=launchsite_satcat, y=launchsite_fsp, by="Var1", all = TRUE)
names(launchsite_satcat) <- c('LaunchSite', 'SATCAT', 'FSP')
launchsite_satcat[is.na(launchsite_satcat)] <- 0

launchsite_satcat$Diff <- launchsite_satcat$FSP - launchsite_satcat$SATCAT
launchsite_satcat <- aggregate(launchsite_satcat['Diff'], by=launchsite_satcat['LaunchSite'], sum)


ggplot(launchsite_satcat, aes(x=LaunchSite, y=Diff)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle=60, hjust=1)) +
  geom_text(aes(label=ifelse(Diff > 50, Diff, "")), vjust= -1, hjust=0.5) +
  geom_text(aes(label=ifelse(Diff < -50, Diff, "")), vjust= 1, hjust=0.5) +
  labs(title='Difference in number of launches per site (SATCAT - FSP)')
