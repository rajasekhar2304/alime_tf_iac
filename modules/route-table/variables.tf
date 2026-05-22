variable "route_table_name" {
  description = "Route Table name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "routes" {
  description = "Route entries"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
}

variable "tags" {
  description = "Tags for route table"
  type        = map(string)
  default     = {}
}