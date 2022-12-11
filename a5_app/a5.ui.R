library(shiny)
library(dplyr)
library(maps)
library(leaflet)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(shinythemes)
library(rio)
library(DT)
library(stargazer)

highest_co2_per_capita$co2_per_capita

ui <- 
  fluidPage(
    theme = bslib::bs_theme(bootswatch = "united"),
    tabsetPanel(
      tabPanel("Introduction", 
               fluidPage(
                 
                 titlePanel("CO2 Emission Trends and How It Impacts Climate Change"),
                 hr(),
                 p("Carbon dioxide (CO2) is an essential chemical compound found in the world. It’s the most important greenhouse gas and has the ability to absorb and trap heat in Earth’s atmosphere. All living organisms need CO2 to survive and thrive in their environment. However, too much of this chemical compound can be detrimental to the Earth."),
                 p("Recently, the world has been suffering from a steady increase of CO2 which has resulted in a warming of Earth’s atmosphere. This is heavily a result of the habits humans have the involve CO2. This increase in temperature has led to some climates not being sustainable for the life that supports it. This leads to ecosystems dying off, species becoming extinct, and overall quality of human health to diminish. This concept is called climate change."),
                 p("To better understand analyze the root cause of climate change, we used data collected from Our World in Data to pinpoint what factors are causing these global CO2 emission trends. "),
                 p("From this data, we looked at three important variables and their relationship with each other."),
                 tags$ul(
                   tags$li(tags$b("CO2 Emissions Per Capita (co2_per_capita)")),
                   tags$li(tags$b("Absolute Growth of CO2 (co2_growth_abs)")),
                   tags$li(tags$b("CO2 Emissions From Coal (coal_co2)"))
                 ),
                 p("After investigating the data, we found important average values regarding the variables studied.These results are collected from 2021.")
                    tags$li("Average value of CO2 emissions per captia (co2_per_capita) in the world:",round(co2_per_capita_average,2)),
                    tags$li("Average value of absolute growth of CO2(co2_growth_abs) in the world:",round(co2_growth_abs_average,2)),
                    tags$li("Average value of CO2 emissions from coal (coal_co2) in the world:",round(coal_co2_average,2))
                 ),
                 p("We also found highest and lowest values of CO2 emissions from these values")
                         tags$li("Highest value of CO2 emissions per captia (co2_per_capita) in the world:",round(highest_co2_per_capita,2),"in",highest_co2_per_capita$year,"for: ",highest_co2_per_capita$country),
                         tags$li("Lowest value of CO2 emissions per captia (co2_per_capita) in the world",round(min_co2_per_capita$co2_per_capita,2),"in",lowest_co2_per_capita$year,"for: ",lowest_co2_per_capita$country),
                         
                         tags$li("Highest value of absolute growth of CO2(co2_growth_abs) in the world:",round(highest_co2_growth_abs$co2_growth_abs,2),"in",highest_co2_growth_abs$year,"for: ",max_co2_growth_abs$country),
                         tags$li("Lowest value of absolute growth of CO2(co2_growth_abs) in the world:",round(lowest_co2_growth_abs$co2_growth_abs,2),"in",lowest_co2_growth_abs$year,"for: ",lowest_co2_growth_abs$country),
                         
                         tags$li("Highest value of CO2 emissions from coal (coal_co2) in the world:",round(highest_coal_co2$oil_co2,2),"in",highest_coal_co2$year,"for country : ",highest_coal_co22$country),
                         tags$li("Lowest value of CO2 emissions from coal (coal_co2) in the world",round(min_oil_co2$oil_co2,2),"in",lowest_coal_co22$year,"for country : ",lowest_coal_co2$country),
                         
                 ),
                 p("These are the percent change the variables studied from 1960-2021")),
                 p(tags$b("Percentage change of CO2 emissions per captia (co2_per_capita:)"))
                 DT::dataTableOutput("percent_difference_co2_per_capita"),
                 p(tags$b("Percentage change of absolute growth of CO2(co2_growth_abs:)")),
                 DT::dataTableOutput("percent_difference_co2_growth_abs"),
                 p(tags$b("Percentage change of CO2 emissions from coal (coal_co2:)")),
                 DT::dataTableOutput("percent_difference_coal_co2")
               )
      ),
      tabPanel("Interactive Visualization",
               fluidPage(
                 
                 titlePanel("Line Graph"),
                 sidebarLayout(
                   
                   sidebarPanel(
                     # selector for Country
                     h3("CO2 Emissions for Each Country Throughout Years"),
                     selectInput(
                       inputId = "choose_a_country",
                       label = "Choose a country",
                       choices =unique(data$country),
                       selected = "United States",
                       multiple = FALSE
                     ),
                     selectInput(
                       inputId = "select_variable1",
                       label = "Choose a Variable",
                       choices = c("co2_per_capita","co2_growth_abs","coal_co2"),
                       selected = "co2_per_capita",
                       multiple = FALSE
                     ),
                     dateRangeInput('dateRange',label = "Select Years : ",format = "yyyy",start = '1960-01-01', end='2021-01-01',startview = "year",separator = " - "),
                     br(),
                     br(),
                     br(),
                   mainPanel(
                     # epicurve goes here
                     plotlyOutput("plot_bar_country"),
                     p('Caption : The above bar graph shows the relationship between selected variables of CO2 and year for different countries.In the year 2021 the Co2 per Capita has incresased for all the countries.'),
                     plotlyOutput("plot_line_country"),
                     p('Caption : The line bar is controlled by the Country, variable for co2 & year range. From yaer 1991 to 2021, almost all the counties have started reocding their co2 varaibles.'),
                     plotlyOutput("plot_group_bar"),
                     p('Caption : Group bar chart for all the co2 related varaibles by country.')
                   )
                   
                 )
               )
      )
    )
  )





# Define UI for application that draws a histogram
#shinyUI(fluidPage(

    # Application title
#    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
#    sidebarLayout(
#        sidebarPanel(
#            sliderInput("bins",
                        "Number of bins:",
#                        min = 1,
#                       max = 50,
#                        value = 30)
#        ),

        # Show a plot of the generated distribution
#        mainPanel(
#            plotOutput("distPlot")
#        )
#    )
#))
