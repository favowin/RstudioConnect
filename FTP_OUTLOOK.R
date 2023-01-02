install.packages("RDCOMClient", repos = "http://www.omegahat.net/R", type = "win.binary")
library(RDCOMClient)
library(openxlsx)
library(lubridate)

# setwd("E:/Taiwanese")
outlook_app <- COMCreate("Outlook.Application")
search <- outlook_app$AdvancedSearch(
  "Inbox",
  "urn:schemas:httpmail:subject like '%EPAY_EVN_%'"
)

Sys.sleep(10)
results <- search$Results()
attachment_file <- tempfile()

library(RCurl)

date <- function(){
  if ((wday(format(Sys.Date(), "%Y-%m-%d"), label = FALSE)) == 1){
    return(format(Sys.Date(), "%Y-%m-%d"))
  } else {
    return(format(Sys.Date()-1, "%Y-%m-%d"))
  }
}

for (i in 400:results$Count()) {
  if (as.Date("1899-12-30") + floor(results$Item(i)$ReceivedTime()) == as.Date(date())) {
    email <- results$Item(i)
    attachment <- email$Attachments()
    
    for(j in 1:attachment$Count()) {
      if (grepl(".xlsx", attachment$Item(j)$FileName(), ignore.case = TRUE)) {
        attachmentname <- attachment$Item(j)$FileName()
        attachment_file <- paste0(getwd(), "/", attachmentname)
        # attachment$Item(j)$SaveAsFile(attachment_file)
        # ftpUpload(attachment$Item(j)$FileName(), paste("ftp://ngejmair:Fofawubian369@ftp.fofawubian369.com/public_html/wp-content/uploads/2022/11/",gsub(".xlsx",".xlsx",attachment$Item(j)$FileName()),sep=""))
        ftpUpload(attachment$Item(j)$FileName(), paste("ftp://ngejmair:Fofawubian369@ftp.fofawubian369.com/public_html/wp-content/uploads/2022/11/",attachment$Item(j)$FileName(),sep=""))
        
      }
      Sys.sleep(10)
    }
  }
}
