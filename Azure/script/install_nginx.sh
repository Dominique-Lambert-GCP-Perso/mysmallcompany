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
  az vmss extension set \
    --publisher Microsoft.Azure.Extensions \
    --version 2.0 \
    --name CustomScript \
    --resource-group $rgName \
    --vmss-name myvmss03$i \
    --settings '{ "fileUris": ["https://raw.githubusercontent.com/linuxacademy/content-az-300-lab-repos/master/application-gateway/iis/install_nginx.sh"], "commandToExecute": "./install_nginx.sh" }'
done
