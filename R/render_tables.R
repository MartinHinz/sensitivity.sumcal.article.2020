render_orig_sim_result_table <- function(this_data) {
  n_samples <- as.numeric(rownames(this_data))
  sample_density <- n_samples / 700
  mean_perc_sig_detect <- rowMeans(this_data) * 100
  sd_perc_sig_detect <- apply(this_data, 1, sd) * 100
  inner_quartile_perc_sig_detect <- apply(this_data,
                                          1,
                                          quantile,
                                          c(.25, .75)
                                          ) %>%
    t() %>%
    round(digits = 3)

  inner_quartile_perc_sig_detect <- paste0(inner_quartile_perc_sig_detect[, 1],
                                           " \u2013 ",
                                           inner_quartile_perc_sig_detect[, 2])
  interval_95 <- apply(this_data,
                       1,
                       quantile, c(.025, .975)) %>%
    t() %>% round(digits = 3)

  interval_95 <- paste0(interval_95[, 1], " \u2013 ", interval_95[, 2])

  table_out <- tibble::tibble(
    "number of samples" = n_samples,
    "sample density (per years)" = sample_density %>% round(digits = 3),
    "mean proportion signal detected" = (mean_perc_sig_detect / 100) %>% round(digits = 3),
    "standard deviation proportion signal detected" =   (sd_perc_sig_detect / 100) %>% round(digits = 3),
    "inner quartiles" = inner_quartile_perc_sig_detect,
    "95% quantiles" = interval_95
  )

  return(make_knitr_table(table_out))
}
render_full_sim_result_table <- function(this_data) {
  n_samples <- as.numeric(rownames(this_data))
  d_samples <- (n_samples / 700) %>% round(digits = 3)
  out_table <- cbind(n_samples, d_samples, this_data)

  colnames(out_table)[1:2] <- c("number of samples", "sample density")

  return(make_knitr_table(out_table))
}

make_knitr_table <- function(table_out) {
  flextable::flextable(as.data.frame(table_out))
}
