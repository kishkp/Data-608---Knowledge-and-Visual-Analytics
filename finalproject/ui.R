library(shiny)
library(shinythemes)
library(dplyr)
library(googleVis)
library(plotly)
library(data.table)
library(RJSONIO)
library(lazyeval)

fluidPage(theme = shinytheme("cerulean"),
  #shinythemes::themeSelector('cerulean'),
  navbarPage("Consumer Complaints Analysis", id = "tabs",
    tabPanel("Project Summary", value = "PS",  
      fluidPage(
        mainPanel(
          includeHTML("html/ProjectBrief.html")
        )
      )
    ),
    
    tabPanel("Complaints Trend", value = "CT",
      fluidPage(
        sidebarLayout(
          sidebarPanel(
            includeHTML("html/ComplaintsTrend_Brief.html"),
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
    
    tabPanel("Analysis by State", value = "AS",
      fluidPage(
        sidebarLayout(
          sidebarPanel(
            includeHTML("html/AnalysisByState_Brief.html"),
            selectInput(inputId = "AS_Comp", label = "Company :", choices = c('Amex', 'Bank of America', 'Capital One', 'Citibank', 
                          'Ditech Financial LLC', 'Encore Capital Group', 'Equifax', 'Experian', 'JPMorgan Chase & Co.', 'Nationstar Mortgage', 
                          'Navient Solutions, LLC.', 'Ocwen', 'Others', 'PNC Bank N.A.', 'Synchrony Financial', 
                          'TransUnion Intermediate Holdings, Inc.', 'U.S. Bancorp', 'Wells Fargo & Company')),
            selectInput(inputId = "AS_Prod", label = "Product :",  choices = c('Bank account or service', 'Consumer Loan', 'Credit card', 
                          'Credit reporting', 'Debt collection', 'Mortgage', 'Others', 'Student Loan')),
            width=3),
          mainPanel(
            includeHTML("html/AnalysisByState.html")
          )
        )
      )
    ),
    
    tabPanel("Company Performance", value = "CP",
      fluidPage(
        sidebarLayout(
          sidebarPanel(
            includeHTML("html/CompanyPerformance_Brief.html"),
            radioButtons("CP_fact", "",
                         c("Complaints" = "Complaints", "Timely" = "Timely_Count", 
                           "Disputed" = "Disputed_Count"), selected = "Complaints"),
            tags$p(tags$b("Levels:"), "You can select which levels to include to drill into."),
            checkboxGroupInput("CP_dims", "",
                               c("Product" = "Product",
                                 "Channel" = "Channel",
                                 "Status" = "Status")),
            width=3),
          mainPanel(
            includeHTML("html/CompanyPerformance.html")
          )
        )
      )
    ),
    tabPanel("Channel Analysis", value = "CA",
      fluidPage(
        sidebarLayout(
          sidebarPanel(
            includeHTML("html/channelAnalysis_Brief.html"),
            radioButtons("CA_fact", "",
                         c("Complaints" = "Complaints", "Timely" = "Timely_Count", 
                           "Disputed" = "Disputed_Count"), selected = "Complaints"),
            selectInput(inputId = "CA_Comp", label = "Company :", choices = c('Amex', 'Bank of America', 'Capital One', 'Citibank', 
                                                                              'Ditech Financial LLC', 'Encore Capital Group', 'Equifax', 'Experian', 'JPMorgan Chase & Co.', 'Nationstar Mortgage', 
                                                                              'Navient Solutions, LLC.', 'Ocwen', 'Others', 'PNC Bank N.A.', 'Synchrony Financial', 
                                                                              'TransUnion Intermediate Holdings, Inc.', 'U.S. Bancorp', 'Wells Fargo & Company')),
            selectInput(inputId = "CA_Prod", label = "Product :",  choices = c('Bank account or service', 'Consumer Loan', 'Credit card', 
                                                                               'Credit reporting', 'Debt collection', 'Mortgage', 'Others', 'Student Loan')),
            width=3),
          mainPanel(
            fluidRow(plotlyOutput(outputId = "CA_timeseries", height = "300px")),
            fluidRow(plotlyOutput(outputId = "CA_heatmap", height = "300px"))
          )
        )
      )        
    )
  )
)
