


expResources=$(az graph query -q 'where todatetime(tags.expireOn) < now() | project id')

for r in $expResources
do
    echo $r
    echo "---"
done


# az resource delete --ids