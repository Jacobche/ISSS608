library(shiny)
library(tidyverse) ##read csv using readr but it is part of tidyverse family

exam <- read.csv("data/Exam_data.csv")

ui <- fluidPage(
    titlePanel("Subject Correlation Analysis"),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "yvariable",
                        label = "y Variable:",
                        choices = c("English" = "ENGLISH", #Create a list here
                                    "Maths" = "MATHS",
                                    "Science" = "SCIENCE"),
                        selected = "ENGLISH"), #Default value
            selectInput(inputId = "xvariable",
                        label = "x Variable:",
                        choices = c("English" = "ENGLISH", #Create a list here
                                    "Maths" = "MATHS",
                                    "Science" = "SCIENCE"),
                        selected = "MATHS"),
            submitButton("Apply changes")
        ),
        mainPanel(
          plotOutput("scatterPlot") #A container for the output
    )
  )
)

server <- function(input, output, session) {
    output$scatterPlot <- renderPlot({
        ggplot(data = exam, 
               aes_string(x = input$xvariable,
                          y = input$yvariable)) +
            geom_point()
    })
}

shinyApp(ui = ui, server = server)
