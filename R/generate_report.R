#' Generate Report
#'
#' @param noms_data_path Path to data created by read_noms_data.
#' @param prior_assessments_path (optional) Path to the csv file of prior assessments.
#' @param output_file Where you want the report to be saved.
#' @return Report
#' @examples
#' generate_noms_report("Desktop/new_noms_data.xls", "Desktop/prior_assessments.csv", "Desktop/report.html")

#' @export
generate_noms_report <- function(noms_data_path, prior_assessments_path,
                                 output_file = "noms_check_report.html",
                                 output_dir = getwd(), intermediates_dir = getwd(),
                                 knit_root_dir = getwd(), ...) {
  if (missing(prior_assessments_path)) prior_assessments_path <- ""
  rmd_path <- system.file("rmarkdown/templates/noms_check/skeleton/skeleton.Rmd", package = "nomscheck")
  rmarkdown::render(
    input = rmd_path,
    output_dir = output_dir,
    output_file = output_file,
    intermediates_dir = intermediates_dir,
    knit_root_dir = knit_root_dir,
    params = list(
      noms_data_path = noms_data_path,
      prior_assessments_path = prior_assessments_path
    ),
    ...
  )
}

