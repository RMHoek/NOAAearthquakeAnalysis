## function unite_YMD()
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

#' create single column data.frame with dates based on YMD data
#'
#' @description this function creates a data.frame with a single column containing
#' dates based on a data.frame containing three columns "YEAR", "MONTH", "DAY".
#'
#' @param YMD_frame a data.frame with three columns:
#' "YEAR" the year of the event
#' "MONTH" the month of the year of the event or NA
#' "DAY" the day of the month of the event or NA
#'
#' @return data.frame with single column containing DATE info in date format
#'
#' @note this function is for internal use
#' @note if Month or Day are NA they will be set to 1
#'
#' @examples
#' \dontrun{
#'     datesFrame <- naoo_data %>% dplyr::select(YEAR, MONTH, DAY)
#'     datesFrame <- unite_YMD(datesFrame)
#' }
#'
#' @importFrom lubridate as_date
#' @importFrom dplyr as_data_frame

unite_YMD <- function(YMD_frame){
    new_frame <- NULL
    for(i in 1:nrow(YMD_frame)){
        Year <- YMD_frame$YEAR[i]
        Month <- YMD_frame$MONTH[i]
        if(is.na(Month)) Month <- 1
        Day <- YMD_frame$DAY[i]
        if(is.na(Day)) Day <- 1
        if(Year<0){
            Date <- as_BC_date(Year, Month, Day) #internal function
        } else {
            Year <- as.character(Year)
            Month <- as.character(Month)
            Day <- as.character(Day)
            d <- paste(Year, Month, Day, sep = "/")
            Date <- lubridate::as_date(d)
        }
        new_frame <- c(new_frame, Date)
    }
    new_frame <- lubridate::as_date(new_frame)
    new_frame <- dplyr::as_data_frame(new_frame)
    names(new_frame) <- "DATE"
    return(new_frame)
}
