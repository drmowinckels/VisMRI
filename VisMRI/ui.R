#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny); 

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("MRI visualization"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("threshold",
                  "Minimum overlay threshold:",
                  min = 0,
                  max = 10,
                  value = 2.3)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

