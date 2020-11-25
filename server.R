#Plant phenology
source("cicerone.R", local = T)

# Load data
clim.dat = read.csv("Ex2_climatedata.csv")
phen.dat=read.csv("Ex2_phenologydata_long.csv")
specs <- c("Amelanchier canadensis", "Cichorium intybus", "Erigeron canadensis", "Erigeron pulchellus", "Vaccinium corymbosum")

for (i in c(1:123)) {
  clim.dat$JanApr[i] <- mean(c(clim.dat$Jan[i], clim.dat$Feb[i], clim.dat$Mar[i], clim.dat$Apr[i]), na.rm = T)
}

for (i in c(1:75)) {
  phen.dat$JanApr[i] <- mean(c(phen.dat$Jan[i], phen.dat$Feb[i], phen.dat$Mar[i], phen.dat$Apr[i]), na.rm = T)
}

# Define server logic to do filtering
shinyServer(function(input, output) {
  
  observeEvent(input$tour1, guide1$init()$start())
  
  observeEvent(input$reset1, {
    reset("month-wrapper")
    reset("year-wrapper")
  })
  
  observeEvent(input$tour2, guide2$init()$start())
  
  observeEvent(input$reset2, {
    reset("month")
    reset("species")
  })
  
  clim.data <- reactive({
    #restrict years
    x <- strsplit(as.character(input$year), "\\s+")
    clim.dat %>% filter(Year >= as.numeric(x[1]) & Year <= as.numeric(x[2]))
    })
  
  #pick species
  phen.data <- reactive({
    phen.dat %>% filter(Species %in% input$species)
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
    
    HTML("<b>Stats</b>
         <br>Slope:", signif(as.numeric(fit$coefficients[2]), digits = 2), "°C/year",
         "<br> p-value:", pval)
  })
  
  output$PhenologyPlot <- renderPlot({
    ggplot(data = phen.data(), aes_string(x = input$month, y = 'doy')) +
      geom_point() +
      geom_smooth(method = "lm", se = F) +
      facet_wrap(~Species, ncol = 2, scales = "free") +
      theme_bw() + ylab("First flowring date (day of year)") + xlab("Temperature (°C)") +
      theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12), 
            legend.text = element_text(size = 12), legend.title = element_text(size = 12))
  })
  
  
  output$PhenologyPlotly <- renderPlotly({
    validate(
      need(input$species, "Select species")
    )
    df <- phen.data()
    xvar <- df[, input$month]
    
    pal <- c('#d7191c', '#fdae61', 'black', 'green', '#2c7bb6')
    pal <- setNames(pal, specs)  
    p <- plot_ly() %>%
      add_markers(x = ~xvar, 
                  y = ~df$doy, 
                  color = ~df$Species, 
                  colors = pal, 
                  type = "scatter",
                  text = paste0("<br>Year: ", df[, "year"]),
                  hovertemplate = "(%{x}, %{y}) %{text}") %>%
      layout(xaxis = list(title = "Temperature (°C)"),
             yaxis = list(title = "First flowring date (day of year)"))
    
    array <- input$species
    for (i in 1:length(array)) {
      species <- array[i]
      subset <- df[df$Species == species, ][, c("year", "doy", input$month, "Species")] %>% na.omit()
      fit <- lm(subset[, "doy"] ~ subset[, input$month])

      if (dim(summary(fit)$coefficients) > 1) {
        linetype <- ifelse(signif(summary(fit)$coefficients[2,4], digits = 2) < 0.05, "solid", "dash")
        
        p <- p %>% 
          add_lines(x = subset[, input$month], 
                    y = fitted(fit), 
                    color = subset[, "Species"], 
                    colors = pal, 
                    name = paste(species, "trendline"), 
                    line = list(dash = linetype), 
                    mode = "lines")
      }
    }

    p
  })
  
})