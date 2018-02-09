getOverlay = function(data,plane,slice, thresh.min=2.3, thresh.max){
  if(missing(thresh.max)) thresh.max = data$Val %>% max %>% round(1)
  require(tidyverse)
  
  tmp = data %>% 
    filter(get(plane) %in% slice) %>% 
    filter(abs(Val) >= thresh.min & abs(Val) <= thresh.max)
  
 
  return(tmp)
}