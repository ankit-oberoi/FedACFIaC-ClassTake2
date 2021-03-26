<#
    .SYNOPSIS
        DSC configuration for the Litware domain controller
#>

Configuration SQLISS
{
    # current deployment has password scattered throughout solution, so we must suppress plain text password
    
    Import-DscResource -Module PSDesiredStateConfiguration
    Import-DscResource -Module xNetworking

    #Node for IISSQL
    Node localhost
    {
        # Install IIS Server
        WindowsFeature IIS {
            Name   = 'Web-Server'
            Ensure = 'Present'
        }     
    }
}
