param vmname    string
//param vmuser    string
//@secure()
//param vmpass    string
//param prefix    string
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

