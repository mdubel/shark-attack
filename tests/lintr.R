#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  path <- "."
} else if (length(args) == 1) {
  path <- args[1]
} else {
  stop("Expected at most 1 argument (directory to lint)")
}

linters <- lintr::with_defaults(
  # Purposefully disabled linters:
  object_usage_linter = NULL, # Conflicts with standard usage of dplyr.
  camel_case_linter = NULL, # Conflicts with Shiny functions which are camelCase.
  commented_code_linter = NULL, # Commented code is useful in a template.
  # Enabled linters with custom arguments:
  open_curly_linter = lintr::open_curly_linter(allow_single_line = TRUE),
  closed_curly_linter = lintr::closed_curly_linter(allow_single_line = TRUE),
  line_length_linter = lintr::line_length_linter(140),
  object_length_linter = lintr::object_length_linter(40)
)

# TODO: Use .lintr files for exclusions instead. Currently they seem not to work with lint_dir().
exclusions <- c(
  "src/renv/activate.R" # Generated file
)

# The exclusions parameter of `lint_dir` will only work properly if we first change to linted dir.
setwd(path)

# TODO: Lint only git-modified files to speed things up.
lints <- lintr::lint_dir(".", linters = linters, exclusions = exclusions)
print(lints)
quit(status = length(lints) > 0)
