variable "environment" {
  description = "Deployment environment (e.g., Dev/UAT/Prod)."
  type        = string
}

variable "name_suffix" {
  description = "Suffix used in resource names to avoid collisions."
  type        = string
  default     = "001"
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}

variable "tenant_id" {
  description = "Azure AD tenant id."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription id."
  type        = string
}

variable "aad_admin_login" {
  description = "AAD admin login (for Azure SQL AAD-only auth)."
  type        = string
}

variable "aad_admin_object_id" {
  description = "AAD admin object id (for Azure SQL AAD-only auth)."
  type        = string
}

variable "alert_emails" {
  description = "Emails to receive CPU alerts. If empty, alerts are not created."
  type        = list(string)
  default     = []
}

variable "app_gateway_enable_https" {
  description = "Whether to configure App Gateway HTTPS listener."
  type        = bool
  default     = false
}

variable "app_gateway_ssl_certificate_secret_id" {
  description = "Key Vault secret id containing the SSL certificate (PFX) for App Gateway HTTPS."
  type        = string
  default     = null
}

