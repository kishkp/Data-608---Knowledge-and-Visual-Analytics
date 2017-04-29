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

df <- read.csv('https://raw.githubusercontent.com/kishkp/Data-608---Knowledge-and-Visual-Analytics/master/finalproject/Data/Consumer_Complaints_condensed.csv', stringsAsFactors = FALSE)

all_states <- unique(df$State)
all_products <- c('Bank account or service', 'Credit card', 'Credit reporting', 'Debt collection', 'Mortgage', 'Others')
all_compresp <- c('Company believes complaint caused principally by actions of third party outside the control or direction of the company', 'Company believes complaint is the result of an isolated error', 'Company believes complaint relates to a discontinued policy or procedure', 'Company believes complaint represents an opportunity for improvement to better serve consumers', 'Company believes it acted appropriately as authorized by contract or law', 'Company believes the complaint is the result of a misunderstanding', 'Company cant verify or dispute the facts in the complaint', 'Company chooses not to provide a public response', 'Company disputes the facts presented in the complaint', 'Company has responded to the consumer and the CFPB and chooses not to provide a public response', 'No Response')
all_companies <- c('Amex', 'Bank of America', 'Capital One', 'Citibank', 'Discover', 'Ditech Financial LLC', 'Encore Capital Group', 'Equifax', 'Experian', 'HSBC North America Holdings Inc.', 'JPMorgan Chase & Co.', 'Nationstar Mortgage', 'Navient Solutions, LLC.', 'Ocwen', 'Others', 'PNC Bank N.A.', 'Synchrony Financial', 'TransUnion Intermediate Holdings, Inc.', 'U.S. Bancorp', 'Wells Fargo & Company')
all_channels <-  c('Email', 'Fax', 'Phone', 'Postal mail', 'Referral', 'Web')
all_status <- c('Closed', 'Closed with explanation', 'Closed with monetary relief', 'Closed with non-monetary relief', 'Closed with relief', 'Closed without relief', 'In progress', 'Untimely response')
all_years <- unique(df$Year)


prod.fact <- factor(df$Product, labels = all_products)
compresp.fact <- factor(df$CompPubResp, labels = all_compresp)
comp.fact <- factor(df$Company, labels = all_companies)
channel.fact <- factor(df$Channel, labels = all_channels)
status.fact <- factor(df$Status, labels = all_status)

df <- cbind.data.frame(select(df, Month, Year, State, Timely, Disputed, Complaints), Product = prod.fact, CompPubResp = compresp.fact, Company = comp.fact, Channel = channel.fact, Status = status.fact)

function(input, output, session) {
  selectedData <- reactive({
    select_cols <- c(input$dim, "Year", "Complaints", "Timely_Count", "Dispute_Count")
    group_cols <- c(input$dim, "Year")
    CJ_cols <- switch(input$dim, State = all_states, Product = all_products, CompPubResp = all_compresp, Company = all_companies,                   Channel = all_channels, Status=all_status)
    
    
    dfSlice <- df %>%
      mutate(Timely_Count = if_else(Timely=='Y', 1, 0, missing=0)) %>%
      mutate(Dispute_Count = if_else(Disputed=='Y', 1, 0, missing=0)) %>%
      select_(.dots = select_cols) %>%
      group_by_(.dots = group_cols) %>% 
      summarise(Complaints = sum(Complaints), Timely_Count=sum(Timely_Count), Dispute_Count=sum(Dispute_Count)) %>%
      data.table() %>%
      setkeyv(group_cols)
    
    dfs <- data.frame(dfSlice[CJ(CJ_cols,all_years), roll=TRUE])
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