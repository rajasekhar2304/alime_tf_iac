resource "azurerm_firewall_application_rule_collection" "application_rule" {
  name                = var.name
  azure_firewall_name = var.firewall_name
  resource_group_name = var.resource_group_name
  priority            = var.priority
  action              = var.action
  dynamic "rule" {
    for_each = var.rules
    content {
      name             = rule.value.name
      source_addresses = rule.value.source_addresses
      target_fqdns     = rule.value.target_fqdns
      dynamic "protocol" {
        for_each = rule.value.protocols
        content {
          type = protocol.value.type
          port = protocol.value.port
        }
      }
    }
  }
}