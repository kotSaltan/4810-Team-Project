library(tidyr)

# Transform datasets into long format
transform_to_long <- function(data, base_vars, subject_vars) {
  
  long_data <- pivot_longer(
    data, 
    cols = starts_with(base_vars),      # Columns to gather (all temperature variables)
    names_to = c(".value", "Round"),    # ".value" means the base variable name stays as is, "Round" becomes the round number
    names_pattern = "(.*)([1-4])"       # Extract the base variable and round number
  )
  
  long_data$Round <- factor(long_data$Round, levels = c("1", "2", "3", "4"))
  
  return(long_data)
}

# Base temperature variables
base_temp_vars <- c("T_offset", "Max1R13_", "Max1L13_", "aveAllR13_", "aveAllL13_", 
                    "T_RC", "T_RC_Dry", "T_RC_Wet", "T_RC_Max", 
                    "T_LC", "T_LC_Dry", "T_LC_Wet", "T_LC_Max", 
                    "RCC", "LCC", "canthiMax", "canthi4Max", 
                    "T_FHCC", "T_FHRC", "T_FHLC", "T_FHBC", "T_FHTC", 
                    "T_FH_Max", "T_FHC_Max", "T_Max", "T_OR", "T_OR_Max")

subject_vars <- c("SubjectID", "Gender", "Age", "Ethnicity", "Cosmetics", "T_atm", "Humidity", "Distance", "Date", "Time")

# Apply the function
flir_group1_long <- transform_to_long(flir_group1_clean, base_temp_vars, subject_vars)
flir_group2_long <- transform_to_long(flir_group2_clean, base_temp_vars, subject_vars)
ici_group1_long  <- transform_to_long(ici_group1_clean, base_temp_vars, subject_vars)
ici_group2_long  <- transform_to_long(ici_group2_clean, base_temp_vars, subject_vars)

head(flir_group1_long)
head(flir_group2_long)
head(ici_group1_long)
head(ici_group2_long)

summary(flir_group1_long)
summary(flir_group2_long)
summary(ici_group1_long)
summary(ici_group2_long)

dim(flir_group1_long)
dim(flir_group2_long)
dim(ici_group1_long)
dim(ici_group2_long)

colnames(flir_group1_long)
colnames(flir_group2_long)
colnames(ici_group1_long)
colnames(ici_group2_long)

sum(is.na(flir_group1_long))
sum(is.na(flir_group2_long))
sum(is.na(ici_group1_long))
sum(is.na(ici_group2_long))






# Check the T_atm range for each dataset
summary(flir_group1_long$T_atm)  # Expected: 20-24°C
summary(flir_group2_long$T_atm)  # Expected: 24-29°C
summary(ici_group1_long$T_atm)   # Expected: 20-24°C
summary(ici_group2_long$T_atm)   # Expected: 24-29°C



# Add T_atm category based on group and set as factor
flir_group1_long$T_atm_category <- factor("20-24°C", levels = c("20-24°C", "24-29°C"))
flir_group2_long$T_atm_category <- factor("24-29°C", levels = c("20-24°C", "24-29°C"))
ici_group1_long$T_atm_category <- factor("20-24°C", levels = c("20-24°C", "24-29°C"))
ici_group2_long$T_atm_category <- factor("24-29°C", levels = c("20-24°C", "24-29°C"))

# Combine FLIR and ICI datasets 
flir_combined <- rbind(flir_group1_long, flir_group2_long)
ici_combined <- rbind(ici_group1_long, ici_group2_long)



# Check the combined dataset
head(flir_combined)
head(ici_combined)
