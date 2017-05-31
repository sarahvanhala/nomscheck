
#' @export
save_prior_assessments <- function(noms_data, path) {
  noms_data %>%
    distinct(ConsumerID, Assessment, der_intake_seq_no) %>%
    write_csv(path)
}
