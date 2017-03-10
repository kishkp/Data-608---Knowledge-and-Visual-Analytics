<<<<<<< HEAD
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

# fluidPage(
#   headerPanel('Mortality Rate'),
#   sidebarPanel(
#     selectInput('year', 'Year', unique(df$Year), selected='2010'),
#     selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms')
#   ),
#   mainPanel(
#     tabsetPanel(tabPanel("GGPlot",     plotOutput('plot1')),
#                   tabPanel("GoogleVis", htmlOutput('plot2')), 
#                   tabPanel("Plotly", plotlyOutput('plot3'))
#                 # tabPanel("Vegalite", plotOutput('plot1'))
#                 )
#     )
# )
=======
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

# fluidPage(
#   headerPanel('Mortality Rate'),
#   sidebarPanel(
#     selectInput('year', 'Year', unique(df$Year), selected='2010'),
#     selectInput('disease', 'Disease', unique(df$ICD.Chapter), selected='Neoplasms')
#   ),
#   mainPanel(
#     tabsetPanel(tabPanel("GGPlot",     plotOutput('plot1')),
#                   tabPanel("GoogleVis", htmlOutput('plot2')), 
#                   tabPanel("Plotly", plotlyOutput('plot3'))
#                 # tabPanel("Vegalite", plotOutput('plot1'))
#                 )
#     )
# )
>>>>>>> 0ed2cfae5097ef811c1c384edf39a9fede104d19
