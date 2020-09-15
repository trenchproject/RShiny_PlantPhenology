# Plant phenology

library(shiny)
library(tidyverse)
library(stringr)
library(cowplot)

#specify choices
specs <- c("Amelanchier canadensis", "Cichorium intybus", "Erigeron canadensis", "Erigeron pulchellus", "Vaccinium corymbosum")
months <- c('January'='Jan','February'='Feb','March'='Mar','April'='Apr','May'='May','June'='Jun','July'='Jul','August'='Aug','September'='Sep','October'='Oct','November'='Nov','December'='Dec','Annual'='Annual','January through April'='JanApr')

# Load data
clim.dat = read.csv("Ex2_climatedata.csv")

# Define UI 
shinyUI(

# Define UI
fluidPage(  
  title = "Plant phenology",

  includeMarkdown("include.md"),

  hr(),
  # Pick options for climate plot
  fluidRow(
     column(4,selectInput('clim.month', 'Month', choices = months)),
     column(4,sliderInput('year', 'Range of years to plot', 
                          min = min(clim.dat$Year),
                          max = max(clim.dat$Year), 
                          value = c(min(clim.dat$Year), max(clim.dat$Year)),
                          format = "####",sep = "",step = 1))
  ),
 
  # Climate plot
  plotOutput(outputId = "ClimatePlot", width = "800px", height = "600px"),
  htmlOutput("stats"),

  
  hr(),
  includeMarkdown("include2.md"),
  
  fluidRow(
    column(4,selectInput('x', 'Climate Variable', choices = months)),
    column(4,selectInput('species.sel', 'Select species to plot', choices = specs, multiple = TRUE, selected = specs))
  ),
  
  plotOutput(outputId="PhenologyPlot"),
  hr()
  
  )
)
