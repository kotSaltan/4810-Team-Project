# Load necessary libraries
library(ggplot2)
library(gridExtra)
library(car)
library(dplyr)



# Step 2: Extract numerical variables ending with "_avg"
avg_columns <- grep("_avg$", names(train_data), value = TRUE)
numerical_avg_data <- train_data[, avg_columns]

# Descriptive Analysis

# 1. Scatterplots for numerical variables ending with "_avg"
generate_avg_scatterplots <- function(data, pairs_per_plot = 4) {
  scatter_plots <- list()
  plot_count <- 1
  
  for (i in 1:(ncol(data) - 1)) {
    for (j in (i + 1):ncol(data)) {
      scatter_plots[[plot_count]] <- ggplot(data, aes_string(x = names(data)[i], y = names(data)[j])) +
        geom_point(alpha = 0.6) +
        labs(title = paste( names(data)[i], "vs", names(data)[j]),
             x = names(data)[i], y = names(data)[j]) +
        theme_minimal()
      plot_count <- plot_count + 1
    }
  }
  
  return(scatter_plots)
}

# Generate and display scatterplots
scatter_plots <- generate_avg_scatterplots(numerical_avg_data)
for (i in seq(1, length(scatter_plots), by = 4)) {
  grid.arrange(grobs = scatter_plots[i:min(i + 3, length(scatter_plots))], ncol = 2)
}

# Load necessary library
library(gridExtra)

# Function to save scatterplots in batches of 6
save_existing_scatterplots_in_batches <- function(scatter_plots, save_path = "scatterplots_batches") {
  # Create the directory to save the combined plots if it doesn't exist
  if (!dir.exists(save_path)) {
    dir.create(save_path)
  }
  
  # Loop through scatterplots in batches of 6
  for (i in seq(1, length(scatter_plots), by = 6)) {
    # Create a 2x3 grid of scatterplots (or fewer if it's the last batch)
    batch_plots <- scatter_plots[i:min(i + 5, length(scatter_plots))]
    combined_plot <- grid.arrange(grobs = batch_plots, ncol = 3)
    
    # Save the combined grid as a PNG
    file_name <- paste0(save_path, "/scatterplots_batch_", ceiling(i / 6), ".png")
    ggsave(filename = file_name, plot = combined_plot, width = 12, height = 8)
  }
  
  cat("Scatterplot batches saved in directory:", save_path, "\n")
}

# Usage Example
# Assuming `scatter_plots` is the list of scatterplots you've already generated
save_existing_scatterplots_in_batches(scatter_plots)


# 2. Correlation Matrix
cor_matrix <- cor(numerical_avg_data, use = "complete.obs")
print(cor_matrix)

library(corrplot)
# Plot the correlation matrix
corrplot(cor_matrix, method = "color", type = "upper", 
         tl.col = "black", tl.cex = 0.8, title = "Correlation Matrix", mar = c(0, 0, 1, 0))

# 3. Check multicollinearity (VIF)
***CHECK***

# 4. Histograms for numerical variables ending with "_avg"
par(mfrow = c(3, 3))  # Adjust grid size based on the number of variables
for (col in avg_columns) {
  hist(train_data[[col]], main = paste("Histogram of", col), xlab = col, col = "blue", border = "white")
}

# Reset the plotting grid
par(mfrow = c(1, 1))

# Load necessary libraries
library(ggplot2)
library(gridExtra)

# Ensure Cosmetics is a factor
train_data$Cosmetics <- factor(train_data$Cosmetics, levels = c(0, 1), labels = c("No", "Yes"))
categorical_vars <- c("Gender", "Age", "Ethnicity", "Cosmetics")

# Function to save 4 boxplots in one PNG
save_boxplots_in_batches <- function(train_data, avg_columns, categorical_vars, save_path = "boxplots_batches") {
  # Create a directory for saving the files, if it doesn't exist
  if (!dir.exists(save_path)) {
    dir.create(save_path)
  }
  
  # List to store all plots
  all_plots <- list()
  plot_count <- 1
  
  # Generate boxplots for each combination of categorical and numerical variables
  for (cat_col in categorical_vars) {
    for (num_col in avg_columns) {
      # Create the boxplot
      boxplot <- ggplot(train_data, aes_string(x = cat_col, y = num_col)) +
        geom_boxplot(fill = "lightblue", outlier.colour = "red", outlier.shape = 16) +
        labs(title = paste("Boxplot of", num_col, "by", cat_col),
             x = cat_col, y = num_col) +
        theme_minimal()
      
      # Add the plot to the list
      all_plots[[plot_count]] <- boxplot
      plot_count <- plot_count + 1
    }
  }
  
  # Save the boxplots in batches of 4
  for (i in seq(1, length(all_plots), by = 4)) {
    # Create a 2x2 grid of boxplots (or fewer if fewer than 4 remain)
    batch_plots <- all_plots[i:min(i + 3, length(all_plots))]
    combined_plot <- grid.arrange(grobs = batch_plots, ncol = 2)
    
    # Save the combined grid as a PNG file
    file_name <- paste0(save_path, "/boxplots_batch_", ceiling(i / 4), ".png")
    ggsave(filename = file_name, plot = combined_plot, width = 12, height = 8)
  }
  
  cat("Boxplots saved in batches to directory:", save_path, "\n")
}

# Example usage
# Call the function with your data
save_boxplots_in_batches(train_data, avg_columns, categorical_vars)


