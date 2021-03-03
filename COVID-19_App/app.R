library(rvest)

covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

library(shiny)
library(tidyverse)

state_name <- covid19 %>%
    arrange(state) %>%
    distinct(state) %>%
    pull(state)
    
    
ui <- fluidPage("Covid Case Comparison",
    selectInput(inputId = "state", 
                label = "Enter State:",
                choices = state_name,
                multiple = TRUE),
    plotOutput(outputId = "timeplot"),
    submitButton("Submit"))
server <- function(input, output){
    output$timeplot <- renderPlot(
        covid19%>%
            filter(state %in% input$state) %>%
            ggplot(aes(x = date, y = cases, color = state)) +
            geom_line() +
            theme_minimal() +
            scale_y_log10())}


shinyApp(ui = ui, server = server)


