# nomscheck: Check NOMs H-data 

Installation Instructions

1. Download [R](https://www.r-project.org/)
2. Download the free versio of [R-Studio](https://www.rstudio.com/products/rstudio/download2/)
3. Open R-Studio and make sure you have the `devtools` package installed (type the code below into the console).

```
install.packages("devtools")
```

4. Windows users: You may have to download and install [Rtools](https://cran.rstudio.com/bin/windows/Rtools/)                                MAC users: You may have to download and install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12)

5. To install the nomscheck package, use `install_github` in `devtools`, as follows.

```
devtools::install_github("sarahvanhala/nomscheck")
```

6. To run the report, you will need to have the `rmarkdown` package installed.

```
install.packages("rmarkdown")
```

7. To save the prior assessments csv file and run the report with only newly entered clients, you would need to run the following code where path is the path to your datsest and output_file is the path you want to save the prior assessments to.

```{r}
library(nomscheck)
noms_data <- read_noms_data(path)
save_prior_assessments(noms_data, output_file)
```

8. 
