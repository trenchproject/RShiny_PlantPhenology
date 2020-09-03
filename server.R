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
    from <- as.numeric(x[1])
    to <-   as.numeric(x[2])
    clim.dat %>% filter(Year >=  from & Year <= to)

    })
  
  #pick species
  phen.data <- reactive({
    phen.dat %>% filter(Species %in% input$species.sel)
  })
  
  
  output$ClimatePlot <- renderPlot({
    
    ggplot(data=clim.data(), aes_string(x = 'Year', y=input$clim.month))+
      theme_bw() +
      geom_point() + geom_smooth(method="lm", se=FALSE)+
      ylab("Temperature (°C)") +
      xlab("Year") + 
      theme(axis.text=element_text(size=12), axis.title=element_text(size=12), legend.text=element_text(size=12), legend.title=element_text(size=12))
    
  })
  
  output$stats <- renderText({
    
    fit <- lm(clim.data()[, input$clim.month] ~ clim.data()[, "Year"])

    pval <- signif(summary(fit)$coefficients[2, 4], digits = 2)
    if (pval < 0.05) {
      pval <- paste("<b style = 'color:red;'>", pval, "</b>")
    }
    
    HTML("<b>Trend line analysis</b>
         <br>Slope:", signif(as.numeric(fit$coefficients[2]), digits = 2), 
         "<br> p-value:", pval,
         "<br> R<sup>2</sup> value: ", signif(summary(fit)$r.squared, digits = 2))
  })
  
  output$PhenologyPlot <- renderPlot({
    
    ggplot(data=phen.data(), aes_string(x=input$x, y = 'doy'))+
      geom_point()+
      geom_smooth(method="lm",se=F)+
      facet_wrap(~Species, ncol=2, scales="free") +
      theme_bw()+ylab("phenology (doy)")+xlab("Temperature (°C)") +
      theme(axis.text=element_text(size=12), axis.title=element_text(size=12), legend.text=element_text(size=12), legend.title=element_text(size=12))
    
    # plot_grid(p1, p2, nrow=1, rel_widths=c(1,1.5) )
  })
  
})