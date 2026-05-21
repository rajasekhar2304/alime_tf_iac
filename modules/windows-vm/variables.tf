variable "vm_name" {
  description = "Name of the Windows VM"
  type        = string
}

variable "computer_name" {
  description = "Windows computer hostname"
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

variable "size" {
  description = "VM size"
  type        = string
}

variable "network_interface_ids" {
  description = "List of NIC IDs attached to VM"
  type        = list(string)
}

variable "admin_username" {
  description = "Admin username"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "os_disk" {
  description = "OS disk configuration"
  type = object({
    caching              = string
    storage_account_type = string
  })
}

variable "source_image_reference" {
  description = "Windows image configuration"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "tags" {
  description = "Tags for VM"
  type        = map(string)
  default     = {}
}