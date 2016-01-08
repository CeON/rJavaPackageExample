#' After installing the package in the system, you can execute lines of this
#' file step by step to see what happens when you try to use its functions.

library("rJavaPackageExample")

?add_numbers
add_numbers(1, 2)

add_vectors(c(1, 2), c(3, 4))

#' Calling the function below should fail since it is not exported from the
#' package
convert_matrix_to_java_array_of_double_arrays(matrix(c(1, 2, 3, 4), nrow = 2))
