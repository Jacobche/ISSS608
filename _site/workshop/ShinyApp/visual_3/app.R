library(shiny)
library(tidyverse)
library(sf)
library(tmap)

buildings <- read_sf("data/Buildings.csv", 
                     options = "GEOM_POSSIBLE_NAMES=location")
employers <- read_sf("data/employers_revised.csv", 
                     options = "GEOM_POSSIBLE_NAMES=location")

print(buildings)

ui <- fluidPage(
    titlePanel("Turnover Rate in Ohio"),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "variable_che_5",
                        label = "Turnover Rate Level:",
                        choices = list("low" = "Low Rate",
                                       "medium" = "Medium Rate",
                                       "high" = "High Rate"
                                       ),
                        selected = "Low Rate")
            # ,
            # radioButtons(inputId = "variable_che_2",
            #             label = "Direction:",
            #             choices = list("Forward" = "1",
            #                            "Backward" = "-1"),
            #             selected = "1")
        ),
        mainPanel(
            plotOutput("mapPlot")
        )
    )
)

server <- function(input, output){
    output$mapPlot <- renderPlot({
      tmap_mode("plot") +
        tm_shape(buildings)+
        tm_polygons(col = "white",
                    size = 1,
                    border.col = "grey",
                    border.lwd = 1) +
        tm_shape(employers) +
        tm_dots(col = "level", size = 0.5, palette = "YlOrBr") +
        tm_compass(size = 2,
                   position = c('right', 'top'))
        })
}

shinyApp (ui=ui, server=server)

