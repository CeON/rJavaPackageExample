#' Add two numbers.
#'
#' @param a A number.
#' @param b A number.
#' @return The sum of \code{a} and \code{b}.
#' @examples
#' add_numbers(1, 2)
#' @export
add_numbers <- function(a, b){
  #' Create an instance of the given Java class and pass parameters to its
  #' constructor.
  adder <- rJava::.jnew("pl.edu.icm.rjava_project_example.SimpleAdder", a, b)

  #' Call a method of the instance and specify the type of the output as a
  #' "double".
  result <- rJava::.jcall(adder, "D", "getResult")
  return(result)
}

#' Add two vectors.
#'
#' @param a A numeric vector.
#' @param b A numeric vector.
#' @return Sum of the vectors.
#' @export
add_vectors <- function(a, b){
  #' Call a static method of the class. Specify that the output is an
  #' array of "double"s.
  result <- rJava::.jcall("pl.edu.icm.rjava_project_example.AdvancedAdder",
                "[D", "addVectors", a, b)
  return(result)
}

convert_matrix_to_java_array_of_double_arrays <- function(data) {
  #' Convert each row into a Java array and place it in a list.
  java_list <- apply(data, 1, rJava::.jarray)

  #' Place java arrays in a java array.
  #' Because the argument of the `.jarray` function is a list of java objects,
  #' we need to specify types of these objects explicitly i.e. we
  #' use "[D" to say that each object is an array of doubles.
  array <- rJava::.jarray(java_list, "[D")
  return(array)
}

convert_java_array_of_double_arrays_to_matrix <- function(data){
  #' The structure that corresponds to Java's array of arrays of double values
  #' is visible as a list of Java arrays to R.
  #' First, let's convert each element of this list to a vector.
  list <- lapply(data, rJava::.jevalArray)
  #' Now let's stack the vectors in the list on top of each other and create
  #' a single matrix from them this way.
  result <- do.call(rbind, list)
  return(result)
}

#' Add two matrices.
#'
#' @param a A numeric matrix.
#' @param b A numeric matrix.
#' @export
add_matrices <- function(a, b){
  a_java <- convert_matrix_to_java_array_of_double_arrays(a)
  b_java <- convert_matrix_to_java_array_of_double_arrays(b)
  #' Call a static method of the class. Specify that the output is an
  #' array of arrays of "double" values.
  result_java <- rJava::.jcall("pl.edu.icm.rjava_project_example.AdvancedAdder",
                          "[[D", "addMatrices", a_java, b_java)
  result <- convert_java_array_of_double_arrays_to_matrix(result_java)
  return(result)
}
