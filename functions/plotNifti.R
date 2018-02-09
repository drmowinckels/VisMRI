plotNifti = function(Dat, view="sagittal", slice=45, 
                     threshMin=0,threshMax, show.legend=T,
                     crossHair=0, peak.highlight=F){
  require(tidyverse); require(plotly); 
  source("functions/theme_nifti.R")
  
  # Toggle coordinates depending on which view is asked for -------
  X = switch(view, "coronal"="X", "sagittal"="Y", "axial"="X")
  Y = switch(view, "coronal"="Y", "sagittal"="Z", "axial"="Z")
  Z = switch(view, "coronal"="Z", "sagittal"="X", "axial"="Y")
  
  # Toggle orientation labels depending on view -----
  left = switch(view, "coronal"="L", "sagittal"="A", "axial"="L")
  right = switch(view, "coronal"="R", "sagittal"="P", "axial"="R")
  
  #COLORSCALE = c("darkblue","lightblue","white","darkred","yellow")
  COLORSCALE = brewer.pal(11,"RdBu") %>% rev()
  
  # Do some renaming to make BG obvious ------
  tmp  = Dat %>% rename(BG=Val)
  
  # If there is another column, assume it's an overlay -------
  idx = which(!((tmp) %>% names %in% c("X", "Y", "Z","BG")))
  if(!is_empty(idx)){
    
    RANGE = cbind(Min = tmp[,idx] %>% min(), Max =  tmp[,idx] %>% max()) %>% as.data.frame()
    RANGE = c(RANGE$Min, RANGE$Min/2, 0, RANGE$Max/2, RANGE$Max) %>% round(1)
    
    tmp[,idx] = ifelse(abs(tmp[,idx])>=threshMin, tmp[,idx], NaN)
    if(!missing(threshMax)) tmp[,idx] = ifelse(abs(tmp[,idx])<=threshMax, tmp[,idx], NaN)
  }
  
  # Reduce data to what is asked for -------
  tmp = eval(parse(text=paste0("tmp %>% filter(",Z," %in% ",slice,") "))) %>% 
    mutate(Key=view)  
  
  # Initiate the ggplot ------
  P = eval(parse(text=paste0("ggplot(tmp, aes(x=",X,",y=",Y,",z=",Z,",key=Key))")))

  # Plot the tileplot ------
  P = P +  
    geom_tile(aes(fill=BG), show.legend = F) + 
    scale_fill_gradient(high = "white", low = "black") + 
    theme_nifti() 
  
  # If there is an overlay, add points to the plot -----
  if(!is_empty(idx)){
    
    tmp2 = tmp %>% na.omit()
    overlay = paste0("P + geom_point(data=tmp2,aes(col=",names(tmp2)[idx],"), alpha=.7, show.legend = show.legend)")
    P = eval(parse(text=overlay)) +
      scale_color_gradientn(colours = COLORSCALE,
                            na.value = "transparent",
                            breaks=RANGE,labels=RANGE,
                            limits=RANGE[c(1,5)])
  }
  
  # Orientation labels ---------
  P = P + 
    annotate("text",x=(tmp %>% select_(X) %>% min()+3), y=(tmp %>% select_(Y) %>% max() / 2), label=left, col="white") + 
    annotate("text",x=(tmp %>% select_(X) %>% max()-3), y=(tmp %>% select_(Y) %>% max() / 2), label=right, col="white")
 
  # Toggle crosshair ---------
  if(sum(crossHair) != 0){
    cross = tmp[tmp[,X] %in% crossHair[1],]
    cross = cross[cross[,Y] %in% crossHair[2],]
    
    P = P + 
      geom_vline(xintercept = cross[1, X], color="white") + 
      geom_hline(yintercept = cross[1, Y], color="white")
  }
  
  # Highligh peak voxel -------
  if(peak.highlight){
    if(!is_empty(idx)){
      Peak = tmp[tmp[,idx] %in% max(tmp[,idx], na.rm = T),]
      P = P + geom_point(data=Peak,color="black", shape=1, size=5)
    }
  }
  
  MRI = ggplotly(P)
  
  ### Ugly hacks to fix coordinate system difficulties on hover in plotting a 3D object with fixed coordinates
  MRI$x$data[[2]]$text = MRI$x$data[[2]]$text %>% 
    gsub("X:","Q:",.) %>% gsub("Y:","W:",.) %>% gsub("Z:","T:",.) %>% 
    gsub("Q:",paste0(X,":"),.) %>% gsub("W:",paste0(Y,":"),.) %>% gsub("T:",paste0(Z,":"),.)
  
  if(!is_empty(idx)){
    
    MRI$x$data[[2]]$text = MRI$x$data[[2]]$text %>% 
      gsub("X:","Q:",.) %>% gsub("Y:","W:",.) %>% gsub("Z:","T:",.) %>% 
      gsub("Q:",paste0(X,":"),.) %>% gsub("W:",paste0(Y,":"),.) %>% gsub("T:",paste0(Z,":"),.)
  }
  
  MRI$elementId = view
    
  return(MRI)
}
