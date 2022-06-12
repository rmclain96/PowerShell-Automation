<#
.Synopsis
   First attempt at a discord bot. We will see how much I am able to accomplish
.DESCRIPTION
   TBD
.EXAMPLE
   Example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
    File Name  : DiscordBot_Trial.ps1    
    Author: Ryan L. McLain
    Date last revised: 6/11/2022

    Dependencies:
    Powershell 5.1+
    Module: PSDiscord
    Module: Microsoft.PowerShell.SecretManagement
#>

#First step: Make any necessary authentication with discord API using GitHub secrets
#   GitHub secrets are used to avoid Discord auth tokens being in plain-text

