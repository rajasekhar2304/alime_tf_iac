variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_groups" {
  description = "Map of Resource Groups"
  type = map(object({
    rg_name     = string
    rg_location = string
    tags        = optional(map(string), {})
  }))
}

variable "vnets" {
  description = "Map of VNets"
  type = map(object({
    vnet_name          = string
    location           = string
    resource_group_key = string
    address_space      = list(string)
    tags               = optional(map(string), {})
  }))
}

variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    subnet_name        = string
    resource_group_key = string
    vnet_key           = string
    address_prefixes   = list(string)
  }))
}

variable "peerings" {
  description = "Map of VNet peerings"
  type = map(object({
    peering_name                 = string
    resource_group_key           = string
    source_vnet_key              = string
    remote_vnet_key              = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, true)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
}

variable "nsgs" {
  description = "Map of NSGs"
  type = map(object({
    nsg_name           = string
    resource_group_key = string
    subnet_key         = string
    location           = string
    tags               = optional(map(string), {})
    security_rules = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "nics" {
  description = "Map of NICs"
  type = map(object({
    nic_name                      = string
    location                      = string
    resource_group_key            = string
    subnet_key                    = string
    private_ip_address_allocation = optional(string, "Static")
    private_ip_address            = string
    tags                          = optional(map(string), {})
  }))
}

variable "windows_vms" {
  description = "Map of Windows VMs"
  type = map(object({
    vm_name            = string
    computer_name      = string
    location           = string
    resource_group_key = string
    nic_keys           = list(string)
    size               = string
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    tags = optional(map(string), {})
  }))
}

variable "vm_extensions" {
  description = "Map of VM extensions"
  type = map(object({
    extension_name             = string
    vm_key                     = string
    publisher                  = string
    type                       = string
    type_handler_version       = string
    auto_upgrade_minor_version = optional(bool, true)
    settings                   = string
  }))
}

variable "firewalls" {
  description = "Map of Azure Firewalls"
  type = map(object({
    firewall_name = string
    public_ip_name = string
    location = string
    resource_group_key = string
    subnet_key = string
    sku_tier = optional(string, "Basic")
    tags = optional(map(string), {})
  }))
}

variable "firewall_nat_rules" {
  type = map(object({
    firewall_key       = string
    resource_group_key = string
    name               = string
    priority           = number
    action             = string
    rules              = any
  }))
}

variable "firewall_network_rules" {
  type = map(object({
    firewall_key       = string
    resource_group_key = string
    name               = string
    priority           = number
    action             = string
    rules              = any
  }))
}

variable "firewall_application_rules" {
  type = map(object({
    firewall_key       = string
    resource_group_key = string
    name               = string
    priority           = number
    action             = string
    rules              = any
  }))
}

variable "route_tables" {
  type = map(object({
    route_table_name = string
    location = string
    resource_group_key = string
    routes = list(object({
      name = string
      address_prefix = string
      next_hop_type = string
      next_hop_in_ip_address = optional(string)
    }))
    tags = optional(map(string), {})
  }))
}

variable "route_table_associations" {
  type = map(object({
    subnet_key = string
    route_table_key = string
  }))
}

variable "application_gateways" {
  type = map(object({
    application_gateway_name = string
    public_ip_name = string
    location = string
    resource_group_key = string
    subnet_key = string
    sku_name = string
    sku_tier = string
    capacity = number
    backend_pool_name = string
    backend_vm_private_ips = list(string)
    frontend_port_name = string
    frontend_port = number
    http_setting_name = string
    listener_name = string
    routing_rule_name = string
    probe_name = string
    probe_host = optional(string, "127.0.0.1")
    probe_path = optional(string, "/")
    tags = optional(map(string), {})
  }))
}

