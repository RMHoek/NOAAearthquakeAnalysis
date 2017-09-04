## function eq_create_label()
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

#' Function to create popup_label text for interactive map
#'
#' @description This function creates labels for an interactive map using three
#' columns from a data.frame (the \code{data} variable). By default these are the
#' "LOCATION" (the \code{line_1} variable), "EQ_PRIMARY" (the \code{line_2}
#' variable) AND "TOTAL_DEATHS" (the \code{line_3} variable) columns. It will
#' omit all \code{NA} info from the label text, and returns a vector that can be
#' used as popuptext column in the data.frame as label text in the eq_map function.
#'
#' @param data a data.frame containing columns named:
#' "LOCATION" LOCATION info of earthquake events
#' "EQ_PRIMARY" size of earthquake events on Richter scale
#' "TOTAL_DEATHS" Total deaths info of earthquake events
#' @param line_1 the name of a column in \code{data}; by default "LOCATION"
#' @param line_2 the name of a column in \code{data}; by default "EQ_PRIMARY"
#' @param line_3 the name of a column in \code{data}; by default "TOTAL_DEATHS"
#'
#' @return character vector containing popup-text
#'
#' @examples
#' \dontrun{
#' # assuming earthquake data is in the file earthquakes.tvs.gz in the wd
#' readr::read_delim("earthquakes.tsv.gz", delim = "\t") %>%
#'     eq_clean_data() %>%
#'     dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#'     dplyr::mutate(popup_text = eq_create_label(.)) %>%
#'     eq_map(annot_col = "popup_text")#'
#' }
#'
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @export

eq_create_label <- function(data = NULL, line_1 = "LOCATION",
                            line_2 = "EQ_PRIMARY", line_3 = "TOTAL_DEATHS"){
    pu_text_col <- data %>%
        dplyr::mutate(popup_text = paste0(
            "<b>Location:</b> ", data[[line_1]], "<br/>",
            "<b>Magnitude:</b> ", data[[line_2]], "<br/>",
            "<b>Total deaths:</b> ", data[[line_3]], "<br/>")) %>%
        dplyr::select(popup_text)
    pu_text_col[["popup_text"]] <-
        sub("<b>Location:</b> NA<br/>", "", pu_text_col[["popup_text"]])
    pu_text_col[["popup_text"]] <-
        sub("<b>Magnitude:</b> NA<br/>", "", pu_text_col[["popup_text"]])
    pu_text_col[["popup_text"]] <-
        sub("<b>Total deaths:</b> NA<br/>", "", pu_text_col[["popup_text"]])
    return(as.vector(as.matrix(pu_text_col)))
}
