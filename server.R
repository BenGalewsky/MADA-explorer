source('init.R')

function(input, output, session) {

  output$yearSelector <- renderUI({
    if (input$timeMode == 'One year') {
      list(
        sliderInput('yr', 'Year:', min = 1200, max = 2012, value = 2012 ),
        textInput('yrTxt', 'Year:', 2012)
      )
    } else {
      list(
        sliderInput('yr', 'Year:', min = 1200, max = 2012, value = c(1913, 2012)),
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
    if (length(yr) > 0) {
      if (length(yr) == 1) {
        DT1 <- madaVN[year == yr]
        DT2 <- recVN[year == yr]
        limits1 <- c(-8, 8)
        limits2 <- c(-3, 3)
      } else {
        DT1 <- madaVN[year %between% yr,
                   .(pdsi = mean(pdsi, na.rm = TRUE)),
                   by = .(long, lat)]
        DT2 <- recVN[year %between% yr,
                    .(z = mean(z, na.rm = TRUE)),
                    by = .(id, long, lat)]
        limits1 <- abs_range(DT1$pdsi)
        limits2 <- abs_range(DT2$z)
      }
      p1 <- ggplot() +
        geom_tile(aes(long, lat, fill = pdsi), DT1, width = 1, height = 1) +
        geom_sf(data = vn, fill = NA, color = 'gray') +
        scale_fill_distiller(palette = 'RdBu', limits = limits1, name = 'PDSI', direction = 1)

      p2 <- ggplot() +
        geom_sf(data = vn, fill = NA, color = 'gray') +
        geom_line(aes(long, lat, color = z, group = id), DT2) +
        scale_color_distiller(palette = 'RdBu', limits = limits2, name = 'Streamflow\nindex', direction = 1)

      pl <- p1 + p2 & theme_map()
      pl
    }
  })
}
