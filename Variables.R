# Load the data in 4 groups ####


# FLIR (Forward-Looking Infrared) Groups:
# The dataset includes data captured using the FLIR thermography camera.
# FLIR Group 1: Ambient Temp 20-24°C, Relative Humidity: 10–62%
# FLIR Group 2: Ambient Temp 24-29°C, Relative Humidity: 10–62%



# Load and clean FLIR Group 1
flir_group1 <- read.csv("data/FLIR_group1.csv", header = FALSE, skip = 2)
colnames(flir_group1) <- flir_group1[1, ]
flir_group1 <- flir_group1[-1, ]

# Replace empty strings or spaces with NA
flir_group1[flir_group1 == "" | flir_group1 == " "] <- NA

# Remove columns where all values are NA
flir_group1_clean <- flir_group1[, colSums(is.na(flir_group1)) != nrow(flir_group1)]



# Load and clean FLIR Group 2
flir_group2 <- read.csv("data/FLIR_group2.csv", header = FALSE, skip = 2)
colnames(flir_group2) <- flir_group2[1, ]
flir_group2 <- flir_group2[-1, ]

# Replace empty strings or spaces with NA
flir_group2[flir_group2 == "" | flir_group2 == " "] <- NA

# Remove columns where all values are NA
flir_group2_clean <- flir_group2[, colSums(is.na(flir_group2)) != nrow(flir_group2)]



# ICI (Infrared Cameras Inc.) Groups:
# ICI Group 1: Ambient Temp 20-24°C
# ICI Group 2: Ambient Temp 24-29°C

# Load and clean ICI Group 1
ici_group1 <- read.csv("data/ICI_group1.csv", header = FALSE, skip = 2)
colnames(ici_group1) <- ici_group1[1, ]
ici_group1 <- ici_group1[-1, ]

# Replace empty strings or spaces with NA
ici_group1[ici_group1 == "" | ici_group1 == " "] <- NA

# Remove columns where all values are NA
ici_group1_clean <- ici_group1[, colSums(is.na(ici_group1)) != nrow(ici_group1)]



# Load and clean ICI Group 2
ici_group2 <- read.csv("data/ICI_group2.csv", header = FALSE, skip = 2)
colnames(ici_group2) <- ici_group2[1, ]
ici_group2 <- ici_group2[-1, ]

# Replace empty strings or spaces with NA
ici_group2[ici_group2 == "" | ici_group2 == " "] <- NA

# Remove columns where all values are NA
ici_group2_clean <- ici_group2[, colSums(is.na(ici_group2)) != nrow(ici_group2)]



#### Check the structure and column names of the cleaned datasets ####
str(flir_group1_clean)
str(flir_group2_clean)
str(ici_group1_clean)
str(ici_group2_clean)

names(flir_group1_clean)
names(flir_group2_clean)
names(ici_group1_clean)
names(ici_group2_clean)


#### Check for duplicate SubjectIDs and overlaps ####
# Ensure all SubjectIDs are unique within each dataset
length(unique(flir_group1_clean$SubjectID)) == nrow(flir_group1_clean)
length(unique(flir_group2_clean$SubjectID)) == nrow(flir_group2_clean)
length(unique(ici_group1_clean$SubjectID)) == nrow(ici_group1_clean)
length(unique(ici_group2_clean$SubjectID)) == nrow(ici_group2_clean)

# Find duplicated SubjectIDs
duplicated_flir_group1 <- flir_group1_clean$SubjectID[duplicated(flir_group1_clean$SubjectID)]
duplicated_flir_group2 <- flir_group2_clean$SubjectID[duplicated(flir_group2_clean$SubjectID)]
duplicated_ici_group1 <- ici_group1_clean$SubjectID[duplicated(ici_group1_clean$SubjectID)]
duplicated_ici_group2 <- ici_group2_clean$SubjectID[duplicated(ici_group2_clean$SubjectID)]

# Check for overlapping SubjectIDs between datasets
overlap_flir1_flir2 <- intersect(flir_group1_clean$SubjectID, flir_group2_clean$SubjectID)
overlap_flir1_ici1 <- intersect(flir_group1_clean$SubjectID, ici_group1_clean$SubjectID)
overlap_flir1_ici2 <- intersect(flir_group1_clean$SubjectID, ici_group2_clean$SubjectID)
overlap_flir2_ici1 <- intersect(flir_group2_clean$SubjectID, ici_group1_clean$SubjectID)
overlap_flir2_ici2 <- intersect(flir_group2_clean$SubjectID, ici_group2_clean$SubjectID)
overlap_ici1_ici2 <- intersect(ici_group1_clean$SubjectID, ici_group2_clean$SubjectID)

# Print overlaps
overlap_flir1_flir2
overlap_flir1_ici1
summary(overlap_flir1_ici1)

overlap_flir1_ici2
overlap_flir2_ici1
overlap_flir2_ici2
summary(overlap_flir2_ici2)

overlap_ici1_ici2


#### Clean column names and convert variables ####

# Fix incorrect variable name "T_LC14" to "T_LC4" in all datasets
fix_column_name <- function(data) {
  if ("T_LC14" %in% colnames(data)) {
    colnames(data)[colnames(data) == "T_LC14"] <- "T_LC4"
  }
  return(data)
}

# Apply the function to all datasets
flir_group1_clean <- fix_column_name(flir_group1_clean)
flir_group2_clean <- fix_column_name(flir_group2_clean)
ici_group1_clean <- fix_column_name(ici_group1_clean)
ici_group2_clean <- fix_column_name(ici_group2_clean)


# Vector of base variable names excluding the round numbers
base_temp_vars <- c("T_offset", "Max1R13_", "Max1L13_", "aveAllR13_", "aveAllL13_", 
                    "T_RC", "T_RC_Dry", "T_RC_Wet", "T_RC_Max", 
                    "T_LC", "T_LC_Dry", "T_LC_Wet", "T_LC_Max", 
                    "RCC", "LCC", "canthiMax", "canthi4Max", 
                    "T_FHCC", "T_FHRC", "T_FHLC", "T_FHBC", "T_FHTC", 
                    "T_FH_Max", "T_FHC_Max", "T_Max", "T_OR", "T_OR_Max")

# Function to convert variables to numeric for all 4 rounds
convert_to_numeric <- function(data, base_vars, rounds = 4) {
  for (round in 1:rounds) {
    for (var in base_vars) {
      var_name <- paste0(var, round)
      if (var_name %in% colnames(data)) {
        data[[var_name]] <- as.numeric(data[[var_name]])
      } else {
        cat(var_name, "not found in the dataset\n")
      }
    }
  }
  return(data)
}

# Apply the function to all datasets
flir_group1_clean <- convert_to_numeric(flir_group1_clean, base_temp_vars)
flir_group2_clean <- convert_to_numeric(flir_group2_clean, base_temp_vars)
ici_group1_clean <- convert_to_numeric(ici_group1_clean, base_temp_vars)
ici_group2_clean <- convert_to_numeric(ici_group2_clean, base_temp_vars)

# Confirm the conversion
str(flir_group1_clean)
str(flir_group2_clean)
str(ici_group1_clean)
str(ici_group2_clean)


#### Convert other specific columns to numeric or factors ####

# Convert aveOralF and aveOralM to numeric
convert_oral_vars <- function(data) {
  data$aveOralF <- as.numeric(data$aveOralF)
  data$aveOralM <- as.numeric(data$aveOralM)
  return(data)
}

flir_group1_clean <- convert_oral_vars(flir_group1_clean)
flir_group2_clean <- convert_oral_vars(flir_group2_clean)
ici_group1_clean <- convert_oral_vars(ici_group1_clean)
ici_group2_clean <- convert_oral_vars(ici_group2_clean)

# Convert Gender, Age, Ethnicity and Cosmetics to factors
convert_factors <- function(data) {
  data$Gender <- as.factor(data$Gender)
  data$Age <- as.factor(data$Age)
  data$Ethnicity <- as.factor(data$Ethnicity)
  data$Cosmetics <- as.factor(data$Cosmetics)
  return(data)
}

flir_group1_clean <- convert_factors(flir_group1_clean)
flir_group2_clean <- convert_factors(flir_group2_clean)
ici_group1_clean <- convert_factors(ici_group1_clean)
ici_group2_clean <- convert_factors(ici_group2_clean)

# Convert T_atm, Humidity, and Distance to numeric
convert_environment_vars <- function(data) {
  data$T_atm <- as.numeric(data$T_atm)
  data$Humidity <- as.numeric(data$Humidity)
  data$Distance <- as.numeric(data$Distance)
  return(data)
}

flir_group1_clean <- convert_environment_vars(flir_group1_clean)
flir_group2_clean <- convert_environment_vars(flir_group2_clean)
ici_group1_clean <- convert_environment_vars(ici_group1_clean)
ici_group2_clean <- convert_environment_vars(ici_group2_clean)


#### Convert Date and Time columns ####

# Use lubridate to convert Date and Time
library(lubridate)

convert_date_time <- function(data) {
  data$Time <- lubridate::hms(data$Time)   # Convert Time to HH:MM:SS format
  data$Date <- lubridate::ymd(data$Date)   # Convert Date to YYYY-MM-DD format
  return(data)
}

# Apply the function to all datasets
flir_group1_clean <- convert_date_time(flir_group1_clean)
flir_group2_clean <- convert_date_time(flir_group2_clean)
ici_group1_clean <- convert_date_time(ici_group1_clean)
ici_group2_clean <- convert_date_time(ici_group2_clean)

# Check the summaries to confirm correct formatting
summary(flir_group1_clean$Time)
summary(flir_group1_clean$Date)

summary(flir_group2_clean$Time)
summary(flir_group2_clean$Date)

summary(ici_group1_clean$Time)
summary(ici_group1_clean$Date)

summary(ici_group2_clean$Time)
summary(ici_group2_clean$Date)



#### Handling the NA values ####

library(naniar)

# Visualize missing data for each dataset
vis_miss(flir_group1_clean)
vis_miss(flir_group2_clean)
vis_miss(ici_group1_clean)
vis_miss(ici_group2_clean)



#### Function to check unique levels for categorical variables ####

check_categorical_levels <- function(data) {
  for (column in colnames(data)) {
    
    # If the column is a factor, print its unique levels and number of NA values
    
    if (is.factor(data[[column]])) {
      cat("\nUnique values in", column, ":\n")
      print(unique(data[[column]]))
      cat("Number of NAs in", column, ":\n")
      print(sum(is.na(data[[column]])))
    }
  }
  return(data)
}

# Apply to all datasets

# For FLIR Group 1
cat("FLIR Group 1:\n")
flir_group1_clean <- check_categorical_levels(flir_group1_clean)

# For FLIR Group 2
cat("\nFLIR Group 2:\n")
flir_group2_clean <- check_categorical_levels(flir_group2_clean)

# For ICI Group 1
cat("\nICI Group 1:\n")
ici_group1_clean <- check_categorical_levels(ici_group1_clean)

# For ICI Group 2
cat("\nICI Group 2:\n")
ici_group2_clean <- check_categorical_levels(ici_group2_clean)



#### Removing rows with missing values ####

# complete.cases to remove rows that contain any missing values from each dataset
flir_group1_clean <- flir_group1_clean[complete.cases(flir_group1_clean), ]
flir_group2_clean <- flir_group2_clean[complete.cases(flir_group2_clean), ]
ici_group1_clean <- ici_group1_clean[complete.cases(ici_group1_clean), ]
ici_group2_clean <- ici_group2_clean[complete.cases(ici_group2_clean), ]

# Count the number of remaining NA values
cat("\nRemaining NA counts:\n")
cat("FLIR Group 1: ", sum(is.na(flir_group1_clean)), "\n")
cat("FLIR Group 2: ", sum(is.na(flir_group2_clean)), "\n")
cat("ICI Group 1: ", sum(is.na(ici_group1_clean)), "\n")
cat("ICI Group 2: ", sum(is.na(ici_group2_clean)), "\n")

#### Final structure check ####

# Check the structure of the cleaned datasets after removing rows with missing values
cat("\nFinal structure of datasets:\n")
str(flir_group1_clean) # Expected: 488 rows, ~7% NAs before removal
str(flir_group2_clean) # Expected: 445 rows, ~5.5% NAs before removal
str(ici_group1_clean)  # Expected: 342 rows, ~32% NAs before removal
str(ici_group2_clean)  # Expected: 299 rows, ~35% NAs before removal
