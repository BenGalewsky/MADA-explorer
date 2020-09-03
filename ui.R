source('init.R')

fluidPage(

  # Application title
  titlePanel("MADA Explorer"),

  # Sidebar with a slider input for year
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        'timeMode',
        'Time slice mode:',
        choices = c('One year', 'Multi-year average')
      ),
      uiOutput('yearSelector')
    ),

    # Show a plot of the selected year
    mainPanel(
      plotOutput('madaPlot', width = 1000, height = 750)
    )
  )
)
