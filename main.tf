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

module "nics" {
  source   = "./modules/nic"
  for_each = var.nics
  nic_name = each.value.nic_name
  location = each.value.location

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name

  subnet_id = module.subnets[
    each.value.subnet_key
  ].subnet_id

  private_ip_address_allocation = (
    each.value.private_ip_address_allocation
  )

  private_ip_address = each.value.private_ip_address

  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

module "windows_vms" {
  source   = "./modules/windows-vm"
  for_each = var.windows_vms
  vm_name  = each.value.vm_name
  location = each.value.location

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name

  network_interface_ids = [
    for nic_key in each.value.nic_keys :
    module.nics[nic_key].nic_id
  ]

  admin_username         = data.azurerm_key_vault_secret.vm_admin_username.value
  admin_password         = data.azurerm_key_vault_secret.vm_admin_password.value
  size                   = each.value.size
  os_disk                = each.value.os_disk
  source_image_reference = each.value.source_image_reference
  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

module "vm_extensions" {
  source         = "./modules/vm-extension"
  for_each       = var.vm_extensions
  extension_name = each.value.extension_name

  virtual_machine_id = module.windows_vms[
    each.value.vm_key
  ].vm_id

  publisher            = each.value.publisher
  type                 = each.value.type
  type_handler_version = each.value.type_handler_version

  auto_upgrade_minor_version = (
    each.value.auto_upgrade_minor_version
  )
  settings = each.value.settings
}