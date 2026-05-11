resource "azurerm_linux_web_app" "this" {
  name                = var.webapp_name
  location            = var.location
  resource_group_name = var.resource_group_name

  service_plan_id = var.service_plan_id
  https_only       = true

  identity {
    type         = "UserAssigned"
    identity_ids = [var.identity_id]
  }

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE"                 = "1"
    "WEBSITE_VNET_ROUTE_ALL"                  = "1"
    "APPINSIGHTS_CONNECTION_STRING"          = var.app_insights_connection_string
    "APPINSIGHTS_INSTRUMENTATIONKEY"         = var.app_insights_instrumentation_key
    "KEY_VAULT_URI"                          = var.key_vault_uri
  }

  site_config {
    always_on = true
    ftps_state = "Disabled"
    http2_enabled = true
    minimum_tls_version = "1.2"
  }

  tags = var.tags
}

resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  app_service_id = azurerm_linux_web_app.this.id
  subnet_id      = var.app_subnet_id
  depends_on     = [azurerm_linux_web_app.this]
}

resource "azurerm_cdn_profile" "this" {
  name                = var.cdn_profile_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard_Microsoft"
  tags                = var.tags
}

resource "azurerm_cdn_endpoint" "this" {
  name                = var.cdn_endpoint_name
  profile_name        = azurerm_cdn_profile.this.name
  location            = var.location
  resource_group_name = var.resource_group_name

  origin_host_header = azurerm_linux_web_app.this.default_hostname

  is_http_allowed  = false
  is_https_allowed = true

  optimization_type = "GeneralWebDelivery"

  origin {
    name       = "webapp-origin"
    host_name  = azurerm_linux_web_app.this.default_hostname
  }

  tags = var.tags
}

