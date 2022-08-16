<#
.Synopsis
   Intakes a CSV that holds formstack data, outputs 3 metrics reports
.DESCRIPTION
   Intakes a CSV that holds formstack data, outputs metrics reports for daily traffic, traffic metrics, and employee statistics into CSVs
.EXAMPLE
   Change file paths and names to fit your files, and no further modifications should be required
.OUTPUTS
   Output.csv containing dates/check-ins for service
.NOTES
    File Name  : FormStackDate
    Author: Ryan L. McLain
    Date last revised: 7/22/2022

#>

#Region Parameters

Param(
    #File path for the files
    [Parameter(Mandatory = $False)]
    [String] $FilePath = 'C:\TechZone',
    #Filename of the input file
    [Parameter(Mandatory = $False)]
    [String] $InputFileName = "Cardswipe_Data_08-15-22.csv",
    #Filename of the output file
    [Parameter(Mandatory = $False)]
    [String] $OutputDateName = "OutputDates",
   #Filename of the output file
   [Parameter(Mandatory = $False)]
   [String] $OutputULIDName = "OutputULID",
   #Filename of the output file
   [Parameter(Mandatory = $False)]
   [String] $OutputQuestionName = "OutputQuestions"
)

#CHANGE THIS TO SET WHICH MONTH the report will run for. By default it is set to -1 so that it runs last months report.
$Month = (Get-Date).Month-1
#Report date format
$ReportDate = get-date -Month $Month -format "yyyy-MM"

#endregion Parameters

#Datatable hashtable to be used later
$DataTable = @{}
#import CSV and only grab the time column
$Data = Import-CSV -Path "$FilePath/$InputFileName" | Select-Object Time, "My ULID", "What I did:"

#region DateOutput
#For every Date/time change the date formatting to dd/MM/yyyy to more easily match lines
ForEach($Line in $Data){
   $Date = $Line.time.substring(0, $Line.time.indexof(' '))
   
   #If this date is the same as the last date in $Data, skip to next line
   if($LastDate -contains $Date){
      Continue
   #Count the number of rows that share a date, and make that the Check-in data, then save it to a hashtable
   }Else{
      $CheckInCount = ($Data |Where-Object {$_.time -Like "$Date*"}).count
      $LastDate = $Date

      #Saves Date and check ins to a hashtable
      $DataTable += @{
      "$Date" = $CheckInCount
      }
   }
}
#endregion DateOutput

#region MonthlyReport

   $PriorMonth = $Data | Where-Object {(get-date $_.Time -format "yyyy-MM") -eq (get-date $Dateformat -Format "yyyy-MM")}

   #Groups the columns to count all instances of every value. So that we can see how many times a value occurred.
   $ULIDCount = $PriorMonth | Group-Object "My ULID" | Select-Object Name, Count
   $QuestionCount = $PriorMonth |Group-Object "What I Did:" | Select-Object Name, Count

#endregion MonthlyReport

#Sorts for DateOutput within $Datatable hash table based on the date column being seen as date/time and export CSV
$DataTable.GetEnumerator() | Select-Object Name, Value | Sort-Object {$_.Name -as [DateTime]} | Export-CSV -Path "$FilePath/$OutputDateName-$ReportDate.csv" -NoTypeInformation
$QuestionCount | Export-CSV -Path "$FilePath/$OutputQuestionName-$ReportDate.csv" -NoTypeInformation
$ULIDCount | Export-CSV -Path "$FilePath/$OutputULIDName-$reportDate.csv" -NoTypeInformation