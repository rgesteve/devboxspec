resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "myVM"
    location              = "westus"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    vm_size               = "Standard_B2ms"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myvm"
        admin_username = "rgesteve"
    }

    os_profile_linux_config {
        disable_password_authentication = false
        # ssh_keys {
        #     path     = "/home/rgesteve/.ssh/authorized_keys"
        #     key_data = "ssh-rsa AAAAB3Nz{snip}hwhqT9h"
        # }
    }

    # boot_diagnostics {
    #     enabled = "true"
    #     storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    # }
}
