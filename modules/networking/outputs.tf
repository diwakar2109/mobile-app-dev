output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db.id
}

output "vault_private_dns_zone_id" {
  value = azurerm_private_dns_zone.vaultcore.id
}

output "sql_private_dns_zone_id" {
  value = azurerm_private_dns_zone.sql.id
}

output "redis_private_dns_zone_id" {
  value = azurerm_private_dns_zone.redis.id
}

