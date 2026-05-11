resource "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"

  retention_in_days = 30
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type  = "web"

  workspace_id = azurerm_log_analytics_workspace.this.id
  tags          = var.tags
}

resource "azurerm_monitor_action_group" "alerts" {
  count               = length(var.alert_emails) > 0 ? 1 : 0
  name                = "${var.app_insights_name}-ag"
  resource_group_name = var.resource_group_name
  short_name          = "cpualert"
  tags                = var.tags

  dynamic "email_receiver" {
    for_each = var.alert_emails
    content {
      name          = "cpu"
      email_address = email_receiver.value
    }
  }
}

resource "azurerm_monitor_metric_alert" "cpu" {
  count               = length(var.alert_emails) > 0 ? 1 : 0
  name                = "${var.app_insights_name}-cpu"
  resource_group_name = var.resource_group_name

  scopes = [var.app_service_plan_id]
  description = "CPU metric alert on App Service Plan."

  frequency   = "PT1M"
  window_size = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "CpuPercentage"
    aggregation       = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts[0].id
  }

  tags = var.tags
}

