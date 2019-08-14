

$rgs = Get-AzResourceGroup;
 
foreach($resourceGroup in $rgs){
    $name=  $resourceGroup.ResourceGroupName;
    $count = (Get-AzResource | Where-Object{ $_.ResourceGroupName -match $name }).Count;
    if($count -eq 0){
        Write-Output "The resource group $name is empty. Deleting it...";
        Remove-AzResourceGroup -Name $name -Force -WhatIf
    }
}
