#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  path <- "."
} else if (length(args) == 1) {
  path <- args[1]
} else {
  stop("Expected at most 1 argument (directory with unit tests)")
}

testthat::test_dir(path)
