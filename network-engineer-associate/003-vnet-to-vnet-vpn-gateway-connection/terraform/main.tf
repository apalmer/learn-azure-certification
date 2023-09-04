provider "azurerm" {
  features {}
}

locals {
  resourceGroupName     = "rg-networking"
  resourceGroupLocation = "eastus"

  vnet1ResourceGroup = "rg-networking-eus"
  vnet1Location = "eastus"
  vnet1Name   = "vnet1"
  vnet1CIDR   = "10.1.0.0/16"
  subnetAName = "subnetA"
  subnetACIDR = "10.1.0.0/24"

  vnet2ResourceGroup = "rg-networking-wus"
  vnet2Location = "westus"
  vnet2Name   = "vnet2"
  vnet2CIDR   = "10.41.0.0/16"
  subnetBName = "subnetB"
  subnetBCIDR = "10.41.0.0/24"

  tags = {
    Project = "AzureNetworkingCertification"
    Lab     = "003-vnet-to-vnet-vpn-gateway-connection"
  }
}

resource "azurerm_resource_group" "rgNetworkingEast" {
  name     = local.vnet1ResourceGroup
  location = local.vnet1Location

  tags = local.tags
}

resource "azurerm_virtual_network" "vnet1" {
  name                = local.vnet1Name
  location            = azurerm_resource_group.rgNetworkingEast.location
  resource_group_name = azurerm_resource_group.rgNetworkingEast.name

  address_space = [local.vnet1CIDR]

  tags = local.tags
}

resource "azurerm_subnet" "a" {
  name                = local.subnetAName
  resource_group_name = azurerm_resource_group.rgNetworkingEast.name

  address_prefixes     = [local.subnetACIDR]
  virtual_network_name = azurerm_virtual_network.vnet1.name
}

resource "azurerm_resource_group" "rgNetworkingWest" {
  name     = local.vnet2ResourceGroup
  location = local.vnet2Location

  tags = local.tags
}

resource "azurerm_virtual_network" "vnet2" {
  name                = local.vnet2Name
  location            = azurerm_resource_group.rgNetworkingWest.location
  resource_group_name = azurerm_resource_group.rgNetworkingWest.name

  address_space = [local.vnet2CIDR]

  tags = local.tags
}

resource "azurerm_subnet" "b" {
  name                = local.subnetBName
  resource_group_name = azurerm_resource_group.rgNetworkingWest.name

  address_prefixes     = [local.subnetBCIDR]
  virtual_network_name = azurerm_virtual_network.vnet2.name
}

module "netective-1" {
  source = "../../000-netective-virtual-machine/terraform"
  name = "netective-1"

  resource_group_name = "rg-netective-1"
  location = local.vnet1Location
  subnet_id = azurerm_subnet.a.id

  tags = local.tags
}

module "netective-2" {
  source = "../../000-netective-virtual-machine/terraform"
  name = "netective-2"

  resource_group_name = "rg-netective-2"
  location = local.vnet2Location
  subnet_id = azurerm_subnet.b.id

  tags = local.tags
}