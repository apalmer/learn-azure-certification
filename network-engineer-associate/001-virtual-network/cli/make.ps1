$resourceGroupName = 'rg-networking'
$resourceGroupLocation = 'eastus'
$tags = 'Project=AzureNetworkingCertification', 'Lab=001-Virtual-Network'
$vnetName = 'vnet-1'
$vnetCIDR = '10.1.0.0/16'
$subnetName = 'subnet-1'
$subnetCIDR = '10.1.0.0/24'

az group create `
    --location $resourceGroupLocation `
    --name $resourceGroupName `
    --tags $tags

az network vnet create `
--resource-group $resourceGroupName `
--name  $vnetName `
--address-prefix $vnetCIDR  `
--subnet-name $subnetName `
--subnet-prefixes $subnetCIDR  `
--tags $tags