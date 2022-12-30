library(bigrquery)
library(devtools)
library(bigrquery)
library(dplyr)
library(readxl)
library(readr)
library("googlesheets4")
library(dplyr)
left <- function(text, n) {
  substr(text, 1, n)
}

right <- function(text, n) {
  substr(text, nchar(text) - (n - 1), nchar(text))
}

mid <- function(text, start, n) {
  substr(text, start, start + n - 1)
}


Dat<-seq(as.Date(Sys.Date()-6), as.Date(Sys.Date()-3), by="days")
Day<-format(Dat,format="%d")
Month<-format(Dat,format="%m")
Year<-format(Dat,format="%Y")
Date<-paste(Year,Month,Day,sep="-")


Payment_Collection_CASHLOAN<-read.csv("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/20221029/Payment_Collection_Merchant.csv")
for (i in 1:length(Date)){
  Payment_Collection_CASHLOAN_1<-read.csv(paste("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/",gsub("-","",Date[i]),"/Payment_Collection_CASHLOAN_",gsub("-","",Date[i]),".csv",sep=""))
  Payment_Collection_CASHLOAN<-rbind(Payment_Collection_CASHLOAN,Payment_Collection_CASHLOAN_1)
}

Payment_Collection_CASHLOAN$PAYMENT_DATE_CONVERT<-paste(right(Payment_Collection_CASHLOAN$PAYMENT_DATE,4),left(Payment_Collection_CASHLOAN$PAYMENT_DATE,2),mid(Payment_Collection_CASHLOAN$PAYMENT_DATE,4,2),sep="-")

Payment_Collection_CASHLOAN$TRANSACTION_ID<-gsub("VTLEC","",Payment_Collection_CASHLOAN$TRANSACTION_ID)

Payment_Collection_CASHLOAN$GHEP<-paste(Payment_Collection_CASHLOAN$CONTRACT_ID,Payment_Collection_CASHLOAN$TRANSACTION_ID,Payment_Collection_CASHLOAN$PAYMENT_AMOUNT,sep="")

write_csv(Payment_Collection_CASHLOAN,paste0('data/','Payment_Collection_CASHLOAN_',gsub("-","",Sys.Date()-1),'.csv',sep=""))
