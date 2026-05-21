variable "nic_name" {
  description = "Name of the Network Interface"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where NIC will be attached"
  type        = string
}

variable "private_ip_address_allocation" {
  description = "Private IP allocation method"
  type        = string
  default     = "Static"
}

variable "private_ip_address" {
  description = "Static private IP address"
  type        = string
}

variable "tags" {
  description = "Tags for NIC"
  type        = map(string)
  default     = {}
}