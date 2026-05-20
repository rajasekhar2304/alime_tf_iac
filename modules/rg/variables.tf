variable "rg_location" {
  description = "The Azure region where the Resource Group will be created"
  type        = string  
}

variable "rg_name" {
  description = "The name of the Resource Group"
  type        = string  
}

variable "tags" {
  description = "Tags for Resource Group"
  type        = map(string)
}