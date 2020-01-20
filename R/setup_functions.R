### Input Functions ###

#' Prepares the environment for further analysis by loading
#' and initialising necessary packages
#'
#' @return NULL
#' @export
set_up_environment <- function(){
  requireNamespace("magrittr")
  requireNamespace("foreach")
  requireNamespace("doParallel")
  requireNamespace("oxcAAR")
  oxcAAR::quickSetupOxcal()
  requireNamespace("ggplot2")
  requireNamespace("reshape2")
  requireNamespace("broom")
  requireNamespace("ggthemes")
  requireNamespace("grid")
  requireNamespace("scales")
}
