library(ggplot2)
library(dplyr)
library(googleVis)
library(plotly)
library(jsonlite)
library(vegalite)
#library(quantmod)
#library(reshape2)

df <- read.csv('https://raw.githubusercontent.com/kishkp/Data-608---Knowledge-and-Visual-Analytics/master/lecture3/Data/cleaned-cdc-mortality-1999-2010-2.csv', stringsAsFactors = FALSE)

function(input, output, session) {
  
  selectedData <- reactive({
    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))
  })
  
  # selectedGGPlotData <- reactive({
  #   dfSlice <- df %>%
  #     filter(Year == input$year, ICD.Chapter == input$disease) %>%
  #     select(State, Crude.Rate) %>%
  #     arrange(desc(Crude.Rate))
  # })
  # 
  # selectedGVisData <- reactive({
  #   dfSlice <- df %>%
  #     filter(Year == input$year, ICD.Chapter == input$disease) %>%
  #     select(State, Crude.Rate) %>%
  #     arrange(desc(Crude.Rate))
  # })
  # 
  # selectedPlotlyData <- reactive({
  #   dfSlice <- df %>%
  #     filter(Year == input$year, ICD.Chapter == input$disease) %>%
  #     select(State, Crude.Rate) %>%
  #     arrange(desc(Crude.Rate))
  # })

  output$plot1 <- renderPlot({
    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))
    
    ggplot(selectedData(), aes(x = State, y = Crude.Rate)) +
    geom_bar(stat='identity') +
    scale_x_discrete(limits = dfSlice$State)
  })

  output$plot2 <- renderGvis({
    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))
    gvisColumnChart(selectedData())
  })

  output$plot3 <- renderPlotly({
    
    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))

    xform <- list(categoryorder = "array",
                  categoryarray = dfSlice$State)

    plot_ly(selectedData(), x = ~State, y = ~Crude.Rate, type='bar') %>%
      layout(xaxis = xform)
  })

  output$plot4 <- renderVegalite({

    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))
    
    colnames(dfSlice) <- c("State", "CrudeRate")
    

    vegalite(viewport_height=250) %>%
      add_data(dfSlice) %>%
      encode_x("State", "nominal") %>%
      encode_y("CrudeRate", "quantitative") %>%
#      encode_order("State", "nominal", sort="descending") %>%
      mark_bar()    
    
  })
=======
library(ggplot2)
library(dplyr)
library(googleVis)
library(plotly)
library(jsonlite)
library(vegalite)
#library(quantmod)
#library(reshape2)


df <- read.csv('D:/CUNY/Courses/Data 608 - Knowledge and Visual Analytics/Data-608---Knowledge-and-Visual-Analytics/lecture3/Data/cleaned-cdc-mortality-1999-2010-2.csv', stringsAsFactors = FALSE)

function(input, output, session) {
  
  selectedData <- reactive({
    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))
  })
  
  # selectedGGPlotData <- reactive({
  #   dfSlice <- df %>%
  #     filter(Year == input$year, ICD.Chapter == input$disease) %>%
  #     select(State, Crude.Rate) %>%
  #     arrange(desc(Crude.Rate))
  # })
  # 
  # selectedGVisData <- reactive({
  #   dfSlice <- df %>%
  #     filter(Year == input$year, ICD.Chapter == input$disease) %>%
  #     select(State, Crude.Rate) %>%
  #     arrange(desc(Crude.Rate))
  # })
  # 
  # selectedPlotlyData <- reactive({
  #   dfSlice <- df %>%
  #     filter(Year == input$year, ICD.Chapter == input$disease) %>%
  #     select(State, Crude.Rate) %>%
  #     arrange(desc(Crude.Rate))
  # })

  output$plot1 <- renderPlot({
    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))
    
    ggplot(selectedData(), aes(x = State, y = Crude.Rate)) +
    geom_bar(stat='identity') +
    scale_x_discrete(limits = dfSlice$State)
  })

  output$plot2 <- renderGvis({
    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))
    gvisColumnChart(selectedData())
  })

  output$plot3 <- renderPlotly({
    
    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))

    xform <- list(categoryorder = "array",
                  categoryarray = dfSlice$State)

    plot_ly(selectedData(), x = ~State, y = ~Crude.Rate, type='bar') %>%
      layout(xaxis = xform)
  })

  output$plot4 <- renderVegalite({

    dfSlice <- df %>%
      filter(Year == input$year, ICD.Chapter == input$disease) %>%
      select(State, Crude.Rate) %>%
      arrange(desc(Crude.Rate))
    
    colnames(dfSlice) <- c("State", "CrudeRate")
    

    vegalite(viewport_height=250) %>%
      add_data(dfSlice) %>%
      encode_x("State", "nominal") %>%
      encode_y("CrudeRate", "quantitative") %>%
#      encode_order("State", "nominal", sort="descending") %>%
      mark_bar()    
    
  })
