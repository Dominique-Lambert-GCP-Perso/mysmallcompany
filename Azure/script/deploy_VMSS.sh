#!/bin/bash
rgName=$(az group list --query '[].{name:name}' --output tsv)
vnetName=$(az network vnet list --query '[].{name:name}' --output tsv)
snetName=$(az network vnet subnet list --resource-group $rgName --vnet-name $vnetName --query "[?contains(name, 'snet2')].{Name:name}" --output tsv)
agwName=$(az network application-gateway list --query '[].{name:name}' --output tsv)

echo "rgName : $rgName"
echo "vnetName : $vnetName"
echo "snetName : $snetName"
echo "agwName : $agwName"


for i in `seq 1 1`; do

  if [ $i -eq 1 ]
  then
    poolName="defaultbackendpool" 
  fi

  if [ $i -eq 2 ]
  then
    poolName="imagesBackendPool"
  fi

  if [ $i -eq 3 ]
  then
    poolName="videoBackendPool"
  fi

  az vmss create \
    --name myvmss$i \
    --resource-group $rgName \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password Azure123456! \
    --instance-count 2 \
    --vnet-name $vnetName \
    --subnet $snetName \
    --vm-sku Standard_DS1_v2 \
    --upgrade-policy-mode Automatic \
    --app-gateway $agwName \
    --backend-pool-name $poolName

sleep 20s

done
