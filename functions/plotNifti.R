plotNifti = function(Dat, view="sagittal", slice=45, threshMin=0,threshMax){
  require(tidyverse); require(plotly); 
  source("functions/theme_nifti.R")
  
  X = switch(view, "coronal"="X", "sagittal"="Y", "axial"="X")
  Y = switch(view, "coronal"="Y", "sagittal"="Z", "axial"="Z")
  Z = switch(view, "coronal"="Z", "sagittal"="X", "axial"="Y")
  
  left = switch(view, "coronal"="L", "sagittal"="A", "axial"="L")
  right = switch(view, "coronal"="R", "sagittal"="P", "axial"="R")
  
  tmp  = Dat %>% rename(BG=Val)
  # If there is another column, assume it's an overlay
  idx = which(!((tmp) %>% names %in% c("X", "Y", "Z","BG")))
  if(!is_empty(idx)){
    
    RANGE = cbind(Min = tmp[,5] %>% min(), Max =  tmp[,5] %>% max()) %>% as.data.frame()
    RANGE = c(RANGE$Min, RANGE$Min/2, 0, RANGE$Max/2, RANGE$Max) %>% round(1)
    
    if(!missing(threshMin)) tmp[,idx] = ifelse(abs(tmp[,idx])>=threshMin, tmp[,idx], NaN)
    if(!missing(threshMax)) tmp[,idx] = ifelse(abs(tmp[,idx])<=threshMax, tmp[,idx], NaN)
  }
  
  tmp = eval(parse(text=paste0("tmp %>% filter(",Z," %in% ",slice,")")))
  
  #P = eval(parse(text=paste0("ggplot(tmp, aes(x=",X,",y=",Y,",frame=",Z,"))")))
  P = eval(parse(text=paste0("ggplot(tmp, aes(x=",X,",y=",Y,"))")))
  
  P = P + 
    geom_raster(aes(fill=BG), interpolate = T, show.legend = F) + 
    scale_fill_gradient(high = "white", low = "black") + 
    theme_nifti() 
  
  if(!is_empty(idx)){
    
    tmp2 = tmp %>% na.omit()
    overlay = paste0("P + geom_point(data=tmp2,aes(col=",names(tmp2)[idx],"), alpha=.7)")
    P = eval(parse(text=overlay)) +
      scale_color_gradientn(colours = c("darkblue","lightblue","white","darkred","yellow"),
                            na.value = "transparent",
                            breaks=RANGE,labels=RANGE,
                            limits=RANGE[c(1,5)])
  }
  
  P = P + 
    annotate("text",x=(tmp %>% select_(X) %>% min()+3), y=(tmp %>% select_(Y) %>% max() / 2), label=left, col="white") + 
    annotate("text",x=(tmp %>% select_(X) %>% max()-3), y=(tmp %>% select_(Y) %>% max() / 2), label=right, col="white") +
    annotate("text",x=(tmp %>% select_(X) %>% min()+6), y=(tmp %>% select_(Y) %>% max()-3), 
             label=paste(Z,"=",slice), col="white") 
  
  ggplotly(P)
}
