#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  path <- "."
} else if (length(args) == 1) {
  path <- args[1]
} else {
  stop("Expected at most 1 argument (directory to lint)")
}

setwd(path)

system(paste0(
  "uglifyjs ",
  paste0(
      list.files(path = "src/app/scripts",
      recursive = TRUE,
      full.names = TRUE,
      pattern = "\\.js$"),
    collapse = " "),
  " -o src/app/www/js/bundle.min.js")
)
