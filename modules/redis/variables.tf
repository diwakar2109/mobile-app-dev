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

variable "redis_name" {
  type        = string
  description = "Redis Cache name."
}

variable "capacity" {
  type        = number
  description = "Redis capacity (size depends on family)."
  default     = 2
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet id where the Redis private endpoint will be created."
}

variable "redis_private_dns_zone_id" {
  type        = string
  description = "Private DNS zone id for privatelink.redis.cache.windows.net."
}

