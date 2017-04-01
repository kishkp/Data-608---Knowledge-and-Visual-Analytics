fluidPage(
  headerPanel('Mortality Rate'),
  # sidebarPanel(
  #   selectInput('year', 'Year', unique(df$Year), selected='2010'),
  #   selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms')
  # ),
  mainPanel(
    fluidRow(
      column(6,
             selectInput("State", "State: (Multi Select)", unique(df$State), selected = "Nat Avg", multiple = TRUE)),
      column(6,
             selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms'))
    ),
      tabsetPanel(tabPanel("GGPlot",     plotOutput('plot1')),
                      tabPanel("GoogleVis", htmlOutput('plot2')),
                      tabPanel("Plotly", plotlyOutput('plot3')),
                      tabPanel("Vegalite", vegaliteOutput('plot4'))
                    )
        )
  )
=======
fluidPage(
  headerPanel('Mortality Rate'),
  # sidebarPanel(
  #   selectInput('year', 'Year', unique(df$Year), selected='2010'),
  #   selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms')
  # ),
  mainPanel(
    fluidRow(
      column(6,
             selectInput("State", "State: (Multi Select)", unique(df$State), selected = "Nat Avg", multiple = TRUE)),
      column(6,
             selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms'))
    ),
      tabsetPanel(tabPanel("GGPlot",     plotOutput('plot1')),
                      tabPanel("GoogleVis", htmlOutput('plot2')),
                      tabPanel("Plotly", plotlyOutput('plot3')),
                      tabPanel("Vegalite", vegaliteOutput('plot4'))
                    )
        )
  )

