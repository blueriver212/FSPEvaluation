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
  group_by(month = lubridate::floor_date(X.9., 'year')) %>%
  summarize(sum = sum(count))

satcat_2019_above <- satcat_JUST_PAYLOAD[satcat_JUST_PAYLOAD$LAUNCH_DATE > '2019-01-01',]
satcat_2019_above$LAUNCH_DATE <- as.Date(satcat_2019_above$LAUNCH_DATE)
satcat_2019_above$count <- 1


satcat_by_month <- satcat_2019_above %>% 
  group_by(month = lubridate::floor_date(LAUNCH_DATE, 'year')) %>%
  summarize(sum = sum(count))

master_monthly <- merge(x = satcat_by_month, y = fsp_by_month, by="month", all.x = TRUE)
#master_monthly <- head(master_monthly, -1)

MAPE(master_monthly$sum.y, master_monthly$sum.x)
smape(master_monthly$sum.y, master_monthly$sum.x)
rmse(master_monthly$sum.y, master_monthly$sum.x)
mse(master_monthly$sum.y, master_monthly$sum.x)
mae(master_monthly$sum.y, master_monthly$sum.x)


ggplot(data = master_monthly, aes(x=month)) + 
  geom_line(aes(y= sum.x, colour = "SATCAT")) +
  geom_line(aes(y=sum.y, colour = "FSP")) +
  labs(y="Satellites", x="Date", title="Actual vs Predicted Satellite Launches by 6-month intervals", colour="Data Source")

## the next set of analysis are for total objects in the sky rather than just launches
fsp_number_decayed <- fsp[, c('X.2.','X.9.', 'X.10.', 'X.23.')]
