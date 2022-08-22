library(shiny)
library(tidyverse)
library(plotly)
library(crosstalk)


jobs_employers_1 <- read_csv("data/jobs_employers_1.csv")
jobs_employers_1$jobs_count <- as.character(jobs_employers_1$jobs_count)

ui <- fluidPage(
    titlePanel("How many Employers having how many Jobs ?"),
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "variable_che_3",
                        label = "Plot Type:",
                        choices = list("Bar Plot" = "bar",
                                       "Dot Plot" = "scatter",
                                       "Line Plot" = "violin"),
            selected = "bar"
                        ),
            checkboxInput(inputId = "showData",
                          label = "Show data table",
                          value = TRUE)
        ),
        mainPanel(
            plotlyOutput("barPlot"),
            DT::dataTableOutput(outputId = "table")
        )
    )
)

server <- function(input, output, session){
    output$barPlot <- renderPlotly({
      p <- jobs_employers_1 %>%
        plot_ly( x = ~jobs_count,
                 y = ~companies_count,
                 type = input$variable_che_3,
                 orientation = 'v') %>% 
        layout(xaxis = list(categoryorder = "total descending",
                            title = 'No. of Jobs Required'),
               yaxis = list(title = 'No. of Employers'))
      
    })
    
    output$table <- DT::renderDataTable({
      d <- event_data("plotly_click")
      if(input$showData){
        DT::datatable(data = d[, c(4, 3)],
                      colnames = c('There are ___ numbers of employers', 'having ___ numbers of jobs'),
                      rownames = FALSE,
                      options = list(
                        columnDefs = list(list(className = 'dt-center', targets = 0:1))))
          }

  })
}

shinyApp (ui=ui, server=server)

