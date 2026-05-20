variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_groups" {
  description = "Map of Resource Groups"
  type = map(object({
    rg_name     = string
    rg_location = string
    tags     = optional(map(string), {})
  }))
}