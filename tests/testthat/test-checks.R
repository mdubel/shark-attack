setwd("../../src/app")
GridManager <- use("logic/GridManager.R")$GridManager
ObjectsManager <- use("logic/ObjectsManager.R")$ObjectsManager
ScoreManager <- use("logic/ScoreManager.R")$ScoreManager
TrashManager <- use("logic/TrashManager.R")$TrashManager

GridManager <- GridManager$new()
ScoreManager <- ScoreManager$new()
TrashManager <- TrashManager$new()

context("Application checks logic")

test_that("Success happens when boat and diver are on the same location.", {
  objects_manager <- ObjectsManager$new(ScoreManager, TrashManager)
  location <- "1-1"
  objects_manager$save_object_location("diver", location)
  objects_manager$save_object_location("boat", location)
  
  # Error as shinyjs function is about to be triggered.
  expect_error(objects_manager$check_success())
})

test_that("Success does not happen when boat and diver are not on the same location.", {
  objects_manager <- ObjectsManager$new(ScoreManager, TrashManager)
  objects_manager$save_object_location("diver", "1-3")
  objects_manager$save_object_location("boat", "1-2")
  
  expect_false(objects_manager$check_success())
})

test_that("Bite happens when shark and diver are on the same location.", {
  objects_manager <- ObjectsManager$new(ScoreManager, TrashManager)
  location <- "1-1"
  objects_manager$save_object_location("diver", location)
  objects_manager$save_object_location("shark", location)
  
  expect_error(objects_manager$check_shark_bite())
})

test_that("Bite does not happen when shark and diver are not on the same location.", {
  objects_manager <- ObjectsManager$new(ScoreManager, TrashManager)
  objects_manager$save_object_location("diver", "1-3")
  objects_manager$save_object_location("shark", "1-2")
  
  expect_false(objects_manager$check_shark_bite())
})
