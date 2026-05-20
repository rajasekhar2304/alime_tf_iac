variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "virtual_network_name" {
  description = "VNet name"
  type        = string
}

variable "address_prefixes" {
  description = "Subnet CIDR ranges"
  type        = list(string)
}