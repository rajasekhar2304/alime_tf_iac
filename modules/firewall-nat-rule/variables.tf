variable "name" {
  description = "NAT rule collection name"
  type        = string
}

variable "firewall_name" {
  description = "Azure Firewall name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "priority" {
  description = "Rule collection priority"
  type        = number
}

variable "action" {
  description = "NAT rule action"
  type        = string
}

variable "rules" {
  description = "NAT rules"
  type = list(object({
    name               = string
    source_addresses   = list(string)
    destination_ports  = list(string)
    translated_address = string
    translated_port    = string
    protocols          = list(string)
  }))
}

variable "firewall_public_ip" {
  description = "Firewall Public IP"
  type        = string
}