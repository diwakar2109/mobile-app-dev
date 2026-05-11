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

variable "vnet_name" {
  type        = string
  description = "VNet name."
}

variable "vnet_address_space" {
  type        = string
  description = "VNet CIDR."
}

variable "appgw_subnet_name" {
  type        = string
  description = "App Gateway subnet name."
}

variable "appgw_subnet_prefix" {
  type        = string
  description = "App Gateway subnet prefix."
}

variable "app_subnet_name" {
  type        = string
  description = "App Service subnet name."
}

variable "app_subnet_prefix" {
  type        = string
  description = "App Service subnet prefix."
}

variable "db_subnet_name" {
  type        = string
  description = "Database/private endpoint subnet name."
}

variable "db_subnet_prefix" {
  type        = string
  description = "Database/private endpoint subnet prefix."
}

