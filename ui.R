#
# Plant phenology
#

library(shiny)
library(tidyverse)

#specify choices
specs= c("Amelanchier_cadensis","Cichorium_intybus","Erigeron_cadensis","Erigeron_pulchellus","Vaccinium_corymbosum")

# Load data
clim.dat=read.csv(paste(getwd(),"/Ex2_climatedata.csv",sep = ""))
clim.dat$Annual= rowMeans(clim.dat[,2:13], na.rm=TRUE)

# Define UI 
shinyUI(

# Define UI
fluidPage(  
  title = "Plant phenology",
  fluidRow(
    column(12,
           includeMarkdown("include.md")
    )),

 hr(),
  # Pick options for climate plot
 fluidRow(
     column(4,selectInput('clim.month', 'Month', c('January'='Jan','February'='Feb','March'='Mar','April'='Apr','May'='May','June'='Jun','July'='Jul','August'='Aug','September'='Sep','October'='Oct','November'='Nov','December'='Dec','Annual'='Annual'))),
     column(4,    sliderInput('year', 'Range of years to plot', 
                              min=min(clim.dat$Year),
                              max=max(clim.dat$Year), 
                              value=c(min(clim.dat$Year), 
                                      max(clim.dat$Year)),
                              format = "####",sep = "",step = 1))
  ),
 
  # Climate plot
  mainPanel(
    column(12,plotOutput(outputId="ClimatePlot", width="800px",height="600px")
  )),
 hr(),
 fluidRow(
   column(12,
          includeMarkdown("include2.md")
   )),
 fluidRow(
   column(4,selectInput('x', 'Climate Variable', c('January'='Jan','February'='Feb','March'='Mar','April'='Apr','May'='May','June'='Jun','July'='Jul','August'='Aug','September'='Sep','October'='Oct','November'='Nov','December'='Dec','Annual'='Annual','January through April'='JanApr'))),
   column(4,selectInput('species.sel', 'Select species to plot', choices= specs, multiple=TRUE, selectize=FALSE, selected=specs))
   
   ),
 fluidRow(
   column(12,plotOutput(outputId="PhenologyPlot")
   )),
 fluidRow(
   column(12,
          includeMarkdown("include3.md")
   )),
 hr()


)
)
