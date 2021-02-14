Param( 
  [string]$resourceGroupName,
  [string]$resourceName,
  [string]$resourceId
)

$context = Get-AzContext
if (!$context) {
  Write-Output "##########`nNo Azure context found! Please make sure azlogin has run before.`n##########"
  exit
}

$ErrorActionPreference = 'Stop'

Try {
  if ($resourceGroupName) {
    Write-Output "##########`nRemoving resource group $resourceGroupName ...`n"
    Remove-AzResourceGroup -Name $resourceGroupName -Force
  }
  elseif ($resourceName -and $resourceGroupName) {
    Write-Output "##########`nRemoving resource $resourceName ...`n"
    Remove-AzResource -ResourceName $resourceName -Force
  }
  elseif ($resourceId) {
    Write-Output "##########`nRemoving resource with resource ID $resourceId ...`n"
    Remove-AzResource -ResourceId $resourceId -Force
  }
}
Catch {
  $_.Exception.Message
  $_.Exception.ItemName
  Throw
}