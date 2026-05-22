output "application_gateway_id" {
  value = azurerm_application_gateway.agw.id
}

output "application_gateway_name" {
  value = azurerm_application_gateway.agw.name
}

output "application_gateway_public_ip" {
  value = azurerm_public_ip.agw_pip.ip_address
}
