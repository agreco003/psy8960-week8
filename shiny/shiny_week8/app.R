library(tidyverse)
library(shiny)
#comment out working directory #setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Define UI
ui <- fluidPage(
  titlePanel("Week8 Interactive App"),
  #Create sidebar layout for options on the left, plot in the main panel on the right
  sidebarLayout(
    sidebarPanel(
      #create 3 inputs, one for a gender filter, one for activating error bars (SE) and one for one for a date filter
      selectInput(inputId = "gender", label = "Gender of Participants", choices = list("All", "Male","Female"), selected = "All"),
      selectInput(inputId = "SE", label = "Error Band?", choices = list("Display Error Band", "Suppress Error Band"), selected = "Display Error Band"),
      selectInput(inputId = "date", label = "Include Participants before August 1, 2017?", choices = c(list("Include", "Exclude")), selected = "Include")
    ),
    mainPanel(
      plotOutput('plot'))
  )
)

# Define server logic
server <- function(input, output) {
  data_tbl <- readRDS("week8.rds")
  #create a plot output
  output$plot <- renderPlot({
    #filter gender in the tibble to match a single gender input. Otherwise, do nothing to show all results. 
    if (input$gender == c("Male") | input$gender == c("Female")) {
      data_tbl <- data_tbl %>% filter(gender == input$gender)
    } else {}
    #filter timeStart in tibble to only show results after Aug 1, 2017 if selected in the input. Otherwise, do nothing to show all results.
    if (input$date == c("Exclude")) {
      data_tbl <- data_tbl %>% filter(timeStart >= c("2017-08-01"))
    } else {}
    #Create a plot without error bands if "Suppress" is selected. Otherwise, build a plot with error bands.
    if (input$SE == c("Suppress Error Band")) {
      data_tbl %>%
        ggplot(aes(x = q1_q6_mean, y = q7_q10_mean)) +
        geom_smooth(method = "lm", color = "purple", se = FALSE) +
        geom_point()
    } else {
      data_tbl %>%
        ggplot(aes(x = q1_q6_mean, y = q7_q10_mean)) +
        geom_smooth(method = "lm", color = "purple", se = TRUE) +
        geom_point()
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
#rsconnect::deployApp()