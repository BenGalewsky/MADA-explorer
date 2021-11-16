source('init.R')

fluidPage(

  # Application title
  titlePanel("MADA and Streamflow in Vietnam"),

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
      plotOutput('madaPlot', width = 1000, height = 750),
      HTML('
        <div style="position: relative; bottom: 0; left: 0; width: 100%; text-align: right;">
          <br>
          <p> This is a prototype, version 0.0.0.9000. </p>
          <p> Author: Nguyen Tan Thai Hung </p>
        </div>'
      )
    )
  )
)

          # <a href="https://github.com/ntthung/MADA-explorer">GitHub</a>
