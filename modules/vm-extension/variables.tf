variable "extension_name" {
  description = "VM Extension name"
  type        = string
}

variable "virtual_machine_id" {
  description = "Virtual Machine ID"
  type        = string
}

variable "publisher" {
  description = "Extension publisher"
  type        = string
}

variable "type" {
  description = "Extension type"
  type        = string
}

variable "type_handler_version" {
  description = "Extension handler version"
  type        = string
}

variable "auto_upgrade_minor_version" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "settings" {
  description = "Extension settings JSON"
  type        = string
}