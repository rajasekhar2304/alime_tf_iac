output "resource_group_names" {
  value = {
    for k, rg in module.resource_groups :
    k => rg.resource_group_name
  }
}

output "vnet_names" {
  value = {
    for k, vnet in modules.vnets :
    k => vnet.vnet_name
  }
}