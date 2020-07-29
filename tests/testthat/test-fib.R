source("../../src/fib.R")
context("Fibonacci sequence generation")

test_that("fib() is correct for small integers", {
  expect_equal(fib(0), 0)
  expect_equal(fib(1), 1)
  expect_equal(fib(2), 1)
  expect_equal(fib(3), 2)
  expect_equal(fib(4), 3)
  expect_equal(fib(5), 5)
})
