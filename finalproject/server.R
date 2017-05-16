library(shiny)
library(shinythemes)
library(dplyr)
library(googleVis)
library(plotly)
library(data.table)
library(RJSONIO)
library(lazyeval)


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

function(input, output, session) {

###############################################################  

  # Observe the webpage for changes - when the user selects from the dropdowns

  observe({
    # print(input$tabs)
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
    
    
    group_cols <- c("Company", input$CP_dims)
    select_cols <- c(group_cols, input$CP_fact)

    # print(group_cols)
    # print(select_cols)
    
     # select_cols <- c("Company", "Product", "Complaints")
     # group_cols <- c("Company", "Product")
     # sum_cols <- "Complaints"
     
    #select_cols <- c("Company", "Product", "Channel", "Complaints")
    # create necessary dataset

    CP_Data <- df %>%
      select_(.dots = select_cols) %>%
      group_by_(.dots = group_cols) %>% 
      summarise_(sum_val = interp(~sum(var), var = as.name(input$CP_fact))) #http://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string
      #summarise_(sum_val = interp(~sum(var), var = as.name(sum_cols))) #http://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string
    
      CP_Data <- as.data.frame(CP_Data)
      #CP_Data <- cbind.data.frame(master = "Companies",CP_Data)

    # convert the data frame into flare.json format
    # Adapted from http://stackoverflow.com/questions/12818864/how-to-write-to-json-with-children-from-r/12823899#12823899
    
    # print(head(CP_Data))
    
    makeList<-function(x){
      if(ncol(x)>2){
        listSplit<-split(x[-1],x[1],drop=T)
        lapply(names(listSplit),function(y){list(name=y,children=makeList(listSplit[[y]]))})
      }else{
        lapply(seq(nrow(x[1])),function(y){list(name=x[,1][y],size=x[,2][y])})
      }
    }
    
    if(length(group_cols)==1){
      #print("here")
      jsonOut<-toJSON(list(name="CP_Data",children=makeList(CP_Data)))
    } else {
      CP_Data <- cbind.data.frame(master = "Companies",CP_Data)
      jsonOut<-toJSON(list(name="CP_Data",children=makeList(CP_Data[-1])))
    }

    # send this JSON to the javascript so that the JS can render the new chart.
    session$sendCustomMessage(type = "CPdataChanged", jsonOut)
    
    } else if(input$tabs == "CA") {

      output$CA_timeseries <- renderPlotly({
          select_cols <- c("Channel", "Year", input$CA_fact)
#          select_cols <- c("Channel", "Year", "Complaints")
          
          CA_Data <- df %>%
            filter(Product == input$CA_Prod, Company == input$CA_Comp) %>%
            #filter(Product == "Credit card", Company == "Amex") %>%
            select_(.dots = select_cols) %>%
            group_by(Channel, Year) %>%
            summarise_(cases = interp(~sum(var), var = as.name(input$CA_fact))) #http://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string
            #summarise(sum_val = sum(Complaints)) #http://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string

          CA_Data <- data.frame(CA_Data)
          
          p <- plot_ly(data = CA_Data, x = ~Year, y = ~cases, color = ~Channel, mode = 'markers+line')
          p
      })
      
      output$CA_heatmap <- renderPlotly({
          select_cols <- c("Channel", "Status", input$CA_fact)
          # select_cols <- c("Channel", "Status", "Complaints")
          
          CA_Data <- df %>%
            filter(Product == input$CA_Prod, Company == input$CA_Comp) %>%
            #filter(Product == "Credit card", Company == "Amex") %>%
            select_(.dots = select_cols) %>%
            group_by(Channel, Status) %>%
            summarise_(cases = interp(~sum(var), var = as.name(input$CA_fact))) #http://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string
            #summarise(sum_val = sum(Complaints)) #http://stackoverflow.com/questions/26724124/standard-evaluation-in-dplyr-summarise-on-variable-given-as-a-character-string
          
          CA_Data <- as.data.frame(tidyr::spread(data = CA_Data, key = Channel, value = cases))
          CA_Data[is.na(CA_Data)] <- 0
          
          
          m <- as.matrix(CA_Data[, 2:ncol(CA_Data)])
          p <- plot_ly(
            x = colnames(CA_Data[, 2:ncol(CA_Data)]), y = as.character(CA_Data[,1]),
            z = m, type = "heatmap"
          )
          
          p
          
      })
    }  
  }) 
}
