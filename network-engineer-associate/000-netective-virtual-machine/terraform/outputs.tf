output "public_ip_address" {
    value = data.azurerm_public_ip.netective.ip_address
}

output "private_ip_address" {
  value = azurerm_network_interface.netective.private_ip_address
}