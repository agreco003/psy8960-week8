setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
week8_df <- read.table(file = "week8.dat")

# Define UI for application that draws a histogram
ui <- fluidPage(
  

)

# Define server logic required to draw a histogram
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
