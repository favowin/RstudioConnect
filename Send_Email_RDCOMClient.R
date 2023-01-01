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
sheet1 <- createSheet(workbook, sheetName = "4 Cylinder Cars")

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

# Add a data frame to our worksheet
addDataFrame(mtcars[mtcars$cyl == 4 , ], sheet1, startRow=6, startColumn=1, colnamesStyle = headingStyle, rownamesStyle = rowStyle)

# Set the width of the first column to be wider so the full car names display
setColumnWidth(sheet1, colIndex=1, colWidth=15)

# Save the workbook
saveWorkbook(workbook, "workbook.xlsx")
