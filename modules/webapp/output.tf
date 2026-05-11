output "webapp_default_hostname" {
  value = azurerm_linux_web_app.this.default_hostname
}

output "webapp_id" {
  value = azurerm_linux_web_app.this.id
}

output "cdn_endpoint_hostname" {
  value = azurerm_cdn_endpoint.this.host_name
}

