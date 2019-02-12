#' Plot yearly Return
#'
#' This function plot yearly return
#'
#' @param R Return Data
#' @importFrom xts apply.yearly
#' @importFrom dplyr mutate
#' @importFrom tibble rownames_to_column
#' @importFrom tidyr gather
#' @importFrom lubridate year
#' @importFrom ggplot2 ggplot aes geom_bar ggtitle xlab ylab theme_bw
#' @importFrom ggplot2 scale_x_continuous theme element_text element_blank
#' @importFrom ggplot2 geom_text position_dodge geom_bar scale_x_continuous
#'
#' @examples
#'   R = asset_data
#'   plot_yearly(R)
#' @export

plot_yearly = function(R) {

  Date = key = value = NULL

  R = as.xts(R)
  R.yr = apply.yearly(R, Return.cumulative) %>%
    data.frame() %>%
    rownames_to_column(var = 'Date') %>%
    mutate(Date = year(Date)) %>%
    gather(key, value, -Date) %>%
    mutate(key = factor(key, levels = unique(key)))

  ggplot(R.yr, aes(x = Date, y = value, fill = factor(key))) +
    geom_bar(position = "dodge", stat = "identity") +
    ggtitle('Yearly Return') +
    xlab(NULL) +
    ylab(NULL) +
    theme_bw() +
    scale_x_continuous(breaks = R.yr$Date,
                       expand = c(0.01, 0.01)) +
    theme(plot.title = element_text(hjust = 0.5,
                                    size = 12),
          legend.position = 'bottom',
          legend.title = element_blank(),
          legend.text = element_text(size=7),
          axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
          panel.grid.minor.x = element_blank()
    ) +
    geom_text(aes(label = paste(round(value * 100, 2), "%"),
                  vjust = ifelse(value >= 0, -0.5, 1.5)),
              position = position_dodge(width = 1),
              size = 3)

}