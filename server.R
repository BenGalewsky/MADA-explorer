source('init.R')

function(input, output, session) {

  output$yearSelector <- renderUI({
    if (input$timeMode == 'One year') {
      list(
        sliderInput('yr', 'Year:', min = 0, max = 2012, value = 2012 ),
        textInput('yrTxt', 'Year:', 2012)
      )
    } else {
      list(
        sliderInput('yr', 'Year:', min = 0, max = 2012, value = c(1913, 2012)),
        textInput('yrStt', 'Start year:', 1913),
        textInput('yrEnd', 'End year:', 2012)
      )
    }
  })

  observeEvent(input$yrTxt, {
    if (input$yrTxt != '' & as.numeric(input$yrTxt) != input$yr)
      updateSliderInput(session, 'yr', value = input$yrTxt)
  })

  observeEvent(input$yrStt, {
    if (input$yrStt != '' & as.numeric(input$yrStt) != input$yr[1])
      updateSliderInput(session, 'yr', value = c(input$yrStt, input$yr[2]))
  })

  observeEvent(input$yrEnd, {
    if (input$yrEnd != '' & as.numeric(input$yrEnd) != input$yr[2])
      updateSliderInput(session, 'yr', value = c(input$yr[1], input$yrEnd))
  })

  observeEvent(input$yr, {
    if (input$timeMode == 'One year') {
      if (input$yrTxt != '' & as.numeric(input$yrTxt) != input$yr) {
        updateTextInput(session, 'yrTxt', value = input$yr)
      }
    } else { # Multi-year
      if (input$yrStt != '' & input$yrEnd != '') {
        if (as.numeric(input$yrStt) != input$yr[1]) {
          updateTextInput(session, 'yrStt', value = input$yr[1])
        }
        if (as.numeric(input$yrEnd) != input$yr[2]) {
          updateTextInput(session, 'yrEnd', value = input$yr[2])
        }
      }
    }
  })

  output$madaPlot <- renderPlot({
    yr <- input$yr
    if (length(yr) == 1) {
      DT <- mada[year == yr]
      limits <- c(-13.25, 13.25)
      breaks <- -13:13
    } else {
      DT <- mada[year %between% yr,
                 .(pdsi = mean(pdsi, na.rm = TRUE)),
                 by = .(long, lat)]
      limits <- abs_range(DT$pdsi)
      breaks <- seq(limits[1], limits[2], length.out = 18)
    }
    ggplot(DT) +
      geom_tile(aes(long, lat, fill = pdsi)) +
      geom_sf(data = countries, fill = NA, size = 0.25) +
      scale_fill_stepsn(
        name = 'PDSI',
        colours = c(rev(brewer.pal(9, 'Reds')), brewer.pal(9, 'Blues')),
        breaks = breaks,
        limits = limits
      ) +
      labs(x = NULL, y = NULL) +
      coord_sf(xlim = xRange, ylim = yRange, expand = FALSE) +
      theme_bw() +
      theme(
        text = element_text(size = 20),
        legend.key.height = unit(8, 'lines')
      )

  })
}
