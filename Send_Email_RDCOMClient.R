# Load the xlsx package
library("xlsx")

# Create an empty Excel workbook
workbook <- createWorkbook(type="xlsx")

# Add a format for the title
titleStyle <- CellStyle(workbook) + Font(workbook, name = "Calibri Light", heightInPoints=18, color="#AE4371")

# Add a format for table headings
headingStyle <- CellStyle(workbook) + Font(workbook, name = "Calibri", heightInPoints=11, color="#44546A",  isBold=TRUE) + Border(color="#8EA9DB", position="BOTTOM", pen="BORDER_MEDIUM")

# Add a format for table rows
rowStyle <- CellStyle(workbook) + Font(workbook, name = "Calibri", heightInPoints=11, isBold=TRUE)

# Add a format for comments
commentStyle <- CellStyle(workbook) + Font( workbook, name = "Calibri", heightInPoints=11, color="#7F7F7F", isItalic=TRUE)

# Add a sheet to our workbook
sheet1 <- createSheet(workbook, sheetName = "Payment")
sheet2 <- createSheet(workbook, sheetName = "4 Cylinder Cars")


# We'll start with adding a title

# First we'll create a new row, let's put the title on row 2
titleRow <-createRow(sheet1, rowIndex=2)
# We'll add a cell to that row (in the first column) for the title
sheetTitle <-createCell(titleRow, colIndex=1)
# We'll add the sheet title to the cell
setCellValue(sheetTitle[[1,1]], "4 Cylinder Cars")
# We'll choose the formatting for the cell
setCellStyle(sheetTitle[[1,1]], titleStyle)

# Now we'll repeat this process to add a comment to the worksheet

# First we'll create a new row, let's put the comment on row 4
titleRow <-createRow(sheet1, rowIndex=4)
# We'll add a cell to that row (in the first column) for the comment
sheetTitle <-createCell(titleRow, colIndex=1)
# We'll add the comment to the cell
setCellValue(sheetTitle[[1,1]], "A listing of all the 4 cylinder cars from the mtcars dataset")
# We'll choose the formatting for the cell
setCellStyle(sheetTitle[[1,1]], commentStyle)

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


# Add a data frame to our worksheet
addDataFrame(Payment_Collection_CASHLOAN, sheet1, startRow=6, startColumn=1, colnamesStyle = headingStyle, rownamesStyle = rowStyle)

# Set the width of the first column to be wider so the full car names display

# Save the workbook
saveWorkbook(workbook, paste("FIPO/workbook_",paste(format(Sys.Date()-1,format="%d"),format(Sys.Date()-1,format="%m"),format(Sys.Date()-1,format="%Y"),sep=""),".xlsx",sep=""))

