locals {
  frontend_port_http_name  = "${var.app_gateway_name}-fp80"
  frontend_port_https_name = "${var.app_gateway_name}-fp443"

  frontend_ip_config_name = "${var.app_gateway_name}-feip"
  http_listener_name       = "${var.app_gateway_name}-httpl"
  https_listener_name      = "${var.app_gateway_name}-httpsl"

  backend_pool_name        = "${var.app_gateway_name}-bepool"
  backend_http_settings    = "${var.app_gateway_name}-be-httpsettings"

  request_routing_rule_http  = "${var.app_gateway_name}-rout-http"
  request_routing_rule_https = "${var.app_gateway_name}-rout-https"

  ssl_certificate_name = "${var.app_gateway_name}-sslcert"
}

