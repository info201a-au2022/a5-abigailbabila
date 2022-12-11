
## server input

server <- function(input, output, session) {
  output$line_plot_country <- renderPlotly(
    plot_line(data, 
              country1 = input$choose_country,
              col_name1 = input$select_variable1,
              date1 = input$dateRange[1], 
              date2 = input$dateRange[2])
  )

  output$percent_difference_co2_per_capita <- DT::renderDT(
    percent_difference_co2_per_capita
  )
  output$percent_difference_co2_growth_abs <- DT::renderDT(
    percent_difference_co2_growth_abs
  )
  output$percent_difference_coal_co2 <- DT::renderDT(
    percent_difference_coal_co2
  )
  
}

