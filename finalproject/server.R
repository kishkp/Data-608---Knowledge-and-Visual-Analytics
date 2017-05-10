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



df <- read.csv('https://raw.githubusercontent.com/kishkp/Data-608---Knowledge-and-Visual-Analytics/master/finalproject/data/Consumer_Complaints_coded.csv', stringsAsFactors = FALSE)

# "Uncode"  the columns of the condensed dataset
products <- c('Bank account or service', 'Consumer Loan', 'Credit card', 'Credit reporting', 'Debt collection', 'Mortgage', 'Others', 'Student Loan')
compresp <- c('No response', 'Company believes complaint caused principally by actions of third party outside the control or direction of the company', 'Company believes complaint is the result of an isolated error', 'Company believes complaint relates to a discontinued policy or procedure', 'Company believes complaint represents an opportunity for improvement to better serve consumers', 'Company believes it acted appropriately as authorized by contract or law',  'Company believes the complaint is the result of a misunderstanding', 'Company cant verify or dispute the facts in the complaint', 'Company chooses not to provide a public response', 'Company disputes the facts presented in the complaint', 'Company has responded to the consumer and the CFPB and chooses not to provide a public response')
companies <- c('Amex', 'Bank of America', 'Capital One', 'Citibank', 'Ditech Financial LLC', 'Encore Capital Group', 'Equifax', 'Experian', 'JPMorgan Chase & Co.', 'Nationstar Mortgage', 'Navient Solutions, LLC.', 'Ocwen', 'Others', 'PNC Bank N.A.', 'Synchrony Financial', 'TransUnion Intermediate Holdings, Inc.', 'U.S. Bancorp', 'Wells Fargo & Company')
states <- c("", "AA", "AE", "AK", "AL", "AP", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "FM", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MH", "MI", "MN", "MO", "MP", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "PW", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY")
channels <-  c('Email', 'Fax', 'Phone', 'Postal mail', 'Referral', 'Web')
status <- c('Closed', 'Closed with explanation', 'Closed with monetary relief', 'Closed with non-monetary relief', 'Closed with relief', 'Closed without relief', 'In progress', 'Untimely response')
timely <- c("No", "Yes")
disputed <- c( "", "No", "Yes")

years <- unique(df$Year)


prod.fact <- factor(df$Product, labels = products)
compresp.fact <- factor(df$CompPubResp, labels = compresp)
comp.fact <- factor(df$Company, labels = companies)
states.fact <- factor(df$State, labels = states)
channel.fact <- factor(df$Channel, labels = channels)
status.fact <- factor(df$Status, labels = status)
timely.fact <- factor(df$timely, labels = timely)
disputed.fact <- factor(df$disputed, labels = disputed)

df <- cbind.data.frame(select(df, Month, Year, Complaints), Product = prod.fact, 
                       CompPubResp = compresp.fact, Company = comp.fact, State = states.fact, 
                       Channel = channel.fact, Status = status.fact, Timely = timely.fact, Disputed = disputed.fact)

function(input, output, session) {
  selectedData <- reactive({
    select_cols <- c(input$dim, "Year", "Complaints", "Timely_Count", "Dispute_Count")
    group_cols <- c(input$dim, "Year")
    CJ_cols <- switch(input$dim, State = states, Product = products, CompPubResp = compresp, Company = companies,                   Channel = channels, Status=status)
    
    
    dfSlice <- df %>%
      mutate(Timely_Count = if_else(Timely=='Y', 1, 0, missing=0)) %>%
      mutate(Dispute_Count = if_else(Disputed=='Y', 1, 0, missing=0)) %>%
      select_(.dots = select_cols) %>%
      group_by_(.dots = group_cols) %>% 
      summarise(Complaints = sum(Complaints), Timely_Count=sum(Timely_Count), Dispute_Count=sum(Dispute_Count)) %>%
      data.table() %>%
      setkeyv(group_cols)
    
    dfs <- data.frame(dfSlice[CJ(CJ_cols,years), roll=TRUE])
    # dfs[is.na(dfs$Complaints), ]$Complaints <- 0
    # dfs[is.na(dfs$Timely_Count), ]$Timely_Count <- 0
    # dfs[is.na(dfs$Dispute_Count), ]$Dispute_Count <- 0
  })

  output$plot1 <- renderGvis({
    gvisMotionChart(selectedData(), 
                    idvar=paste0("", input$dim, ""), 
#                    idvar=paste0("", input$dim, ""), 
                    timevar="Year",
                    xvar = "Timely_Count", yvar = "Dispute_Count",
                    sizevar = "Complaints",    
                    options=list(width="700px", height="500px")
    )
    })
}