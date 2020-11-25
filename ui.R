# Plant phenology

library(shiny)
library(ggplot2)
library(magrittr)
library(tidyverse)
library(stringr)
library(shinyWidgets)
library(cicerone)
library(shinyjs)
library(shinyBS)
#library(cowplot)
library(plotly)

#specify choices
specs <- c("Amelanchier canadensis", "Cichorium intybus", "Erigeron canadensis", "Erigeron pulchellus", "Vaccinium corymbosum")
months <- c('January'='Jan','February'='Feb','March'='Mar','April'='Apr','May'='May','June'='Jun','July'='Jul','August'='Aug','September'='Sep','October'='Oct','November'='Nov','December'='Dec','Annual'='Annual','January through April'='JanApr')

# Load data
clim.dat = read.csv("Ex2_climatedata.csv")

# Define UI 
shinyUI(

# Define UI
fluidPage(id = "page",
  use_cicerone(),
  useShinyjs(),
  title = "Plant phenology",

  includeMarkdown("include.md"),
  
  actionBttn(
    inputId = "reset1",
    label = "Reset", 
    style = "material-flat",
    color = "danger",
    size = "xs"
  ),
  bsTooltip("reset1", "If you have already changed the variables, reset them to default here before starting the tour."),
  
  actionBttn(
    inputId = "tour1",
    label = "Take a tour!", 
    style = "material-flat",
    color = "success",
    size = "sm"
  ), 
  hr(),
  # Pick options for climate plot
  fluidRow(
    
    column(4, 
           div(
             id = "month-wrapper",
             pickerInput('clim.month', 'Month', choices = months)
           )
    ),
  
    column(4, 
           div(
             id = "year-wrapper",
             sliderInput('year', 'Range of years', min = min(clim.dat$Year),
                          max = max(clim.dat$Year), 
                          value = c(min(clim.dat$Year), max(clim.dat$Year)),
                          format = "####", sep = "", step = 1)
           )
    )
  ),
 
  # Climate plot
  plotOutput(outputId = "ClimatePlot", width = "800px", height = "600px"),
  htmlOutput("stats"),

  
  hr(),
  includeMarkdown("include2.md"),
  br(),
  actionBttn(
    inputId = "reset2",
    label = "Reset", 
    style = "material-flat",
    color = "danger",
    size = "xs"
  ),
  bsTooltip("reset2", "If you have already changed the variables, reset them to default here before starting the tour."),
  
  actionBttn(
    inputId = "tour2",
    label = "Take a tour!", 
    style = "material-flat",
    color = "success",
    size = "sm"
  ), 
  hr(),
  div(
    id = "viz-wrapper",

    fluidRow(
      column(4, 
             div(
               id = "month-wrapper", 
               pickerInput('month', 'Month', choices = months)
             )
      ),
      column(4, 
             div(
               id = "spec-wrapper", 
               pickerInput('species', 'Species', choices = specs, multiple = TRUE, selected = specs[1],
                           options = list(`actions-box` = TRUE))
             )
      )
    ),
    
    # h4("ggplot"),
    # plotOutput(outputId = "PhenologyPlot"),
    # hr(),
    # h4("Plotly"),
    plotlyOutput(outputId = "PhenologyPlotly"),
    hr()
    )
  )
)
