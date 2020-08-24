context("test home")

setwd("/mnt/src/app") # Modules require setting a working directory (there are relative paths used in modules code)

consts <- config::get(file = "constants/constants.yml")
home <- modules::use("modules/home.R")
home$initialize(consts)

test_that("count message is correct", {
  expect_equal(home$count_message(0), "You clicked me 0 times!")
})
