resource "azurerm_firewall_nat_rule_collection" "nat" {
  for_each = var.nat_rule_collections
  name = each.value.name
  azure_firewall_name = var.firewall_name
  resource_group_name = var.resource_group_name
  priority = each.value.priority
  action = each.value.action
  dynamic "rule" {
    for_each = each.value.rules
    content {
      name = rule.value.name
      source_addresses = rule.value.source_addresses
      destination_ports = rule.value.destination_ports
      destination_addresses = [ var.firewall_public_ip ]
      translated_address = rule.value.translated_address
      translated_port = rule.value.translated_port
      protocols = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "network" {
  for_each = var.network_rule_collections
  name = each.value.name
  azure_firewall_name = var.firewall_name
  resource_group_name = var.resource_group_name
  priority = each.value.priority
  action = each.value.action
  dynamic "rule" {
    for_each = each.value.rules
    content {
      name = rule.value.name
      source_addresses = rule.value.source_addresses
      destination_addresses = rule.value.destination_addresses
      destination_ports = rule.value.destination_ports
      protocols = rule.value.protocols
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "application" {
  for_each = var.application_rule_collections
  name = each.value.name
  azure_firewall_name = var.firewall_name
  resource_group_name = var.resource_group_name
  priority = each.value.priority
  action = each.value.action
  dynamic "rule" {
    for_each = each.value.rules
    content {
      name = rule.value.name
      source_addresses = rule.value.source_addresses
      target_fqdns = rule.value.target_fqdns
      dynamic "protocols" {
        for_each = rule.value.protocols
        content {
          type = protocols.value.type
          port = protocols.value.port
        }
      }
    }
  }
}
