

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

