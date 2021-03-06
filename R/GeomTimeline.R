## geom_timeline
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

#' Create a timeline diagram
#'
#' @description This geom plots a timeline of dates (requires \code{x} date
#' aesthetics) in one or more lines (depending on optional \code{y} aesthetics
#' to group data by selected variable). Furthermore size and colour can be
#' linked to numeric variables.
#'
#' @param xmin A date. If used the plot will start from this date
#' @param xmax A date. If used the plot will end at this date
#' @inheritParams ggplot2::geom_point
#' @note required_aes x date of data points to be plotted
#' @note default_aes y, size, colour with y=0.1, size=3, colour="grey"
#'
#' @return Grob representing timeline(s) and datapoints
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
#' @importFrom ggplot2 layer
#' @export

geom_timeline <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", ..., na.rm = FALSE,
                          xmin = NULL, xmax = NULL, show.legend = NA,
                          inherit.aes = TRUE) {
    ggplot2::layer(
        geom = GeomTimeline,
        mapping = mapping,
        data = data,
        stat = stat,
        position = position,
        show.legend = show.legend,
        inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, xmin = xmin, xmax = xmax, ...)
    )
}

#' ggproto class for geom_timeline
#'
#' for internal use
#'
#' @importFrom ggplot2 ggproto Geom aes draw_key_point
#' @importFrom grid polylineGrob unit gpar pointsGrob gList
#' @importFrom dplyr filter
#' @importFrom magrittr %>%
#' @importFrom scales alpha


GeomTimeline <- ggplot2::ggproto(
    "GeomTimeline", ggplot2::Geom,
    required_aes = c("x"),
    default_aes = ggplot2::aes(y = 0.1, size = 3, colour = "grey",
                               fill = "grey", alpha = 0.6,
                               shape = 21, stroke = 0.5),
    draw_key = ggplot2::draw_key_point,
    setup_data = function(data, params) {
        if(!is.null(params$xmin)) {
            data <- data %>%
                dplyr::filter(data$x >= params$xmin)
        }
        if(!is.null(params$xmax)) {
            data <- data %>%
                dplyr::filter(data$x <= params$xmax)
        }
        data
    },
    draw_panel = function(data, panel_scales, coord, xmin, xmax){
        # if no points in data, return nullGrob
        if (nrow(data) == 0) return(nullGrob())
        # if 'y' coordinate not defined, add default
        if (!("y" %in% colnames(data))) {
            data$y <- 0.1
        }
        #transform data
        coords <- coord$transform(data, panel_scales)
        #construct grobs for timeline(s) and datapoints
        ypos <- unique(coords$y)
        ylines <- grid::polylineGrob(
            x = grid::unit(rep(c(0, 1), each = length(ypos)), "npc"),
            y = grid::unit(c(ypos, ypos), "npc"),
            id = rep(seq_along(ypos), 2),
            gp = grid::gpar(
                col = scales::alpha("lightgrey", alpha = 0.8),
                lwd = 0.5))
        dpoints <- grid::pointsGrob(
            x = coords$x,
            y = coords$y,
            pch = coords$shape,
            size = grid::unit(coords$size / 4, "char"),
            gp = grid::gpar(
                col = scales::alpha(coords$colour, coords$alpha),
                fill = scales::alpha(coords$colour, coords$alpha)))

        # return combined ylines and dpoints grobs
        grid::gList(ylines, dpoints)
    })
