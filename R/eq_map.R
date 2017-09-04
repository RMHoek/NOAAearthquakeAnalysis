## function to get interactive map
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

#' Function to create interactive map
#'
#' @description This function creates an interactive map using a data.frame with
#' columns "LATITUDE", LONGITUDE" for marker position and "EQ_PRIMARY" for marker
#' size. Furthermore, the function creates popup_info labels based on the
#' \code{annot_col} column present in the data.frame. It returns an interactive
#' map with popup-text annotations.
#'
#' @param data a data.frame containing columns named:
#' LATITUDE: latitude info of earthquake events
#' LONGITUDE: longitude info of earthquake events
#' EQ_PRIMARY: size of earthquake event on Richter scale
#' @param annot_col the name of a column present in \code{data} to be used as
#' annotation text in the interactive map
#'
#' @return leaflet interactive map
#'
#' @examples
#' \dontrun{
#' # assuming earthquake data is in the file earthquakes.tvs.gz in the wd
#' readr::read_delim("earthquakes.tsv.gz", delim = "\t") %>%
#'     eq_clean_data() %>%
#'     dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#'     eq_map(annot_col = "DATE")
#' }
#'
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#' @importFrom leaflet leaflet addProviderTiles addCircleMarkers
#' @export

eq_map <- function(data = NULL, annot_col = "DATE"){
    data <- data %>%
        dplyr::mutate(popup_info = data[[annot_col]]) %>%
        dplyr::mutate(marker_radius = EQ_PRIMARY)
    ## for interactive map use leaflet with marker radius = richter scale
    IA_map <- data %>% leaflet::leaflet() %>%
        leaflet::addProviderTiles("Esri.OceanBasemap") %>%
        leaflet::addCircleMarkers(radius = ~ marker_radius, lng= ~ LONGITUDE,
                         lat= ~ LATITUDE, popup = ~ popup_info,
                         color = "Red", weight = 1)
    return(IA_map)
    }
