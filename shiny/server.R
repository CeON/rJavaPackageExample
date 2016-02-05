library(rJavaPackageExample)

shinyServer(function(input, output) {

output$result <- renderText({
      paste("The result is: ",
            add_numbers(
              as.numeric(input$input1),
              as.numeric(input$input2)))
    })

})
