Param( 
  [string]$resourceGroupName,
  [string]$location,
  [string]$resourceGroupCommand,
  [string]$templateFile,
  [string]$parametersFile,
  [string]$templateUri,
  [string]$parametersUri,
  [string]$scope
)

$ErrorActionPreference = 'Stop'

$context = Get-AzContext
if (!$context) {
  Write-Output "##########`nNo Azure context found! Please make sure azlogin has run before.`n##########"
  exit
}

Try {
  $deploymentName = "$($env:GITHUB_WORKFLOW)-$($env:GITHUB_ACTOR)-$(Get-Date -Format yyyyMMddHHMMss)"[0..63] -join ""
  Write-Output "$deploymentName"
  if ($resourceGroupCommand -and ($resourceGroupCommand -like "create") -and $resourceGroupName) {
    Write-Output "##########`nExecuting commands to create/update resource group $resourceGroupName ...`n"
    if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
      if ($location) {
        New-AzResourceGroup -Name "$resourceGroupName" -Location "$location" -Force
      }
    }
    if ($templateFile -and $parametersFile) {
      Write-Output "##########`nDeploying with templateFile and parametersFile in $resourceGroupName ...`n##########"
      Write-Output "templateFile: $templateFile"
      Write-Output "parametersFile: $parametersFile"
      $DeploymentInputs = @{
        Name                  = "$deploymentName"
        ResourceGroupName     = "$resourceGroupName"
        TemplateFile          = "$templateFile"
        TemplateParameterFile = "$parametersFile"
        Mode                  = "Incremental"
        Verbose               = $true
        ErrorAction           = "Stop"
      }

      New-AzResourceGroupDeployment @DeploymentInputs
    }
    elseif ($templateUri -and $parametersUri) {
      Write-Output "##########`nDeploying with templateUri and parametersUri in $resourceGroupName ...`n##########"
      Write-Output "templateUri: $templateUri"
      Write-Output "parametersUri: $parametersUri"
      $DeploymentInputs = @{
        Name                 = "$deploymentName"
        ResourceGroupName    = "$resourceGroupName"
        TemplateUri          = "$templateUri"
        TemplateParameterUri = "$parametersUri"
        Mode                 = "Incremental"
        Verbose              = $true
        ErrorAction          = "Stop"
      }
    
      New-AzResourceGroupDeployment @DeploymentInputs
    }
    elseif ($templateUri -and $parametersFile) {
      Write-Output "##########`nDeploying with templateUri and parametersFile in $resourceGroupName ...`n##########"
      Write-Output "templateUri: $templateUri"
      Write-Output "parametersFile: $parametersFile"
      $DeploymentInputs = @{
        Name                  = "$deploymentName"
        ResourceGroupName     = "$resourceGroupName"
        TemplateUri           = "$templateUri"
        TemplateParameterFile = "$parametersFile"
        Mode                  = "Incremental"
        Verbose               = $true
        ErrorAction           = "Stop"
      }

      New-AzResourceGroupDeployment @DeploymentInputs
    }
    else {
      Write-Output "##########`nTemplate or parameters file does not exist. ...`n##########"
    }
  }
  elseif ($resourceGroupCommand -like "delete") {
    Write-Output "resourceGroupCommand is set to 'delete'. Removing $resourceGroupName now. "
    Remove-AzResourceGroup -Name $resourceGroupName -Force
  } # Subscription scope deployment
  elseif (($scope -like 'subscription') -and $location) {
    Write-Output "##########`nDeployment scope is set to $scope ...`n"
    if ($templateFile -and $parametersFile) {
      Write-Output "##########`nDeploying with templateFile and parametersFile on $($context).Account   ...`n##########"
      Write-Output "templateFile: $templateFile"
      Write-Output "parametersFile: $parametersFile"
      $DeploymentInputs = @{
        Name                  = "$deploymentName"
        Location              = "$location"
        TemplateFile          = "$templateFile"
        TemplateParameterFile = "$parametersFile"
        Verbose               = $true
        ErrorAction           = "Stop"
      }

      New-AzDeployment @DeploymentInputs
    }
    elseif ($templateUri -and $parametersUri) {
      Write-Output "##########`nDeploying with templateUri and parametersUri on $($context).Account ...`n##########"
      Write-Output "templateUri: $templateUri"
      Write-Output "parametersUri: $parametersUri"
      $DeploymentInputs = @{
        Name                 = "$deploymentName"
        Location             = "$location"
        TemplateUri          = "$templateUri"
        TemplateParameterUri = "$parametersUri"
        Verbose              = $true
        ErrorAction          = "Stop"
      }
    
      New-AzDeployment @DeploymentInputs
    }
    elseif ($templateUri -and $parametersFile) {
      Write-Output "##########`nDeploying with templateUri and parametersFile on $($context).Account ...`n##########"
      Write-Output "templateUri: $templateUri"
      Write-Output "parametersFile: $parametersFile"
      $DeploymentInputs = @{
        Name                  = "$deploymentName"
        Location              = "$location"
        TemplateUri           = "$templateUri"
        TemplateParameterFile = "$parametersFile"
        Verbose               = $true
        ErrorAction           = "Stop"
      }
      
      New-AzDeployment @DeploymentInputs
    }
    else {
      Write-Output "##########`nSomething went wrong ...`n##########"
    }
  }
}
Catch {
  $_.Exception.Message
  $_.Exception.ItemName
  Throw
}
