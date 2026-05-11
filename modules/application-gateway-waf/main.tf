resource "azurerm_application_gateway" "this" {
  name                = var.app_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_http2 = true

  # Internal App Gateway
  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = var.waf_capacity_min
  }

  autoscale_configuration {
    min_capacity = var.waf_capacity_min
    max_capacity = var.waf_capacity_max
  }

  gateway_ip_configuration {
    name      = "${var.app_gateway_name}-gwip"
    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {
    name                          = local.frontend_ip_config_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.app_gateway_private_ip_address
  }

  frontend_port {
    name = local.frontend_port_http_name
    port = 80
  }

  dynamic "frontend_port" {
    for_each = var.enable_https && var.app_gateway_ssl_certificate_secret_id != null ? [1] : []
    content {
      name = local.frontend_port_https_name
      port = 443
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.enable_https && var.app_gateway_ssl_certificate_secret_id != null ? [1] : []
    content {
      name                = local.ssl_certificate_name
      key_vault_secret_id = var.app_gateway_ssl_certificate_secret_id
    }
  }

  # Backend routing
  backend_address_pool {
    name  = local.backend_pool_name
    fqdns = var.backend_fqdns
  }

  backend_http_settings {
    name                  = local.backend_http_settings
    cookie_based_affinity = "Disabled"
    port                  = var.enable_https ? 80 : 80
    protocol              = "Http"
    request_timeout      = 30
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_config_name
    frontend_port_name            = local.frontend_port_http_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_http
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name = local.backend_pool_name
    backend_http_settings_name = local.backend_http_settings
  }

  dynamic "http_listener" {
    for_each = var.enable_https && var.app_gateway_ssl_certificate_secret_id != null ? [1] : []
    content {
      name                           = local.https_listener_name
      frontend_ip_configuration_name = local.frontend_ip_config_name
      frontend_port_name            = local.frontend_port_https_name
      protocol                       = "Https"
      ssl_certificate_name          = local.ssl_certificate_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.enable_https && var.app_gateway_ssl_certificate_secret_id != null ? [1] : []
    content {
      name                        = local.request_routing_rule_https
      priority                    = 110
      rule_type                   = "Basic"
      http_listener_name          = local.https_listener_name
      backend_address_pool_name  = local.backend_pool_name
      backend_http_settings_name  = local.backend_http_settings
    }
  }

  waf_configuration {
    enabled       = true
    firewall_mode = "Prevention"

    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  tags = var.tags
}

