### Data Preparation Functions ###

#' Turns the input data into a probability distribution and hands this and
#' other parameters to further analysis
#'
#' @param this_data the raw population estimate data
#'
#' @return a list containing the number of dates and the signal strengths
#' from the input data, and a probability distribution derived from the population data
#'
#' @export
prepare_data <- function(this_data) {
  population_series <- make_population_series(this_data$population_pattern)
  return(list(
    population_series = population_series,
    n_dates = this_data$n_dates,
    signal_strength = this_data$signal_strength
  ))

}

range_to_seq <- function(x) {
  return(x[1]:x[2])
}

make_population_series <- function(x) {
  # necessary to avoid problems in package check
  . <- NULL

  population_series <- range(x[, 1]) %>%
    round(-2) %>%
    range_to_seq() %>%
    approx(x = x[, 1], y = x[, 2], xout = ., rule = 2) %>%
    data.frame %>%
    na.omit

  rownames(population_series) <- population_series$x
  population_series$y <- population_series$y / sum(population_series$y)

  return(population_series)
}
