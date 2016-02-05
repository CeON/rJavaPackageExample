library(markdown)

shinyUI(fluidPage(
  titlePanel("Adding two values using rjava"),
  sidebarLayout(
    sidebarPanel(
      paste("app version: ", includeText("version.txt"))

    ),
    mainPanel(
        h1("Let's add two values!"),
	      numericInput("input1", "first value", 1),
	      numericInput("input2", "second value", 2),
        h1(textOutput("result"))
    )
  )
))

