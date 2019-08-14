
$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Connect-AzAccount `
        -ServicePrincipal `
        -Tenant $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}


$expResources= Search-AzGraph -Query 'where todatetime(tags.expireOn) < now() | project id'

foreach ($r in $expResources) {
    "Expired Resource ID=" + $r.id
    Remove-AzResource -ResourceId $r.id -Force -WhatIf
    "------------------------------"
}

Write-Output "== Done deleting Resources. =========="


$rgs = Get-AzResourceGroup;
 
foreach($resourceGroup in $rgs){
    $name=  $resourceGroup.ResourceGroupName;
    $count = (Get-AzResource | Where-Object{ $_.ResourceGroupName -match $name }).Count;
    if($count -eq 0){
        Write-Output "==> $name is empty. Deleting it...";
        Remove-AzResourceGroup -Name $name -Force -WhatIf
    }
}
