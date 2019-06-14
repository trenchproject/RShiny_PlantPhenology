#Test

#Plant phenology
#

library(shiny)
library(cowplot)

#
rgb.palette <- colorRampPalette(c("red", "orange", "blue"), space = "rgb")

# Load data
clim.dat=read.csv(paste(getwd(),"/Ex2_climatedata.csv",sep = ""))
phen.dat=read.csv(paste(getwd(),"/Ex2_phenologydata_long.csv",sep = "")) #Ex2_phenologydata.csv
phen.dat$Species <- as.character(phen.dat$Species)
phen.dat$Species[phen.dat$Species=="Amelanchier_cadensis"] <- "Amelanchier_canadensis"
phen.dat$Species[phen.dat$Species=="Erigeron_cadensis"] <- "Erigeron_canadensis"
clim.dat$Annual= rowMeans(clim.dat[,2:13], na.rm=TRUE)


# Define server logic to do filtering
shinyServer(function(input, output) {
  
  clim.data <- reactive({
    #restrict years
    x <- strsplit(as.character(input$year), "\\s+")
    print(x)
    from <- as.numeric(x[1])
    to <-   as.numeric(x[2])
    print(from)
    print(to)
    clim.dat %>% filter(Year >=  from & Year <= to)
    
    #pick month
    #clim.dat=  %>% filter(species %in% input$month.sel)
   
    })
  
  phen.data <- reactive({
    #pick species
    phen.dat %>% filter(Species %in% input$species.sel)
    
  })
  
  
  output$ClimatePlot <- renderPlot({
    
    ggplot(data=clim.data(), aes_string(x = 'Year', y=input$clim.month))+
      theme_bw()+
      geom_point()+geom_smooth(method="lm", se=FALSE)+
      ylab("Temperature (C)")+
      xlab("Year")
  })
  
  output$PhenologyPlot <- renderPlot({
    
    ggplot(data=phen.data(), aes_string(x=input$x, y = 'doy'))+
      geom_point()+
      geom_smooth(method="lm",se=F)+
      facet_wrap(~Species, ncol=2, scales="free") +
      theme_bw()+ylab("phenology (doy)")+xlab("Temperature (C)")
    
    # plot_grid(p1, p2, nrow=1, rel_widths=c(1,1.5) )
  })
  
})