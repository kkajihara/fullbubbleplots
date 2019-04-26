library(rsconnect)
library(shiny)
library(plotly)
library(dplyr)

#File inputs
mapping <- read.csv(file = "~/Desktop/Shiny App/fullbubbleplots/Miseq02_full_run_metadata_ITS_table.csv", sep = ",")
abundance <- read.csv(file = "~/Desktop/Shiny App/fullbubbleplots/Miseq02_abundance_ITS_table.csv", sep = ",")
taxonomy <- read.csv(file = "~/Desktop/Shiny App/fullbubbleplots/Miseq02_taxonomy_ITS_table.csv", sep = ",")

#change 'Group' column in abundance table to 'id' (to match 'id' column of metadata table)
colnames(abundance)[colnames(abundance)=="Group"] <- "id"


# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Full Bubble Plots"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select a sample type ----
      selectInput(inputId = "sampleType",
                  label = "Select a sample type:",
                  choices = c("A", "B", "C"))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Plotly ----
      #output$plot <- renderPlotly({
        #plot_ly()
      #})
      
    )
  )
)

server <- function(input, output) {
  
  
}

shinyApp(ui = ui,server = server)
