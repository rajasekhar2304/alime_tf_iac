variable "application_gateway_name" {
  description = "Application Gateway name"
  type        = string
}

variable "public_ip_name" {
  description = "Application Gateway Public IP name"
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
  description = "AGW subnet ID"
  type        = string
}

variable "sku_name" {
  description = "AGW SKU name"
  type        = string
}

variable "sku_tier" {
  description = "AGW SKU tier"
  type        = string
}

variable "capacity" {
  description = "Instance count"
  type        = number
}

variable "backend_pool_name" {
  description = "Backend pool name"
  type        = string
}

variable "backend_ip_addresses" {
  description = "Backend server IPs"
  type        = list(string)
}

variable "frontend_port_name" {
  description = "Frontend port name"
  type        = string
}

variable "frontend_port" {
  description = "Frontend port"
  type        = number
}

variable "http_setting_name" {
  description = "Backend HTTP setting name"
  type        = string
}

variable "listener_name" {
  description = "HTTP listener name"
  type        = string
}

variable "routing_rule_name" {
  description = "Routing rule name"
  type        = string
}

variable "probe_name" {
  description = "Health probe name"
  type        = string
}

variable "probe_host" {
  description = "Health probe host"
  type        = string
  default     = "127.0.0.1"
}

variable "probe_path" {
  description = "Health probe path"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}