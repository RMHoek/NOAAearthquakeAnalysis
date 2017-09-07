#' \code{NOAAearthquakeAnalysis} package
#'
#' See the README on
#' \href{https://github.com/RMHoek/NOAAearthquakeAnalysis#readme}{GitHub}
#'
#' @docType package
#' @name NOAAearthquakeAnalysis
#' @importFrom dplyr select mutate
#' @importFrom utils globalVariables
NULL

## to quiet concerns of 'R CMD check' re: the .'s that appear in pipes
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
