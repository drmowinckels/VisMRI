Nifti3D = function(ConvertedNifti){
  require(tidyverse);
  
  tmp = ConvertedNifti %>% group_by(X,Y) %>% spread(Z,Val) %>% as.data.frame()
  
  tmp$Z=tmp %>% select(-(1:2)) %>% as.list()
  
  tmp = tmp %>% select(X,Y,Z)
  return(tmp)
}