variable "rg_location" {
  type        = string
  description = "The Azure region where the Resource Group will be created"
  default     = "East US"
}

variable "rg_name" {
  type        = string
  description = "The name of the Resource Group"
}

variable "tags" {
  type        = map(string)
  description = "Tags for Resource Group"
  default     = {}
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources"

}