library(rsconnect)
library(shiny)
library(plotly)
library(dplyr)
library(janitor)
library(data.table)
library(tidyverse)

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
      
      # Input: Select a project (later sampleType) ----
      selectInput(inputId = "projectName",
                  label = "Select a project:",
                  choices = c("crowlab", "phykaa", "cmaiki", "mock", "control"))
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Plotly ----
      plotlyOutput("trendPlot")
      
    )
  )
)





server <- function(input, output) {
  
  #filters metadata table to keep rows where "project" == cmaiki (test)
  filteredMeta <- metadata[metadata[, "project"] == 'cmaiki',]
  
  #filters abundance table to keep rows where id from filteredMeta match
  filteredAbun <- abundance[abundance$id %in% filteredMeta$id, ]
  
  #isolates columns in filteredAbun where colSum is not 0
  nonZeroCol <- (colSums(filteredAbun, na.rm = T) != 0)
  
  #new data frame where only non-zero columns remain
  nonZeroAbun <- filteredAbun[, nonZeroCol]
  
  #adds "Total" row at bottom with colSums
  addColSums <- nonZeroAbun %>% adorn_totals("row")
  
  #filters taxonomy table to only include rows where OTUs match nonZeroAbun
  #filteredTax <- taxonomy[taxonomy$OTU %in% colnames(nonZeroAbun), ]
  
  #check that "Total" colSum row was added
  #lastRow <- tail(addColSums, 1)
  
  #make id column values into row names
  row.names(addColSums) <- addColSums$id
  addColSums[1] <- NULL
  
  #adds counts for how many samples the OTU showed up in (using table without column sums)
  sampleCounts <- colSums(nonZeroAbun != 0)
  
  #remove first row
  sampleCountsLess <- tail(sampleCounts, -1)
  
  #appends sample count row to abundance table with column sums
  forPlotly <- rbind(addColSums, sampleCountsLess)
  
  #switches column names and row names for easier plotly use (using transpose)
  plotlyTransformed <- as.data.frame(t(forPlotly))
  
  #creates column for OTUs for easier plotly use
  addOTUColumn <- setDT(plotlyTransformed, keep.rownames = "OTU")
  
  #rename last column to reference in plotly
  addCountsTitle <- names(addOTUColumn)[length(names(addOTUColumn))] <- "Counts" 

  plotlyReady <- addOTUColumn
  View(plotlyReady)
  
  
    output$trendPlot <- renderPlotly({
      
      p <- plot_ly(plotlyReady, x = ~Counts, y = ~Total, type = 'scatter', mode = 'markers', size = ~Total, color = ~OTU, colors = 'Paired',
                   #Choosing the range of the bubbles' sizes:
                   sizes = c(10, 50),
                   marker = list(opacity = 0.5, sizemode = 'diameter')) %>%
        
        layout(title = 'Fungal Abundance',
               xaxis = list(showgrid = FALSE),
               yaxis = list(showgrid = FALSE),
               showlegend = FALSE)
    })
  
}

shinyApp(ui = ui,server = server)
