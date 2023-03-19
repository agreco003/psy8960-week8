library(tidyverse)
library(shiny)

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
  week8_df = readRDS(file = "../shiny/shiny_week8/week8.rds")
  #plotGender <- reactive({input$gender} %>% case_when("All" ~ ".","Male" ~ "Male","Female" ~ "Female")
  #Alternate with 2 lines? #plotGender <- reactive({input$gender}) #plotGender()$gender %>% case_when("All" ~ ".","Male" ~ "Male","Female" ~ "Female")
  #broken, not finished #plotErrorbars <- reactive({case_when(input$SE== "Display Error Band" ~ 1, "Suppress Error Band" ~ 0)})
  #broken, not finished #plotDate <- reactive({case_when(input$date=="Include"~ as.POSIXct(), "Exclude"~ as.POSIXct(2017-08-01))})
  
  plot_selection <- function(){
    week8_df %>%
      filter(gender == plotGender) %>% #or maybe plotGender()$gender?
      filter(timeStart >= plotDate) %>%
      ggplot(aes(x = q1_q6_mean, y = q7_q10_mean)) +
      geom_smooth(method = "lm", color = "purple", se = plotErrorbars) +
      geom_point()
  }
  
  output$plot <- plotly::renderPlotly(plot_selection())
}
# Run the application 
shinyApp(ui = ui, server = server)
#deployApp("../shiny/shiny_week8/week8.rds", appName = "shiny_week8", appTitle = "shiny_week8")