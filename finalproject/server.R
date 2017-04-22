library(ggplot2)
library(dplyr)
library(googleVis)
library(plotly)
library(jsonlite)
library(vegalite)
#library(quantmod)
library(reshape2)

df <- read.csv('https://raw.githubusercontent.com/kishkp/Data-608---Knowledge-and-Visual-Analytics/master/lecture3/Data/cleaned-cdc-mortality-1999-2010-2.csv', stringsAsFactors = FALSE)

NatAvg <- df %>%  
  select(ICD.Chapter, Year, Deaths, Population) %>% 
  group_by(ICD.Chapter, Year) %>% 
  summarise(Deaths = sum(Deaths), Population = sum(Population)) %>%
  mutate(Crude.Rate = Deaths / Population * 100000) %>%
  mutate(State = 'Nat Avg') 

df <- rbind.data.frame(df, NatAvg)


function(input, output, session) {
  
  selectedData <- reactive({
    dfSlice <- df %>%
      filter(ICD.Chapter == input$disease, State == input$State) %>%
      select(State, Year, Crude.Rate)
  })
  

  output$plot1 <- renderPlot({

    ggplot(selectedData(), aes(x = Year, y = Crude.Rate, color = State)) +
      geom_line() +
      scale_x_discrete(name = "Year", limits=c(1998:2010))
  })

  output$plot2 <- renderGvis({

    ds <- dcast(selectedData(), Year ~ State, value.var = 'Crude.Rate')
    
    gvisLineChart(ds, xvar = 'Year', yvar = input$State)
    
  })

  output$plot3 <- renderPlotly({
    
    plot_ly(selectedData(), x = ~Year, y = ~Crude.Rate, color = ~State, type='scatter',
            mode = 'lines') %>%
      layout(
        xaxis = list(tickvals = c(1998:2010)))
    
  })

  output$plot4 <- renderVegalite({

    dfSlice <- df %>%
      filter(ICD.Chapter == input$disease, State == input$State) %>%
      select(State, Year, Crude.Rate)

    colnames(dfSlice) <- c("State", "Year", "CrudeRate")
    

    vegalite() %>%
      # cell_size(500, 300) %>%
      add_data(dfSlice) %>%
      encode_x(field = 'Year', type='nominal') %>%
      encode_y(field = 'CrudeRate', type = 'quantitative') %>%
      encode_color(field = 'State', type='nominal') %>%
      mark_line()    
  })
}