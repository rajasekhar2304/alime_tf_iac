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
