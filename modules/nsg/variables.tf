variable "nsg_name" {
  description = "NSG name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for NSG association"
  type        = string
}

variable "tags" {
  description = "Tags for NSG"
  type        = map(string)
  default     = {}
}

variable "security_rules" {
  description = "Map of NSG rules"
  type = map(object({
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
}