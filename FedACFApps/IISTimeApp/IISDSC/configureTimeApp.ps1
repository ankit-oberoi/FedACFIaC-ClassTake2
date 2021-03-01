<#
    .SYNOPSIS
        DSC configuration for the Litware time card app server
#>

Configuration timeApp
{

    Import-DscResource -Module PSDesiredStateConfiguration
    Import-DscResource -Module ComputerManagementDsc
    Import-DscResource -Module xWebAdministration
    Import-DscResource -Module xNetworking

    # Create Credential Objects
    $crdDomainAdmin = Get-AutomationPSCredential 'domainAdminCredential'
    $appSourceFilePath = Get-AutomationVariable 'appSourceFilePath'
    $stagingStorageSASCred = Get-AutomationPSCredential 'storageSASCred'
    $stagingStorageSAS = $stagingStorageSASCred.GetNetworkCredential().Password

    # Node for TC1
    Node localhost
    {

        # Open remote PowerShell to be accessible from public to improve testing
        xFirewall RemotePowerShell {
            Name      = "Windows Remote Management (HTTP-In) All"
            Direction = "Inbound"
            Action    = "Allow"
            Enabled   = "True"
            LocalPort = 5985
            Protocol  = "TCP"
        }

        File createTempFolder
        {
            DestinationPath = 'C:\temp'
            Type = 'Directory'
            Ensure = 'Present'
        }
        Script getContent
        {
            GetScript = {
                $pathTest = Test-Path -Path "C:\temp\timeApp.zip"
            }

            TestScript = {
                $pathTest = Test-Path -Path "C:\temp\timeApp.zip"
                return $pathTest
            }

            SetScript = {
                Invoke-WebRequest -Uri "$using:appSourceFilePath/timeApp.zip$using:stagingStorageSAS" -OutFile "c:\temp\timeApp.zip" -UseBasicParsing
            }
            DependsOn = '[File]createTempFolder'
        }
        Archive unZipContent { 
            Destination = 'C:\Source'
            Path        = 'C:\temp\timeApp.zip'
            Ensure      = "Present"
            force       = $true
            DependsOn = '[script]getContent'
        }

        # Install IIS
        WindowsFeature IIS {
            Name                 = 'Web-Server'
            IncludeAllSubFeature = $true
            Ensure               = 'Present'
        }

        # Remove Default WebSite
        xWebSite WebDefault {
            Name      = 'Default Web Site'
            Ensure    = 'Absent'
            DependsOn = '[WindowsFeature]IIS'
        }

        # Copy TimeApp into Inetpub
        File fldTimeApp {
            DestinationPath = 'C:\inetpub'
            SourcePath      = 'C:\Source'
            Recurse         = $true
            Ensure          = 'Present'
            DependsOn       = '[xWebSite]WebDefault', '[Archive]unZipContent'
        }

        # Create Website - TimeApp
        xWebSite WebTimeApp {
            Name               = 'Litware TimeApp'
            BindingInfo        = MSFT_xWebBindingInformation {
                Protocol = 'http'
                Port     = 80
            }
            AuthenticationInfo = MSFT_xWebAuthenticationInformation {
                Anonymous = $true
                Windows   = $true
            }
            PhysicalPath       = 'C:\inetpub\TimeApp'
            Ensure             = 'Present'
            DependsOn          = '[xWebSite]WebDefault', '[File]fldTimeApp'
        }
    }
}
