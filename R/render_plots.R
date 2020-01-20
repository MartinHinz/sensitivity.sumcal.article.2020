render_orig_sim_result_boxplot <- function(this_data) {

  # necessary to avoid problems in package check
  nsamples <- p_signal_detected <- NULL

  this_data_for_plot <- melt(this_data)
  colnames(this_data_for_plot) <- c("nsamples", "run", "p_signal_detected")
  this_data_for_plot$nsamples <- factor(this_data_for_plot$nsamples)

  ggplot(this_data_for_plot,
         aes(x = nsamples,
             y = p_signal_detected)
         ) +
    geom_boxplot() +
    xlab("number of samples") +
    ylab("percent signal detected") + theme_Publication()
}

render_orig_sim_result_regression <- function(this_data) {

  # necessary to avoid problems in package check
  nsamples <- p_signal_detected <- NULL

  this_data_for_plot <- melt(this_data)
  colnames(this_data_for_plot) <- c("nsamples", "run", "p_signal_detected")

  ggplot(this_data_for_plot,
         aes(x = nsamples,
             y = p_signal_detected)
  ) +
    geom_jitter(alpha = 0.5) +
    geom_smooth() +
    xlab("number of samples (log scale)") +
    ylab("percent signal detected") + theme_Publication() + scale_x_log10()
}

render_full_sim_result_regression <- function(this_data) {

  # necessary to avoid problems in package check
  nsamples <- p_signal_detected <- signal_strength <- NULL

  this_data_for_plot <- melt(this_data)
  colnames(this_data_for_plot) <- c("nsamples",
                                    "signal_strength",
                                    "p_signal_detected")
  this_data_for_plot$signal_strength <-
    factor(this_data_for_plot$signal_strength)

  ggplot(this_data_for_plot,
         aes(x = nsamples,
             y = p_signal_detected,
             colour = signal_strength)
  ) +
    geom_point() +
    geom_line() +
    xlab("number of samples (log scale)") +
    ylab("percent signal detected") + theme_Publication() + scale_x_log10()
}

theme_Publication <- function(base_size=12, base_family="helvetica") {
  (ggthemes::theme_foundation(base_size = base_size)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1.2), hjust = 0.5),
            text = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold", size = rel(1)),
            axis.title.y = element_text(angle = 90, vjust = 2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(),
            axis.line = element_line(colour = "black"),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour = "#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.key = element_rect(colour = NA),
            legend.position = "bottom",
            legend.direction = "horizontal",
            legend.key.size = unit(0.2, "cm"),
            legend.margin = unit(0, "cm"),
            legend.title = element_text(face = "italic"),
            plot.margin = unit(c(10, 5, 5, 5), "mm"),
            strip.background = element_rect(colour = "#f0f0f0",
                                            fill = "#f0f0f0"),
            strip.text = element_text(face = "bold")
    ))

}

scale_fill_Publication <- function(...){
  discrete_scale("fill",
                 "Publication",
                 manual_pal(values = c("#386cb0",
                                       "#fdb462",
                                       "#7fc97f",
                                       "#ef3b2c",
                                       "#662506",
                                       "#a6cee3",
                                       "#fb9a99",
                                       "#984ea3",
                                       "#ffff33")),
                 ...)

}

scale_colour_Publication <- function(...){
  discrete_scale("colour", "Publication", manual_pal(values = c("#386cb0",
                                                                "#fdb462",
                                                                "#7fc97f",
                                                                "#ef3b2c",
                                                                "#662506",
                                                                "#a6cee3",
                                                                "#fb9a99",
                                                                "#984ea3",
                                                                "#ffff33")),
                 ...)

}
