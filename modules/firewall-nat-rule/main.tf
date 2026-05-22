resource "azurerm_firewall_nat_rule_collection" "nat_rule" {
  name                = var.name
  azure_firewall_name = var.firewall_name
  resource_group_name = var.resource_group_name
  priority            = var.priority
  action              = var.action
  dynamic "rule" {
    for_each = var.rules
    content {
      name              = rule.value.name
      source_addresses  = rule.value.source_addresses
      destination_ports = rule.value.destination_ports
      destination_addresses = [
        var.firewall_public_ip
      ]
      translated_address = rule.value.translated_address
      translated_port    = rule.value.translated_port
      protocols          = rule.value.protocols
    }
  }
}