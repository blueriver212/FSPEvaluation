# This is a script to start plotting box scores for the fsp paper
# need to create a table with satellites object by country owner on the left
# then a break down of each type on the x axis (so  to speak)
library(ggplot2)

## GET ALL OF THE ACTIVE SATELLITES AND THEN JOIN TO THE MASTER TABLE
all_active_satellites <- data.frame(satcat[satcat$OPS_STATUS_CODE == "+" | satcat$OPS_STATUS_CODE == "P" | satcat$OPS_STATUS_CODE == "B" | satcat$OPS_STATUS_CODE == "S" | satcat$OPS_STATUS_CODE == "X", ])
active <- data.frame(table(all_active_satellites$OWNER))
names(active)[1] <- "Country"
names(active)[3] <- "Active"
active$var2 <- NULL

## CREATE MASTER TABLE
master_table <- data.frame(unique(satcat$OWNER))
names(master_table)[1] <- "Country"

master_table <- merge(x = master_table, y = active, by="Country", all.x = TRUE)
names(master_table)[2] <- "Payloads_Active"

satcat_JUST_DEBRIS <- satcat[satcat$OBJECT_TYPE != "PAY", ] # 49, 064
satcat_JUST_PAYLOAD <- satcat[satcat$OBJECT_TYPE == "PAY", ] # 13, 937


# ===========================================================================================================#
# ADD ACTIVE PAYLOADS

## we know the total for debris, so we do that, then calculate debris, everything else must be on orbit
payloads_total <- data.frame(table(satcat_JUST_PAYLOAD$OWNER))
names(payloads_total)[1] <- "Country"
names(payloads_total)[2] <- "Active"

## merge back into master
master_table <- merge(x = master_table, y = payloads_total, by="Country", all.x = TRUE)
names(master_table)[3] <- "Payloads_Total"

## now for decayed
payload_decayed <- data.frame(satcat_JUST_PAYLOAD[satcat_JUST_PAYLOAD$OPS_STATUS_CODE == "D" ,])
payload_decayed <- data.frame(table(payload_decayed$OWNER))
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

total_debris_by_owner <- data.frame(table(satcat_JUST_DEBRIS$OWNER))
names(total_debris_by_owner)[1] <- "Country"
names(total_debris_by_owner)[2] <- "Total"

## merge back into master
master_table <- merge(x = master_table, y = total_debris_by_owner, by="Country", all.x = TRUE)
names(master_table)[6] <- "Debris_Total"
master_table[is.na(master_table)] <- 0

## now for decayed
debris_decayed <- data.frame(satcat_JUST_DEBRIS[satcat_JUST_DEBRIS$OPS_STATUS_CODE == "D" ,])
debris_decayed <- data.frame(table(debris_decayed$OWNER))
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
master_table$All_ObOrbit <- master_table$Payloads_OnOrbit + master_table$Debris_OnOrbit
master_table$All_Decayed <- master_table$Payloads_Decayed + master_table$Debris_Decayed
master_table$All_Total <- master_table$Payloads_Total + master_table$Debris_Total

