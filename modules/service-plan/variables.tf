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

variable "service_plan_name" {
  type        = string
  description = "App Service Plan name."
}

variable "app_subnet_id" {
  type        = string
  description = "Subnet id for App Service VNet integration (used by webapp module)."
}

variable "autoscale_min_instances" {
  type        = number
  default     = 2
}

variable "autoscale_max_instances" {
  type        = number
  default     = 10
}

