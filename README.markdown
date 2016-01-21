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

# Installation

Note that in order to be able to build the project, you need to have all R packages listed in the Imports section of the `DESCRIPTION` file installed in the system.

# Some issues

- Note that the **name of the project is repeated many times**.
    - In the source files we have:
        - `*.Rproj` file: its name
        - `DESCRIPTION` file
        - `usage_example_of_installed_package.R` file: `library` statement
        - `tests/testthat.R` file: `library` statement and as an argument to `test_check` call
    - This is against the DRY principle; however, trying to deal with it would be probably too complex. 
- When running `devtools::check()` two NOTEs are printed related to the following things.
    - The first one is that the **paths in the Java project are too long** (messages like "storing paths of more than 100 bytes is not portable"). This is unfortunate, because Java projects tend to contain files with long paths. I haven't found a good way of solving this problem.
    - The second one is that `GNU make` is a system requirement of the package (as defined in the `DESCRIPTION` file). This is required, because in the `java/number-adder/Makefile` file we use `ifndef` construction which is GNU make extension with regards to POSIX make. Using GNU Make is discouraged because it is not completely portable as noted in ["Writing R Extensions" document, section "Writing-portable-packages"][1].
- Note that the philosophy of this code is that the **derived files are not included in the version control system**. As such, automatically generated file `NAMESPACE` and directory `man` are entered in `.gitignore` file. Hadley Wickham disapproves of this in his book (see chapter "Git and GitHub", paragraph starting from "Some developers never commit derived files").

[1]: https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Writing-portable-packages
