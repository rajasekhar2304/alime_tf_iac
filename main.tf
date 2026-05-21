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
  source              = "./modules/vnet"
  for_each            = var.vnets
  vnet_name           = each.value.vnet_name
  location            = each.value.location
  resource_group_name = module.resource_groups[each.value.resource_group_key].resource_group_name
  address_space       = each.value.address_space
  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

module "subnets" {
  source               = "./modules/subnet"
  for_each             = var.subnets
  subnet_name          = each.value.subnet_name
  resource_group_name  = module.resource_groups[each.value.resource_group_key].resource_group_name
  virtual_network_name = module.vnets[each.value.vnet_key].vnet_name
  address_prefixes     = each.value.address_prefixes
}

module "peerings" {
  source                    = "./modules/peering"
  for_each                  = var.peerings
  peering_name              = each.value.peering_name
  resource_group_name       = module.resource_groups[each.value.resource_group_key].resource_group_name
  virtual_network_name      = module.vnets[each.value.source_vnet_key].vnet_name
  remote_virtual_network_id = module.vnets[each.value.remote_vnet_key].vnet_id
  allow_forwarded_traffic   = each.value.allow_forwarded_traffic
  allow_gateway_transit     = each.value.allow_gateway_transit
  use_remote_gateways       = each.value.use_remote_gateways
}

module "nsgs" {
  source   = "./modules/nsg"
  for_each = var.nsgs
  nsg_name = each.value.nsg_name
  location = each.value.location
  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name
  subnet_id = module.subnets[
    each.value.subnet_key
  ].subnet_id
  tags = merge(
    local.common_tags,
    each.value.tags
  )
  security_rules = each.value.security_rules
}