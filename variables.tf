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
    peering_name            = string
    resource_group_key      = string
    source_vnet_key         = string
    remote_vnet_key         = string
    allow_virtual_network_access = optional(bool,true)
    allow_forwarded_traffic = optional(bool, true)
    allow_gateway_transit   = optional(bool, false)
    use_remote_gateways     = optional(bool, false)
  }))
}

variable "nsgs" {
  description = "Map of NSGs"
  type = map(object({
    nsg_name = string
    resource_group_key = string
    subnet_key = string
    location = string
    tags = optional(map(string), {})
    security_rules = map(object({
      name = string
      priority = number
      direction = string
      access = string
      protocol = string
      source_port_range = string
      destination_port_range = string
      source_address_prefix = string
      destination_address_prefix = string
    }))
  }))
}