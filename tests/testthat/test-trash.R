library(modules)
library(R6)
library(magrittr)

setwd("../../src/app")
TrashManager <- use("logic/TrashManager.R")$TrashManager

# To be able to test private functions from class.
TrashManagerTester <- R6Class(
  "TrashManagerTester",
  inherit = TrashManager,
  public = list(
    get_private = function() private
  )
)
trash_manager_tester <- TrashManagerTester$new()

context("Application trash logic")

test_that("Random trash returns one of the trash from the list", {
  expect_true(trash_manager_tester$get_private()$random_trash() %in% names(trash_manager_tester$trash))
})
