library(tidyverse); library(oro.nifti); library(plotly); library(shiny)
rm(list=ls())

sapply(list.files("functions",pattern=".R", full.names = T), source)

py <- plot_ly(username="Athanasiamo", key="wy77nSuYC4DS7yF12Qhs")


#Read in background image and convert
BG = readNIfTI("data/bg_image.nii.gz") %>% 
  nifti2df()

#Read in overlay (stats) 
Cope3 = readNIfTI("data/zstat5.nii.gz") %>% 
  nifti2df() %>% rename(Cope3=Val)

# Add overlay to the df for plotting (will only work with one overlay)
IMG = left_join(BG, Cope3, by = c("X", "Y", "Z"))

# Try some plotting!
plotNifti(BG, view="axial")
plotNifti(Cope3, view="sagittal")
P = plotNifti(Dat=IMG, view="sagittal", threshMin=2)
x = plotNifti(Dat=IMG, view="axial", slice=30,threshMin=2.5)
G = plotNifti(Dat=IMG, view="coronal", slice=30,threshMin=2.5)
G = plotNifti(Dat=IMG, view="sagittal", slice=30,threshMin=2.5, 
              crossHair = c(44,15),
              peak.highlight=T)

ggplotly(G)



