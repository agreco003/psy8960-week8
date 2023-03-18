library(tidyverse)
library(shiny)
read_delim("../shiny/shiny_week8/week8.dat")

# Define UI
ui <- fluidPage(
  

)

# Define server logic
server <- function(input, output) {

}

# Run the application 
shinyApp(ui = ui, server = server)
