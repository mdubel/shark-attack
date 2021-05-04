context("Application logic")
ObjectsManager <- use("../../src/logic/ObjectsManager.R")$ObjectsManager

test_that("Success happens when boat and diver are on the same location.", {
  objects_manager <- ObjectsManager$new()
  location <- "1-1"
  objects_manager$add_on_grid("diver", location)
  objects_manager$add_on_grid("boat", location)
  
  expect_true(objects_manager$check_success())
})
