#### DANA 4010 Team Project

# Kari Bautista
# Anna Dorosheva
# Carlos Henrique
# Alexandra Schweig


# Load the dataset, skipping first 2 rows (incorrect headers)
data <- read.csv("data/FLIR_groups1and2.csv", header = FALSE, skip = 2)

# Assign the header (column names)
colnames(data) <- data[1, ]

# Remove the row from the data as it is now set as the header
data <- data[-1, ]

head(data)
names(data)
str(data)
