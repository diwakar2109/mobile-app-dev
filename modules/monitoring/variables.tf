variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags."
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics workspace name."
}

variable "app_insights_name" {
  type        = string
  description = "Application Insights name."
}

variable "alert_emails" {
  type        = list(string)
  default     = []
  description = "Email receivers for CPU alerts."
}

variable "app_service_plan_id" {
  type        = string
  description = "App Service Plan resource id for CPU metric alert scope."
}

