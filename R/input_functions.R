### Input Functions ###

#' Read the three input files and turns them into a object (list)
#' for further analysis
#'
#' @param path The location of the input files
#' @param test boolean if this is a test run or not
#'
#' @return a list containing the data frames from the imported csv files
#' @export
read_input_data <- function(path = "analysis/data/raw_data", test = FALSE) {
  signal_strength <- read_signal_strength(path)
  if(test) {signal_strength <- 0.3}
  return(
    list(
      population_pattern = read_black_death(path),
      n_dates = read_n_dates(path),
      signal_strength = signal_strength
    )
  )
}

read_black_death <- function(path) {
  read.csv(normalizePath(paste0(path, "/black_death.csv")))
}

read_n_dates <- function(path) {
  read.csv(normalizePath(paste0(path, "/n_dates.csv")),
           row.names = 1)[, 1]
}

read_signal_strength <- function(path) {
  read.csv(normalizePath(paste0(path, "/signal_strength.csv")),
           row.names = 1)[, 1]
}
