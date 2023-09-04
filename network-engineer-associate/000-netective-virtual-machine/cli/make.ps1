$resource_group_name = 'rg-virtual-machine-images'
$location = 'East US'
$vmName = 'netshooter'
$vmImage = 'UbuntuLTS'
$vmAdminUserName = 'nsadmin'

az group create `
  --name $resource_group_name `
  --location $location

az vm create `
  --resource-group $resource_group_name `
  --name $vmName `
  --image $vmImage `
  --admin-username $vmAdminUserName `
  --generate-ssh-keys `
  --public-ip-sku Standard