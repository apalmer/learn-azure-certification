$resourceGroupName = 'rg-networking-2'
$resourceGroupLocation = 'eastus'
$tags = 'Project=AzureNetworkingCertification', 'Lab=002-virtual-network-peering'
$vnet1Name = 'vnet1'
$vnet1CIDR = '10.1.0.0/16'
$subnetAName = 'subnetB'
$subnetACIDR = '10.1.0.0/24'
$vnet2Name = 'vnet2'
$vnet2CIDR = '10.2.0.0/16'
$subnetBName = 'subnetA'
$subnetBCIDR = '10.2.0.0/24'

az group create `
    --location $resourceGroupLocation `
    --name $resourceGroupName `
    --tags $tags

az network vnet create `
    --resource-group $resourceGroupName `
    --name  $vnet1Name `
    --address-prefix $vnet1CIDR  `
    --subnet-name $subnetAName `
    --subnet-prefixes $subnetACIDR  `
    --tags $tags

az network vnet create `
    --resource-group $resourceGroupName `
    --name  $vnet2Name `
    --address-prefix $vnet2CIDR  `
    --subnet-name $subnetBName `
    --subnet-prefixes $subnetBCIDR  `
    --tags $tags

$vnet1Id = (az network vnet show `
    --resource-group $resourceGroupName `
    --name  $vnet1Name `
    | ConvertFrom-Json).id

$vnet2Id = (az network vnet show `
    --resource-group $resourceGroupName `
    --name  $vnet2Name `
    | ConvertFrom-Json).id

az network vnet peering create `
    --resource-group $resourceGroupName `
    --name "$vnet1Name$vnet2Name" `
    --vnet-name $vnet1Name `
    --remote-vnet $vnet2Id `
    --allow-vnet-access

az network vnet peering create `
    --resource-group $resourceGroupName `
    --name "$vnet2Name$vnet1Name" `
    --vnet-name $vnet2Name `
    --remote-vnet $vnet1Id `
    --allow-vnet-access