provider "azurerm" {
  features {}
}

locals {
  resourceGroupName     = "rg-networking"
  resourceGroupLocation = "eastus"

  vnet1Name   = "vnet1"
  subnetAName = "subnetA"
  subnetAResourceGroupName = "rg-networking"

  vnet2Name   = "vnet2"
  subnetBName = "subnetB"
  subnetBResourceGroupName = "rg-networking"

  tags = {
    Project = "AzureNetworkingCertification"
    Lab     = "002-virtual-network"
  }
}

data "azurerm_subnet" "a" {
  name = local.subnetAName
  resource_group_name = local.subnetAResourceGroupName
  
  virtual_network_name = local.vnet1Name
}

data "azurerm_subnet" "b" {
  name = local.subnetBName
  resource_group_name = local.subnetBResourceGroupName
  
  virtual_network_name = local.vnet2Name
}

module "netective-1" {
  source = "../../terraform"
  name = "netective-1"

  resource_group_name = "rg-netective-1"
  subnet_id = data.azurerm_subnet.a.id

  tags = local.tags
}

module "netective-2" {
  source = "../../terraform"
  name = "netective-2"

  resource_group_name = "rg-netective-2"
  subnet_id = data.azurerm_subnet.b.id

  tags = local.tags
}