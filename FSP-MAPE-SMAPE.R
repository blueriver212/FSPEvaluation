## This script aims to calculate the MAPE and SMAPE for the predicted and actual number of orbital objects

# first we need to be able to group by date and then plot each
library(tidyverse)
library(MLmetrics)
library(Metrics)

fsp_2019_2023_monthly <- fsp[, c('X.2.','X.9.', 'X.10.', 'X.23.')]
fsp_above_2019 <- fsp_2019_2023_monthly[fsp_2019_2023_monthly$X.9. > '2019-01-01',]
fsp_above_2019$X.9. <- as.Date(fsp_above_2019$X.9.)
fsp_above_2019$count <- 1

fsp_by_month <- fsp_above_2019 %>% 
  group_by(month = lubridate::floor_date(X.9., 'quarterly')) %>%
  summarize(sum = sum(count))

satcat_2019_above <- satcat[satcat$LAUNCH_DATE > '2019-01-01',]
satcat_2019_above$LAUNCH_DATE <- as.Date(satcat_2019_above$LAUNCH_DATE)
satcat_2019_above$count <- 1


satcat_by_month <- satcat_2019_above %>% 
  group_by(month = lubridate::floor_date(LAUNCH_DATE, 'quarterly')) %>%
  summarize(sum = sum(count))

master_monthly <- merge(x = satcat_by_month, y = fsp_by_month, by="month", all.x = TRUE)
#master_monthly <- head(master_monthly, -1)

MAPE(master_monthly$sum.y, master_monthly$sum.x)
rmse(master_monthly$sum.y, master_monthly$sum.x)
mse(master_monthly$sum.y, master_monthly$sum.x)


ggplot(data = master_monthly, aes(x=month)) + 
  geom_line(aes(y= sum.x, colour = "SATCAT")) +
  geom_line(aes(y=sum.y, colour = "FSP")) +
  labs(y="Satellites", x="Date", title="Actual vs Predicted Satellite Launches by Quarter", colour="Data Source")
  

