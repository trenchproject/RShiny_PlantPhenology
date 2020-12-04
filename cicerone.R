guide1 <- Cicerone$
  new()$
  step(
    el = "ClimatePlot",
    title = "Visualization",
    description = HTML("The plot shows the mean temperature in January since 1893. Each point represents a year, and the blue line shows the trend.
                       We can see a slight upward trend but is the trend significant? Hit next."),
    position = "top"
  )$
  step(
    el = "stats",
    title = "Statistics",
    description = HTML("The slope tells us that the temperature in January is only increasing by 0.0041 &deg;C per year. A p-value greater than 0.05 means that the trend is not significant.
                       In other words, the slope of the trendline is not significantly different from 0.")
  )$
  step(
    el = "month1-wrapper",
    title = "Month selection",
    description = HTML("Here, you can choose a month you want to plot. 
                       There are options for annual and <b>January through April</b>, which is especially relavent for plants phenology.")
  )$
  step(
    el = "year-wrapper",
    title = "Year slider",
    description = "Lastly, you can specify specific periods to see if the trends have been fluctiating or consistent."
  )


guide2 <- Cicerone$
  new()$
  step(
    el = "viz-wrapper",
    title = "Visualization",
    description = HTML("The plot currently shows the relationship between mean January temperature and the first flowering date of <em>Amelanchier canadensis</em>.")
  )$
  step(
    el = "PhenologyPlotly",
    title = "Phenology plot",
    description = HTML("Each data point represents a year. Try hovering over the point on the far right. 
                       It tells you that in 2006, the average temperature in January was 0.9 &deg;C and <em>A. canadensis</em> first flowered at day 111, or late April.
                       <br>You can also see a clear downward trend, which interprets that <em>A. canadensis</em> has an earlier flowering date as January temperature increases.
                       <br>Let's see the phenology of other species. Hit next.")
  )$
  step(
    el = "month2-wrapper",
    title = "Month",
    description = "This shows the month plotted. Try selecting <b>April</b> and hit next.",
    position = "right"
  )$
  step(
    el = "spec-wrapper",
    title = "Species selection",
    description = HTML("Here, you can select which species to plot. Let's select all species by clicking on <b>Select All</b> and move on."),
    position = "right"
  )$
  step(
    el = "PhenologyPlotly",
    title = "New plot!",
    description = HTML("Now, we have more data points and lines on the plot. Do you see any trend?
                       Notice that some lines are solid while others are dotted. The solid lines indicate that the trend is significant while the dotted lines don't.")
  )$
  step(
    el = "viz-wrapper",
    title = "End of tour",
    description = "That's it for the tour. Try selecting months and species you like to see!"
  )