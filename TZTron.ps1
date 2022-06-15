<#
.SYNOPSIS
    Runs the most updated version of Tron that can be found at: www.bmrf.org
.DESCRIPTION
    Verifies it is being launched with elevated privledges, then reaches out to https://www.bmrf.org/repos/tron/ and grabs the most recent version of Tron. Tron then runs with minimal user interface.
.NOTES
    AUTHOR: 	Ryan L. McLain (rmclain@ilstu.edu)
	VERSION:	1.0.1
    Date:       06/15/2022

   REQUIREMENTS:   
        Administrator access - Local administrator account 
        A normal Windows 10 Environment or Safe-Mode With Networking
#>

#Region Parameters
Param(
    #The download path for the download files
    [Parameter(Mandatory = $False)]
    [String] $DLPath = "$env:userprofile\Downloads",
    #Tron destination + Filename
    [Parameter(Mandatory = $False)]
    [String] $TronDownload = "tron.exe",
    #Repository where Tron is downloaded
    [Parameter(Mandatory = $False)]
    [String] $URL = "https://www.bmrf.org/repos/tron/"
)

#This sets $var to the equivalent of running curl and grepping for "Tron.exe" I barely understand this portion but it works well
$var = (((Invoke-WebRequest -uri $url).links.href | Sort-Object -Descending)[1])

#endregion Parameters

#Region Code Execution
# Verify the Script is being run as an Administrator, if not, force it to run as admin
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(` [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-process PowerShell ISE -Verb RunAs
    Exit
}

#Deletes any Tron folder/exe that already exist in the downloads folder
Get-Childitem -Path "$DLPath\tron.exe" -ErrorAction Ignore | Remove-Item -Force -Verbose -Recurse
Get-Childitem -Path "$DLPath\tron" -ErrorAction Ignore | Remove-Item -Force -Verbose -Recurse
Remove-Item -Path "C:\tron" -ErrorAction Ignore -Force -Verbose -Recurse
    
#Downloads the newest version of Tron found at bmrf.org.
New-Item -ItemType directory -Path "C:\Tron"
Write-Output "Downloading Most recent version in Repo: $url$var"
Invoke-WebRequest -uri $url$var -OutFile "$DLPath\$TronDownload"
Write-Output "Placing $TronDownload at directory: $DLPath"
    
#Runs Tron.exe, waits for the Exe to finish running, and places the extracted files into C:\Tron
$proc = Start-Process -workingdirectory "$DLPath" Tron.exe -Passthru
$proc.WaitForExit()
Start-Sleep -S 15
Write-Output "Extracting Tron Files to C:\Tron"
Move-Item -path "$DLPath\Tron\*" -Destination "C:\Tron\"

#Deletes created folder and exe from the downloads folder
Remove-Item "$DLPath\tron.exe" -ErrorAction Ignore -Force -Recurse
Remove-Item "$DLPath\tron" -ErrorAction Ignore -Force -Recurse

#Attemps to Run tron
If (Get-ChildItem "C:\Tron\Tron.bat") {
    #Launches Tron
    Start-Process -workingdirectory "C:\Tron" tron.bat
}
Else {
    #If Tron can not run, assumes something is wrong
    Add-Type -AssemblyName PresentationCore, PresentationFramework    
    $ButtonType = [System.Windows.MessageBoxButton]::Ok
    $MessageboxTitle = "ERROR"
    $Messageboxbody = "Tron has failed to succesfully start. Please verify your internet connection and try again"
    $MessageIcon = [System.Windows.MessageBoxImage]::Warning
    [System.Windows.MessageBox]::Show($Messageboxbody, $MessageboxTitle, $ButtonType, $messageicon)
    Exit
}
    
#endregion Code Execution