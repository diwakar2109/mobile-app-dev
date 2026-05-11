output "resource_group_name" {
  value = module.resourcegroup.resource_group_name
}

output "vnet_id" {
  value = module.networking.vnet_id
}

output "webapp_default_hostname" {
  value = module.webapp.webapp_default_hostname
}

output "app_gateway_id" {
  value = module.appgateway_waf.app_gateway_id
}

output "key_vault_uri" {
  value = module.keyvault.key_vault_uri
}

output "sql_server_fqdn" {
  value = module.sql.sql_server_fqdn
}

output "redis_hostname" {
  value = module.redis.redis_hostname
}

