
#================================================================
#= Very dangerous interactive script that delete all rescources 
#= from all rescourcegroup in a specific subscription
#================================================================



# How to install and configure Azure PowerShell
# https://docs.microsoft.com/en-us/powershell/azureps-cmdlets-docs/

# Login
Login-AzureRmAccount 

# Get a list of all Azure subscript that the user can access
$allSubs = Get-AzureRmSubscription 

$allSubs | Sort-Object Name | Format-Table -Property Name, SubscriptionId, State


$theSub = Read-Host "Enter the subscriptionId you want to clean"

Write-Host "You select the following subscription. (it will be display 15 sec.)" -ForegroundColor Cyan
Get-AzureRmSubscription -SubscriptionId $theSub | Select-AzureRmSubscription 

# Get all the resources groups
$allRG = Get-AzureRmResourceGroup

foreach ( $g in $allRG){

    Write-Host $g.ResourceGroupName -ForegroundColor Yellow 
    Write-Host "------------------------------------------------------`n" -ForegroundColor Yellow 
    
    # Using -ODataQuery is compatible with AzureRM 5.x and AzureRM 6.x. -ResourceGroupName is only in 6.x
    $query = "`$filter=resourceGroup eq '{0}'" -f $g.ResourceGroupName
    $allResources = Get-AzureRmResource -ODataQuery $query
    
    if($allResources){
        $allResources | Format-Table -Property Name, ResourceName
    }else{
         Write-Host "-- empty--`n"
    } 
    Write-Host "`n`n------------------------------------------------------" -ForegroundColor Yellow 
}

exit

$lastValidation = Read-Host "Do you wich to delete ALL the resouces previously listed? (YES/ NO)"

if($lastValidation.ToLower().Equals("yes")){

    foreach ( $g in $allRG){

        Write-Host "Deleting " $g.ResourceGroupName 
        # Last safety, you need to remove the -WhatIf parameter to really delete the resources
        Remove-AzureRmResourceGroup -Name $g.ResourceGroupName -Force -WhatIf

    }
}else{
     Write-Host "Aborded. Nothing was deleted." -ForegroundColor Cyan
}

