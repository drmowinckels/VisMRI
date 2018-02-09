##### ---- Sliders ---- ####
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
