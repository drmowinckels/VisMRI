##### ---- Volumetric plot ---- ####
output$volumetricChoices = renderUI({
  if(input$mainPanel == "Volumetric"){
    checkboxGroupInput("axes","Choose volumetric surfaces",
                       choices = c("Sagittal","Coronal","Axial"), 
                       selected = c("Sagittal","Axial"), inline = T)
  }
})

output$volumetricPlotUI = renderUI({
  if(input$mainPanel == "Volumetric"){
    fluidRow(plotlyOutput("volumetricPlot",height = "600px"))
  }
})

output$volumetricPlot = renderPlotly({
  p = plot_ly()
  
  if(!is.null(input$axes)){
    
    if(any(grepl("Axial",input$axes))){
      BG.Z = getBG(BG,"Z",Z())
      Overlay.Z = getOverlay(Cope3,"Z",Z(), thresh.min=input$threshold[1], thresh.max=input$threshold[2]) %>% 
        rename(Cope3=Val)
      
      p =  p %>%
        add_surface(z~BG.Z$z, x= BG.Z$x, y = BG.Z$y, surfacecolor=BG.Z$SurfaceColor, 
                    colors="Greys",reversescale=T,cauto=T, showscale = FALSE, name="BG") %>% 
        add_trace(data = Overlay.Z, x = Overlay.Z$X, y = Overlay.Z$Y, z = Overlay.Z$Z, mode = "markers", type = "scatter3d", 
                  marker = list( color = ~Cope3, colors = COLORSCALE, size = 6, symbol = "square"), 
                  name="Cope3",legendgroup="a", text = ~paste('value: ', round(Overlay.Z$Cope3,2)))
    }
    
    if(any(grepl("Coronal",input$axes))){
      BG.X = getBG(BG,"X",X())
      Overlay.X = getOverlay(Cope3,"X",X(), thresh.min=input$threshold[1], thresh.max=input$threshold[2]) %>% 
        rename(Cope3=Val)
      
      p =  p %>%
        add_surface(z~BG.X$z, x= BG.X$x, y = BG.X$y, surfacecolor=BG.X$SurfaceColor, 
                    colors="Greys",reversescale=T,cauto=T, showscale = FALSE, name="BG" ) %>% 
        add_trace(data = Overlay.X, x = Overlay.X$X, y = Overlay.X$Y, z = Overlay.X$Z, mode = "markers", type = "scatter3d", 
                  marker = list( color = ~Cope3, colors = COLORSCALE, size = 6, symbol = "square"), 
                  name="Cope3",legendgroup="a", text = ~paste('value: ', round(Overlay.X$Cope3,2)))
    }
    
    if(any(grepl("Sagittal",input$axes))){
      BG.Y = getBG(BG,"Y",Y())
      Overlay.Y = getOverlay(Cope3,"Y",Y(), thresh.min=input$threshold[1], thresh.max=input$threshold[2]) %>% 
        rename(Cope3=Val)
      
      p =  p %>%
        add_surface(z~BG.Y$z, x= BG.Y$x, y = BG.Y$y, surfacecolor=BG.Y$SurfaceColor, 
                    colors="Greys",reversescale=T,cauto=T, showscale = FALSE, name="BG") %>% 
        add_trace(data = Overlay.Y, x = Overlay.Y$X, y = Overlay.Y$Y, z = Overlay.Y$Z, mode = "markers", type = "scatter3d", 
                  marker = list( color = ~Cope3, colors = COLORSCALE, size = 6, symbol = "square"), 
                  name="Cope3",legendgroup="a", text = ~paste('value: ', round(Overlay.Y$Cope3,2)))
    }
    
    p %>% layout(scene = list(
      aspectratio = list(x = 91/109, y = 1, z = 91/109),
      xaxis = list(
        backgroundcolor = "rgb(230, 230,230)",
        gridcolor = "rgb(255, 255, 255)",
        showbackground = TRUE,
        zerolinecolor = "rgb(255, 255, 255)",
        range=c(1,91),
        title="X"),
      yaxis = list(
        backgroundcolor = "rgb(230, 230,230)",
        gridcolor = "rgb(255, 255, 255)",
        showbackground = TRUE,
        zerolinecolor = "rgb(255, 255, 255)",
        range=c(1,109),
        title="Y"),
      zaxis = list(
        backgroundcolor = "rgb(230, 230,230)",
        gridcolor = "rgb(255, 255, 255)",
        range = c(1, 91),
        showbackground = TRUE,
        zerolinecolor = "rgb(255, 255, 255)",
        title="Z")
    ))
  }# if
})
