fsp <- read.csv("C:\\Users\\someg\\Downloads\\fspcat_20230101_v90721_nodeb.csv", strip.white = TRUE)
names(fsp)[1] <- "LAUNCH_DATE"
names(fsp)[3] <- "OBJECT_TYPE"
names(fsp)[4] <- "OPS_STATUS_CODE"
names(fsp)[7] <- "OWNER"

fsp$OWNER[fsp$OWNER == "USA"] <- "US"
fsp$OWNER[fsp$OWNER == "Japan"] <- "JPN"
fsp$OWNER[fsp$OWNER == "EU"] <- "ESA"

# active satellites are defined here: https://celestrak.org/satcat/status.php
fsp$OPS_STATUS_CODE <- as.character(fsp$OPS_STATUS_CODE)
fsp_all_active_satellites <- data.frame(fsp[fsp$OPS_STATUS_CODE == "+" | fsp$OPS_STATUS_CODE == "P" | fsp$OPS_STATUS_CODE == "B" | fsp$OPS_STATUS_CODE == "S" | fsp$OPS_STATUS_CODE == "X", ])
fsp_active <- data.frame(table(fsp_all_active_satellites$OWNER))
names(fsp_active)[1] <- "Country"
names(fsp_active)[2] <- "Active"

# Create master table
fsp_master_table <- data.frame(unique(fsp$OWNER))
names(fsp_master_table)[1] <- "Country"

fsp_master_table <- merge(x = fsp_master_table, y = fsp_active, by="Country", all.x = TRUE)
names(fsp_master_table)[2] <- "FSP_Payloads_Active"

fsp_JUST_DEBRIS <- fsp[fsp$OBJECT_TYPE != "plat", ] # 7033, remember they didn't cound debris
fsp_JUST_PAYLOAD <- fsp[fsp$OBJECT_TYPE == "plat", ] # 13, 613


## JUST DO PAYLOADS AS THEY WERE NOT INTERESTED IN DEBRIS IN THIS STUDY
fsp_payloads_total <- data.frame(table(fsp_JUST_PAYLOAD$OWNER))
names(fsp_payloads_total)[1] <- "Country"
names(fsp_payloads_total)[2] <- "Active"
## merge back into master
fsp_master_table <- merge(x = fsp_master_table, y = fsp_payloads_total, by="Country", all.x = TRUE)
names(fsp_master_table)[3] <- "FSP_Payloads_Total"

## now for decayed
fsp_payload_decayed <- data.frame(fsp_JUST_PAYLOAD[fsp_JUST_PAYLOAD$OPS_STATUS_CODE == "D" ,])
fsp_payload_decayed <- data.frame(table(fsp_payload_decayed$OWNER))
names(fsp_payload_decayed)[1] <- "Country"
names(fsp_payload_decayed)[2] <- "Active"

fsp_master_table <- merge(x = fsp_master_table, y = fsp_payload_decayed, by="Country", all.x = TRUE)
names(fsp_master_table)[4] <- "FSP_Payloads_Decayed"


# find number of payloads that are on orbit
fsp_master_table[is.na(fsp_master_table)] <- 0
fsp_master_table$FSP_Payloads_OnOrbit <- fsp_master_table$FSP_Payloads_Total - fsp_master_table$FSP_Payloads_Decayed

## FIND THE DIFFERENCEs
output <- merge(x=master_table, y=fsp_master_table, by="Country", all.x = TRUE)
output$DIFF_payloads_active <- output$Payloads_Active - output$FSP_Payloads_Active
output$DIFF_payloads_Total <- output$Payloads_Total - output$FSP_Payloads_Total
output$DIFF_payloads_decayed <- output$Payloads_Decayed - output$FSP_Payloads_Decayed
output$DIFF_payloads_onorbit <- output$Payloads_OnOrbit - output$FSP_Payloads_OnOrbit


write.csv(output, 'C:\\Users\\someg\\OneDrive\\Documents\\UCL\\DataVisualisation\\FSP_Boxscore.csv', row.names = TRUE)
