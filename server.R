#Plant phenology

# Load data
clim.dat = read.csv("Ex2_climatedata.csv")
phen.dat=read.csv("Ex2_phenologydata_long.csv")


# Define server logic to do filtering
shinyServer(function(input, output) {
  
  clim.data <- reactive({
    #restrict years
    x <- strsplit(as.character(input$year), "\\s+")
    clim.dat %>% filter(Year >= as.numeric(x[1]) & Year <= as.numeric(x[2]))
    })
  
  #pick species
  phen.data <- reactive({
    phen.dat %>% filter(Species %in% input$species.sel)
  })
  
  
  output$ClimatePlot <- renderPlot({
    ggplot(data = clim.data(), aes_string(x = 'Year', y = input$clim.month))+
      theme_bw() +
      geom_point() + geom_smooth(method = "lm", se = FALSE) +
      ylab("Temperature (°C)") +
      xlab("Year") + 
      theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12), 
            legend.text = element_text(size = 12), legend.title = element_text(size = 12))
  })
  
  output$stats <- renderText({
    fit <- lm(clim.data()[, input$clim.month] ~ clim.data()[, "Year"])
    pval <- signif(summary(fit)$coefficients[2, 4], digits = 2)
    
    if (pval < 0.05) {
      pval <- paste("<b style = 'color:red;'>", pval, "</b>")
    }
    
    HTML("<b>Trend line analysis</b>
         <br>Slope:", signif(as.numeric(fit$coefficients[2]), digits = 2), 
         "<br> p-value:", pval)
  })
  
  output$PhenologyPlot <- renderPlot({
    ggplot(data = phen.data(), aes_string(x = input$x, y = 'doy')) +
      geom_point() +
      geom_smooth(method = "lm", se = F) +
      facet_wrap(~Species, ncol = 2, scales = "free") +
      theme_bw() + ylab("First flowring date (day of year)") + xlab("Temperature (°C)") +
      theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12), 
            legend.text = element_text(size = 12), legend.title = element_text(size = 12))
  })
  
})