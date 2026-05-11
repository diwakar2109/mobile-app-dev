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

variable "sql_server_name" {
  type        = string
  description = "Azure SQL Server name."
}

variable "sql_database_name" {
  type        = string
  description = "Azure SQL Database name."
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet id where the private endpoint will be created."
}

variable "sql_private_dns_zone_id" {
  type        = string
  description = "Private DNS zone id for privatelink.database.windows.net."
}

variable "aad_admin_login" {
  type        = string
  description = "AAD admin login name."
}

variable "aad_admin_object_id" {
  type        = string
  description = "AAD admin object id."
}

variable "sql_sku_name" {
  type        = string
  default     = "GP_Gen5_4"
  description = "Azure SQL Database SKU."
}

