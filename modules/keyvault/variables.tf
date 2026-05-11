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

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant id."
}

variable "key_vault_name" {
  type        = string
  description = "Key Vault name (must be globally unique)."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet where the Key Vault private endpoint will be created."
}

variable "vault_private_dns_zone_id" {
  type        = string
  description = "Private DNS zone id for Key Vault (privatelink.vaultcore.azure.net)."
}

variable "identity_principal_id" {
  type        = string
  description = "Principal id that will be granted Key Vault access via RBAC."
}

