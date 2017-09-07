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
utils::globalVariables(c("COUNTRY", "DAY", "EQ_PRIMARY", "FLAG_TSUNAMI",
                         "FOCAL_DEPTH", "INTENSITY I_D", "LATITUDE",
                         "LOCATION_NAME", "LONGITUDE", "MONTH", "STATE",
                         "TOTAL_DAMAGE_MILLIONS_DOLLARS", "TOTAL_DEATHS",
                         "TOTAL_HOUSES_DAMAGED", "TOTAL_HOUSES_DESTROYED",
                         "TOTAL_INJURIES", "TOTAL_MISSING", "YEAR",
                         "popup_text"))
