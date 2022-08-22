library(shiny)
library(tidyverse)
library(treemapify)

jobs_employers <- read_csv("data/jobs_employers.csv")

ui <- fluidPage(
    titlePanel("Avg Hourly Rate by Employers"),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "variable_che_1",
                        label = "Colour Scheme:",
                        choices = list("Blues" = "Blues",
                                       "Red-Purple" = "RdPu",
                                       "Yellow-Brown" = "YlOrBr",
                                       "Yellow-Green" = "YlGn",
                                       "Orange-Red" = "OrRd"),
                        selected = "Blues"),
            radioButtons(inputId = "variable_che_2",
                        label = "Direction:",
                        choices = list("Forward" = "1",
                                       "Backward" = "-1"),
                        selected = "1")
        ),
        mainPanel(
            plotOutput("treemapPlot")
        )
    )
)

server <- function(input, output){
    output$treemapPlot <- renderPlot({
      ggplot(jobs_employers, aes(area = avg_hourly_rate, fill = avg_hourly_rate, label = avg_hourly_rate)) +
        geom_treemap() +
        geom_treemap_text(fontface = "italic", colour = "black", place = "centre", grow = F, size = 10) +
        scale_fill_distiller(name = "Avg Hourly Rate", palette = input$variable_che_1, direction = input$variable_che_2)
        })
}

shinyApp (ui=ui, server=server)

