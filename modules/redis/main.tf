resource "azurerm_redis_cache" "this" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name

  capacity = var.capacity
  family   = "C"
  sku_name = "Premium"

  # TLS-only, non-SSL port disabled (matches “TLS 6380 only” intent).
  enable_non_ssl_port   = false
  minimum_tls_version   = "1.2"

  # Rely on Private Endpoint for network access.
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_private_endpoint" "redis" {
  name                = "${var.redis_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.redis_name}-psc"
    private_connection_resource_id = azurerm_redis_cache.this.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.redis_private_dns_zone_id]
  }
}

