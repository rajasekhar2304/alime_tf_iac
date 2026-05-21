output "nic_id" {
  value = azurerm_network_interface.nic.id
}

output "nic_name" {
  value = azurerm_network_interface.nic.name
}

output "private_ip_address" {
  value = azurerm_network_interface.nic.private_ip_address
}