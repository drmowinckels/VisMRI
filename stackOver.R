library(tidyverse); library(oro.nifti); library(plotly); library(shiny)
rm(list=ls())

sapply(list.files("functions",pattern=".R", full.names = T), source)


#Read in background image and convert
BG = readNIfTI("data/bg_image.nii.gz") %>% 
  nifti2df()

Cope3 = readNIfTI("data/zstat5.nii.gz") %>% nifti2df()

X=40; Y=35; Z=60

BG1 = getBG(BG,"Z",Z)
BG2 = getBG(BG,"X",X)
BG3 = getBG(BG,"Y",Y)

OverLay1 = getOverlay(Cope3,"Z",Z) %>% rename(Cope3=Val)
OverLay2 = getOverlay(Cope3,"X",X) %>% rename(Cope3=Val)
OverLay3 = getOverlay(Cope3,"Y",Y) %>% rename(Cope3=Val)

COLORSCALE = c("darkblue","lightblue","white","darkred","yellow")
COLORSCALE = brewer.pal(12,"RdBu")


plot_ly() %>% 
  add_surface(z~BG1$z, x= BG1$x, y = BG1$y, name="BG",
              colors="Greys",reversescale=T,cauto=T, surfacecolor=BG1$SurfaceColor, showscale = FALSE) %>% 
  add_surface(z~BG2$z, x= BG2$x, y = BG2$y, name="BG",
              colors="Greys",reversescale=T,cauto=T, surfacecolor=BG2$SurfaceColor,showscale = FALSE) %>%  
  add_trace(data = OverLay1, x = OverLay1$X, y = OverLay1$Y, z = OverLay1$Z, mode = "markers", type = "scatter3d", 
           marker = list( color = ~Cope3, colors = COLORSCALE, size = 6, symbol = "square"), 
           name="Cope3",legendgroup="a", text = ~paste('value: ', round(Cope3,2))) %>% 
  add_trace(data = OverLay2, x = OverLay2$X, y = OverLay2$Y, z = OverLay2$Z, mode = "markers", type = "scatter3d", 
            marker = list( color = ~Cope3, colors = COLORSCALE, size = 6, symbol = "square"), 
            name="Cope3",legendgroup="a", text = ~paste('value: ', round(Cope3,2))) %>% 
  layout(scene = list(
    aspectratio = list(
      x = 91/109, 
      y = 109/109, 
      z = 91/109
    ), 
    xaxis = list(
      backgroundcolor = "rgb(235, 235,235)", 
      gridcolor = "rgb(255, 255, 255)", 
      showbackground = TRUE, 
      zerolinecolor = "rgb(255, 255, 255)",
      range=c(1,91),
      title="X"
    ), 
    yaxis = list(
      backgroundcolor = "rgb(235, 235,235)", 
      gridcolor = "rgb(255, 255, 255)", 
      showbackground = TRUE, 
      zerolinecolor = "rgb(255, 255, 255)",
      range=c(1,109),
      title="Y"
    ), 
    zaxis = list(
      backgroundcolor = "rgb(235, 235,235)", 
      gridcolor = "rgb(255, 255, 255)", 
      range = c(1, 91), 
      showbackground = TRUE, 
      zerolinecolor = "rgb(255, 255, 255)",
      title="Z"
    ),
    annotations = list(list(
      showarrow = F,
      x = 91/2,
      y = 109/2,
      z = 1,
      text = "Inferior",
      zanchor = "bottom",
      zshift = -50,
      opacity = 0.7
    ), list(
      showarrow = F,
      x = 91/2,
      y = 109/2,
      z = 91,
      text = "Superior",
      zanchor = "top",
      zshift = 50,
      opacity = 0.7
    ), list(
      showarrow = F,
      x = 91/2,
      y = 1,
      z = 91/2,
      text = "Posterior",
      xanchor = "right",
      yshift = 50,
      opacity = 0.7
    ), list(
      showarrow = F,
      x = 91/2,
      y = 109,
      z = 91/2,
      text = "Anterior",
      xanchor = "left",
      yshift = 50,
      opacity = 1
    ), list(
      showarrow = F,
      x = 1,
      y = 109/2,
      z = 91/2,
      text = "Left",
      xanchor = "left",
      yshift = 50,
      opacity = 1
    ), list(
      showarrow = F,
      x = 91,
      y = 109/2,
      z = 91/2,
      text = "Right",
      xanchor = "right",
      yshift = 50,
      opacity = 1
    ))
  ))
