getBG = function(data,plane,slice){
  require(tidyverse)
  tmp = data %>% filter(get(plane) %in% slice)
  
  x = tmp %>% select(X) %>% unique() %>% unlist() %>% unname()
  y = tmp %>% select(Y) %>% unique() %>% unlist() %>% unname()
  z = tmp %>% select(Z) %>% unique() %>% unlist() %>% unname()
  
  Trace = list()
  
  Trace = switch(plane,
                 "Z"={
                   Trace$SurfaceColor = tmp %>% select(-Z) %>% spread(X,Val) %>% select(-Y) %>% as.matrix()
                   Trace$z <- matrix(slice, ncol=ncol(Trace$SurfaceColor), nrow=nrow(Trace$SurfaceColor))
                   Trace$x = x
                   Trace$y = y
                   
                   Trace
                 },
                 "X"={
                   Trace$SurfaceColor = tmp %>% select(-X) %>% spread(Z,Val) %>% select(-Y) %>% as.matrix()
                   Trace$z <- tmp %>% select(Z) %>% unlist() %>% 
                     matrix(ncol=ncol(Trace$SurfaceColor), nrow=nrow(Trace$SurfaceColor))
                   Trace$x = rep(slice, ncol(Trace$z))
                   Trace$y = y
                   
                   Trace
                 },
                 "Y"={
                   Trace$SurfaceColor = tmp %>% select(-Y) %>% spread(X,Val) %>% select(-Z) %>% as.matrix()
                   Trace$z <- tmp %>% select(X) %>% unlist() %>% as.numeric() %>%  
                     matrix(ncol=ncol(Trace$SurfaceColor), nrow=nrow(Trace$SurfaceColor))# %>% t
                   Trace$x = x
                   Trace$y = rep(slice, ncol(Trace$z))
                   
                   Trace
                 }
  )
  
  colnames(Trace$z) = Trace$x 
  rownames(Trace$z) = Trace$y
  Trace$name = "BG"
  
  return(Trace)
}