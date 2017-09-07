## function as_BC_date() to return dates BC
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

#' function to create date BC
#'
#' @description the lubridate as_date function doesn't handle dates BC correctly,
#' hence this function creates the BC date by first projecting the date as AD,
#' and then subtract from 0 AD.
#'
#' @return date as BC date
#'
#' @note this function is for internal use
#' @note the year can be passed as negative or positive, the function assumes
#' the user needs a BC date
#'
#' @examples
#' \dontrun{
#'    BCDate <- as_BC_date(-2150, 1, 1)
#' }
#'
#' @importFrom lubridate as_date

as_BC_date <- function(year, month = 1, day = 1){
    if(year < 0) year<-(-year)
    Y <- as.character(year)
    M <- as.character(month)
    D <- as.character(day)
    fwdY <- paste(Y, "1", "1", sep = "/")
    fwdYMD <- paste(Y, M, D, sep = "/")
    AD0 <- lubridate::as_date("0000/1/1") ##merry xmas!
    n_AD0 <- as.numeric(AD0)
    n_fwdY <- as.numeric(lubridate::as_date(fwdY))
    n_MD <- as.numeric(lubridate::as_date(fwdYMD)) -
        as.numeric(lubridate::as_date(fwdY))
    n_BC <- n_AD0 - (n_fwdY - n_AD0) + n_MD
    if(n_MD==0) n_BC <- n_BC + 1
    BC_date <- lubridate::as_date(n_BC)
    return(BC_date)
}
