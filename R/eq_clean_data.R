## function eq_clean_data()
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

#' clean naoo data contained in data.frame
#'
#' @description this function expects a data.frame containing the columns
#' detailed below. It will create a dataframe containing
#' - a new \code{LOCATION} column containing the cleaned data from the
#' \code{LOCATION_NAME} column
#' - a new \code{DATE} column in date format from the YEAR, MONTH and DAY info
#' - latitude, longitude and all columns starting with TOTAL_* to numeric format
#'
#' @param df a data.frame containing columns named in note
#'
#' @note the columns are:
#' I_D: the ID of the event given by the naoo
#' FLAG_TSUNAMI: if the event gave rise to a tsunami
#' YEAR: the year of the event
#' MONTH: the month of the event
#' DAY: the day of the event
#' FOCAL_DEPTH: the depth of the event
#' EQ_PRIMARY: the size of the event oin the Richter scale
#' INTENSITY: the intensity of the event on the ... scale
#' COUNTRY: the country of the event
#' STATE: the state in the country of the event
#' LOCATION_NAME: the location description of the event
#' LATITUDE: the latitude of the event
#' LONGITUDE: the longitude of the event
#' TOTAL_DEATHS: total number of deaths from the event
#' TOTAL_MISSING: total number of missing from the event
#' TOTAL_INJURIES: total number of injured from the event
#' TOTAL_DAMAGE_MILLIONS_DOLLARS: total amount of damages from the event
#' TOTAL_HOUSES_DESTROYED: total number of houses destroyed by the event
#' TOTAL_HOUSES_DAMAGED: total number of houses damaged by the event
#'
#' @return data.frame containing the (reformatted) columns described above
#'
#' @examples
#' \dontrun{
#' library(readr)
#' #get earthquake data (tab-delimited txt file) from noaa website into a tibble
#' eq_data_file <- paste0("https://www.ngdc.noaa.gov/nndc/struts/",
#'                        "results?type_0=Exact&query_0=$ID&",
#'                        "t=101650&s=13&d=189&dfn=signif.txt")
#' eq_data <- readr::read_delim(eq_data_file, delim = "\t")
#' eq_data_clean <- eq_clean_data(eq_data)
#' }
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr select mutate
#' @export

eq_clean_data <- function(df){
    lnc <- df %>% dplyr::select(LOCATION_NAME)
    lnc <- eq_location_clean(lnc) #inteernal function
    datesFrame <- df %>% dplyr::select(YEAR, MONTH, DAY)
    datesFrame <- unite_YMD(datesFrame)
    Lat_Lon <- df %>% dplyr::select(LATITUDE, LONGITUDE) %>%
        dplyr::mutate(LATITUDE = as.numeric(LATITUDE)) %>%
        dplyr::mutate(LONGITUDE = as.numeric(LONGITUDE))
    df_pt1 <- df %>% dplyr::select(I_D, FLAG_TSUNAMI)
    df_pt2 <- df %>% dplyr::select(FOCAL_DEPTH, EQ_PRIMARY, INTENSITY,
                                   COUNTRY, STATE) %>%
        dplyr::mutate(FOCAL_DEPTH = as.numeric(FOCAL_DEPTH),
                      EQ_PRIMARY = as.numeric(EQ_PRIMARY))
    df_pt3 <- df %>% dplyr::select(TOTAL_DEATHS,
                                   TOTAL_MISSING,
                                   TOTAL_INJURIES,
                                   TOTAL_DAMAGE_MILLIONS_DOLLARS,
                                   TOTAL_HOUSES_DESTROYED,
                                   TOTAL_HOUSES_DAMAGED) %>%
        dplyr::mutate(TOTAL_DEATHS = as.numeric(TOTAL_DEATHS),
                      TOTAL_MISSING = as.numeric(TOTAL_MISSING),
                      TOTAL_DAMAGE_MILLIONS_DOLLARS =
                          as.numeric(TOTAL_DAMAGE_MILLIONS_DOLLARS),
                      TOTAL_HOUSES_DESTROYED = as.numeric(TOTAL_HOUSES_DESTROYED),
                      TOTAL_HOUSES_DAMAGED = as.numeric(TOTAL_HOUSES_DAMAGED))
    mod_df <- cbind(df_pt1, datesFrame, df_pt2, lnc, Lat_Lon, df_pt3)
    return(mod_df)
}
