#' Code that runs tests when executing `R CMD check`

library(testthat)
library("rJavaPackageExample")

test_check("rJavaPackageExample")
