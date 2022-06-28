library(shiny)
library(tidyverse)
library(plotly)
library(crosstalk)


jobs_employers_1 <- read_csv("data/jobs_employers_1.csv")

ui <- fluidPage(
    titlePanel("No. of Jobs Required by Employers"),
    sidebarLayout(
        sidebarPanel(
            # selectInput(inputId = "variable_che_3",
            #             label = "Jobs Count:",
            #             choices = list("two jobs" = "2",
            #                            "three jobs" = "3",
            #                            "four jobs" = "4",
            #                            "five jobs" = "5",
            #                            "six jobs" = "6",
            #                            "seven jobs" = "7",
            #                            "eight jobs" = "8",
            #                            "nine jobs" = "9")
            #             ),
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
    # dataset = reactive({
    #   jobs_employers_1
    # })
    # 
    # output$barPlot <- renderPlotly({
    #   p <- ggplot(data = dataset(), 
    #              aes(x = reorder(jobs_count, companies_count), y=companies_count)) +
    #         geom_bar(stat = "identity", color="black", fill="light blue") +
    #         geom_text(aes(label=companies_count),
    #                   position = position_stack(vjust = 0.5)) +
    #         coord_flip() +
    #         labs(y= 'Number of Companies', x= 'Jobs Count') +
    #         theme(axis.ticks.x= element_blank(), axis.ticks.y= element_blank(),
    #               axis.line= element_line(color= 'grey'))
    #   ggplotly(p)
    #   })
    #   
    #   output$table <- DT::renderDataTable({
    #     if(input$showData){
    #       DT::datatable(data = dataset(),
    #                     rownames = FALSE)
    #         }
    #     
    # })
  
    output$barPlot <- renderPlotly({
      p <- jobs_employers_1 %>%
        plot_ly( x = ~jobs_count,
                 y = ~companies_count,
                 type = 'bar',
                 orientation = 'v')
    })
    
    output$table <- DT::renderDataTable({
      d <- event_data("plotly_click")
      if(input$showData){
        DT::datatable(data = d,
                      rownames = FALSE)
          }

  })
}

shinyApp (ui=ui, server=server)

