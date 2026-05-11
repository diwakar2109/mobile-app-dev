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

variable "app_gateway_name" {
  type        = string
  description = "App Gateway name."
}

variable "subnet_id" {
  type        = string
  description = "Subnet id for App Gateway."
}

variable "backend_fqdns" {
  type        = list(string)
  description = "Backend FQDNs to route to (e.g., webapp default hostname)."
}

variable "waf_capacity_min" {
  type        = number
  default     = 2
}

variable "waf_capacity_max" {
  type        = number
  default     = 10
}

variable "enable_https" {
  type        = bool
  default     = false
}

variable "app_gateway_ssl_certificate_secret_id" {
  type        = string
  default     = null
}

variable "app_gateway_private_ip_address" {
  type        = string
  default     = "10.247.20.36"
  description = "Static private IP address inside the App Gateway subnet."
}

