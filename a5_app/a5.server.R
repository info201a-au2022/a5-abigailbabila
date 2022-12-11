library(shiny)
library(ggplot2)
library(plotly)
library(dplyr)
library(tidyverse)
library(shinydashboard)
library(leaflet)
library(maps)
library(DT)
library(stargazer)
library(corrplot)
library(zoo)
library(caret)
library(caTools)
library(broom)
library(MASS)

## data + refining
co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")
co2_data <- na.omit(co2_data)
co2_data  = subset(co2_data, select = -c(iso_code))
cols <- c("co2_per_capita","co2_growth_abs","coal_co2")
co2_data

data <- co2_data %>% 
  group_by(year) %>% 
  mutate(co2_per_capita = ifelse(is.na(co2_per_capita), mean(co2_per_capita, na.rm = T), co2_per_capita))
data <- co2_data %>%
  group_by(year) %>%
  mutate(co2_growth_abs = ifelse(is.na(co2_growth_abs), mean(co2_growth_abs, na.rm = T), co2_growth_abs))
data <- co2_data %>%
  group_by(year) %>%
  mutate(coal_co2 = ifelse(is.na(coal_co2), mean(coal_co2, na.rm = T), coal_co2))

data <- data[,c("country","year","co2_per_capita","co2_growth_abs","coal_co2")] 

## data averages
co2_per_capita_average <- data.frame(data %>% 
                                       filter(year == 2021) %>% 
                                       summarize(Mean = mean(co2_per_capita))) %>% pull(Mean)
co2_growth_abs_average <- data.frame(data %>% 
                                       filter(year == 2021) %>% 
                                       summarize(Mean = mean(co2_growth_abs))) %>% pull(Mean)
coal_co2_average <- data.frame(data %>% 
                                 filter(year == 2021) %>% 
                                 summarize(Mean = mean(coal_co2))) %>% pull(Mean)
                               
temp <- data.frame(data %>% filter(!country %in% c('World','Asia')))

## max and min of data

highest_co2_per_capita <- data.frame(temp[which.max(temp$co2_per_capita),])
lowest_co2_per_capita <- data.frame(temp[which.min(temp$co2_per_capita),])

highest_co2_growth_abs <- data.frame(temp[which.max(temp$co2_growth_abs),])
lowest_co2_growth_abs <- data.frame(temp[which.min(temp$co2_growth_abs),])

highest_coal_co2 <- data.frame(temp[which.max(temp$coal_co2),])
lowest_coal_co2 <- data.frame(temp[which.min(temp$coal_co2),])

## difference in data
data_co2 <- data %>%
  filter(year %in% c(1960:2021))%>%
  arrange(country, year) %>%
  group_by(country) %>%
  mutate(
    difference_co2_per_capita = co2_per_capita - lag(co2_per_capita),
    difference_co2_growth_abs = co2_growth_abs - lag(co2_growth_abs),
    difference_coal_co2 = coal_co2 - lag(coal_co2)
  )

## difference in percentage
percent_difference_co2_per_capita <- data.frame(data_co2 %>%
                                       group_by(country) %>% 
                                       summarise(co2_per_capita_difference = ((max(co2_per_capita) - min(co2_per_capita))/min(co2_per_capita))*100))

percent_difference_co2_growth_abs <-data.frame(data_co2 %>%
                                                group_by(country) %>%
                                                summarise(co2_growth_abs_difference = ((max(co2_growth_abs) - min(co2_growth_abs))/min(co2_growth_abs))*100))

percent_difference_coal_co2 <- data.frame(data_co2 %>%
                                         group_by(country) %>%
                                         summarise(coal_co2_difference = ((max(coal_co2) - min(coal_co2))/min(coal_co2))*100))


pacman::p_load("tidyverse", "lubridate", "shiny")

## line graph

plot <- function(data, country1 = 'Afghanistan', col_name = 'co2_per_capita',date1,date2) {
  
  
  date1 <- format(as.Date(date1, format="%d/%m/%Y"),"%Y")
  date2 <- format(as.Date(date2, format="%d/%m/%Y"),"%Y")
  
  data <- data %>%
    filter(year %in% (as.numeric(date1):as.numeric(date2)) )
  View(data)
  data_fun <- data.frame(data %>% 
                           filter(country == country1))
  graph <- plot_ly(data_fun, x = data_fun$year, y = data_fun[[col_name1]], name = col_name1, mode = 'lines+markers') 
  graph <- graoh %>% layout(title = stringr::str_glue("Line Graph for - {country1} for {col_name1}."),
                        xaxis = list(title = ""),
                        yaxis = list(title = ""))
  return(graph)
}

## server input

server <- function(input, output, session) {
  output$line_plot_country <- renderPlotly(
    plot_line(data, country1 = input$select_country,col_name1 = input$select_variable1,date1 = input$dateRange[1], date2 = input$dateRange[2])
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

