#!/usr/bin/env bash

# This script runs interactively (it requires some parameters from the user)
# (Assumes ARM template has been generated using `az bicep build`)

RESOURCEGRPNAME="testdeploy-grp"
DEPLOYMENTNAME="FirstDeployment"

az login
# If above doesn't open an interactive browser (I've seen this happen sometimes when working on codespace)
#     use `az login --use-device-code`, which will provide short code you can then use at https://microsoft.com/devicelogin
#     to authenticate.  This is called "device flow" and (kinda) documented at https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli#sign-in-interactively
# This actually doesn't work because the `list` command returns result with quotes
az account set --subscription $(az account list | jq '.[0].id')

az group create --name ${RESOURCEGRPNAME} --location "westus"
az deployment group create --name ${DEPLOYMENTNAME} --resource-group ${RESOURCEGRPNAME} --template-file ubuntu_azvmbp/first.json \
  --query "properties.outputs.[publicFQDN.value, publicSSH.value]" -o tsv

# az group delete --name ${RESOURCEGRPNAME}
# az deployment group create \
#  --resource-group <REPLACE_WITH_YOUR_RESOURCE_GROUP> \
#  --template-uri "https://raw.githubusercontent.com/Azure/iotedge-vm-deploy/1.2.0/edgeDeploy.json" \
#  --parameters dnsLabelPrefix='<REPLACE_WITH_UNIQUE_DNS_FOR_VIRTUAL_MACHINE>' \
#  --parameters adminUsername='azureuser' \
#  --parameters authenticationType='sshPublicKey' \
#  --parameters adminPasswordOrKey="$(< ~/.ssh/id_rsa.pub)" \
#  --query "properties.outputs.[publicFQDN.value, publicSSH.value]" -o tsv