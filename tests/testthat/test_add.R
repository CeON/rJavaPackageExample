context("Simple tests of adding various numeric structures")

test_that("adding numbers works", {
  expect_equal(add_numbers(1, 2), 3)
  expect_equal(add_numbers(0, 0), 0)
  expect_equal(add_numbers(-1, 1), 0)
  expect_equal(add_numbers(-4, 1), -3)
})

test_that("adding vectors works", {
  expect_equal(add_vectors(c(1, 0, -1), c(2, 0, 1)), c(3, 0, 0))
})

test_that("there is an error when vectors differ in length", {
  ## Exception thrown in Java when vectors have different length should be
  ## propagated to R as an error.
  expect_error(add_vectors(c(1, 0), c(2, 0, 1)))
})

test_that("adding matrices works",{
  x <- matrix(c(1, -1, 2, 0, 1, 3), ncol = 2)
  y <- matrix(c(2, 1, 3, 0, 3, 3), ncol = 2)
  expected <- matrix(c(3, 0, 5, 0, 4, 6), ncol = 2)
  expect_equal(add_matrices(x, y), expected)
})
