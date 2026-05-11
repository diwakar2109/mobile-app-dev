resource "random_password" "sql_admin" {
  length           = 32
  special          = true
  override_special = "!@#$%&*()-_=+[]{}<>?"
}

locals {
  sql_admin_login = "sqladminuser"
}

resource "azurerm_mssql_server" "this" {
  name                = var.sql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  version = "12.0"

  administrator_login          = local.sql_admin_login
  administrator_login_password = random_password.sql_admin.result

  azuread_administrator {
    login_username = var.aad_admin_login
    object_id      = var.aad_admin_object_id
  }

  azuread_authentication_only = true

  public_network_access_enabled = false
  minimal_tls_version           = "1.2"

  tags = var.tags

  lifecycle {
    # For AAD-only auth, the SQL login/password is unused; ignore updates to avoid Azure constraints.
    ignore_changes = [
      administrator_login_password
    ]
  }
}

resource "azurerm_mssql_database" "this" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.this.id
  sku_name       = var.sql_sku_name
  tags           = var.tags

  # Helps align with “TDE” requirement.
  transparent_data_encryption_enabled = true

  short_term_retention_policy {
    retention_days = 7
  }
}

resource "azurerm_private_endpoint" "sql" {
  name                = "${var.sql_server_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.sql_server_name}-psc"
    private_connection_resource_id = azurerm_mssql_server.this.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.sql_private_dns_zone_id]
  }
}

