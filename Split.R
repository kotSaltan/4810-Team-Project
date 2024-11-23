# Load necessary library
library(dplyr)

# Read the CSV file
combined_data <- read.csv("combined_data.csv")

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
