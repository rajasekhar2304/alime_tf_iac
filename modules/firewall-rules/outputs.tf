output "nat_rule_collection_ids" {
  value = {
    for k, v in azurerm_firewall_nat_rule_collection.nat :
    k => v.id
  }
}

output "network_rule_collection_ids" {
  value = {
    for k, v in azurerm_firewall_network_rule_collection.network :
    k => v.id
  }
}

output "application_rule_collection_ids" {
  value = {
    for k, v in azurerm_firewall_application_rule_collection.application :
    k => v.id
  }
}