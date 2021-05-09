library(modules)
library(R6)
library(magrittr)

setwd("../../src/app")
GridManager <- use("logic/GridManager.R")$GridManager

# To be able to test private functions from class.
GridManagerTester <- R6Class(
  "GridManagerTester",
  inherit = GridManager,
  public = list(
    get_private = function() private
  )
)
grid_manager_tester <- GridManagerTester$new()

context("Application grid logic")

test_that("Single grid element has correct class", {
  expect_true(grepl("single-grid", grid_manager_tester$get_private()$single_grid_element("1-1")))
})

test_that("Single grid element id is as expected", {
  expect_equal(grid_manager_tester$get_private()$prepare_grid_element_id(1,1), "1-1")
})

test_that("Single grid element id split as expected", {
  expect_equal(grid_manager_tester$get_private()$get_grid_element_location("1-1"), c(1,1))
})

test_that("Random grid location uses given range", {
  column_range <- c(1:10)
  row_range <- c(1:10)
  location <- 
    grid_manager_tester$get_private()$random_grid_location(column_range, row_range, c("0-0")) %>% 
    grid_manager_tester$get_private()$get_grid_element_location()
  expect_true(location[1] <= 10)
  expect_true(location[2] <= 10)
})
