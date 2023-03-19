library(tidyverse)
library(shiny)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
week8_df = read_csv(file = "week8.csv")

# Define UI
ui <- fluidPage(
  titlePanel("Week8 Interactive App"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "gender", label = "Gender of Participants", choices = list("All", "Male","Female"), selected = "All"),
      selectInput(inputId = "SE", label = "Error Band?", choices = list("Display Error Band", "Suppress Error Band"), selected = "Display Error Band"),
      selectInput(inputId = "date", label = "Include Participants before August 1, 2017?", choices = c(list("Include", "Exclude")), selected = "Include")
    ),
    mainPanel(
      plotly::plotlyOutput('plot'))
  ))

# Define server logic
server <- function(input, output) {
  plotGender <- reactive({input$gender %>% case_match("All" ~as.list(.),"Male" ~as.list("Male"),"Female" ~as.list("Female"))})
  #plotErrorbars <- reactive({case_when(input$SE, "Display Error Band" ~ TRUE, "Suppress Error Band" ~ FALSE)})
  #plotDate <- reactive({case_when(input$date=="Include"~ as.POSIXct(0000-00-00), input$date=="Exclude"~ as.POSIXct(2017-08-01))})
  
  plot_selection <- function(){
    week8_df %>%
      filter(gender == reactiveValuesToList(plotGender)) %>%
      #filter(timeStart >= plotDate) %>%
      ggplot(aes(x = q1_q6_mean, y = q7_q10_mean)) +
      geom_smooth(method = "lm", color = "purple", se = TRUE) +
      geom_point()
  }
  
  output$plot <- plotly::renderPlotly(plot_selection())
}
# Run the application 
shinyApp(ui = ui, server = server)
