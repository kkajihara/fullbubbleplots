library(rsconnect)
library(shiny)
library(plotly)
library(dplyr)

#File inputs
metadata <- read.csv(file = "~/Desktop/Shiny App/fullbubbleplots/Miseq02_full_run_metadata_ITS_table.csv", sep = ",")
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
                  choices = c("crowlab", "phykaa", "cmaiki", "mock", "control"))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Plotly ----
      #plotlyOutput("trendPlot")
      
    )
  )
)

#filters metadata table to keep rows where "project" == "cmaiki"
filteredMeta <- metadata[metadata[, "project"] == "cmaiki",]

#filters abundance table to keep rows where id from filteredMeta match
filteredAbun <- abundance[abundance$id %in% filteredMeta$id, ]

#isolates columns in filteredAbun where colSum is not 0
nonZeroCol <- (colSums(filteredAbun, na.rm = T) != 0)

#new data frame where only non-zero columns remain
nonZeroAbun <- filteredAbun[, nonZeroCol]



server <- function(input, output) {
  
    #output$trendPlot <- renderPlotly({
    #plot_ly()
    #})
  
}

shinyApp(ui = ui,server = server)
