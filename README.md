# nomscheck: Check NOMs H-data 

Make sure you have the `devtools` package installed.

```
install.packages("devtools")
```


If you are working on a Windows computer, you may have to download and install [Rtools](https://cran.rstudio.com/bin/windows/Rtools/)

If you are working on a MAC computer, you may have to download and install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12)

To install the nomscheck package, use `install_github` in `devtools`, like as follows.

```
devtools::install_github("sarahvanhala/nomscheck")
```

To run the report, you will need to have the `rmarkdown` package installed.

```
install.packages("rmarkdown")
```

To save the prior assessments csv file and run the report with only newly entered clients, you would need to run the following:

```{r}
library(nomscheck)
noms_data <- read_noms_data(path)
save_prior_assessments(noms_data, output_file)
```
where path is the path to your datsest and output_file is the path you want to save the prior assessments to.
