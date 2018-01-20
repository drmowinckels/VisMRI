#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny); library(tidyverse)
sapply(list.files("functions",pattern=".R", full.names = T), source)

BG = readNIfTI("data/Fix_94_FL12DW_291115_NoDiff/bg_image.nii.gz") %>% 
  nifti2df()

Cope3 = readNIfTI("data/Fix_94_FL12DW_291115_NoDiff/cope3.feat/stats/zstat5.nii.gz") %>% 
  nifti2df() %>% rename(Cope3=Val)

IMG = left_join(BG, Cope3, by = c("X", "Y", "Z"))

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("MRI visualisation"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      radioButtons("view",
                   "View", 
                   choices = c("sagittal","axial","coronal"), 
                   selected = "sagittal",
                   inline = T
      ),
      uiOutput("sliceSlider"),
      uiOutput("thresholdSlider")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("mriPlot",height = "800px")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  leaf <- eventReactive(input$view,{
    Z = switch(input$view, "coronal"="Z", "sagittal"="X", "axial"="Y")
    return(Z)
  })
  
  output$mriPlot <- renderPlotly({
    plotNifti(Dat=IMG, view=input$view, slice=input$slice,
              threshMin=input$threshold[1],threshMax=input$threshold[2] )
  })
  
  output$sliceSlider <- renderUI({
    MAX = IMG %>% select_(leaf()) %>% max() %>% round(1)
    sliderInput("slice",
                paste("Choose", leaf(), " slice:"),
                min = 1,
                max = MAX,
                value = MAX/2,
                step = 1
    )
    
  })
  
  output$thresholdSlider <- renderUI({
    MAX = IMG %>% select(5) %>% max()
    sliderInput("threshold", label = h3("Slider Range"),
                min = 0, max = MAX, 
                value = c(2.3, MAX))
  })

}

# Run the application 
shinyApp(ui = ui, server = server)

