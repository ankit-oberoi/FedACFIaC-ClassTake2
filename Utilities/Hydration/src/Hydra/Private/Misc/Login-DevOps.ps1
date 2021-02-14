<#
.Synopsis
    az CLI login
.Description
    az CLI login
#>
function Connect-DevOps {

    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        # Switch to skip login
        [Parameter(
            Mandatory = $false,
            HelpMessage = "Skip the login and uses cached credentials."
        )]
        [switch]$skipLogin = $false
    )
    process {
        Write-Verbose  "Logging in to Azure DevOps"
        Write-Verbose  "Loading DevOps CLI extension"
        if ($pscmdlet.ShouldProcess('CLI extension [azure-devops]', 'Install')) {
            az extension add --name azure-devops
        }

        if ($skipLogin) {
            Write-Warning "Skip 'az devops login': Using exsisting credentials"
        }
        else {
            Write-Verbose  "Logging in ..."
            if ($pscmdlet.ShouldProcess('To CLI context', 'Login')) {
                az devops login
            }
            Write-Verbose  "Login successfull"
        }

        Write-Verbose  "Logging in to Azure DevOps completed"
    }
}