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