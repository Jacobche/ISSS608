library(shiny)
library(tidyverse) ##read csv using readr but it is part of tidyverse family

exam <- read.csv("data/Exam_data.csv")

ui <- fluidPage(
    titlePanel("Pupils Examination Result Dashboard"),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "variable",
                        label = "Subject:",
                        choices = c("English" = "ENGLISH", #Create a list here
                                    "Maths" = "MATHS",
                                    "Science" = "SCIENCE"),
                        selected = "ENGLISH"), #Default value
            sliderInput(inputId = "bins",
                        label = "Number of Bins",
                        min = 5,
                        max = 20,
                        value = 10) #Default value
        ),
        mainPanel(
          plotOutput("distPlot") #A container for the output
    )
  )
)

server <- function(input, output) {
    output$distPlot <- renderPlot({
        x <- unlist(exam[,input$variable]) #Create a new variable here
        ggplot(exam, aes(x)) +
            geom_histogram(bins = input$bins,
                          color="black",
                          fill="light blue")
    })
}

shinyApp(ui = ui, server = server)
