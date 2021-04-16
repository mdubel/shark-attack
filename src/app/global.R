library(shiny)
library(shiny.semantic)
library(modules)
library(config)
library(sass)

consts <- config::get(file = "constants/constants.yml")

sass(
  sass::sass_file(consts$sass$input),
  cache_options = sass_cache_options(FALSE),
  options = sass_options(output_style = consts$sass$style),
  output = consts$sass$output
)

# load isolated modules
# user_details <- use("modules/user_details.R")
home <- use("modules/home.R")
home$initialize(consts)
