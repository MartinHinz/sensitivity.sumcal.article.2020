context("General (Dummy) Test")

test_that("run_analysis runs proper", {
  expect_error(
    {n_run <- 2
    path <- system.file("testdata", package = "sensitivity.sumcal.article.2020")
    #stop(path)
    set_up_environment()
    this_data <- read_input_data(path, test = TRUE) %>%
      prepare_data() %>%
      make_the_simulations(n_run = n_run, test = TRUE)},
    NA)
})
