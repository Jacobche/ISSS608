library(shiny)
library(tidyverse)
library(sf)
library(tmap)
library(leaflet)

buildings <- read_sf("data/Buildings.csv",
                     options = "GEOM_POSSIBLE_NAMES=location")
employers <- read_sf("data/employers_revised.csv",
                     options = "GEOM_POSSIBLE_NAMES=location")
employers$turnovers <- sub('0', '0.5', employers$turnovers)
employers$turnovers <- as.numeric(employers$turnovers)
employers$level <- factor(employers$level, levels=c('Low Rate', 'Medium Rate', 'High Rate'))


ui <- fluidPage(
    titlePanel("Turnover Rate in Engagement"),
    sidebarLayout(
        sidebarPanel(
            radioButtons(inputId = "variable_che_4",
                        label = "Colour Scheme:",
                        choices = list("Orange" = "Oranges",
                                       "Green" = "Greens",
                                       "Purple" = "Purples"),
                        selected = "Oranges"),
            submitButton("Apply Changes")
        ),
        mainPanel(
            leafletOutput("mapPlot"),
            textOutput("text")
        )
    )
)

server <- function(input, output, session){
    output$mapPlot <- renderLeaflet({
      map <- tm_shape(buildings)+
      tm_polygons(col = "white",
                  size = 1,
                  border.col = "grey",
                  border.lwd = 1) +
      tm_shape(employers) +
      tm_dots(col = "level", size = "turnovers", 
              palette = input$variable_che_4)
      
      tmap_leaflet(map)
      
        })
    
    output$text <- renderText({"Note: Turnover rate of 0 is being represented by 0.5 on this map"})
}

shinyApp (ui=ui, server=server)

