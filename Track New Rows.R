# Title: Tracking New Entries in an Updated Excel Dataset Using R

# Introduction ####
# In data analysis, keeping track of changes in datasets is crucial, especially when dealing with updates over time. 
# This R script is designed to compare 2 versions of an excel dataset: one representing an old version (oldsheet.xlsx)
# and the other representing a newer version containing updates (newsheet.xlsx). The goal is to identify and highlight
# new records that were added in the latest version, while retaining all relevant information for further analysis.
# It identifies new rows in the updated dataset and highlights them for easy tracking.
# This method is particularly useful for applications such as customer lists,financial transactions, 
# tracking employee records or any CRM or database that undergoes periodic updates to records.
# By automating the comparison process, the script ensures accuracy, reduces manual effort and 
# provides a structured way to monitor changes over time.

# Key Steps ####

# install and Load necessary packages ####
install.packages("readxl")
install.packages("dplyr")
install.packages("openxlsx")

# Load libraries
library("readxl")
library("dplyr")
library("openxlsx")
# The above codes install and load necessary packages

# Set working directory, to ensure the right/correct folder ####
setwd("add/working/directory/path")
 
# Read in Excel files ####
D1 <- read_excel("oldsheet.xlsx", sheet=1) # Input sheet path of the old dataset here
D2 <- read_excel("newsheet.xlsx", sheet=1) # Input sheet path of the new dataset here
# D1 represents the original dataset
# D2 represents the updated dataset (which contains possible new entries)

# Joins ####
# Join data based on matching columns
D3 <- right_join(D1,D2, by= names(D2)) 
# The above code ensures that all records from D2 (new dataset) remain, 
# while matching records from D1 (old dataset) are included. 
# This preserves all data from the new file while allowing comparison with the old one

# Find rows in D2 that are not in D1/Identifying new rows
D4 <- anti_join(D2,D1, by=c("First","Last"))
# This works to extract rows from D2 that do not exist in D1
# In the above code, this is done based on a 'First' and 'Last' name column search through both tables (D1, D2). 
# Note, you can choose your own parameters, based on columns you believe or assume to represent unique records like names, email, etc.

# Labeling ####
# Labeling (New vs Existing)
D3 <- D3 %>%
  mutate(highlight_new = ifelse(First %in% D4$First &
                                  Last %in% D4$Last, "New Row", "Existing Row"))
# The above code adds a new column (highlight_new) and apportions "New Row",
# if the row exists in D2 but not D1 and found in D4.  Similarly, it highlights as "Existing Row" if the row was already in D1

# ##Move the new column (highlight_new) to 4th column for accessibility
D3 <- D3 %>%
  select(1, 2, 3, highlight_new, everything())
# The above code keeps the first 3 columns unchanged and moves "highlight_new" to the 4th position

# Export to Excel ####
write.xlsx(D3, "NEWFILEname.xlsx")
# This code saves the updated dataset (D3) to an excel file called "NEWFILEname.xlsx" or whatever name you choose.

# ENJOY!!!