library(tidyverse); library(plotly)
sapply(list.files("../functions",pattern=".R", full.names = T), source)

BG = readNIfTI("../data/Fix_94_FL12DW_291115_NoDiff/bg_image.nii.gz") %>% 
  nifti2df()

Cope3 = readNIfTI("../data/Fix_94_FL12DW_291115_NoDiff/cope3.feat/stats/zstat5.nii.gz") %>% 
  nifti2df() %>% rename(Cope3=Val)

IMG = left_join(BG, Cope3, by = c("X", "Y", "Z"))