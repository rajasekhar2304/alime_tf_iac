module "resource_groups" {
  source      = "./modules/rg"
  for_each    = var.resource_groups
  rg_name     = each.value.rg_name
  rg_location = each.value.rg_location
  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

module "vnets" {
  source = "./modules/vnet"
  for_each = var.vnets
  vnet_name = each.value.vnet_name
  location = each.value.location
  resource_group_name = module.resource_groups[each.value.resource_group_key].resource_group_name
  address_space = each.value.address_space
  tags = merge(
    local.common_tags,
    each.value.tags
  )
}