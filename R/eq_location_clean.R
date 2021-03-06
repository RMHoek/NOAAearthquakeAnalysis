## function eq_location_clean()
## Copyright (C) 2017 by RM Hoek
## assignment Capstone project Coursera course 'MSDR'
## This function is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.

## This function is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.

## This package contains copy of the GNU General Public License.
## If you can not find it, please see <http://www.gnu.org/licenses/>.

#' Function to clean the location info in noaa earthquake data set
#'
#' @description This function cleans the info in the original NOAA data.frame
#' column "LOCATION_NAME", stripping redundant info like country name and
#' secundary location descriptions. It returns a single column data.frame with
#' the location text.
#'
#' @param raw_location a single column data.frame containing the LOCATION_NAME
#' column from the naoo dataset
#'
#' @return data.frame containing cleaned location data in one column
#'
#' @note this function is for internal use
#'
#' @examples
#' \dontrun{
#' locNameClean <- eq_location_clean(naoo_data$LOCATION_NAME)
#' }
#'
#' @importFrom stringr str_split str_to_title
#' @importFrom dplyr as_data_frame
#' @importFrom utils tail


eq_location_clean <- function(raw_location){
    raw_location <- as.vector(as.matrix(raw_location))
    clntxt <- stringr::str_split(raw_location, ";")
    clntxt <- sapply(clntxt, "[[", 1)
    clntxt <- stringr::str_split(clntxt, ": ")
    clntxt <- lapply(clntxt, utils::tail, n=1L)
    clntxt <- lapply(clntxt, stringr::str_to_title)
    clntxt <- unlist(clntxt)
    clntxt <- dplyr::as_data_frame(clntxt)
    names(clntxt) <- "LOCATION"
    return(clntxt)
}
