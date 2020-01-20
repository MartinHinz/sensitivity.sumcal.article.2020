### Simulation Functions ###

#' @keywords internal
make_the_simulations <- function(this_data, n_run, test=FALSE) {
  result <- list(orig_sim = simulate_original(this_data,
                                              n_run, test),
                 full_sim = simulate_full_range(this_data,
                                                n_run),
                 envelope_sim = simulate_with_envelope(this_data,
                                                       n_run,
                                                       reuse_existing = FALSE,
                                                       test),
                 envelope_orig_sim = simulate_orig_with_envelope(this_data,
                                                                 n_run, test))
  if(!test){
    write.csv(result$orig_sim,
              file = "analysis/data/derived_data/orig_sim.csv")
    write.csv(result$full_sim,
              file = "analysis/data/derived_data/full_sim.csv")
    write.csv(result$envelope_sim,
              file = "analysis/data/derived_data/envelope_sim.csv")
    write.csv(result$envelope_orig_sim,
              file = "analysis/data/derived_data/envelope_orig_sim.csv")

    saveRDS(result, file = "analysis/data/derived_data/result.rds")
  }
}

#' @keywords internal
simulate_orig_with_envelope <- function(this_data, n_run, test) {
  this_data$signal_strength <-
    this_data$population_series$y[this_data$population_series$x == 1410] /
    this_data$population_series$y[this_data$population_series$x == 1310]

  if(!test){
    this_data$n_dates <- c(this_data$n_dates, seq(3000, 6000, by = 1000))
  }

  simulate_with_envelope(this_data = this_data,
                         n_run = n_run,
                         reuse_existing = TRUE, test = test)
}

#' @keywords internal
simulate_with_envelope <- function(this_data, n_run, reuse_existing = FALSE, test=FALSE) {
  message("\n###### simulate_with_envelope ######\n")

  n_env <- 1000
  read.path <- "analysis/data/derived_data/conf_envelopes.rds"

  if (test) {
    n_env <- 10
    read.path <- "conf_envelopes.rds"
  }

  if (!reuse_existing){
    conf_envelopes <- make_conf_envelopes(this_data = this_data, n_env)

    saveRDS(conf_envelopes,
            file = normalizePath(read.path, mustWork = F))
  }

  conf_envelopes <-
    readRDS(file = normalizePath(read.path))

  do_simulate(this_data, n_run, conf_envelopes = conf_envelopes)
}

#' @keywords internal
make_conf_envelopes <- function(this_data, n_run = 1000) {
  # necessary to avoid problems in package check
  . <- NULL

  conf_envelopes <- list()
  for (n_dates in this_data$n_dates) {

    run_results <- foreach(i = 1:n_run, .combine = rbind) %do% {
      oxcalSumSim(
        n = n_dates,
        stds = sample(20:40, size = n_dates, replace = TRUE),
        timeframe_begin = min(this_data$population_series$x),
        timeframe_end = max(this_data$population_series$x),
        date_distribution = "uniform"
      )$raw_probabilities
    }

    envelope <- by(run_results,
                   run_results$dates,
                   function(x) quantile(x$probabilities,
                                        probs = c(0.025, 0.975)))

    conf_envelopes[[as.character(n_dates)]] <- envelope %>% do.call(rbind, .)
  }
  return(conf_envelopes)
}

#' @keywords internal
simulate_original <- function(this_data, n_run, test) {
  message("\n###### simulate_original ######\n")
  n_rep <- 200
  if(test) {
    message("\n###### This is a Test! ######\n")
    n_rep <- 2
  }
  original_setting <- this_data

  original_setting$signal_strength <-
    this_data$population_series$y[this_data$population_series$x == 1410] /
    this_data$population_series$y[this_data$population_series$x == 1310]

  collector <- rep(list(NA), n_rep)
  for (i in 1:n_rep) {
    collector[[i]] <- do_simulate(original_setting, n_run)
  }

  result <- do.call(cbind, collector)
  colnames(result) <- 1:n_rep
  return(result)
}

#' @keywords internal
simulate_full_range <- function(this_data, n_run) {
  message("\n###### simulate_full_range ######\n")
  do_simulate(this_data, n_run)
}

#' @keywords internal
do_simulate <- function(this_data, n_run, conf_envelopes = NULL) {
  pattern_found_collector <- matrix(nrow = length(this_data$n_dates),
                                    ncol = length(this_data$signal_strength))
  rownames(pattern_found_collector) <- this_data$n_dates
  colnames(pattern_found_collector) <- this_data$signal_strength

  chk <- Sys.getenv("_R_CHECK_LIMIT_CORES_", "")

  if (nzchar(chk) && chk == "TRUE") {
    # use 2 cores in CRAN/Travis/devtools::check()
    cores <- 2L
  } else {
    # use all cores - 2 as standard and in devtools::test()
    cores <- parallel::detectCores() - 2
  }

  for (n_date in this_data$n_dates) {
    message(paste0("\n###### simulating ", n_date, " dates ######\n"))

    for (signal_strength in this_data$signal_strength) {
      message(paste0("\n###### simulating ",
                     signal_strength,
                     " signal_strength ######\n"))

      pattern_found <- 0

      # setting some random seeds randomly
      # otherwise all parallel streams will have the same result
      r_seeds <- sample(1:1000, n_run, replace = T)

      # setup parallel backend to use many processors,
      # still not to overload your computer
      cl <- parallel::makeForkCluster(cores[1])

      doParallel::registerDoParallel(cl)

      # necessary to avoid problems in package check
      i <- NULL

      pattern_found <- foreach(i = 1:n_run, .combine = "+") %dopar% {
        set.seed(r_seeds[i])

        sum_cal_result <- simulate_dates(this_data, n_date, signal_strength) %>%
          sum_calibrate_simulated_dates() %>%
          smooth_sumcal_result(1)
        detect_pattern(sum_cal_result, conf_envelopes[[as.character(n_date)]])
      }

      parallel::stopCluster(cl)

      pattern_found_collector[as.character(n_date),
                              as.character(signal_strength)] <-
        pattern_found / n_run
    }
  }
  return(pattern_found_collector)
}

#' Detects a population pattern in given result from a sum calibration.
#'
#' @param sum_cal_result the sum calibration result
#' @param conf_envelope optional a confindence envelope
#'
#' @return true or false if a pattern was detected or not
#' @export
detect_pattern <- function(sum_cal_result, conf_envelope = NULL) {

  # necessary to avoid problems in package check
  dates <- . <- probabilities <- NULL

  threshold <- 0.1

  target_range <- subset(sum_cal_result, dates > 1210 & dates <= 1630)

  minimum <- target_range %>% .$probabilities %>%
    get_local_minima() %>%
    target_range[., ]

  if (!(nrow(minimum) > 0)) return(FALSE)

  minimum <- subset(minimum, probabilities == min(minimum$probabilities))

  older <- subset(sum_cal_result, dates > 1260 - 50 & dates <= 1260 + 50)

  younger <- subset(sum_cal_result, dates > 1580 - 50 & dates <= 1580 + 50)

  if (!(minimum$dates > 1310 & minimum$dates < 1530)) return(FALSE)

  if (1 - minimum$probabilities / mean(older$probabilities) < threshold)
    return(FALSE)

  if (1 - minimum$probabilities / mean(younger$probabilities) < threshold)
    return(FALSE)

  if (!is.null(conf_envelope)) {
    this_envelope_min <-
      conf_envelope[as.character(round(minimum$dates / 5) * 5 + .5), ] * 5

    if (this_envelope_min[1] < minimum$probabilities) {
      return(FALSE)
    }
  }

  return(TRUE)
}

#' Smooths the result of a sum calibration with a moving average in a given window
#'
#' @param x The result of a sum calibration
#' @param window_size The size of the window of the moving average
#'
#' @return a smoothed sum calibration result
#' @export
smooth_sumcal_result <- function(x, window_size) {
  x$probabilities <- moving_average(x$probabilities / sum(x$probabilities),
                                    n = window_size) %>%
    as.vector

  return(x)
}

#' @keywords internal
moving_average <- function(x, n = 5){
  filter(x, rep(1 / n, n), sides = 2)
}

#' Samples a number of calendar dates from a given population (probability)
#' distribution according to a given signal strength.
#'
#' @param this_data The input data set
#' @param n_date The number of calendar dates to be sampled
#' @param signal_strength The signal strength of the pattern
#'
#' @return A list of calendar dates with a density according
#' to the population (probability) distribution.
#'
#' @export
simulate_dates <- function(this_data, n_date, signal_strength) {
  this_population <- rescale_population(this_data$population_series,
                                        signal_strength)

  this_dates <- sample(this_population$x,
                       n_date,
                       replace = T,
                       prob = this_population$y)

  return(this_dates)
}

#' @keywords internal
rescale_population <- function(this_population, signal_strength) {
  pattern_begin_loc <- which(this_population$x == 1310)
  pattern_max_loc <- which(this_population$x == 1410)
  pattern_end_loc <- which(this_population$x == 1440)
  max_o <- max_n <- this_population$y[pattern_begin_loc]
  min_n <- signal_strength * this_population$y[pattern_begin_loc]
  min_o <- this_population$y[pattern_max_loc]
  result <- this_population
  result$y[pattern_begin_loc:pattern_end_loc] <-
    (max_n - min_n) / (max_o - min_o) *
    (result$y[pattern_begin_loc:pattern_end_loc] - max_o) +
    max_n

  result$y <- result$y / sum(result$y)

  return(result)
}

#' Creates a sum calibration from a number of dates with OxCals C_Simulate function
#'
#' @param this_dates A number of calendar dates
#'
#' @return The result of the sum calibration
#' @export
sum_calibrate_simulated_dates <- function(this_dates){

  this_dates_code <- paste("C_Simulate(AD(", this_dates, "), ",
                           sample(20:40,
                                  size = length(this_dates),
                                  replace = TRUE),
                           ");",
                           collapse = "")

  this_sum_code <- oxcAAR::oxcal_Sum(this_dates_code)
  sum_cal_result_file <- this_sum_code %>%
    executeOxcalScript()

  sum_cal_result <- readOxcalOutput(sum_cal_result_file) %>%
    parseOxcalOutput(only.R_Date = FALSE, first = TRUE)

  oxcAAR:::cleanupOxcalFiles(sum_cal_result_file)

  return(sum_cal_result$` Sum `$raw_probabilities)
}

#' @keywords internal
get_local_minima <- function(x) {
  which(diff(sign(diff(x))) == 2) + 1
}

#' @keywords internal
get_local_maxima <- function(x) {
  which(diff(sign(diff(x))) == -2) + 1
}
