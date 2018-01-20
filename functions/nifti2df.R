nifti2df = function(Nifti){
  require(tidyverse); require(oro.nifti)
  
  Cols = c("X","Y","Z","Val")
  Dat = matrix(NA, nrow=0,ncol=4) %>% as.data.frame()
  names(Dat) = Cols
  for(i in 1:dim(Nifti@.Data)[3]){
    
    tmp = Nifti@.Data[,,i] %>% as.data.frame()
    names(tmp) = 1:ncol(tmp)
    tmp$X = 1:nrow(tmp)
    
    tmp = tmp %>% gather(Y, Val, -X)
    tmp$Y = as.integer(tmp$Y)
    tmp$Z = i
    
    Dat = rbind(Dat,tmp %>% select(one_of(Cols)))
    
  }
  
  return(Dat)
}