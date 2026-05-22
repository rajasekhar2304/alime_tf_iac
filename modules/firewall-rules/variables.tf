variable "firewall_name" {
  description = "Azure Firewall name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "nat_rule_collections" {
  description = "NAT rule collections"
  type = map(object({
    name = string
    priority = number
    action = string
    rules = list(object({
      name = string
      source_addresses = list(string)
      destination_ports = list(string)
      translated_address = string
      translated_port = string
      protocols = list(string)
    }))
  }))
  default = {}
}

variable "network_rule_collections" {
  description = "Network rule collections"
  type = map(object({
    name = string
    priority = number
    action = string
    rules = list(object({
      name = string
      source_addresses = list(string)
      destination_addresses = list(string)
      destination_ports = list(string)
      protocols = list(string)
    }))
  }))
  default = {}
}

variable "application_rule_collections" {
  description = "Application rule collections"
  type = map(object({
    name = string
    priority = number
    action = string
    rules = list(object({
      name = string
      source_addresses = list(string)
      target_fqdns = list(string)
      protocols = list(object({
        type = string
        port = number
      }))
    }))
  }))
  default = {}
}

variable "firewall_public_ip" {
  description = "Firewall Public IP"
  type        = string
}
