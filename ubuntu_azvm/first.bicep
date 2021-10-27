@description('The name of you Virtual Machine.')
param vmname    string
param vmuser    string
@secure()
param vmpass    string
@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmname}-${uniqueString(resourceGroup().id)}')
//param publickey string

// param setupscript          string = 'https://raw.githubusercontent.com/yskszk63/azure-rust-win-vm/main/setup.ps1'
// param setupscriptTimestamp int    = 0

var location = resourceGroup().location

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-07-01' = {
  name      : '${vmname}-nsg'
  location  : location
  properties: {
    securityRules: [
      {
        name: 'allow-ssh'
        properties: {
          priority                 : 110
          protocol                 : 'Tcp'
          sourcePortRange          : '*'
          destinationPortRange     : '22'
          sourceAddressPrefix      : '*'
          destinationAddressPrefix : '*'
          access                   : 'Allow'
          direction                : 'Inbound'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: '${vmname}-vnet'
  location: location
  properties: {
    addressSpace: { 
      addressPrefixes: [ 
        '10.0.0.0/16' 
      ] 
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: { 
            id: nsg.id 
          }
        }
      }
    ]
  }
}

resource pip 'Microsoft.Network/publicIPAddresses@2020-07-01' = {
  name: '${vmname}-pip'
  location: location
  sku: { 
    name: 'Basic' 
  }
  properties: { 
    dnsSettings: { 
      domainNameLabel: dnsLabelPrefix 
    } 
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2020-07-01' = {
  name: '${vmname}-nic'
  location: location
  properties: {
    ipConfigurations: [
        {
          name: 'ifcfg'
          properties: {
            publicIPAddress: { 
              id: pip.id 
            }
            subnet         : { 
              id: vnet.properties.subnets[0].id 
            }
          }
        }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name      : vmname
  location  : location
  properties: {
    hardwareProfile: { 
      vmSize: 'Standard_B2ms' 
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: '${vmname}-osdisk'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: { 
          storageAccountType: 'Premium_LRS' 
        }
        diskSizeGB: 64
      }
    }
    osProfile: {
      computerName : vmname
      adminUsername: vmuser
      adminPassword: vmpass
    }
    networkProfile: { 
      networkInterfaces: [ 
        { 
          id: nic.id 
        } 
      ] 
    }
  }
}

output adminUsername string = vmuser
output hostname string = pip.properties.dnsSettings.fqdn
output sshCommand string = 'ssh ${vmuser}@${pip.properties.dnsSettings.fqdn}'
