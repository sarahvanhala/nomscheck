#' @import ggplot2
NULL

#' @export
compare_dist <- function(newdata, var, mean, sd, binwidth) {
  if (!(var %in% names(refdist))) {
    stop("var must be one of the following: ", paste(names(refdist), collapse = ", "))
  }
  if (missing(mean)) {
    mean <- refdist[[var]][["mean"]]
  }
  if (missing(sd)) {
    sd <- refdist[[var]][["sd"]]
  }
  if (missing(binwidth)) {
    binwidth <- refdist[[var]][["binwidth"]]
  }
  alpha <- mean ^ 2 / sd ^ 2
  beta <- sd ^ 2 / mean
  simdata <- tibble(x = rgamma(1000, shape = alpha, scale = beta))
  ggplot() +
    theme_minimal() +
    geom_histogram(data = simdata, aes(x = x), color = "grey35", fill = "grey35", binwidth = binwidth) +
    geom_vline(xintercept = newdata[[paste0("der_", stringr::str_to_lower(var))]], color = "red") +
    theme(axis.title = element_blank(), axis.ticks.y = element_blank(), axis.text.y = element_blank()) +
    ggtitle(paste("Distribution of new values of", var),
            subtitle = "Compared to reference distribution")
}

