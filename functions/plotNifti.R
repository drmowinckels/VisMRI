plotNifti = function(Dat, view="coronal",threshMin=0,threshMax){
  require(tidyverse); require(plotly); 
  source("functions/theme_nifti.R")
  
  tmp = Dat
  
  X = switch(view, "coronal"="X", "sagittal"="Y", "axial"="X")
  Y = switch(view, "coronal"="Y", "sagittal"="Z", "axial"="Z")
  Z = switch(view, "coronal"="Z", "sagittal"="X", "axial"="Y")
  
  left = switch(view, "coronal"="L", "sagittal"="A", "axial"="L")
  right = switch(view, "coronal"="R", "sagittal"="P", "axial"="R")
  
  # If there is another column, assume it's an overlay
  idx = which(!((tmp) %>% names %in% c("X", "Y", "Z","Val")))
  if(!missing(threshMin)) tmp[,idx] = ifelse(abs(tmp[,idx])>=threshMin, tmp[,idx], NA)
  if(!missing(threshMax)) tmp[,idx] = ifelse(abs(tmp[,idx])<=threshMax, tmp[,idx], NA)
  
  P = eval(parse(text=paste0("ggplot(tmp, aes(x=",X,",y=",Y,",frame=",Z,"))")))
  P = P + 
    geom_raster(aes(fill=Val), interpolate = T, show.legend = F) + 
    scale_fill_gradient(high = "white", low = "black") + 
    theme_nifti() 
  
  if(!is_empty(idx)){
    tmp2 = tmp[!is.na(tmp[,idx]),] 
    overlay = paste0("P + geom_point(data=tmp2,aes(col=",names(tmp2)[idx],", alpha=",names(tmp2)[idx],"))")
    P = eval(parse(text=overlay)) +
      scale_color_gradient(low="darkred",high="yellow")
  }
  
  P = P + 
    annotate("text",x=(tmp %>% select_(X) %>% min()+3), y=(tmp %>% select_(Y) %>% max() / 2), label=left, col="white") + 
    annotate("text",x=(tmp %>% select_(X) %>% max()-3), y=(tmp %>% select_(Y) %>% max() / 2), label=right, col="white") 
  
  ggplotly(P)
  
}
