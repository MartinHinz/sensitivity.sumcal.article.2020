context("General (Dummy) Test")

test_that("run_analysis runs proper", {
  expect_error(
    {run_analysis(n_run = n_run, test = TRUE)},
    NA)
})

test_that("run_analysis runs proper", {
  result <- readRDS(system.file("testdata", "result.rds", package = "sensitivity.sumcal.article.2020"))
  expect_error(
    {render_orig_sim_result_table(result$orig_sim)},
    NA)
  expect_error(
    {render_full_sim_result_table(result$full_sim)},
    NA)
})
