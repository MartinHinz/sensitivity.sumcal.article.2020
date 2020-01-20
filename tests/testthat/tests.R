context("General (Dummy) Test")

test_that("run_analysis runs proper", {
  expect_error(
    {run_analysis(n_run = n_run, test = TRUE)},
    NA)
})

result <- readRDS(system.file("testdata", "result.rds", package = "sensitivity.sumcal.article.2020"))

test_that("render_tables runs proper", {
  expect_error(
    {render_orig_sim_result_table(result$orig_sim)},
    NA)
  expect_error(
    {render_full_sim_result_table(result$full_sim)},
    NA)
})

test_that("render_plots runs proper", {
  expect_error(
    {render_orig_sim_result_boxplot(result$orig_sim)},
    NA)
  expect_error(
    {render_orig_sim_result_regression(result$orig_sim)},
    NA)
  expect_error(
    {render_full_sim_result_regression(result$full_sim)},
    NA)
})
