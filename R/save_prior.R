#' Save a csv file of prior assessments
#'
#' Takes a previous SPARS download (.xls file) and produces a csv file of prior assessments. This csv is used to filter out previous assessments from the plots so that you only see newly entered data.
#'
#' @param noms_data Dataframe created by read_noms_data. This should be the PREVIOUS data set - NOT the dataset in which you are searching for errors.
#' @param path Where you want the csv file of prior assessments to be saved.
#' @return csv file containing prior assessments
#' @examples
#' save_prior_assessments(noms_data, "Desktop/prior_assessments.csv")
#' @export
save_prior_assessments <- function(noms_data, path) {
  noms_data %>%
    distinct(ConsumerID, Assessment, der_intake_seq_no) %>%
    write_csv(path)
}
