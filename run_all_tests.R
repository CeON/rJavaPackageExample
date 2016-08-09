#!/usr/bin/Rscript

#' The script runs all tests in the project and returns status 1 if at least
#' one of them failed,  0 otherwise.

#' Code based on function `all_passed` from `reporter-list.R` file from 
#' `testthat` package
all_passed <- function(res) {
  if (length(res) == 0)
    return(TRUE)
  df <- as.data.frame(res)
  sum(df$failed) == 0 && all(!df$error)
}

#' Run tests
res <- devtools::test()
all_tests_passed <- all_passed(res)

#' Terminate R session with given status returned to shell
if (all_tests_passed) {
  q(status = 0)
} else {
  q(status = 1)
}
