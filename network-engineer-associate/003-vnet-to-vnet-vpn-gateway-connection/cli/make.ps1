
$tags = 'Project=AzureNetworkingCertification', 'Lab=003-vnet-to-vnet-vpn-gateway-connection'
$vnet1ResourceGroup = 'rg-networking-eus'
$vnet1Location = 'eastus'
$vnet1Name = 'vnet1'
$vnet1CIDR = '10.1.0.0/16'
$subnetAName = 'subnetB'
$subnetACIDR = '10.1.0.0/24'
$vnet2ResourceGroup = 'rg-networking-wus'
$vnet2Location = 'westus'
$vnet2Name = 'vnet2'
$vnet2CIDR = '10.41.0.0/16'
$subnetBName = 'subnetA'
$subnetBCIDR = '10.41.0.0/24'

az group create `
    --location $vnet1Location `
    --name $vnet1ResourceGroup `
    --tags $tags

az network vnet create `
    --resource-group $vnet1ResourceGroup `
    --name  $vnet1Name `
    --address-prefix $vnet1CIDR  `
    --subnet-name $subnetAName `
    --subnet-prefixes $subnetACIDR  `
    --tags $tags

az group create `
    --location $vnet2Location `
    --name $vnet2ResourceGroup `
    --tags $tags

az network vnet create `
    --resource-group $vnet2ResourceGroup `
    --name  $vnet2Name `
    --address-prefix $vnet2CIDR  `
    --subnet-name $subnetBName `
    --subnet-prefixes $subnetBCIDR  `
    --tags $tags