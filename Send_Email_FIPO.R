

library(DT)
library(formattable)
library(readr)
library(bigrquery)
library(mailR)
library(htmlTable)
# Create a reproducible data frame
x <- FEE_SERVICE_FIPO
# Convert the data frame into an HTML Table
y <- htmlTable(x, rnames = FALSE)
# Define body of email
html_body <- paste0("<html><head>
               <style>
               body{font-family:Calibri, sans-serif;}
               table{border-left:1px solid #000000;border-top:1px solid #000000;}
               table th{border-right:1px solid #000000;border-bottom:1px solid #000000;font-size:13px; font-weight:bold; margin: 0px; padding-left: 5px; padding-right: 5px; margin: 0px;}
               table td{border-right:1px solid #000000;border-bottom:1px solid #000000;font-size:13px; font-weight:normal; margin: 0px; padding-left: 5px; padding-right: 5px; margin: 0px;}
               </style>
               </head><body><p> This is a test email. Ignore it.</p>",
                    y, 
                    "</body></html>")
# Configure details to send email using mailR
sender <- "fofawubian369@fofawubian369.com"
recipients <- c("duy.nguyen03@easycredit.vn","nguyenducduy250494@gmail.com")
send.mail(from = sender,
          to = recipients,
          subject = paste("SERVICE FEE AND DATA RECONSILIATION FOR 3M FROM"," ",StartMonth," ","TO"," ",EndMonth,sep=""),
          body = html_body,
          smtp = list(host.name = "mail.fofawubian369.com",
                      port = 465, 
                      user.name = "fofawubian369@fofawubian369.com",            
                      passwd = "Fofawubian369",
                      ssl = TRUE),
          authenticate = TRUE,
          html = TRUE,
          send = TRUE)
