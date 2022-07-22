<#
.Synopsis
   Intakes a CSV that holds formstack data, outputs daily information for easy review
.DESCRIPTION
   Intakes a CSV that holds formstack data of dates and categories for service counter help, sorts the data and then exports it into an easily readable format
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
    [String] $InputFileName = "Cardswipe_Data_07-20-22.csv",
    #Filename of the output file
    [Parameter(Mandatory = $False)]
    [String] $OutputFileName = "Output.csv"
)

#endregion Parameters

#Datatable hashtable to be used later
$DataTable = @{}
#import CSV and only grab the time column
$Data = Import-CSV -Path "$FilePath/$InputFileName" | Select-Object -expandProperty Time

#For every Date/time change the date formatting to dd/MM/yyyy to more easily match lines
ForEach($Line in $Data){
   $Date = $Line.substring(0, $Line.indexof(' '))
   
   #If this date is the same as the last date in $Data, skip to next line
   if($LastDate -contains $Date){
      Continue
   #Count the number of rows that share a date, and make that the Check-in data, then save it to a hashtable
   }Else{
      $CheckInCount = ($Data |Where-Object {$_ -Like "$Date*"}).count
      $LastDate = $Date

      #Saves Date and check ins to a hashtable
      $DataTable += @{
      "$Date" = $CheckInCount
      }
   }
}

#Sorts the hash table based on the date column being seen as date/time rather than a string and exports it as a CSV
$DataTable.GetEnumerator() | Select-Object Name, Value | Sort-Object {$_.Name -as [DateTime]} | Export-CSV -Path "$FilePath/$OutputFileName" -NoTypeInformation