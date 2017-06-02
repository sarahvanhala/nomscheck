# nomscheck: Check NOMs H-data 

Installation and Implementation Instructions

1. Download [R](https://www.r-project.org/).
2. Download the free version of [R-Studio](https://www.rstudio.com/products/rstudio/download2/).
3. Open R-Studio and make sure you have the `devtools` and `rmarkdown` packages installed (type the code below into the console).

```
install.packages("devtools")
install.packages("rmarkdown")
```

4. Windows users: You may have to download and install [Rtools](https://cran.rstudio.com/bin/windows/Rtools/)                                MAC users: You may have to download and install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12)

5. Install and load the nomscheck package.

```
devtools::install_github("sarahvanhala/nomscheck")
library(nomscheck)
```

6. Read in a previous SPARS download using noms_data.

```
noms_data <- read_noms_data("/Desktop/ExcelReport old.xls")
```

7. Create the prior_assessment_data csv using save_prior_assessments.

```
save_prior_assessments(noms_data, "/Desktop/prior_assessments.csv")
```

8. Click on File > New File > R Markdown > select from template > select NOMs checking report > OK.

9. Click on the arrow to the right of Knit > knit with parameters.

10. Save the code file. 

11. Enter the paths for the new NOMs data set and optionally for the csv of prior assessments.

12. Click Knit to create the report.

# Instructions on how to change the comparison distributions 

1. Determine the following for each variable:
  a. The probability that the variables will be zero
  b. The mean of the distribution of the variable
  c. The standard deviatio of the distribution of the variable

2. You will have to go into the code that is generated after step 8. above. To do this ctrl+f for compare_diff and add the zero_prob, mean, and sd parameters for each variable as such:

```
compare_diff(diff_data, "Weight", zero_prob = .3, mean = 10)
compare_dist(new_data, "BPressure_s", mean = 90, sd = 15)
```



 
