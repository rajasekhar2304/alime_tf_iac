variable "name" {
  description = "Application rule collection name"
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
  description = "Rule action"
  type        = string
}

variable "rules" {
  description = "Application rules"
  type = list(object({
    name              = string
    source_addresses  = list(string)
    target_fqdns      = list(string)
    protocols = list(object({
      type = string
      port = number
    }))
  }))
}
