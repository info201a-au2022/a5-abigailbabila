library(dplyr)
library(shiny)
library(ggplot2)
library(plotly)

## data + refining
co2_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv"
co2_data <- na.omit(co2_data)
View(co2_data)

## chart
get_co2 <- function(country) {
  df <- co2_data %>%
    group_by(year,country) %>%
    summarise(co2= sum(co2))
  df <- df %>% filter(country %in% country)
  return(df)
}

plot_co2 <- function(country) {
  p <- ggplot(get_co2(country), aes(x=year, y=co2, group=country, color=country))+geom_line()
  return(p)
}

plot_co2()

plot_co2 <- ggplotly(plot_co2())
plot_co2
