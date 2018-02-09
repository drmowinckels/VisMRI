##### ---- Surface plots ---- ####
Sag = reactive({
  plotNifti(Dat=IMG, view="sagittal", slice=X(),
            threshMin=input$threshold[1],threshMax=input$threshold[2],
            show.legend = F, crossHair = CrossHair()$Sag)
})

Ax = reactive({
  plotNifti(Dat=IMG, view="axial", slice=Y(),
            threshMin=input$threshold[1],threshMax=input$threshold[2],
            show.legend = T,crossHair = CrossHair()$Ax)
})

Cor = reactive({
  plotNifti(Dat=IMG, view="coronal", slice=Z(),
            threshMin=input$threshold[1],threshMax=input$threshold[2],
            show.legend = F,crossHair = CrossHair()$Cor)
})

output$surfacePlots = renderUI({
  fluidRow(plotlyOutput("mriPlot",height = ifelse(input$mainPanel == "Volumetric", "200px","900px")))
})

output$mriPlot <- renderPlotly({
  if(input$mainPanel == "Volumetric"){
    subplot(Sag(), Cor(), Ax(), widths = c(.3,.3,.3))
  }else{
    mainP = switch(input$mainPanel,
                   "Sagittal" = Sag(),
                   "Coronal"  = Cor(),
                   "Axial"    = Ax()
    )
    smallP = switch(input$mainPanel,
                    "Sagittal" = list(Cor(),Ax()),
                    "Coronal"  = list(Ax(),Sag()),
                    "Axial"    = list(Cor(),Sag())
    ) %>% subplot(nrows=1, heights = .70)
    
    subplot(mainP, smallP,
            nrows=2, heights=c(.6,1-.6), widths = .7)
  }
})