# Attach dataset for easier variable reference
attach(flir_combined)

# Load necessary libraries for subset selection and regression
library(leaps)
library(MASS)

# Check the format of the variables
str(flir_combined)


# Build an initial linear model using specific variables
M1 <- lm(aveOralM ~ Humidity + T_atm_category + Distance + Cosmetics +
           T_FH_Max + T_FHC_Max + canthiMax + T_Max, 
         data = flir_combined)

summary(M1)

# Initial Model Summary
# ---------------------
# This initial model aims to predict aveOralM based on key predictors, including Humidity, T_atm_category,
# Distance, Cosmetics, and several thermal measurements (T_FH_Max, T_FHC_Max, canthiMax, and T_Max).

# Model Summary:
# - R-squared: 0.6387, about 63.87% of the variance in aveOralM is explained by the predictors.
# - Adjusted R-squared: 0.638, slightly lower, suggesting a well-fit model without overfitting.
# - F-statistic: 822.8, p-value < 2.2e-16, indicating the model as a whole is statistically significant
#   and useful for predicting aveOralM.

# Top 3 most significant predictors (smallest p-values):
# - canthiMax (p < 2e-16)
# - T_FH_Max (p < 2e-16)
# - T_Max (p < 2e-16)
# 
# Insignificant predictor:
# - Cosmetics (p = 0.33647), it may not be useful in predicting aveOralM.





# Stepwise Regression Selection ####

# Stepwise regression (based on AIC, adding or removing predictors)
stepwise_model <- step(lm(aveOralM ~ . - SubjectID, data = flir_combined), direction = "both")

summary(stepwise_model)

# Stepwise Model Summary
# ----------------------
# Stepwise regression selects the most suitable predictors by adding or removing variables based on AIC.
# This model includes additional demographic and environmental variables.

# Model Summary:
# - R-squared: 0.8685, about 86.85% of the variance in aveOralM is explained by the predictors.
# - Adjusted R-squared: 0.8671, slightly lower, suggesting a well-fit model without overfitting.
# - F-statistic: 659.2, p-value < 2.2e-16, the model as a whole is statistically significant
#   and useful for predicting aveOralM.

# Top 3 most significant predictors (smallest p-values):
# - aveOralF (p < 2e-16)
# - GenderMale (p = 6.18e-16)
# - T_atm (p = 9.12e-16)
# 
# Insignificant predictors:
# - Cosmetics (p > 0.05), Age categories (e.g., Age21-25) (p > 0.05), 
#   and some Ethnicity categories (e.g., EthnicityWhite) (p > 0.05), indicating they may not be strong predictors in this model.





# Forward Selection ####

# Initialize minimal model with no predictors
mint <- lm(aveOralM ~ 1, data = flir_combined)

# Forward selection using AIC to add predictors one by one
forward_model <- step(mint, scope = list(lower = ~1, upper = formula(M1)), direction = "forward")

summary(forward_model)

# Forward Model Summary
# ----------------------
# The forward selection model identifies predictors sequentially based on their AIC values. 
# This model includes various environmental and thermal variables that are statistically significant for predicting aveOralM.

# Model Summary:
# - R-squared: 0.6386, about 63.86% of the variance in aveOralM is explained by the predictors.
# - Adjusted R-squared: 0.638, slightly lower, suggesting a well-fit model without overfitting.
# - F-statistic: 940.2, p-value < 2.2e-16, indicating the model 
#   as a whole is statistically significant and useful for predicting aveOralM.

# Top 3 most significant predictors (smallest p-values):
# - canthiMax (p < 2e-16)
# - T_Max (p < 2e-16)
# - T_FH_Max (p < 2e-16)

# Other significant predictors:
# - T_atm_category24-29°C (p = 6.31e-15)
# - T_FHC_Max (p = 3.35e-11)
# - Humidity (p = 4.54e-06)
# - Distance (p = 0.00696): Statistically significant, though less impactful than the others.

# There are no insignificant predictors in this model, as all included variables have p-values below 0.05.





# Backward Elimination ####

# Start with the full initial model and remove predictors step-by-step
backward_model <- step(M1, direction = "backward")

# Display summary of the backward elimination model
summary(backward_model)

# Backward Elimination Model Summary
# ----------------------------------
# Backward elimination removes predictors based on AIC until only significant predictors remain.

# Model Summary:
# - R-squared: 0.6386,  about 63.86% of the variance in aveOralM is explained by the predictors.
# - Adjusted R-squared: 0.638, slightly lower, indicating a well-fit model without overfitting.
# - F-statistic: 940.2, p-value < 2.2e-16, the model 
#   as a whole is statistically significant and useful for predicting aveOralM.

# Top 3 most significant predictors (smallest p-values):
# - canthiMax (p < 2e-16)
# - T_Max (p < 2e-16)
# - T_FH_Max (p < 2e-16)

# Other significant predictors:
# - T_atm_category24-29°C (p = 6.31e-15)
# - T_FHC_Max (p = 3.35e-11)
# - Humidity (p = 4.54e-06)
# - Distance (p = 0.00696)

# There are no insignificant predictors in this model, as all included variables have p-values below 0.05.
