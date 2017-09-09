## geom_timeline_label
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

#' Create labels for a timeline diagram
#'
#' @description This geom creates labels for a timeline plot using dates
#' (requires \code{x} aesthetics), and the label text (requires \code{label}
#' aesthetics) with optional maximal number of labels (depending on optional
#' \code{n_max} aesthetics) of the largest events by size param in geom_timeline.
#'
#' @param n_max An integer. If used, it only plots the labels for the
#' \code{n_max} largest earthquakes in the selected group in the timeline
#' @param xmin A date. If used the plot will start from this date
#' @param xmax A date. If used the plot will end at this date
#' @inheritParams ggplot2::geom_text
#' @note required_aes x, label with x the date of data points plotted and label
#' the variable containing the label text
#'
#' @return Grob representing labels for timeline(s) with datapoints
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


geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "identity",
                                position = "identity", ..., na.rm = FALSE,
                                n_max = NULL, xmin = NULL, xmax = NULL,
                                show.legend = NA, inherit.aes = TRUE) {
    ggplot2::layer(
        geom = GeomTimelineLabel, mapping = mapping,
        data = data, stat = stat, position = position,
        show.legend = show.legend, inherit.aes = inherit.aes,
        params = list(na.rm = na.rm, n_max = n_max, xmin = xmin,
                      xmax = xmax, ...)
    )
}

#' ggproto class for geom_timeline_label
#'
#' for internal use
#'
#' @importFrom ggplot2 ggproto Geom draw_key_blank
#' @importFrom dplyr group_by_ top_n ungroup
#' @importFrom magrittr %>%
#' @importFrom grid polylineGrob unit gpar textGrob gList

GeomTimelineLabel <-
    ggplot2::ggproto(
        "GeomTimelineLabel", ggplot2::Geom,
        required_aes = c("x", "label"),
        draw_key = ggplot2::draw_key_blank,
        setup_data = function(data, params) {
            if(!is.null(params$xmin)) {
                data <- data %>%
                    dplyr::filter(data$x >= params$xmin)
            }
            if(!is.null(params$xmax)) {
                data <- data %>%
                    dplyr::filter(data$x <= params$xmax)
            }
            if (!is.null(params$n_max)) {
                if (!("size" %in% colnames(data))) {
                    stop(paste("The 'size' aesthetics is required if",
                               "the 'n_max' aesthetics is defined."))
                }

                data <- data %>%
                    dplyr::group_by_("group") %>%
                    dplyr::top_n(params$n_max, size) %>%
                    dplyr::ungroup()
            }
            data
        },
        draw_panel = function(data, panel_scales, coord, n_max, xmin, xmax) {

            if (!("y" %in% colnames(data))) {
                data$y <- 0.1
            }

            coords <- coord$transform(data, panel_scales)
            n_grp <- length(unique(data$group))
            offset <- 0.1 / n_grp
            lines <- grid::polylineGrob(
                x = grid::unit(c(coords$x, coords$x), "npc"),
                y = grid::unit(c(coords$y, coords$y + offset), "npc"),
                id = rep(1:dim(coords)[1], 2),
                gp = grid::gpar(
                    col = "lightgrey",
                    alpha = 0.6,
                    lwd = .pt)
            )

            names <- grid::textGrob(
                label = coords$label,
                x = grid::unit(coords$x, "npc"),
                y = grid::unit(coords$y + offset, "npc"),
                just = c("left", "bottom"),
                rot = 45,
                gp = grid::gpar(fontsize = 10)
            )

            grid::gList(lines, names)
        }
    )
