library(rsconnect)
library(shiny)

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Full Bubble Plots"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a taxon ----
      selectInput(inputId = "taxon",
                  label = "Select a taxon:",
                  choices = c("A", "B", "C"))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      #plotOutput(outputId = "distPlot")
      
    )
  )
)

server <- function(input, output) {
  
  
}
