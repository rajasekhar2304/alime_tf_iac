variable "firewall_name" {
  description = "Azure Firewall name"
  type        = string
}

variable "public_ip_name" {
  description = "Firewall Public IP name"
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

variable "subnet_id" {
  description = "AzureFirewallSubnet ID"
  type        = string
}

variable "sku_tier" {
  description = "Firewall SKU tier"
  type        = string
  default     = "Basic"
}

variable "tags" {
  description = "Tags for Firewall resources"
  type        = map(string)
  default     = {}
}