library(shinythemes)

fluidPage(theme = shinytheme("cerulean"),
  #shinythemes::themeSelector('cerulean'), 
  navbarPage("Consumer Complaints Analysis",
    tabPanel("Project Summary", 
      fluidPage(
        mainPanel(
          ncludeHTML("index.html")
        )
      )
    ),
    
    tabPanel("Complaints Trend",
      fluidPage(
        headerPanel('Mortality Rate'),
          mainPanel(
            fluidRow(
              column(3, selectInput('year', 'Year', unique(df$Year), selected='2010')),
              column(9, selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms'))
            ),
            tabsetPanel(
              tabPanel("GGPlot", plotOutput('plot1')),
              tabPanel("GoogleVis", htmlOutput('plot2')),
              tabPanel("Plotly", plotlyOutput('plot3')),
              tabPanel("Vegalite", vegaliteOutput('plot4')
            )
          )
        )
      )
    ),
    tabPanel("Analysis by State"),
    tabPanel("Company Performance"),
    tabPanel("Channel Analysis"),
    tabPanel("Response Time Analysis"),
    tabPanel("Consumer Disputes")

  )
)
