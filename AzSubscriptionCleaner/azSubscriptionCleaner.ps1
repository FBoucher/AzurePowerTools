
clear

$expResources= Search-AzGraph -Query 'where todatetime(tags.expireOn) < now() | project id'

foreach ($r in $expResources) {
    Remove-AzResource -ResourceId $r.id -Force -WhatIf
    "------------------------------"
}
