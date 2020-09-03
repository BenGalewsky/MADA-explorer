# MADA v2 Explorer
# Prototype v.0.0.9000
# Hung Nguyen (ntthung@gmail.com)

library(shiny)
library(data.table)
library(ggplot2)
library(RColorBrewer)

mada <- readRDS('data/mada2full.RDS')
countries <- sf::st_read('data/countries.gpkg', quiet = TRUE)
pasteLong <- function(x) {
  lest::case_when(x < 0   ~ paste0(-x, "\u00b0W"),
                  x > 180 ~ paste0(360 - x, "\u00b0W"),
                  x %in% c(0, 180)  ~ paste0(x, '\u00b0'),
                  TRUE ~ paste0(x, "\u00b0E"))
}

pasteLat <- function(x) {
  ifelse(x < 0, paste0(-x, "\u00b0S"), ifelse(x > 0, paste0(x, "\u00b0N"), paste0(x, '\u00b0')))
}

xRange <- range(mada$long) + c(-0.1, 0.1)
yRange <- range(mada$lat)  + c(-0.1, 0.1)

abs_range <- function(x) {
  absMax <- max(abs(range(x)))
  c(-absMax, absMax)
}
