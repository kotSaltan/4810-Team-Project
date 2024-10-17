#### DANA 4010 Team Project

# Kari Bautista
# Anna Dorosheva
# Carlos Henrique
# Alexandra Schweig

# https://archive.ics.uci.edu/dataset/925/infrared+thermography+temperature+dataset
# Load the dataset, skipping first 2 rows (incorrect headers)
data <- read.csv("data/FLIR_groups1and2.csv", header = FALSE, skip = 2)

# Assign the header (column names)
colnames(data) <- data[1, ]

# Remove the row from the data as it is now set as the header
data <- data[-1, ]

head(data)
names(data)
str(data)

# Remove columns that are entirely NA
data_clean <- data[, colSums(is.na(data)) != nrow(data)]

head(data_clean)
names(data_clean)

subject_info <- c("SubjectID", "Gender", "Age", "Ethnicity")
environmental_factors <- c("T_atm", "Humidity", "Distance", "Cosmetics", "Time", "Date"  )

# Oral Temperature Measurements
oral_temp <- c("aveOralF", "aveOralM")

# Round 1 Measurements
round_1 <- c("T_offset1", "Max1R13_1", "Max1L13_1", "aveAllR13_1", "aveAllL13_1", 
             "T_RC1", "T_RC_Dry1", "T_RC_Wet1", "T_RC_Max1", "T_LC1", "T_LC_Dry1", "T_LC_Wet1", "T_LC_Max1")

# Round 2 Measurements
round_2 <- c("T_offset2", "Max1R13_2", "Max1L13_2", "aveAllR13_2", "aveAllL13_2", 
             "T_RC2", "T_RC_Dry2", "T_RC_Wet2", "T_RC_Max2", "T_LC2", "T_LC_Dry2", "T_LC_Wet2", "T_LC_Max2")

# Round 3 Measurements
round_3 <- c("T_offset3", "Max1R13_3", "Max1L13_3", "aveAllR13_3", "aveAllL13_3", 
             "T_RC3", "T_RC_Dry3", "T_RC_Wet3", "T_RC_Max3", "T_LC3", "T_LC_Dry3", "T_LC_Wet3", "T_LC_Max3")

# Round 4 Measurements
round_4 <- c("T_offset4", "Max1R13_4", "Max1L13_4", "aveAllR13_4", "aveAllL13_4", 
             "T_RC4", "T_RC_Dry4", "T_RC_Wet4", "T_RC_Max4", "T_LC4", "T_LC_Dry4", "T_LC_Wet4", "T_LC_Max4")

