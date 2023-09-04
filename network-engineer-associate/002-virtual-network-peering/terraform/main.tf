provider "azurerm" {
  features {}
}

locals {
  resourceGroupName     = "rg-networking"
  resourceGroupLocation = "eastus"

  vnet1Name   = "vnet1"
  vnet1CIDR   = "10.1.0.0/16"
  subnetAName = "subnetA"
  subnetACIDR = "10.1.0.0/24"

  vnet2Name   = "vnet2"
  vnet2CIDR   = "10.2.0.0/16"
  subnetBName = "subnetB"
  subnetBCIDR = "10.2.0.0/24"

  tags = {
    Project = "AzureNetworkingCertification"
    Lab     = "002-virtual-network-peering"
  }
}

resource "azurerm_resource_group" "rgNetworking" {
  name     = local.resourceGroupName
  location = local.resourceGroupLocation

  tags = local.tags
}

resource "azurerm_virtual_network" "vnet1" {
  name                = local.vnet1Name
  location            = azurerm_resource_group.rgNetworking.location
  resource_group_name = azurerm_resource_group.rgNetworking.name

  address_space = [local.vnet1CIDR]

  tags = local.tags
}

resource "azurerm_subnet" "a" {
  name                = local.subnetAName
  resource_group_name = azurerm_resource_group.rgNetworking.name

  address_prefixes     = [local.subnetACIDR]
  virtual_network_name = azurerm_virtual_network.vnet1.name
}

resource "azurerm_virtual_network" "vnet2" {
  name                = local.vnet2Name
  location            = azurerm_resource_group.rgNetworking.location
  resource_group_name = azurerm_resource_group.rgNetworking.name

  address_space = [local.vnet2CIDR]

  tags = local.tags
}

resource "azurerm_subnet" "b" {
  name                = local.subnetBName
  resource_group_name = azurerm_resource_group.rgNetworking.name

  address_prefixes     = [local.subnetBCIDR]
  virtual_network_name = azurerm_virtual_network.vnet2.name
}

resource "azurerm_virtual_network_peering" "vnet1vnet2" {
  name = "${local.vnet1Name}${local.vnet2Name}"
  resource_group_name = azurerm_resource_group.rgNetworking.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

resource "azurerm_virtual_network_peering" "vnet2vnet1" {
  name = "${local.vnet2Name}${local.vnet1Name}"
  resource_group_name = azurerm_resource_group.rgNetworking.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}

module "netective-1" {
  source = "../../000-netective-virtual-machine/terraform"
  name = "netective-1"

  resource_group_name = "rg-netective-1"
  subnet_id = azurerm_subnet.a.id

  tags = local.tags
}

module "netective-2" {
  source = "../../000-netective-virtual-machine/terraform"
  name = "netective-2"

  resource_group_name = "rg-netective-2"
  subnet_id = azurerm_subnet.b.id

  tags = local.tags
}