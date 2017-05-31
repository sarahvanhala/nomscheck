
age_years <- function(from, to) {
  from <- strftime(from, "%Y.%m%d")
  to <- strftime(to, "%Y.%m%d")
  floor(as.numeric(to) - as.numeric(from))
}

sim_discrete_exp <- function(n, zero_prob, mean) {
  zeros <- rbinom(n, size = 1, prob = 1 - zero_prob)
  pos_neg <- 2 * rbinom(n, size = 1, prob = 0.5) - 1
  exp_component <- ceiling(rexp(n, rate = 1 / mean))
  zeros * pos_neg * exp_component
}

