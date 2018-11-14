

# Login-AzureRmAccount

$Subscription = Get-AzureRmSubscription -SubscriptionName 'SUBSCRIPTION_NAME'

Select-AzureRmSubscription -Subscription $Subscription.Id

#== VM selection =========================
$selectedVMs = Get-Azurermvm -ResourceGroupName cloud5mins

foreach($vm in $selectedVMs) 
{ 
    $ResourceGroup = $vm.ResourceGroupName
    $vmName = $vm.Name
    $ScheduledShutdownResourceId = "/subscriptions/$Subscription/resourceGroups/$ResourceGroup/providers/microsoft.devtestlab/schedules/shutdown-computevm-$vmName"

    $Properties = @{}
    $Properties.Add('status', 'Enabled')
    $Properties.Add('targetResourceId', $vm.Id)
    $Properties.Add('taskType', 'ComputeVmShutdownTask')
    $Properties.Add('dailyRecurrence', @{'time'= 2100})
    $Properties.Add('timeZoneId', 'Eastern Standard Time')
    $Properties.Add('notificationSettings', @{status='Disabled'; timeInMinutes=60})

    New-AzureRmResource -Location $vm.Location -ResourceId $ScheduledShutdownResourceId -Properties $Properties -Force
}

