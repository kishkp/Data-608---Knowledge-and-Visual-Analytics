fluidPage(
  headerPanel('Mortality Rate'),
  # sidebarPanel(
  #   selectInput('year', 'Year', unique(df$Year), selected='2010'),
  #   selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms')
  # ),
  mainPanel(
   fluidRow(
      column(3,
             selectInput('year', 'Year', unique(df$Year), selected='2010')),
      column(9,
             selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms'))
   ),
   tabsetPanel(tabPanel("GGPlot",     plotOutput('plot1')),
                      tabPanel("GoogleVis", htmlOutput('plot2')),
                      tabPanel("Plotly", plotlyOutput('plot3')),
                      tabPanel("Vegalite", vegaliteOutput('plot4'))
                    )
   )
)

