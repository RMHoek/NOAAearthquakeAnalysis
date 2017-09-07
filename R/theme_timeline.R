## theme for timeline plots with geom_timeline
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

#' theme for timeline plotting with geom_timeline
#'
#' @description This theme can be added to the plot made by geom_timeline, it
#' only adds an x-axis and positions the legend to the bottom with a horizontal
#' direction
#'
#' @return theme
#'
#' @examples
#' \dontrun{
#' eq_data %>% eq_clean_data() %>%
#'    filter(COUNTRY %in% c("GREECE", "ITALY"), year(DATE) > 2000) %>%
#'    ggplot(aes(x = DATE,
#'                   y = COUNTRY,
#'                   color = TOTAL_DEATHS,
#'                   size = EQ_PRIMARY)) +
#'    geom_timeline() +
#'    geom_timeline_label(aes(label = LOCATION), n_max = 8) +
#'    theme_timeline() +
#'    scale_size(name = "Richter scale", limits = c(5, 8)) +
#'    scale_color_gradient(name = "# Deaths", low = "black", high = "blue")
#' }
#'
#' @importFrom ggplot2 theme element_blank element_line
#' @export


theme_timeline <- function() {
    ggplot2::theme(
        plot.background = ggplot2::element_blank(),
        panel.background = ggplot2::element_blank(),
        legend.key = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_blank(),
        axis.line.x = ggplot2::element_line(size = 0.5, linetype = 1),
        axis.ticks.y = ggplot2::element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal"
    )
}
