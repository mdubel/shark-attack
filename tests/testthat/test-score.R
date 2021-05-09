library(modules)
library(R6)
library(magrittr)

setwd("../../src/app")
ScoreManager <- use("logic/ScoreManager.R")$ScoreManager

# To be able to test private functions from class.
ScoreManagerTester <- R6Class(
  "ScoreManagerTester",
  inherit = ScoreManager,
  public = list(
    get_private = function() private
  )
)
score_manager_tester <- ScoreManagerTester$new()

context("Application score logic")

test_that("Get scores is a list will current and max values", {
  expect_length(score_manager_tester$get_scores("easy"), 4)
})

test_that("Get scores returns empty list for null level", {
  expect_equal(score_manager_tester$get_scores(NULL), list())
})
