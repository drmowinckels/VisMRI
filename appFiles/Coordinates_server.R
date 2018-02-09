##### ---- Coordinates ---- ####
Z <- reactive({
  d = event_data("plotly_click")
  
  if(!is.null(d)){
    if(!is.null(d$key)){
      idx = switch(d$key[[1]],
                   "axial"="y",
                   "sagittal"="y")
      if(!is.null(idx)) d[[idx]] else input$zSlice
    }else{
      d$z
    }
  }else{
    input$zSlice
  }
})

Y <- reactive({
  d = event_data("plotly_click")
  
  if(!is.null(d)){
    if(!is.null(d$key)){
      idx = switch(d$key[[1]],
                   "coronal"="y",
                   "sagittal"="x")
      if(!is.null(idx)) d[[idx]] else input$ySlice
    }else{
      d$y
    }
  }else{
    input$ySlice
  }
})

X <- reactive({
  d = event_data("plotly_click")
  
  if(!is.null(d)){
    if(!is.null(d$key)){
      idx = switch(d$key[[1]],
                   "coronal"="x",
                   "axial"="x")
      
      if(!is.null(idx)) d[[idx]] else input$xSlice
    }else{
      d$x
    }
  }else{
    input$xSlice
  }
})

CrossHair = reactive({
  if(input$crossHair){
    list(Ax=c(X(),Z()),
         Cor=c(X(),Y()),
         Sag=c(Y(),Z()))
  }else{
    list(Ax=0,
         Cor=0,
         Sag=0)
  }
})
