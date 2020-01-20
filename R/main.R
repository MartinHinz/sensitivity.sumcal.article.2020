
#' Run the simulation analysis
#'
#' \code{run_analysis} runs the simulations of sensitivity of radiocarbon sum calibration
#' to the factors intensity of the signal and number of samples.
#'
#' The input data are taken from three csv files in analysis/raw_data.
#'
#' \itemize{
#'   \item black_death.csv: Population pattern of the Black Death after
#'   Contreras and Meadows (2014)
#'   \item n_dates.csv: number of samples to be simulated
#'   \item signal_strength.csv: Signal strengths to be simulated
#'}
#'
#' The output is generated in analysis/data/derived_data. The results represent
#' detection rates at different signal strengths. The file result.rds
#' contains the an object (list) with all the results from the simulation.
#' The individual results can also be taken from 4 csv files:
#' \itemize{
#'   \item orig_sim.csv: the results according to the original scenario
#'   (signal strength) of Contreras and Meadows (2014). Each column
#'   represents one simulation run.
#'   \item full_sim.csv: the results with variable signal strenghts.
#'   Each column represents a different signal strength.
#'   \item envelope_orig_sim.csv & envelope_sim.csv: The same as above,
#'   but including a check for false positive results using Monte Carlo
#'   estimation of a confidence hull.
#'}
#'
#' For details please consult the related paper.
#'
#' @param n_run The number of simulation repetitions
#' @param test A boolean parameter if it is a test run
#'
#' @references
#' \insertRef{hinz_sensitivity_nodate}{sensitivity.sumcal.article.2020}
#'
#' \insertRef{contreras_summed_2014}{sensitivity.sumcal.article.2020}
#'
#' @importFrom Rdpack reprompt
#'
#' @export
run_analysis <- function(n_run = 200, test=FALSE) {
  path <- getwd()
  system.time({
    if (test) {
      n_run <- 2
      path <- system.file("testdata", package = "sensitivity.sumcal.article.2020")
      
    }
  set_up_environment()
  this_data <- read_input_data(path = path, test = test) %>%
    prepare_data() %>%
    make_the_simulations(n_run = n_run, test=test)
  })
}
