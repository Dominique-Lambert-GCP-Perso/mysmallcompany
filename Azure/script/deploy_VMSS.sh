#!/bin/bash
rgName="grptest"
vnetName="vnet1"
snetName="subnetvm"
agwName="apgw02"

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
    --name myvmss03$i \
    --resource-group $rgName \
    --image UbuntuLTS \
    --admin-username dla \
    --admin-password Lamdomlamdom+0 \
	--public-ip-per-vm \
    --instance-count 2 \
    --vnet-name $vnetName \
    --subnet $snetName \
    --vm-sku Standard_DS1_v2 \
    --upgrade-policy-mode Automatic \
    --app-gateway $agwName \
    --backend-pool-name $poolName

sleep 20s

done
