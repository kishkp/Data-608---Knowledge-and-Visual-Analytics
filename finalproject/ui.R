library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(googleVis)
library(plotly)
library(jsonlite)
library(vegalite)
library(reshape2)
library(data.table)


fluidPage(theme = shinytheme("cerulean"),
  #shinythemes::themeSelector('cerulean'), 
  navbarPage("Consumer Complaints Analysis",
    tabPanel("Project Summary", 
      fluidPage(
        mainPanel(
          includeHTML("ProjectBrief.html")
        )
      )
    ),
    
    tabPanel("Complaints Trend",
      fluidPage(
          mainPanel(
            fluidRow(
              radioButtons("dim", "Dimension:",
                           c("State" = "State",
                             "Product" = "Product",
                             "Company Public response" = "CompPubResp",
                             "Company" = "Company",
                             "Channel" = "Channel",
                             "Status" = "Status"
                             ), selected = "Product"
                           )
            ),
            htmlOutput('plot1')
          )
      )
    ),
    tabPanel("Analysis by State",
      fluidPage(
        mainPanel(
          includeHTML("AnalysisByState.html")
        )
      )
    ),
    tabPanel("Company Performance"),
    tabPanel("Channel Analysis"),
    tabPanel("Response Time Analysis"),
    tabPanel("Consumer Disputes")

  )
)
