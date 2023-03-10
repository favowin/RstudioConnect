library(dplyr)
library(readxl)
library(lubridate)
library(DT)
library(readr)
options(scipen = 999)
Day<-format(Sys.Date()-18,format="%d")
Month<-format(Sys.Date()-18,format="%m")
Year<-format(Sys.Date()-18,format="%Y")
Date<-paste(Year,Month,Day,sep="")
StartMonth<-paste(Year,Month,"01",sep="")
EndMonth<-gsub("-","",ceiling_date(Sys.Date()-30, "month") - days(1))
#EndMonth<-paste(format(Sys.Date(),format="%Y"),format(Sys.Date(),format="%m"),format(Sys.Date(),format="%d"),sep="")
Customer_statements_CASHLOAN_1<-read.csv(paste("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/",EndMonth,"/Customer_statements_CASHLOAN_1_",EndMonth,".csv",sep=""))
Customer_statements_CASHLOAN_2<-read.csv(paste("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/",EndMonth,"/Customer_statements_CASHLOAN_2_",EndMonth,".csv",sep=""))
Customer_statements_CASHLOAN<-rbind(Customer_statements_CASHLOAN_1,Customer_statements_CASHLOAN_2)
library(readxl)
Daily_sales_report_2022_v1_GI <- read.csv("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/Reconsile_Sample/Daily%20sales%20report%202022%20v1_GI.csv")
names(Daily_sales_report_2022_v1_GI)[1]<-"Ghep"
#View(Daily_sales_report_2022_v1_GI)
Daily_sales_report_2022_v1_GI[is.na(Daily_sales_report_2022_v1_GI)]<-""
X<-Customer_statements_CASHLOAN$customer_channel
X[is.na(X)]<-""
Customer_statements_CASHLOAN$X<-X
Y<-Customer_statements_CASHLOAN$partner_code
Y[is.na(Y)]<-""
Customer_statements_CASHLOAN$Y<-Y
Z<-Customer_statements_CASHLOAN$product_name
Z[is.na(Z)]<-""
Customer_statements_CASHLOAN$Z<-Z
T<-Customer_statements_CASHLOAN$product_code
T[is.na(T)]<-""
Customer_statements_CASHLOAN$T<-T
Ghep<-paste(Customer_statements_CASHLOAN$X,Customer_statements_CASHLOAN$Y,Customer_statements_CASHLOAN$Z,Customer_statements_CASHLOAN$T,sep="")
Customer_statements_CASHLOAN$Ghep<-Ghep
Customer_statements_CASHLOAN<-merge(Customer_statements_CASHLOAN,Daily_sales_report_2022_v1_GI,by="Ghep",all.x=TRUE)
#Customer_statements_CASHLOAN<-unique(Customer_statements_CASHLOAN)
#Customer_statements_CASHLOAN<-Customer_statements_CASHLOAN[-c(1),]
FIPO_DATA<-filter(Customer_statements_CASHLOAN,Customer_statements_CASHLOAN$Product=="FIPO" & grepl(paste(Year,Month,sep="-"),Customer_statements_CASHLOAN$disb_month))
FIPO_DATA_AC<-filter(FIPO_DATA,FIPO_DATA$financing_request_status %in% c("ACTIVATED","TERMINATION IN PROGRESS"))
FIPO_DATA_TER<-filter(FIPO_DATA,FIPO_DATA$financing_request_status=="TERMINATED")
Get<-c()
for (i in 1:nrow(FIPO_DATA_TER)){
  if (as.Date(FIPO_DATA_TER$terminated_date[i])-as.Date(FIPO_DATA_TER$disb_date[i])+1<=5){
    Get<-c(Get,0)
  }else{
    Get<-c(Get,1)
  }
}
FIPO_DATA_TER$Get<-Get
FIPO_DATA_TER<-filter(FIPO_DATA_TER,FIPO_DATA_TER$Get==1)
FIPO_DATA_TER<-FIPO_DATA_TER[,-c(43)]
FIPO_DATA_AFTER_ADJUST<-rbind(FIPO_DATA_AC,FIPO_DATA_TER)
FIPO_Product_List<-read.csv("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/Reconsile_Sample/FIPO_Product_List.csv")
FIPO_Product_List<-unique(FIPO_Product_List)
names(FIPO_Product_List)[1]<-"product_code"
names(FIPO_Product_List)[4]<-"Product_Name"
names(FIPO_DATA_AFTER_ADJUST)[10]<-"product_code"
FIPO_DATA_AFTER_ADJUST<-merge(FIPO_DATA_AFTER_ADJUST,FIPO_Product_List,by="product_code",all.x=TRUE)
FIPO_Rate<-read.csv("https://raw.githubusercontent.com/INGUI54/ingui0336425454/main/Reconsile_Sample/FIPO_Rate.csv")
names(FIPO_Rate)[1]<-names(FIPO_DATA_AFTER_ADJUST)[45]
#names(FIPO_DATA_AFTER_ADJUST)[45]<-"Product_Name"
FIPO_DATA_AFTER_ADJUST<-merge(FIPO_DATA_AFTER_ADJUST,FIPO_Rate,by=names(FIPO_DATA_AFTER_ADJUST)[45],all.x=TRUE)
REPORT_FIPO<-aggregate(list("DIS_AMOUNT"=FIPO_DATA_AFTER_ADJUST$approved_amount),list("Product_Name"=FIPO_DATA_AFTER_ADJUST$Real_life_name),sum)
names(FIPO_Rate)[1]<-"Product_Name"
REPORT_FIPO<-merge(REPORT_FIPO,FIPO_Rate,by=names(FIPO_Rate)[1],all.x=TRUE)
SERVICE_FEE_FIZO<-REPORT_FIPO$DIS_AMOUNT*REPORT_FIPO$FIZO_Rate
REPORT_FIPO$SERVICE_FEE_FIZO<-SERVICE_FEE_FIZO
names(REPORT_FIPO)[4]<-"3M_Rate"
SERVICE_FEE_3M<-REPORT_FIPO$DIS_AMOUNT*REPORT_FIPO$`3M_Rate`
REPORT_FIPO$SERVICE_FEE_3M<-SERVICE_FEE_3M
TOTAL<-data.frame("Product_Name"="Total","DIS_AMOUNT"=sum(REPORT_FIPO$DIS_AMOUNT),"FIZO_Rate"="","3M_Rate"="","SERVICE_FEE_FIZO"=sum(REPORT_FIPO$SERVICE_FEE_FIZO),"SERVICE_FEE_3M"=sum(REPORT_FIPO$SERVICE_FEE_3M))
names(TOTAL)[4]<-names(REPORT_FIPO)[4]
FEE_SERVICE_FIPO<-rbind(REPORT_FIPO,TOTAL)
S<-0
for (i in 1:nrow(FIPO_DATA_AFTER_ADJUST)){
  S<-S+FIPO_DATA_AFTER_ADJUST$approved_amount[i]
}
DATA_FIPO_DETAIL<-data.frame("CONTRACT_ID"=FIPO_DATA_AFTER_ADJUST$financing_request,"CUSTOMER_NAME"=FIPO_DATA_AFTER_ADJUST$customer_name,"DIS_AMOUNT"=FIPO_DATA_AFTER_ADJUST$approved_amount,"DIS_DATE"=FIPO_DATA_AFTER_ADJUST$disb_date,"STATUS"=FIPO_DATA_AFTER_ADJUST$financing_request_status,"PRODUCT"=FIPO_DATA_AFTER_ADJUST$Real_life_name)
NOTE<-c()
for (i in 1:nrow(DATA_FIPO_DETAIL)){
  if (DATA_FIPO_DETAIL$STATUS[i]=="TERMINATED"){
    NOTE<-c(NOTE,"Ng??y k???t th??c h???p ?????ng so v???i ng??y gi???i ng??n l???n h??n 5 ng??y")
  }else{
    NOTE<-c(NOTE,"")
  }
}
DATA_FIPO_DETAIL$NOTE<-NOTE

write_csv(DATA_FIPO_DETAIL,paste("FIPO/","DATA_FIPO_DETAIL_",paste(format(Sys.Date()-18,format="%Y"),format(Sys.Date()-18,format="%m"),sep=""),".csv",sep=""))
write_csv(FEE_SERVICE_FIPO,paste("FIPO/","FEE_SERVICE_FIPO_",paste(format(Sys.Date()-18,format="%Y"),format(Sys.Date()-18,format="%m"),sep=""),".csv",sep=""))

