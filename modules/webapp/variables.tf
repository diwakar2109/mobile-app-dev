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

variable "webapp_name" {
  type        = string
  description = "App Service name."
}

variable "service_plan_id" {
  type        = string
  description = "App Service Plan id."
}

variable "identity_id" {
  type        = string
  description = "User-assigned identity id for App Service."
}

variable "app_subnet_id" {
  type        = string
  description = "Subnet id for App Service VNet integration (Swift connection)."
}

variable "app_insights_connection_string" {
  type        = string
  description = "Application Insights connection string."
}

variable "app_insights_instrumentation_key" {
  type        = string
  description = "Application Insights instrumentation key."
}

variable "key_vault_uri" {
  type        = string
  description = "Key Vault URI."
}

variable "cdn_profile_name" {
  type        = string
  description = "CDN profile name."
}

variable "cdn_endpoint_name" {
  type        = string
  description = "CDN endpoint name."
}

