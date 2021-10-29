#!/usr/bin/env bash

# This script runs interactively (it requires some parameters from the user)
# (Assumes ARM template has been generated using `az bicep build`)

RESOURCEGRPNAME="testdeploy-grp"
DEPLOYMENTNAME="FirstDeployment"

az login
# This actually doesn't work because the `list` command returns result with quotes
az account set --subscription $(az account list | jq '.[0].id')

az group create --name ${RESOURCEGRPNAME} --location "westus"
az deployment group create --name ${DEPLOYMENTNAME} --resource-group ${RESOURCEGRPNAME} --template-file ubuntu_azvm/first.json 

# az group delete --resource-group ${RESOURCEGRPNAME}
