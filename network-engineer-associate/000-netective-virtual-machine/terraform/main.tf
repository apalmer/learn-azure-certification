provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "netective" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_public_ip" "netective" {
  name                = "${var.name}-public-ip"
  resource_group_name = azurerm_resource_group.netective.name
  location            = azurerm_resource_group.netective.location

  allocation_method = "Dynamic"

  tags = var.tags
}

resource "azurerm_network_interface" "netective" {
  name                = "${var.name}-nic"
  resource_group_name = azurerm_resource_group.netective.name
  location            = azurerm_resource_group.netective.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.netective.id
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "netective" {
  name                = "${var.name}-nsg"
  resource_group_name = azurerm_resource_group.netective.name
  location            = azurerm_resource_group.netective.location

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "netective" {
  network_interface_id      = azurerm_network_interface.netective.id
  network_security_group_id = azurerm_network_security_group.netective.id
}

resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.netective.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "netective" {
  name                     = "diag${random_id.random_id.hex}"
  resource_group_name      = azurerm_resource_group.netective.name
  location                 = azurerm_resource_group.netective.location

  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "netective" {
  name                = var.name
  resource_group_name = azurerm_resource_group.netective.name
  location            = azurerm_resource_group.netective.location

  size                = "Standard_B2s"
  admin_username      = "adminuser"
  custom_data = filebase64("${path.module}/../cli/ubuntu-cloud-init.yaml")

  network_interface_ids = [
    azurerm_network_interface.netective.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/netective.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.netective.primary_blob_endpoint
  }

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}

data "azurerm_public_ip" "netective" {
  name = azurerm_public_ip.netective.name
  resource_group_name = azurerm_linux_virtual_machine.netective.resource_group_name
}

# resource "azurerm_dev_test_global_vm_shutdown_schedule" "netective" {
#   location           = azurerm_resource_group.netective.location

#   virtual_machine_id = azurerm_linux_virtual_machine.netective.id
#   enabled            = true
#   daily_recurrence_time = "1930"
#   timezone              = "UTC"

#   notification_settings {
#     enabled = false
#   }

#   tags = var.tags
# }
