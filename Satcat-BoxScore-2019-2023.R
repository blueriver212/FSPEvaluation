# This is a script to start plotting box scores for the fsp paper
# need to create a table with satellites object by country owner on the left
# then a break down of each type on the x axis (so  to speak)
library(ggplot2)
library(here)
library(stringr)
library(data.table)
## master country list
fsp_countries <- as.data.frame(table(fsp$SOURCE))
fsp_countries[2] <- NULL
  
satcat_countries <- as.data.frame(table(satcat$OWNER))
satcat_countries[2] <- NULL


master_country_list <- satcat_countries %>%
  full_join(fsp_countries, by="Var1")


# REMOVE ALL WHITE SPACE

# if you want to just get 2023 data
FSP_active_satellites <- data.frame(fsp[fsp$PAYLOAD_OPERATIONAL_STATUS == "+" | fsp$PAYLOAD_OPERATIONAL_STATUS == "P" | fsp$PAYLOAD_OPERATIONAL_STATUS == "B" | fsp$PAYLOAD_OPERATIONAL_STATUS == "S" | fsp$PAYLOAD_OPERATIONAL_STATUS == "X", ])
just_starlink <- fsp[fsp$RSO_NAME %like% 'OneWeb', ]
FSP_active_satellites <- FSP_active_satellites[FSP_active_satellites$LAUNCH_DATE > '2019-01-01',]
active <- data.frame(table(FSP_active_satellites$SOURCE))
names(active)[1] <- "Country"
names(active)[2] <- "Active"
active$var2 <- NULL

## CREATE MASTER TABLE
master_table <- master_country_list
names(master_table)[1] <- "Country"

master_table <- merge(x = master_table, y = active, by="Country", all.x = TRUE)
names(master_table)[2] <- "Payloads_Active"

fsp_JUST_DEBRIS <- fsp_above_2019[fsp_above_2019$RSO_TYPE != "plat", ] # 49, 064 # for satcat this is PAY
fsp_JUST_PAYLOAD <- fsp_above_2019[fsp_above_2019$RSO_TYPE == "plat", ] # 13, 937 # for satcat this is PAY


# ===========================================================================================================#
# ADD ACTIVE PAYLOADS

## we know the total for debris, so we do that, then calculate debris, everything else must be on orbit
payloads_total <- data.frame(table(fsp_JUST_PAYLOAD$SOURCE))
names(payloads_total)[1] <- "Country"
names(payloads_total)[2] <- "Active"

## merge back into master
master_table <- merge(x = master_table, y = payloads_total, by="Country", all.x = TRUE)
names(master_table)[3] <- "Payloads_Total"

## now for decayed
payload_decayed <- data.frame(fsp_JUST_PAYLOAD[fsp_JUST_PAYLOAD$PAYLOAD_OPERATIONAL_STATUS == "D" ,])
payload_decayed <- data.frame(table(payload_decayed$SOURCE))
names(payload_decayed)[1] <- "Country"
names(payload_decayed)[2] <- "Active"

## merge back into master
master_table <- merge(x = master_table, y = payload_decayed, by="Country", all.x = TRUE)
names(master_table)[4] <- "Payloads_Decayed"

# find number of payloads that are on orbit
master_table[is.na(master_table)] <- 0
master_table$Payloads_OnOrbit <- master_table$Payloads_Total - master_table$Payloads_Decayed



# =============================================================================================================#
# Add debris

total_debris_by_owner <- data.frame(table(fsp_JUST_DEBRIS$SOURCE))
names(total_debris_by_owner)[1] <- "Country"
names(total_debris_by_owner)[2] <- "Total"

## merge back into master
master_table <- merge(x = master_table, y = total_debris_by_owner, by="Country", all.x = TRUE)
names(master_table)[6] <- "Debris_Total"
master_table[is.na(master_table)] <- 0

## now for decayed
debris_decayed <- data.frame(fsp_JUST_DEBRIS[fsp_JUST_DEBRIS$PAYLOAD_OPERATIONAL_STATUS == "D" ,])
debris_decayed <- data.frame(table(debris_decayed$SOURCE))
names(debris_decayed)[1] <- "Country"
names(debris_decayed)[2] <- "Active"

## merge back into master
master_table <- merge(x = master_table, y = debris_decayed, by="Country", all.x = TRUE)
names(master_table)[7] <- "Debris_Decayed"
master_table[is.na(master_table)] <- 0

# find number of on orbit debris
master_table$Debris_OnOrbit <- master_table$Debris_Total - master_table$Debris_Decayed


# =============================================================================================================#
# Calculate All Tables
master_table$All_OnOrbit <- master_table$Payloads_OnOrbit + master_table$Debris_OnOrbit
master_table$All_Decayed <- master_table$Payloads_Decayed + master_table$Debris_Decayed
master_table$All_Total <- master_table$Payloads_Total + master_table$Debris_Total

View(master_table)
write.csv(master_table, "Results/FSP_boxscore_2023.csv", row.names = FALSE)


# ===========================================================================================================#
# ===========================================================================================================#

## Calculate for SATCAT too
## GET ALL OF THE ACTIVE SATELLITES AND THEN JOIN TO THE MASTER TABLE
# for satcat need to strip all the white space too
satcat <- satcat %>%
  mutate_if(is.character, str_trim)

satcat <- satcat[satcat$LAUNCH_DATE < '2020-01-01',]

all_active_satellites <- data.frame(satcat[satcat$OPS_STATUS_CODE == "+" | satcat$OPS_STATUS_CODE == "P" | satcat$OPS_STATUS_CODE == "B" | satcat$OPS_STATUS_CODE == "S" | satcat$OPS_STATUS_CODE == "X", ])
all_active_satellites <- all_active_satellites[all_active_satellites$LAUNCH_DATE > '2019-01-01',]

satcat_active <- data.frame(table(all_active_satellites$OWNER))
names(satcat_active)[1] <- "Country"
names(satcat_active)[2] <- "Active"
satcat_active$var2 <- NULL

## CREATE MASTER TABLE
master_table_satcat <- master_country_list
names(master_table_satcat)[1] <- "Country"

master_table_satcat <- merge(x = master_table_satcat, y = satcat_active, by="Country", all.x = TRUE)
names(master_table_satcat)[2] <- "Payloads_Active"

satcat_JUST_DEBRIS <- satcat_above_2019[satcat_above_2019$OBJECT_TYPE != "PAY", ] # 49, 064 # for satcat this is PAY
satcat_JUST_PAYLOAD <- satcat_above_2019[satcat_above_2019$OBJECT_TYPE == "PAY", ] # 13, 937 # for satcat this is PAY


# ===========================================================================================================#
# ADD ACTIVE PAYLOADS

## we know the total for debris, so we do that, then calculate debris, everything else must be on orbit
payloads_total <- data.frame(table(satcat_JUST_PAYLOAD$OWNER))
names(payloads_total)[1] <- "Country"
names(payloads_total)[2] <- "Active"

## merge back into master
master_table_satcat <- merge(x = master_table_satcat, y = payloads_total, by="Country", all.x = TRUE)
names(master_table_satcat)[3] <- "Payloads_Total"

## now for decayed
satcat_payload_decayed <- data.frame(satcat_JUST_PAYLOAD[satcat_JUST_PAYLOAD$OPS_STATUS_CODE == "D" ,])
satcat_payload_decayed <- data.frame(table(satcat_payload_decayed$OWNER))
names(satcat_payload_decayed)[1] <- "Country"
names(satcat_payload_decayed)[2] <- "Active"

## merge back into master
master_table_satcat <- merge(x = master_table_satcat, y = satcat_payload_decayed, by="Country", all.x = TRUE)
names(master_table_satcat)[4] <- "Payloads_Decayed"

# find number of payloads that are on orbit
master_table_satcat[is.na(master_table_satcat)] <- 0
master_table_satcat$Payloads_OnOrbit <- master_table_satcat$Payloads_Total - master_table_satcat$Payloads_Decayed



# =============================================================================================================#
# Add debris

total_debris_by_owner <- data.frame(table(satcat_JUST_DEBRIS$OWNER))
names(total_debris_by_owner)[1] <- "Country"
names(total_debris_by_owner)[2] <- "Total"

## merge back into master
master_table_satcat <- merge(x = master_table_satcat, y = total_debris_by_owner, by="Country", all.x = TRUE)
names(master_table_satcat)[6] <- "Debris_Total"
master_table_satcat[is.na(master_table_satcat)] <- 0

## now for decayed
debris_decayed <- data.frame(satcat_JUST_DEBRIS[satcat_JUST_DEBRIS$OPS_STATUS_CODE == "D" ,])
debris_decayed <- data.frame(table(debris_decayed$OWNER))
names(debris_decayed)[1] <- "Country"
names(debris_decayed)[2] <- "Active"

## merge back into master
master_table_satcat <- merge(x = master_table_satcat, y = debris_decayed, by="Country", all.x = TRUE)
names(master_table_satcat)[7] <- "Debris_Decayed"
master_table_satcat[is.na(master_table_satcat)] <- 0

# find number of on orbit debris
master_table_satcat$Debris_OnOrbit <- master_table_satcat$Debris_Total - master_table_satcat$Debris_Decayed


# =============================================================================================================#
# Calculate All Tables
master_table_satcat$All_OnOrbit <- master_table_satcat$Payloads_OnOrbit + master_table_satcat$Debris_OnOrbit
master_table_satcat$All_Decayed <- master_table_satcat$Payloads_Decayed + master_table_satcat$Debris_Decayed
master_table_satcat$All_Total <- master_table_satcat$Payloads_Total + master_table_satcat$Debris_Total

View(master_table_satcat)
write.csv(master_table_satcat, "Results/SATCAT_boxscore_2023.csv", row.names = FALSE)





### merge the two dataframes together
## <- merge(master_table_satcat, master_table, on="Country", all.x = TRUE, all.y = TRUE)
diff <- master_table_satcat %>%
  left_join(master_table, by = "Country") %>%
  mutate(Payloads_Active_Diff = Payloads_Active.x - Payloads_Active.y, 
         Payloads_Total_Diff = Payloads_Total.x - Payloads_Total.y, 
         Payloads_Decayed_Diff = Payloads_Decayed.x - Payloads_Total.y,
         Debris_Total_Diff = Debris_Total.x - Debris_Total.y,
         Debris_Decayed_Diff = Debris_Decayed.x - Debris_Decayed.y,
         Debris_OnOrbit_Diff = Debris_OnOrbit.x - Debris_OnOrbit.y,
         All_OnOrbit_Diff = All_OnOrbit.x - All_OnOrbit.y,
         All_Decayed_Diff = All_Decayed.x - All_Decayed.y, 
         All_Total_Diff = All_Total.x - All_Total.y) %>%
  select(Country, ends_with('_Diff'))

## NEED TO SORT OUT WHERE THERE ARE SLIGHT DIFFERENCES IN NAME
diff$Country <- str_replace_all(diff$Country, c(
  "USA" = "US",
  "RUS" = "CIS",
  "Other" = "TBD",
  "Japan" = "JPN",
  "EU" = "ESA",
  "CHN" = "PRC"
))

diff$Country <- as.factor(diff$Country)

diff <- diff %>% 
  group_by(Country) %>% 
  summarise(across(everything(), sum))

not_a_country_code <- c("AB", "ABS", "AC", "CHBZ", "FGER", "SEAL", "FRIT", "SGJP", "STCT", "ESA", "ESRO", "EUME", "EUTE", "GLOB", "GRSA", "IM", "IRID", "ISS", "ITSO", "NATO", "NICO", "O3B", "ORB", "PRES", "RASC", "SES", "TBD", "UNK")
diff$Country <- as.character(diff$Country)
diff_just_countries <- diff[!grepl(paste(not_a_country_code, collapse="|"), diff$Country),]

write.csv(diff_just_countries, "Results/Diff_Of_Boxscore_2019_2023.csv", row.names = FALSE)


## histogram of the difference in satcat to satcat
ggplot(data=diff) +
  geom_histogram(aes(x=All_Total_Diff), binwidth = 10, fill="#69b3a2", color="#e9ecef", alpha=0.9) + 
  labs(x="Difference (Actual - Predicted)", y = "Count", title="The difference in SATCAT and FSP Prediction for all catalogued objects") +
  geom_label(label="Russia", x=-499, y=5) +
  geom_label(label="Canada", x=-300, y=5) +
  geom_label(label="UK", x=-220, y=5) +
  geom_label(label="China", x=530, y=5) +
  xlim(-500, 500)

ggsave(filename = here("Plots", "The difference in SATCAT and FSP Prediction for all catalogued objects.png"))

ggplot(data=diff) +
  xlim(-500, 500)+
  geom_histogram(aes(x=Payloads_Total_Diff), binwidth = 10, fill="#69b3a2", color="#e9ecef", alpha=0.9) + 
  labs(x="Difference (Actual - Predicted)", y = "Count", title="The difference in SATCAT and FSP Prediction for all catalogued payloads") +
  geom_label(label="Russia", x=135, y=5) +
  geom_label(label="Canada", x=-294, y=5) +
  geom_label(label="UK", x=-215, y=5) +
  geom_label(label="China", x=368, y=5) +
  geom_label(label="US", x=232, y=5)

ggsave(filename = here("Plots", "The difference in SATCAT and FSP Prediction for all catalogued payloads.png"))



# ===========================================================================================================#
# ===========================================================================================================#

## Calculate for FSP 2043 too
# REMOVE ALL WHITE SPACE
library(stringr)

fsp_2043 <- fsp_2043 %>%
  mutate_if(is.character, str_trim)

fsp_2043_active_satellites <- data.frame(fsp_2043[fsp_2043$PAYLOAD_OPERATIONAL_STATUS == "+" | fsp_2043$PAYLOAD_OPERATIONAL_STATUS == "P" | fsp_2043$PAYLOAD_OPERATIONAL_STATUS == "B" | fsp_2043$PAYLOAD_OPERATIONAL_STATUS == "S" | fsp_2043$PAYLOAD_OPERATIONAL_STATUS == "X", ])
fsp_2043_active_satellites <- fsp_2043_active_satellites[fsp_2043_active_satellites$LAUNCH_DATE > '2019-01-01',]
active <- data.frame(table(fsp_2043_active_satellites$SOURCE))
names(active)[1] <- "Country"
names(active)[2] <- "Active"
active$var2 <- NULL

## CREATE MASTER TABLE
master_table <- master_country_list
names(master_table)[1] <- "Country"

master_table <- merge(x = master_table, y = active, by="Country", all.x = TRUE)
names(master_table)[2] <- "Payloads_Active"

fsp_2043_JUST_DEBRIS <- fsp_2043[fsp_2043$RSO_TYPE != "plat", ] # 49, 064 # for satcat this is PAY
fsp_2043_JUST_PAYLOAD <- fsp_2043[fsp_2043$RSO_TYPE == "plat", ] # 13, 937 # for satcat this is PAY


# ===========================================================================================================#
# ADD ACTIVE PAYLOADS

## we know the total for debris, so we do that, then calculate debris, everything else must be on orbit
payloads_total <- data.frame(table(fsp_2043_JUST_PAYLOAD$SOURCE))
names(payloads_total)[1] <- "Country"
names(payloads_total)[2] <- "Active"

## merge back into master
master_table <- merge(x = master_table, y = payloads_total, by="Country", all.x = TRUE)
names(master_table)[3] <- "Payloads_Total"

## now for decayed
payload_decayed <- data.frame(fsp_2043_JUST_PAYLOAD[fsp_2043_JUST_PAYLOAD$PAYLOAD_OPERATIONAL_STATUS == "D" ,])
payload_decayed <- data.frame(table(payload_decayed$SOURCE))
names(payload_decayed)[1] <- "Country"
names(payload_decayed)[2] <- "Active"

## merge back into master
master_table <- merge(x = master_table, y = payload_decayed, by="Country", all.x = TRUE)
names(master_table)[4] <- "Payloads_Decayed"

# find number of payloads that are on orbit
master_table[is.na(master_table)] <- 0
master_table$Payloads_OnOrbit <- master_table$Payloads_Total - master_table$Payloads_Decayed



# =============================================================================================================#
# Add debris

total_debris_by_owner <- data.frame(table(fsp_2043_JUST_DEBRIS$SOURCE))
names(total_debris_by_owner)[1] <- "Country"
names(total_debris_by_owner)[2] <- "Total"

## merge back into master
master_table <- merge(x = master_table, y = total_debris_by_owner, by="Country", all.x = TRUE)
names(master_table)[6] <- "Debris_Total"
master_table[is.na(master_table)] <- 0

## now for decayed
debris_decayed <- data.frame(fsp_2043_JUST_DEBRIS[fsp_2043_JUST_DEBRIS$PAYLOAD_OPERATIONAL_STATUS == "D" ,])
debris_decayed <- data.frame(table(debris_decayed$SOURCE))
names(debris_decayed)[1] <- "Country"
names(debris_decayed)[2] <- "Active"

## merge back into master
master_table <- merge(x = master_table, y = debris_decayed, by="Country", all.x = TRUE)
names(master_table)[7] <- "Debris_Decayed"
master_table[is.na(master_table)] <- 0

# find number of on orbit debris
master_table$Debris_OnOrbit <- master_table$Debris_Total - master_table$Debris_Decayed


# =============================================================================================================#
# Calculate All Tables
master_table$All_OnOrbit <- master_table$Payloads_OnOrbit + master_table$Debris_OnOrbit
master_table$All_Decayed <- master_table$Payloads_Decayed + master_table$Debris_Decayed
master_table$All_Total <- master_table$Payloads_Total + master_table$Debris_Total

master_table$Country <- str_replace_all(master_table$Country, c(
  "USA" = "US",
  "RUS" = "CIS",
  "Other" = "TBD",
  "Japan" = "JPN",
  "EU" = "ESA",
  "CHN" = "PRC"
))

master_table <- master_table %>% 
  group_by(Country) %>% 
  summarise(across(everything(), sum))

View(master_table)
write.csv(master_table, "Results/fsp_2043_boxscore.csv", row.names = FALSE)


not_a_country_code <- c("AB", "ABS", "AC", "CHBZ", "FGER", "SEAL", "FRIT", "SGJP", "STCT", "ESA", "ESRO", "EUME", "EUTE", "GLOB", "GRSA", "IM", "IRID", "ISS", "ITSO", "NATO", "NICO", "O3B", "ORB", "PRES", "RASC", "SES", "TBD", "UNK")
master_table$Country <- as.character(master_table$Country)
master_table_just_countries <- master_table[!grepl(paste(not_a_country_code, collapse="|"), master_table$Country),]
write.csv(master_table_just_countries, "Results/fsp_2043_boxscore_just_countries.csv", row.names = FALSE)

