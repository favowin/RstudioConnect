library(curl)

library(openxlsx)
library(lubridate)
library(RCurl)
Day<-format(Sys.Date()-1,format="%d")
Month<-format(Sys.Date()-1,format="%m")
Year<-format(Sys.Date()-1,format="%Y")
Date<-paste(Year,Month,Day,sep="")

setwd("VNP/")
download.file(paste("ftp://user1319:806Srkh$@ftp.vnpost.vn/ONLPAY_1319_",Date,".zip",sep=""),paste("ONLPAY_1319_",Date,".zip",sep=""))

df<-unzip(paste("ONLPAY_1319_",Date,".zip",sep=""))

download.file(paste("ftp://user1319:806Srkh$@ftp.vnpost.vn/PCH_2326_",Date,".zip",sep=""),paste("PCH_2326_",Date,".zip",sep=""))

df<-unzip(paste("PCH_2326_",Date,".zip",sep=""))
