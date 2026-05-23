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
  source        = "./modules/windows-vm"
  for_each      = var.windows_vms
  vm_name       = each.value.vm_name
  computer_name = each.value.computer_name
  location      = each.value.location

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

module "firewalls" {
  source         = "./modules/firewall"
  for_each       = var.firewalls
  firewall_name  = each.value.firewall_name
  public_ip_name = each.value.public_ip_name
  location       = each.value.location
  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name

  subnet_id = module.subnets[
    each.value.subnet_key
  ].subnet_id

  sku_tier = each.value.sku_tier
  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

module "firewall_nat_rules" {
  source   = "./modules/firewall-nat-rule"
  for_each = var.firewall_nat_rules
  name     = each.value.name

  firewall_name = module.firewalls[
    each.value.firewall_key
  ].firewall_name

  firewall_public_ip = module.firewalls[
    each.value.firewall_key
  ].firewall_public_ip

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name

  priority = each.value.priority
  action   = each.value.action
  rules    = each.value.rules
}

module "firewall_network_rules" {
  source   = "./modules/firewall-network-rule"
  for_each = var.firewall_network_rules
  name     = each.value.name

  firewall_name = module.firewalls[
    each.value.firewall_key
  ].firewall_name

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name

  priority = each.value.priority
  action   = each.value.action
  rules    = each.value.rules
}

module "firewall_application_rules" {
  source   = "./modules/firewall-application-rule"
  for_each = var.firewall_application_rules
  name     = each.value.name

  firewall_name = module.firewalls[
    each.value.firewall_key
  ].firewall_name

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name

  priority = each.value.priority
  action   = each.value.action
  rules    = each.value.rules
}

module "route_tables" {
  source           = "./modules/route-table"
  for_each         = var.route_tables
  route_table_name = each.value.route_table_name
  location         = each.value.location

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name

  routes = [
    for route in each.value.routes :
    merge(
      route,
      {
        next_hop_in_ip_address = (
          route.next_hop_type == "VirtualAppliance"
          ? module.firewalls["hub"].firewall_private_ip
          : null
        )
      }
    )
  ]

  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

module "route_table_associations" {
  source   = "./modules/route-table-association"
  for_each = var.route_table_associations
  subnet_id = module.subnets[
    each.value.subnet_key
  ].subnet_id
  route_table_id = module.route_tables[
    each.value.route_table_key
  ].route_table_id
}

module "application_gateways" {
  source   = "./modules/application-gateway"
  for_each = var.application_gateways

  application_gateway_name = (
    each.value.application_gateway_name
  )

  public_ip_name = each.value.public_ip_name
  location       = each.value.location

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name
  subnet_id = module.subnets[
    each.value.subnet_key
  ].subnet_id

  sku_name          = each.value.sku_name
  sku_tier          = each.value.sku_tier
  capacity          = each.value.capacity
  backend_pool_name = each.value.backend_pool_name

  backend_ip_addresses = (
    each.value.backend_vm_private_ips
  )

  frontend_port_name = each.value.frontend_port_name
  frontend_port      = each.value.frontend_port
  http_setting_name  = each.value.http_setting_name
  listener_name      = each.value.listener_name
  routing_rule_name  = each.value.routing_rule_name
  probe_name         = each.value.probe_name
  probe_host         = each.value.probe_host
  probe_path         = each.value.probe_path
  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

module "log_analytics_workspaces" {
  source   = "./modules/log-analytics"
  for_each = var.log_analytics_workspaces

  workspace_name = each.value.workspace_name
  location       = each.value.location

  resource_group_name = module.resource_groups[
    each.value.resource_group_key
  ].resource_group_name

  retention_in_days = each.value.retention_in_days

  tags = merge(
    local.common_tags,
    each.value.tags
  )
}

module "diagnostic_settings" {
  source   = "./modules/diagnostic-setting"
  for_each = var.diagnostic_settings

  diagnostic_name = each.value.diagnostic_name

  target_resource_id = (
    each.value.resource_type == "firewall"
    ? module.firewalls[
        each.value.resource_key
      ].firewall_id
    : module.application_gateways[
        each.value.resource_key
      ].application_gateway_id
  )

  log_analytics_workspace_id = (
    module.log_analytics_workspaces[
      each.value.workspace_key
    ].workspace_id
  )
}


