resource "azurerm_key_vault" "this" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  tenant_id = var.tenant_id
  sku_name  = "standard"

  enable_rbac_authorization = true

  public_network_access_enabled = false
  purge_protection_enabled       = true
  soft_delete_retention_days     = 7
}

resource "azurerm_private_endpoint" "vault" {
  name                = "${var.key_vault_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.key_vault_name}-psc"
    private_connection_resource_id = azurerm_key_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.vault_private_dns_zone_id]
  }
}

resource "azurerm_role_assignment" "secrets_user" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.identity_principal_id
}

