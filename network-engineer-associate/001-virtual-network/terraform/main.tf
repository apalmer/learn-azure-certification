provider "azurerm" {
  features {}
}

locals {
  resourceGroupName     = "rg-networking"
  resourceGroupLocation = "eastus"

  vnetName   = "vnet-1"
  vnetCIDR   = "10.1.0.0/16"
  subnetName = "subnet-1"
  subnetCIDR = "10.1.0.0/24"
  tags = {
    Project = "AzureNetworkingCertification"
    Lab     = "001-virtual-network"
  }
}

resource "azurerm_resource_group" "rgNetworking" {
  name     = local.resourceGroupName
  location = local.resourceGroupLocation

  tags = local.tags
}

resource "azurerm_virtual_network" "main" {
  name                = local.vnetName
  location            = azurerm_resource_group.rgNetworking.location
  resource_group_name = azurerm_resource_group.rgNetworking.name

  address_space = [local.vnetCIDR]

  tags = local.tags
}

resource "azurerm_subnet" "main" {
  name                = local.subnetName
  resource_group_name = azurerm_resource_group.rgNetworking.name

  address_prefixes     = [local.subnetCIDR]
  virtual_network_name = azurerm_virtual_network.main.name
}

module "netective-1" {
  source = "../../000-netective-virtual-machine/terraform"
  name = "netective-1"

  resource_group_name = "rg-netective-1"
  subnet_id = azurerm_subnet.main.id

  tags = local.tags
}

module "netective-2" {
  source = "../../000-netective-virtual-machine/terraform"
  name = "netective-2"

  resource_group_name = "rg-netective-2"
  subnet_id = azurerm_subnet.main.id

  tags = local.tags
}