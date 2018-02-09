# load necessary libraries
library(shiny); library(tidyverse); library(oro.nifti); library(plotly); library(RColorBrewer)

# Source necessary custom functions
source("functions/nifti2df.R");
source("functions/plotNifti.R")
source("functions/theme_nifti.R")
source("functions/getBG.R")
source("functions/getOverlay.R")

BG = readNIfTI("data/bg_image.nii.gz") %>% 
  nifti2df()

Cope3 = readNIfTI("data/zstat5.nii.gz") %>% 
  nifti2df() 

IMG = left_join(BG, Cope3 %>% rename(Cope3=Val), by = c("X", "Y", "Z"))

COLORSCALE = brewer.pal(11,"RdBu")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("MRI visualisation"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 3,
                 radioButtons("mainPanel",
                              "Main panel", 
                              choices = c("Sagittal","Axial","Coronal", "Volumetric"), 
                              selected = "Volumetric",
                              inline = T
                 ),
                 checkboxInput("crossHair","Toggle crosshair"),
                 uiOutput("volumetricChoices"),
                 uiOutput("xSlider"),
                 uiOutput("ySlider"),
                 uiOutput("zSlider"),
                 uiOutput("thresholdSlider")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      uiOutput("volumetricPlotUI"),
      uiOutput("surfacePlots")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  source("appFiles/Coordinates_server.R",    local=T)
  source("appFiles/Sliders_server.R",        local=T)
  source("appFiles/SurfacePlots_server.R",   local=T)
  source("appFiles/VolumetricPlot_server.R", local=T)
  
}

# Run the application 
shinyApp(ui = ui, server = server)

