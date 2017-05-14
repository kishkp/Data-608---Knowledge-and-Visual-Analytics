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


# Read dataset from GitHub
df <- read.csv('https://raw.githubusercontent.com/kishkp/Data-608---Knowledge-and-Visual-Analytics/master/finalproject/data/Consumer_Complaints_coded.csv', stringsAsFactors = FALSE)


# "Uncode"  the columns of the condensed dataset
products <- c('Bank account or service', 'Consumer Loan', 'Credit card', 'Credit reporting', 'Debt collection', 'Mortgage', 'Others', 'Student Loan')
compresp <- c('No response', 'Company believes complaint caused principally by actions of third party outside the control or direction of the company', 'Company believes complaint is the result of an isolated error', 'Company believes complaint relates to a discontinued policy or procedure', 'Company believes complaint represents an opportunity for improvement to better serve consumers', 'Company believes it acted appropriately as authorized by contract or law',  'Company believes the complaint is the result of a misunderstanding', 'Company cant verify or dispute the facts in the complaint', 'Company chooses not to provide a public response', 'Company disputes the facts presented in the complaint', 'Company has responded to the consumer and the CFPB and chooses not to provide a public response')
companies <- c('Amex', 'Bank of America', 'Capital One', 'Citibank', 'Ditech Financial LLC', 'Encore Capital Group', 'Equifax', 'Experian', 'JPMorgan Chase & Co.', 'Nationstar Mortgage', 'Navient Solutions, LLC.', 'Ocwen', 'Others', 'PNC Bank N.A.', 'Synchrony Financial', 'TransUnion Intermediate Holdings, Inc.', 'U.S. Bancorp', 'Wells Fargo & Company')
states <- c("", "AA", "AE", "AK", "AL", "AP", "AR", "AS", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "FM", "GA", "GU", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MH", "MI", "MN", "MO", "MP", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "PR", "PW", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VI", "VT", "WA", "WI", "WV", "WY", "LS")
channels <-  c('Email', 'Fax', 'Phone', 'Postal mail', 'Referral', 'Web')
status <- c('Closed', 'Closed with explanation', 'Closed with monetary relief', 'Closed with non-monetary relief', 'Closed with relief', 'Closed without relief', 'In progress', 'Untimely response')
years <- unique(df$Year)

# Create factors for each of the dimensions in the data 
prod.fact <- factor(df$Product, labels = products)
compresp.fact <- factor(df$CompPubResp, labels = compresp)
comp.fact <- factor(df$Company, labels = companies)
states.fact <- factor(df$State, levels = as.character(1:64), labels = states)
channel.fact <- factor(df$Channel, labels = channels)
status.fact <- factor(df$Status, labels = status)

# recreate the dataset with the factors instead of the coded values  
df <- cbind.data.frame(select(df, Month, Year, Complaints, Timely_Count, Disputed_Count), Product = prod.fact, 
                       CompPubResp = compresp.fact, Company = comp.fact, State = states.fact, 
                       Channel = channel.fact, Status = status.fact)

create_hierarchial_JSON <- function(){
  
} 


function(input, output, session) {

###############################################################  

  # Observe the webpage for changes - when the user selects from the dropdowns

  observe({
    print(input$tabs)
    if(input$tabs == "PS") {

    } else if(input$tabs == "CT") {

      # First Analysis - Companies Trend
      CompaniesTrendData <- reactive({
        
        # Select the columns including the column selected in the Radio Buttons.
        select_cols <- c(input$CT_dim, "Year", "Complaints", "Timely_Count", "Disputed_Count")
          
        # Group data by the selected column and year
        group_cols <- c(input$CT_dim, "Year")
          
        # Create a cross join to include all states and all years. 
        # This is useful to fill in any missing states or years 
        CJ_cols <- switch(input$CT_dim, State = states, Product = products, CompPubResp = compresp,
                          Company = companies, Channel = channels, Status=status)
          
        # Create the required dataset
        dfSlice <- df %>%
          select_(.dots = select_cols) %>%
          group_by_(.dots = group_cols) %>% 
          summarise(Complaints = sum(Complaints), Timely_Count=sum(Timely_Count), Disputed_Count=sum(Disputed_Count)) %>%
          data.table() %>%
          setkeyv(group_cols)
        
        # Ensure that the data has no gaps in rows i.e the rows are padded with missing years and 
        # states with the values set to NA
        CT_Data <- data.frame(dfSlice[CJ(CJ_cols,years), roll=TRUE])
      })
      
      output$plot1 <- renderGvis({
        gvisMotionChart(CompaniesTrendData(), 
                        idvar=paste0("", input$CT_dim, ""), 
                        timevar="Year",
                        xvar = "Timely_Count", yvar = "Disputed_Count",
                        sizevar = "Complaints",    
                        options=list(width="700px", height="500px"))
      })
      
    } else if(input$tabs == "AS") {

      ###################################################################  
      # Second Analysis - State Analysis    
      # create necessary dataset
      AS_Data <- df %>%
        filter(Product == input$AS_Prod, Company == input$AS_Comp) %>%
        mutate(State=as.character(State)) %>%
        select(State, Complaints, Timely_Count, Disputed_Count) %>%
        group_by(State) %>% 
        summarise(Complaints = sum(Complaints), Timely_Count=sum(Timely_Count), Disputed_Count=sum(Disputed_Count)) %>%
        data.table() %>%
        setkey("State")
      
      # Ensure that you have all the states i.e pad states that are not existing
      AS_Data <- data.frame(AS_Data[states,])
      
      # set padded states with values of 0
      AS_Data[is.na(AS_Data)] <- 0
      
      # send this revised data back to the javascript so that the JS can render the new chart.
      session$sendCustomMessage(type = "ASdataChanged", AS_Data)

  } else if(input$tabs == "CP") {

    ###################################################################  
    # Third Analysis - Company Performance Analysis    
    
    select_cols <- c(input$CP_fact, "Company", "Product", "Channel", "Status")
    
    # create necessary dataset
    CP_Data <- df %>%
      select(Company, Product, Channel, Status, Complaints, Timely_Count, Disputed_Count) %>%
      group_by(Company, Product, Channel, Status) %>% 
      summarise(Complaints = sum(Complaints), Timely_Counts=sum(Timely_Count), Disputed_Counts=sum(Disputed_Count)) %>%
      select_(.dots = select_cols)
    
    # send this revised data back to the javascript so that the JS can render the new chart.
    # session$sendCustomMessage(type = "CPdataChanged", data.table(CP_Data))
    
    } else if(input$tabs == "CA") {
      
    }  
    
  }) 
}
