variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "location" {
  description = "The Azure region where the vnet will be created"
  type        = string
}

variable "resource_group_name" {
  description = "RG name"
  type        = string
}

variable "address_space" {
  description = "Address space for vnet"
  type        = list(string)
}

variable "tags" {
  description = "Tags for vnet"
  type        = map(string)
}