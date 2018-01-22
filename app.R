#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny); library(tidyverse); library(oro.nifti); library(plotly)
source("functions/nifti2df.R");
source("functions/plotNifti.R")
source("functions/theme_nifti.R")

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
    sidebarPanel(width = 3,
                 
                 radioButtons("view",
                              "Main panel", 
                              choices = c("sagittal","axial","coronal"), 
                              selected = "sagittal",
                              inline = T
                 ),
                 uiOutput("xSlider"),
                 uiOutput("ySlider"),
                 uiOutput("zSlider"),
                 uiOutput("thresholdSlider"),
                 verbatimTextOutput("Coords")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      fluidRow(plotlyOutput("mriPlot",height = "900px"))
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  leaf <- eventReactive(input$view,{
    Z = switch(input$view, "coronal"="Z", "sagittal"="X", "axial"="Y")
    return(Z)
  })
  
  
  Sag = reactive({
    plotNifti(Dat=IMG, view="sagittal", slice=X(),
              threshMin=input$threshold[1],threshMax=input$threshold[2],
              show.legend = F)
  })
  
  
  Ax = reactive({
    
    plotNifti(Dat=IMG, view="axial", slice=Y(),
              threshMin=input$threshold[1],threshMax=input$threshold[2],
              show.legend = T)
  })
  
  Cor = reactive({
    
    plotNifti(Dat=IMG, view="coronal", slice=Z(),
              threshMin=input$threshold[1],threshMax=input$threshold[2],
              show.legend = F)
  })
  
  
  output$mriPlot <- renderPlotly({
    #subplot(Ax,subplot(Sag, Cor, nrows=1), nrows=2, heights=c(.7,.3))6
    subplot( Sag(), Ax(), Cor(), nrows=2)
  })
  
  output$xSlider <- renderUI({
    MAX = IMG %>% select(X) %>% max() %>% round(1)
    VAL = ifelse(is_empty(X()),MAX/2,X())
    
    sliderInput("xSlice",
                paste("Choose X slice:"),
                min = 1,
                max = MAX,
                value = VAL,
                step = 1
    )
    
  })
  
  output$ySlider <- renderUI({
    MAX = IMG %>% select(Y) %>% max() %>% round(1)
    VAL = ifelse(is_empty(Y()),MAX/2,Y())
    
    sliderInput("ySlice",
                paste("Choose Y slice:"),
                min = 1,
                max = MAX,
                value = VAL,
                step = 1
    )
    
  })
  
  output$zSlider <- renderUI({
    MAX = IMG %>% select(Z) %>% max() %>% round(1)
    VAL = ifelse(is_empty(Z()),MAX/2,Z())

    sliderInput("zSlice",
                paste("Choose Z slice:"),
                min = 1,
                max = MAX,
                value = VAL,
                step = 1
    )
    
  })
  
  output$thresholdSlider <- renderUI({
    MAX = IMG %>% select(5) %>% max() %>% round(1)
    sliderInput("threshold", label = h3("Threshold range"),
                min = 0, max = MAX, 
                value = c(2.3, MAX))
  })
  
  Z <- reactive({
    d = event_data("plotly_click")

    if(!is.null(d)){
      idx = switch(d$key[[1]],
                   "axial"="y",
                   "sagittal"="y")
      if(!is.null(idx)) d[[idx]] else input$zSlice
    }else{
      input$zSlice
    }
  })
  
  Y <- reactive({
    d = event_data("plotly_click")
    
    if(!is.null(d)){
      idx = switch(d$key[[1]],
                   "coronal"="y",
                   "sagittal"="x")
      if(!is.null(idx)) d[[idx]] else input$ySlice
    }else{
      input$ySlice
    }
  })
  
  X <- reactive({
    d = event_data("plotly_click")
    
    if(!is.null(d)){
      idx = switch(d$key[[1]],
                   "coronal"="x",
                   "axial"="x")
      
      if(!is.null(idx)) d[[idx]] else input$xSlice
    }else{
      input$xSlice
    }
  })
  
  output$Coords <- renderPrint({
    paste("X:", X()," Y:", Y(), " Z:", Z())
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

