library(tidyverse); library(oro.nifti); library(plotly); library(shiny)
rm(list=ls())

sapply(list.files("functions",pattern=".R", full.names = T), source)

BG = readNIfTI("data/Fix_94_FL12DW_291115_NoDiff/bg_image.nii.gz") %>% 
  nifti2df()

Cope3 = readNIfTI("data/Fix_94_FL12DW_291115_NoDiff/cope3.feat/stats/zstat5.nii.gz") %>% 
  nifti2df() %>% rename(Cope3=Val)

IMG = left_join(BG, Cope3, by = c("X", "Y", "Z"))

plotNifti(BG, view="axial")
plotNifti(Cope3, view="sagittal")
plotNifti(Dat=IMG, view="sagittal", threshMin=2)
plotNifti(Dat=IMG, view="axial", slice=47,threshMin=2.5)
