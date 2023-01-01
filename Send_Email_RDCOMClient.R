library(RDCOMClient)

OutApp<-COMCreate("Outlook.Application")

outMail=OutApp$CreateItem(0)

outMail[["To"]]=paste("duy.nguyen03@easycredit.vn","duy.nguyen03@easycredit.vn",sep=";",collapse = NULL)
outMail[["Cc"]]=paste("","",sep=";",collapse = NULL)
outMail[["subject"]]=paste("OCR-eKYC: Số lượng request eKYC truy vấn tháng ",paste(format(Sys.Date()-27,format="%Y"),format(Sys.Date()-27,format="%m"),sep=""),sep="")
outMail[["HTMLbody"]]=paste("<p>","Dear BI,<br>","FIN gửi số lượng request eKYC ghi nhận. Nhờ BI hỗ trợ check và phản hồi sớm","</p>",paste0("Thanks & Regards,<br>","Nguyễn Đức Duy"))

  
#outMail[["attachments"]]$Add(paste("E:/Reconliiation/RISK_2/Reconsile/",paste(format(Sys.Date()-27,format="%Y"),format(Sys.Date()-27,format="%m"),sep=""),"/eKYC","/","GIAO_DICH_OCR_BI_KHONG_GHI_NHAN_",paste(format(Sys.Date()-27,format="%Y"),format(Sys.Date()-27,format="%m"),sep=""),".xlsx",sep=""))
outMail$Display()
outMail$Send()
