output "resource_group_names" {
  value = {
    for k, rg in module.resource_groups :
    k => rg.resource_group_name
  }
}

output "resource_group_ids" {
  value = {
    for k, rg in module.resource_groups :
    k => rg.resource_group_id
  }
}