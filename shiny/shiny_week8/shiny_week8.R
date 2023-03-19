library(tidyverse)
library(shiny)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

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
      plotOutput('plot'))
  )
)

# Define server logic
server <- function(input, output) {
  data_tbl <- readRDS("week8.rds")
  output$plot <- renderPlot({
    if (input$gender == c("Male") | input$gender == c("Female")) {
      data_tbl <- data_tbl %>% filter(gender == input$gender)
    } else {}
    if (input$date == c("Exclude")) {
      data_tbl <- data_tbl %>% filter(timeStart >= c("2017-08-01"))
    } else {}
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
rsconnect::deployApp("../shiny/shiny_week8/week8.rds", appName = "shiny_week8", appTitle = "shiny_week8")
