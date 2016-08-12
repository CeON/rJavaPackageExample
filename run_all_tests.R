#!/usr/bin/Rscript

#' The script runs all tests in the project and returns status 1 if at least
#' one of them failed,  0 otherwise.

#' The package below is used here explicitly. This is because when you run this
#' script from command-line, the package is not loaded (unlike when you run
#' the script when you use R) and this prevents rJava from working correctly
#' (I got an error saying "object is not a Java object reference (jobjRef/jarrayRef)")
#' A discussion about this problem can be found at
#' http://r.789695.n4.nabble.com/Why-would-something-work-in-R-but-not-Rscript-td4699820.html
library('methods')

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
