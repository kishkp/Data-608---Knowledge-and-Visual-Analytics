library(dplyr)

#### WARNING #####
## This is a huge file of about 300 MB. 
## Please change the below path to the path where you have the huge data file.

df <- read.csv('D:/CUNY/Courses/Data 608 - Knowledge and Visual Analytics/finalproject/Consumer_Complaints.csv', stringsAsFactors = FALSE)

# Add Month and Year columns
df$Month <- substr(df[,1],1,2)
df$Year <- substr(df[,1],7,11)

# Retain only required columns
reqCols <- c("Month", "Year", "Product", "Company.public.response", "Company", "State", "Submitted.via", "Company.response.to.consumer", "Timely.response.", "Consumer.disputed.")
df <- df[, reqCols]

# Rename Columns
colnames(df) <- c("Month", "Year", "Product", "CompPubResp","Company","State","Channel","Status",	"Timely", "Disputed")

# Collapse products with less than 1% into "Others"
product_arr <- df %>% group_by(Product) %>% count() %>% mutate(pert = n/sum(n)*100)
others <- as.character(unlist(product_arr[product_arr$pert < 1,1]))
df[df$Product %in% others, c("Product")] <- "Others"

# Collapse Company with less than 1% into "Others"
company_arr <- df %>% group_by(Company) %>% count() %>% mutate(pert = n/sum(n)*100)
others <- as.character(unlist(company_arr[company_arr$pert < 1,1]))
df[df$Company %in% others, c("Company")] <- "Others"


# Collapse rows and get counts 
df_new <- df %>% 
          mutate(Timely_Count = if_else(Timely=='Yes', 1, 0, missing=0)) %>%
          mutate(Dispute_Count = if_else(Disputed=='Yes', 1, 0, missing=0)) %>%
          group_by(Month, Year, Product, CompPubResp, Company, State, Channel, Status) %>% 
          summarise("Complaints"=n(), "Timely_Count" = sum(Timely_Count), "Disputed_Count" = sum(Dispute_Count))


##### Condense the huge dataset by converting all character variables to 'numeric codes'.

# Product
Product_names <- as.character(levels(factor(df_new$Product)))
df_new$Product_codes <- as.numeric(factor(df_new$Product))

# CompPubResp
CompPubResp_names <- as.character(levels(factor(df_new$CompPubResp)))
df_new$CompPubResp_codes <- as.numeric(factor(df_new$CompPubResp))

# Company
Company_names <- as.character(levels(factor(df_new$Company)))
df_new$Company_codes <- as.numeric(factor(df_new$Company))

# State
State_names <- as.character(levels(factor(df_new$State)))
df_new$State_codes <- as.numeric(factor(df_new$State))

# Channel
Channel_names <- as.character(levels(factor(df_new$Channel)))
df_new$Channel_codes <- as.numeric(factor(df_new$Channel))

# Status
Status_names <- as.character(levels(factor(df_new$Status)))
df_new$Status_codes <- as.numeric(factor(df_new$Status))

# # Timely
# Timely_names <- as.character(levels(factor(df_new$Timely)))
# df_new$Timely_codes <- as.numeric(factor(df_new$Timely))
# 
# # Disputed
# Disputed_names <- as.character(levels(factor(df_new$Disputed)))
# df_new$Disputed_codes <- as.numeric(factor(df_new$Disputed))

######### Generate the coded dataset

reqCols <- c("Month", "Year", "Product_codes", "CompPubResp_codes", "Company_codes", 
             "State_codes", "Channel_codes", "Status_codes", "Timely_Count", "Disputed_Count", "Complaints")

df_coded <- df_new[,reqCols]

# Reset names of column
colnames(df_coded) <- c("Month", "Year", "Product", "CompPubResp","Company","State","Channel","Status",	"Timely_Count", "Disputed_Count", "Complaints")

# Write the condensed csv back to the disk
# This file has been uploaded to github to be used for rest of the analysis.

write.csv(df_coded, 'D:/CUNY/Courses/Data 608 - Knowledge and Visual Analytics/finalproject/Consumer_Complaints_coded.csv', row.names = FALSE)


