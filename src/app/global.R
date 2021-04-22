library(shiny)
library(shiny.fluent)
library(modules)
library(echarts4r)
library(config)
library(sass)
library(ggmap)

consts <- config::get(file = "constants/constants.yml")
options(shiny.autoreload = TRUE)
sass(
  sass::sass_file(consts$sass$input),
  cache = FALSE,
  options = sass_options(output_style = consts$sass$style),
  output = consts$sass$output
)

map <- use("modules/map.R")
DataManager <- use("logic/DataManager.R")$DataManager
