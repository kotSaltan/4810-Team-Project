# Load necessary library
library(dplyr)

# Read the CSV file
combined_data <- read.csv("data/combined_data.csv")

# Set a seed for reproducibility
set.seed(123)

# Randomly sample 80% of the data for training
train_indices <- sample(1:nrow(combined_data), size = 0.8 * nrow(combined_data))

# Create the training and testing datasets
train_data <- combined_data[train_indices, ]
test_data <- combined_data[-train_indices, ]

# Optional: Save the split data to new CSV files
write.csv(train_data, "train_data.csv", row.names = FALSE)
write.csv(test_data, "test_data.csv", row.names = FALSE)


names(train_data)

avg_temp_vars <- c("T_offset_avg", "Max1R_avg", "Max1L_avg", "aveAllR_avg", "aveAllL_avg", 
                    "T_RC_avg", "T_RC_Dry_avg", "T_RC_Wet_avg", "T_RC_Max_avg", 
                    "T_LC_avg", "T_LC_Dry_avg", "T_LC_Wet_avg", "T_LC_Max_avg", 
                    "RCC_avg", "LCC_avg", "canthiMax_avg", "canthi4Max_avg", 
                    "T_FHCC_avg", "T_FHRC_avg", "T_FHLC_avg", "T_FHBC_avg", "T_FHTC_avg", 
                    "T_FH_Max_avg", "T_FHC_Max_avg", "T_Max_avg", "T_OR_avg", "T_OR_Max_avg")

avg_temp_vars <- c("Max1R_avg", "aveAllR_avg", # right eye
                   "T_RC_avg",
                   "T_RC_Dry_avg",
                   "T_RC_Wet_avg",
                   "T_RC_Max_avg", 
                   "RCC_avg",
                   
                   
                   "Max1L_avg", "aveAllL_avg", # left eye
                   "T_LC_avg",
                   "T_LC_Dry_avg",
                   "T_LC_Wet_avg",
                   "T_LC_Max_avg",
                   "LCC_avg",
                   
                   
                   "canthiMax_avg", # extended eye area
                   "canthi4Max_avg", 
                   
                   
                
                  
                   
                   "T_FHRC_avg", # right and left forehead
                   "T_FHLC_avg",
                   
                   
                   "T_FHCC_avg", # forehead
                   "T_FHBC_avg",
                   "T_FHTC_avg",
                   "T_FH_Max_avg",
                   "T_FHC_Max_avg",
                   
                   "T_Max_avg", # full face
                   
                   "T_OR_avg", # oral
                   "T_OR_Max_avg")

pairs(train_data[, avg_temp_vars])
