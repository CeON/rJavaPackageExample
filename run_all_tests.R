#!/usr/bin/Rscript

#' The script runs all tests in the project and returns status 1 if at least
#' one of them failed,  0 otherwise.

#' Run tests
res <- devtools::test()
#' Extract a logical vector where each field corresponds to a separate test.
#' A field is TRUE if the test passed, FALSE otherwise.
test_passed <- unlist(sapply(res, function(x) sapply(x$results, function(y) y$passed)))
all_tests_passed <- all(test_passed)

#' Terminate R session with given status returned to shell
if (all_tests_passed) {
  q(status = 0)
} else {
  q(status = 1)
}
