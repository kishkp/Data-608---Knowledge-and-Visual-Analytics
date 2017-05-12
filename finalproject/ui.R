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
        sidebarLayout(
          sidebarPanel(
            includeHTML("ComplaintsTrend_Brief.html"),
            radioButtons("CT_dim", "Dimension:",
                         c("State" = "State", "Product" = "Product", "Company Response" = "CompPubResp",
                           "Company" = "Company", "Channel" = "Channel", "Status" = "Status"), selected = "Product"),
            width=4),
          mainPanel(
            htmlOutput('plot1')
          )
        )
      )  
    ),
    tabPanel("Analysis by State",
      fluidPage(
        sidebarLayout(
          sidebarPanel(
            includeHTML("AnalysisByState_Brief.html"),
            selectInput("AS_Comp", "Company :", c('Amex', 'Bank of America', 'Capital One', 'Citibank', 
                          'Ditech Financial LLC', 'Encore Capital Group', 'Equifax', 'Experian', 'JPMorgan Chase & Co.', 'Nationstar Mortgage', 
                          'Navient Solutions, LLC.', 'Ocwen', 'Others', 'PNC Bank N.A.', 'Synchrony Financial', 
                          'TransUnion Intermediate Holdings, Inc.', 'U.S. Bancorp', 'Wells Fargo & Company'), TRUE),
            selectInput("AS_Prod", "product :",  c('Bank account or service', 'Consumer Loan', 'Credit card', 
                          'Credit reporting', 'Debt collection', 'Mortgage', 'Others', 'Student Loan'), TRUE),
            width=3),
          mainPanel(
            includeHTML("AnalysisByState.html")
          )
        )
      )
    ),
    tabPanel("Company Performance",
      fluidPage(
        mainPanel(
          includeHTML("companyperformance.html")
        )
      )
    ),
    tabPanel("Channel Analysis"),
    tabPanel("Response Time Analysis"),
    tabPanel("Consumer Disputes")

  )
)
