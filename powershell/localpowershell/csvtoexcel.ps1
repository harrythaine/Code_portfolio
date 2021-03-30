

import-csv "C:\Users\username\test1.csv" | export-excel "C:\Users\username\test1.xlsx"

#Define locations and delimiter
$csv = "C:\Users\username\test1.csv"  #Location of the source file
$xlsx = "C:\Users\username\test1.xlsx" #Desired location of output
$delimiter = "," #Specify the delimiter used in the file

# Create a new Excel workbook with one empty sheet
$excel = New-Object -ComObject excel.application 
$workbook = $excel.Workbooks.Add(1)
$worksheet = $workbook.worksheets.Item(1)

# Build the QueryTables.Add command and reformat the data
$TxtConnector = ("TEXT;" + $csv)
$Connector = $worksheet.QueryTables.add($TxtConnector,$worksheet.Range("A1"))
$query = $worksheet.QueryTables.item($Connector.name)
$query.TextFileOtherDelimiter = $delimiter
$query.TextFileParseType  = 1
$query.TextFileColumnDataTypes = ,1 * $worksheet.Cells.Columns.Count
$query.AdjustColumnWidth = 1

# Execute & delete the import query
$query.Refresh()
$query.Delete()

# Save & close the Workbook as XLSX.
$Workbook.SaveAs($xlsx,51)

$worksheet = $excel.Workbook.Worksheets[1]
$excel.Quit()

."C:\Users\username\username\test1.xlsx" 