variable "diagnostic_name" {
  type = string
}

variable "target_resource_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "log_categories" {
  type = list(string)
}

variable "metric_categories" {
  type = list(string)
}
