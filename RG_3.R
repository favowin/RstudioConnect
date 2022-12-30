library(dplyr)
library(readxl)
library(lubridate)
library(DT)
library(shinymanager)
options(scipen = 999)

Dat<-seq(as.Date(paste(format(Sys.Date()-1,format="%Y"),format(Sys.Date()-1,format="%m"),"01",sep="-")), as.Date(Sys.Date()-1), by="days")
Day<-format(Dat,format="%d")
Month<-format(Dat,format="%m")
Year<-format(Dat,format="%Y")
Date<-paste(Year,Month,Day,sep="")
StartMonth<-paste(Year,Month,"01",sep="")
EndMonth<-gsub("-","",ceiling_date(Sys.Date()-1, "month") - days(1))

Daily_Account_Un_Validate_Entries_Merchant<-read.csv("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/Daily_Account%20Un-Validate_Entries_Merchant.csv")[,c(1:14)]
for (i in 1:length(Date)){
  
  
Daily_Un_Validated_Account_Entries_CASHLOAN<-read.csv(paste("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/",Date[i],"/Daily_Un_Validated_Account_Entries_CASHLOAN_",Date[i],".csv",sep=""))

for (i in 1:14){
  names(Daily_Account_Un_Validate_Entries_Merchant)[i]<-names(Daily_Un_Validated_Account_Entries_CASHLOAN)[i]
}

Daily_Account_Un_Validate_Entries_Merchant<-rbind(Daily_Un_Validated_Account_Entries_CASHLOAN,Daily_Account_Un_Validate_Entries_Merchant)
}
Tran<-c("2124","2131","2121","2125","2122","2123","2133","2132","2115","2114","2112","2113","2111","CCN2123","CCN2121","CCN2122","2134")
DATA_ELS<-filter(Daily_Account_Un_Validate_Entries_Merchant,Daily_Account_Un_Validate_Entries_Merchant$Account.No %in% Tran & Daily_Account_Un_Validate_Entries_Merchant$CREDIT==0 & !Daily_Account_Un_Validate_Entries_Merchant$DEBIT==0)
DATA_ELS<-DATA_ELS[rev(order(as.Date(DATA_ELS$Value.Date, format="%Y-%m-%d"))),]


left <- function(text, n) {
  substr(text, 1, n)
}

right <- function(text, n) {
  substr(text, nchar(text) - (n - 1), nchar(text))
}

mid <- function(text, start, n) {
  substr(text, start, start + n - 1)
}

DATA_ELS$RG<-right(DATA_ELS$Account.No,1)

COUNT<-as.data.frame(table(DATA_ELS$Financing.Request))
DATA_ELS_1<-DATA_ELS[c(1),]
DATA_ELS_1<-DATA_ELS_1[-c(1),]


for (i in 1:nrow(COUNT)){
  j<-match(COUNT$Var1[i],DATA_ELS$Financing.Request,0)
  DATA_ELS_2<-DATA_ELS[c(j),]
  DATA_ELS_1<-rbind(DATA_ELS_1,DATA_ELS_2)
}
DATA_ELS<-DATA_ELS_1

RG_ELS<-aggregate(list("COUNT"=DATA_ELS$RG),list("CONTRACT_ID"=DATA_ELS$Financing.Request,"RG"=DATA_ELS$RG),length)[,c(1:2)]



DATA_MYVIETTEL<-read.csv(paste("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/",paste(format(Sys.Date()-1,format="%Y"),format(Sys.Date()-1,format="%m"),format(Sys.Date()-1,format="%d"),sep=""),"/amber_daily_checkpoint_contract_",paste(format(Sys.Date()-1,format="%Y"),format(Sys.Date()-1,format="%m"),format(Sys.Date()-1,format="%d"),sep=""),".csv",sep=""))
# DATA_MYVIETTEL<-filter(DATA_MYVIETTEL,DATA_MYVIETTEL$utm_source=="MYVIETTEL")

RG_MYVIETTEL<-data.frame("CONTRACT_ID"=DATA_MYVIETTEL$contract_code,"RG"=DATA_MYVIETTEL$final_risk_group)

RG_ALL<-rbind(RG_ELS,RG_MYVIETTEL)

BOM_1<-read.csv(paste("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/",paste(format(Sys.Date()-1,format="%Y"),format(Sys.Date()-1,format="%m"),format(Sys.Date()-1,format="%d"),sep=""),"/BOM_1_",paste(format(Sys.Date()-1,format="%Y"),format(Sys.Date()-1,format="%m"),format(Sys.Date()-1,format="%d"),sep=""),".csv",sep=""))
BOM_2<-read.csv(paste("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/",paste(format(Sys.Date()-1,format="%Y"),format(Sys.Date()-1,format="%m"),format(Sys.Date()-1,format="%d"),sep=""),"/BOM_2_",paste(format(Sys.Date()-1,format="%Y"),format(Sys.Date()-1,format="%m"),format(Sys.Date()-1,format="%d"),sep=""),".csv",sep=""))

BOM<-rbind(BOM_1,BOM_2)

RG_BOM<-data.frame("CONTRACT_ID"=BOM$contract_number,"RG_BOM"=BOM$fin_risk_grp_status)

CHECK_RG<-merge(RG_ALL,RG_BOM,by="CONTRACT_ID",all.x=TRUE)
CHECK_RG<-filter(CHECK_RG,!CHECK_RG$RG_BOM=="Debt sale")

CHECK_RG$LECH<-as.numeric(CHECK_RG$RG)-as.numeric(CHECK_RG$RG_BOM)

LECH<-filter(CHECK_RG,!CHECK_RG$LECH==0)

BOM_MAIN<-data.frame("CONTRACT_ID"=BOM$contract_number,"SYSTEM"=BOM$system,"PRINCIPAL_BALANCE"=BOM$pri_debt_amt)

LECH_1<-merge(LECH,BOM_MAIN,by="CONTRACT_ID",all.x=TRUE)

LECH_1<-filter(LECH_1,!LECH_1$PRINCIPAL_BALANCE==0)





library(mailR)
library(bigrquery)
library(devtools)
library(bigrquery)
library(dplyr)
library(readxl)
library(lubridate)
library(readr)




Dat<-seq(as.Date(Sys.Date()-1), as.Date(Sys.Date()-1), by="days")
Day<-format(Dat,format="%d")
Month<-format(Dat,format="%m")
Year<-format(Dat,format="%Y")
Date<-paste(Year,Month,Day,sep="")
StartMonth<-paste(Year,Month,"01",sep="")



EndMonth<-gsub("-","",ceiling_date(Sys.Date()-9, "month") - days(1))

library(mailR)
library(htmlTable)

y <- htmlTable(LECH_1, rnames = FALSE)

# Define body of email
html_body <- paste0("<html><head>
               <style>
               body{font-family:Calibri, sans-serif;}
               table{border-left:1px solid #000000;border-top:1px solid #000000;}
               table th{border-right:1px solid #000000;border-bottom:1px solid #000000;font-size:13px; font-weight:bold; margin: 0px; padding-left: 5px; padding-right: 5px; margin: 0px;}
               table td{border-right:1px solid #000000;border-bottom:1px solid #000000;font-size:13px; font-weight:normal; margin: 0px; padding-left: 5px; padding-right: 5px; margin: 0px;}
               </style>
               </head><body><p> The contract is different RG between Daily and BOM.</p>",
                    y, 
                    "</body></html>")
# 
# send.mail(from = "fofawubian369@fofawubian369.com",
#           to = c("duy.nguyen03@easycredit.vn"),
#           subject = paste("Different_RG_",Date,sep=""),
#           body = html_body,
#           smtp = list(host.name = "mail.fofawubian369.com", port = 25,
#                       user.name = "fofawubian369@fofawubian369.com", passwd = "Fofawubian369", ssl = TRUE),authenticate = TRUE,html=TRUE,send = TRUE)
# 




send.mail(from = "fofawubian369@fofawubian369.com",
          to = c("duy.nguyen03@easycredit.vn"),
          subject = paste("Different_RG_",Date,sep=""),
          body =html_body,
          smtp = list(host.name = "mail.fofawubian369.com", port = 25,
                      user.name = "fofawubian369@fofawubian369.com",
                      passwd = "Fofawubian369", ssl = TRUE),
          authenticate = TRUE,html=TRUE,
          send = TRUE)
