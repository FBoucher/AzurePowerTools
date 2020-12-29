# AzurePowerTools

Here a little script that will completely delete all resources of every resources group inside a specific subscription.  To be able to execute this script you will need Azure [PowerShell cmdlets](https://docs.microsoft.com/powershell/azureps-cmdlets-docs/?WT.mc_id=dotnet-0000-frbouche).

The script asks you to login-in then list all the subscriptions that this account has access. Once you specify which one, it will list all the resource grouped by resource group. Then as a final warning, it will require one last validation before nuking everything.

Be  careful. 

Related blog post: 

- [Need to Nuke an Azure Subscription?](http://www.frankysnotes.com/2016/12/need-to-nuke-azure-subscription.html)
- [Besoin d'exploser un abonnement Azure?](http://www.cloudenfrancais.com/besoin-dexploser-un-abonnement-azure/)

