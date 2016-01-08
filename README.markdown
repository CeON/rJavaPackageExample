# About

This is an example R package project that uses code written in Java.

For a concise introduction to rJava, read "Documentation" section on the [webpage of the rJava project](https://www.rforge.net/rJava/) .

# Goal

The goal of this project is to show the following things.

- How to make and use Java code embedded in R package.
- How to call Java code from R by
    - creating Java class instance and calling its method,
    - calling static method of a class.
- How to manage the project using a buildsystem based on Makefiles and Maven.
- How to distribute R code that uses Java code (using R package system).
- How to document code (using Roxygen2).
- How to test code (using `testthat` package).
- How to mark functions that should be accessible by users of the package with `@export` annotation.
- How to follow conventions from the excellent ["R packages" 2015 book][Rp] by Hadley Wickham.

[Rp]: (http://r-pkgs.had.co.nz/)

# Some issues

- Note that the **name of the project is repeated many times**.
    - In the source files we have:
        - `*.Rproj` file: its name
        - `DESCRIPTION` file
        - `usage_example_of_installed_package.R` file: `library` statement
        - `tests/testthat.R` file: `library` statement and as an argument to `test_check` call
    - This is against the DRY principle; however, trying to deal with it would be probably too complex. 
- When running `devtools::check()`, the application complains that the **paths in the Java project are too long** (messages like "storing paths of more than 100 bytes is not portable"). This is unfortunate, because Java projects tend to contain files with long paths. I haven't found a good way of solving this problem.
- Note that the philosophy of this code is that the **derived files are not included in the version control system**. As such, automatically generated file `NAMESPACE` and directory `man` are entered in `.gitignore` file. Hadley Wickham disapproves of this in his book (see chapter "Git and GitHub", paragraph starting from "Some developers never commit derived files").
