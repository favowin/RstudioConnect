library(bigrquery)
library(devtools)
library(bigrquery)
library(dplyr)
library(readxl)
library("googlesheets4")

Day<-format(Sys.Date()-1,format="%d")
Month<-format(Sys.Date()-1,format="%m")
Year<-format(Sys.Date()-1,format="%Y")
Date<-paste(Year,Month,Day,sep="")
           
projectid = "evnfc-bigdata"

# Set your query
#sql <- "SELECT * FROM `evnfc-bigdata.bu_fin.payment` where `payment_date` between '08/22/2022' and '08/22/2022'" 

sql<-paste("SELECT * FROM `evnfc-bigdata.bu_fin.payment` where `payment_date` between ","'",paste(Month,Day,Year,sep = "/"),"'"," and ","'",paste(Month,Day,Year,sep = "/"),"'",sep="")



# Run the query and store the data in a tibble
tb <- bq_project_query(projectid, sql)

# Print 08 rows of the data
Payment_Collection_CASHLOAN<-bq_table_download(tb)

# Payment_Collection_CASHLOAN<-Payment_Collection_CASHLOAN[,-c(1)]


Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="VTL"]<-"VIETTEL STORE"
Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="VIETTEL"]<-"VIETTEL STORE"



Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="VTT"]<-"VIETTEL PAY"

Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="MMO"]<-"MOMO"

Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="EW3"]<-"VIETTEL POST"

Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="EW2"]<-"ECPAY"
Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="EW1"]<-"EPAY VIRTUAL ACCOUNT"
Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="EWALLET1"]<-"EPAY VIRTUAL ACCOUNT"

Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="EPA"]<-"EPAY"
#Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="ECPAY"]<-"BANK3"
Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="BK3"]<-"EPAY TGDD"
Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="BK1"]<-"EASY VAY"

Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="PYO"]<-"PAYOO"
Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="SAC"]<-"SACOMBANK"
Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="VTB"]<-"VIETINBANK"
Payment_Collection_CASHLOAN['partner_code'][Payment_Collection_CASHLOAN['partner_code']=="VNP"]<-"VIETNAM POST"

Payment_Collection_CASHLOAN<-filter(Payment_Collection_CASHLOAN,Payment_Collection_CASHLOAN$partner_code!="EVNFC")


library(tidyverse)

left <- function(text, n) {
  substr(text, 1, n)
}

right <- function(text, n) {
  substr(text, nchar(text) - (n - 1), nchar(text))
}

mid <- function(text, start, n) {
  substr(text, start, start + n - 1)
}
#Month<-left(Payment_Collection_CASHLOAN$payment_date,2)
#Day<-mid(Payment_Collection_CASHLOAN$payment_date,4,2)
Year<-right(Payment_Collection_CASHLOAN$payment_date,4)

#payment_date<-paste(Year,Month,Day,sep="-")
#Payment_Collection_CASHLOAN$payment_date<-payment_date
Payment_Collection_CASHLOAN$Year<-Year

Payment_Collection_CASHLOAN<-filter(Payment_Collection_CASHLOAN,Payment_Collection_CASHLOAN$Year=="2022")

Payment_Collection_CASHLOAN<-Payment_Collection_CASHLOAN[,c(2:15,1)]

NO<-data.frame("NO"=1:nrow(Payment_Collection_CASHLOAN))
Payment_Collection_CASHLOAN<-cbind(NO,Payment_Collection_CASHLOAN)
Payment_Collection_CASHLOAN_Name<-read_excel("E:/Data Core New/Reconsile_Payment_Disrsement/20211005/Payment Collection.xlsx")

for(i in 1:15){
  names(Payment_Collection_CASHLOAN)[i+1]<-names(Payment_Collection_CASHLOAN_Name)[i]
  
}
write_csv(Payment_Collection_CASHLOAN,paste0('data/','Payment_Collection_CASHLOAN_',Date,'.csv',sep=""))
