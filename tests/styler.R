#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  path <- "."
} else if (length(args) == 1) {
  path <- args[1]
} else {
  stop("Expected at most 1 argument (directory to lint)")
}

# The exclusions parameter of `lint_dir` will only work properly if we first change to linted dir.
setwd(path)

# TODO: Lint only git-modified files to speed things up.
styler::style_dir(".")
