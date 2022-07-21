<#
.Synopsis
   Intakes a CSV that holds formstack data, outputs daily information for easy review
.DESCRIPTION
   TBD
.EXAMPLE
   Example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
    File Name  : FormStackDate
    Author: Ryan L. McLain
    Date last revised: 7/20/2022

#>

#Region Parameters

Param(
    #File path for the InputCSV file
    [Parameter(Mandatory = $False)]
    [String] $InputFilePath = 'C:\TechZone',
    #Filename of the input file
    [Parameter(Mandatory = $False)]
    [String] $InputFileName = "Cardswipe_Data_07-20-22.csv",
    #File path for the output file
    [Parameter(Mandatory = $False)]
    [String] $OutputFilePath = "",
    #Filename of the output file
    [Parameter(Mandatory = $False)]
    [String] $OutputFileName = ".csv",
    #Download link for MalwareBytes
    [Parameter(Mandatory = $False)]
    [String] $TBD = 0
)

#endregion Parameters

#region Functions

#endregion Functions

#import CSV and only grab the time column
$Data = Import-CSV -Path "$InputFilePath/$InputFileName" | Select-Object -expandProperty Time

#For every Date/time change the date formatting to dd/MM/yyyy to more easily match lines
ForEach($Line in $Data){
   $Date = $Line.substring(0, $Line.indexof(' '))
   $CheckInCount = ($Data |Where-Object {$_ -Like $Date}).count
   
   $CustomerInfo += @{
   Date = $Date
   Check_Ins = $CheckInCount
   }

}