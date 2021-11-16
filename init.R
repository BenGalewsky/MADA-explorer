# MADA v2 Explorer
# Prototype v.0.0.0.9001
# Hung Nguyen (ntthung@gmail.com)

library(shiny)
library(data.table)
library(ggplot2)
library(RColorBrewer)
library(cowplot)
library(patchwork)

madaVN <- readRDS('data/mada-vn.RDS')
recVN <- readRDS('data/recVNFull.RDS')
vn <- sf::st_read('data/vn-boundary.gpkg', quiet = TRUE)

paste_long <- function(x) {
  fcase(x < 0, paste0(-x, "\u00b0W"),
        x > 180, paste0(360 - x, "\u00b0W"),
        x %in% c(0, 180), paste0(x, '\u00b0'),
        default = paste0(x, "\u00b0E"))
}

paste_lat <- function(x) {
  ifelse(x < 0, paste0(-x, "\u00b0S"), ifelse(x > 0, paste0(x, "\u00b0N"), paste0(x, '\u00b0')))
}

abs_range <- function(x) {
  absMax <- max(abs(range(x)))
  c(-absMax, absMax)
}
