# nomscheck: Check NOMs H-data 

Installation and Implementation Instructions

1. Download [R](https://www.r-project.org/)
2. Download the free version of [R-Studio](https://www.rstudio.com/products/rstudio/download2/)
3. Open R-Studio and make sure you have the `devtools` and `rmarkdown` packages installed (type the code below into the console)

```
install.packages("devtools")
install.packages("rmarkdown")
```

4. Windows users: You may have to download and install [Rtools](https://cran.rstudio.com/bin/windows/Rtools/)                                
   MAC users: You may have to download and install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12)

5. Install and load the nomscheck package

```
devtools::install_github("sarahvanhala/nomscheck")
library(nomscheck)
```

6. Read in a SPARS download using the `read_noms_data` function (the file is the file that you download from SPARS)

```
noms_data <- read_noms_data("/Users/sarah/Desktop/SV Work/Evaluation Projects/General Reports/Packages/ExcelReport old.xls")

```

The results of `read_noms_data` includes the following derived variables:

- der_date: Combines discharge and assessments dates so you can filter the data by a particular date
- der_intake_seq_no: Intake sequence number (1, 2, 3, ...)
- der_variables: Missing value codes turned to NA
- der_age: Rough client age calculated from birth month and year
- der_variable_risk: Risk variables as defined in the RFA (HgbA1c and plasma glucose are combined to define diabetes risk)
- der_weight_lbs: Weight in lbs.
- der_height_ft: Height in feet
- der_mechanical_risk_count: The number of mechanical indicators that the client is at risk for
- der_blood_risk_count: The number of blood indicators that the client is at risk for 
- der_mechanical_risk_na_count: The number of mechanical risk indicators that the client has an NA value for
- der_blood_risk_na_count: The number of blood risk indicators that the client has an NA value for
- der_aa_at_all: Client identifies as African American at all
- der_white_only: Client solely identifies as White
- der_hisp_at_all: Client identifies as Hispanic
- der_lgbt: Client identifies as LGBT
- der_women_only: Client solely identifies as a woman
- der_men_only: CLient solely identifies as a man
- der_age_55_p_only: Client is 55+ years old
- der_violence_trauma_only: Client has experienced violence

You can save the results of `read_noms_data` using the follwing code:

```
library(readr)
write_csv(noms_data, "/path/file_name_you_want.csv")
```

7. Create the prior_assessment_data csv using the `save_prior_assessments` function

```
save_prior_assessments(noms_data, "/Desktop/prior_assessments.csv")
```

8. Click on File > New File > R Markdown > select from template > select NOMs checking report > OK

9. Click on the arrow to the right of Knit > knit with parameters

10. Save the code file

11. Enter the paths for the new NOMs data set and optionally for the csv of prior assessments

12. Click Knit to create the report!

# Instructions on how to change the comparison distributions 
  
## For the variable plots:
      
1. Determine the mean of the distribution     

2. Determine the standard deviation of the distribution   

3. Go into the code that is generated after Step 8 above

4. Type ctrl+f for `compare_dist` and change the mean and standard deviation parameters
         
 ## For the difference plots:
  
1. The probability that the difference between assessments is zero
      
2. The mean of the absolute value of the non-zero differences
      
3. Go into the code that is generated after Step 8 above

4. Type ctrl+f for `compare_diff` and change the zero_prob and the mean parameters 
 
## Example

```
compare_diff(diff_data, "Weight", zero_prob = .3, mean = 10)
compare_dist(new_data, "BPressure_s", mean = 90, sd = 15)
```
