# Example R file, tested by `tests/testthat/test-fib.R`.
fib <- function(n) {
  if (n <= 1) {
    return(n)
  } else {
    return(fib(n - 1) + fib(n - 2))
  }
}
