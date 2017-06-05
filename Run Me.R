
#################################### Install and load packages ####################################
install.packages("devtools")
install.packages("rmarkdown")

library(devtools)
library(rmarkdown)

#################################### Install and load nomscheck package ####################################
devtools::install_github("sarahvanhala/nomscheck")
library(nomscheck)

#################################### Work ####################################

# Read in a previous SPARS download using noms_data
noms_data <- read_noms_data("/Users/sarah/Desktop/ExcelReport old.xls")

# Save results of noms_data
install.packages("readr")
library(readr)
write_csv(noms_data, "/path/file_name_you_want.csv")

# Create prior_assessment_data csv using save_prior_assessments
save_prior_assessments(noms_data, "/Users/sarah/Desktop/prior_assessments.csv")
