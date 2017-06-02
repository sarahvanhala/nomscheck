#' Calculate Differences
#'
#' Calculate differences in H-data between current and most previous assessment
#'
#' @param noms_data dataframe created by read_noms_data
#' @return Dataframe with a column of differences
#' @examples
#' calc_diffs(noms_data)
#' @export
calc_diffs <- function(noms_data) {
  noms_data %>%
    select(ConsumerID, Assessment, der_intake_seq_no, der_date,
           der_weight, der_height, der_bpressure_d, der_bpressure_s, der_waistcircum) %>%
    group_by(ConsumerID) %>%
    filter(der_intake_seq_no == max(der_intake_seq_no)) %>%
    ungroup %>%
    mutate_at(vars(der_weight, der_height, der_bpressure_d,
                   der_bpressure_s, der_waistcircum),
              funs(if_else(. < 0, NA_real_, .))) %>%
    group_by(ConsumerID) %>%
    arrange(ConsumerID, Assessment) %>%
    mutate_at(vars(der_weight, der_height, der_bpressure_d,
                   der_bpressure_s, der_waistcircum),
              funs(previous = lag(zoo::na.locf(., na.rm = FALSE)),
                   diff = . - lag(zoo::na.locf(., na.rm = FALSE)))) %>%
    ungroup %>%
    mutate(der_weight_waist = der_weight / der_waistcircum,
           der_weight_waist_previous = der_weight_previous / der_waistcircum_previous,
           der_weight_waist_diff = der_weight_waist - der_weight_waist_previous)
}

#' Compare Differences
#'
#' The purpose of this plot is to look for dramatic differences (which may indicate outliers) in the values of client-specific H-data values between the current and previous assessments.
#'
#' Simulates a comparison distribution and compares client-specific differences in H-data values between current and most previous assessment to the simulated distribution.
#'
#' If optional variables are not specified, the function will use a reference value.
#'
#' @param diffdata dataframe created by calc_diffs
#' @param var H-data variable of interest
#' @param zero_prob (optional) The probability of the difference in the variable of interest being zero
#' @param mean (optional) The mean of the absolute value of the non-zero part of the variable of interest. Note that for the waist circumference:weight ratio, the mean of the absolute value of the non-zero part is multiplied by 1,000
#' @param binwidth (optional) The binwidth of the plot
#' @return Histogram of simulated differences with lines indicating actual differences in H-data.
#' @examples
#' compare_diff(diffdata, var, zero_prob, mean, binwidth)
#' @export
compare_diff <- function(diffdata, var, zero_prob, mean, binwidth) {
  if (!(var %in% names(refdiff))) {
    stop("var must be one of the following: ", paste(names(refdiff), collapse = ", "))
  }
  if (missing(zero_prob)) {
    zero_prob <- refdiff[[var]][["zero_prob"]]
  }
  if (missing(mean)) {
    mean <- refdiff[[var]][["mean"]]
  }
  if (missing(binwidth)) {
    binwidth <- refdiff[[var]][["binwidth"]]
  }

  simdata <- tibble(x = sim_discrete_exp(1000, zero_prob = zero_prob, mean = mean))

  if (var == "Weight_Waist") {
    simdata <- simdata %>%
      mutate(x = x / 1000)
  }

  ggplot() +
    theme_minimal() +
    geom_histogram(data = simdata, aes(x = x), color = "grey35", fill = "grey35", binwidth = binwidth) +
    geom_vline(xintercept = diffdata[[paste0("der_", stringr::str_to_lower(var), "_diff")]],
               color = "red") +
    theme(axis.title = element_blank(), axis.ticks.y = element_blank(), axis.text.y = element_blank()) +
    ggtitle(paste("Difference in", var, "from prior assessment (for new values)"),
            subtitle = "Compared to reference distribution of differences")
}

