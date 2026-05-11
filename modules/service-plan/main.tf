resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name  = "P2v3"
  reserved = true

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "this" {
  name                = "${var.service_plan_name}-uami"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_monitor_autoscale_setting" "this" {
  name                = "${var.service_plan_name}-autoscale"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  target_resource_id = azurerm_service_plan.this.id
  enabled             = true

  profiles {
    name = "cpu-profile"

    capacity {
      default = var.autoscale_min_instances
      minimum = var.autoscale_min_instances
      maximum = var.autoscale_max_instances
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.this.id
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation   = "Average"
        operator            = "GreaterThan"
        threshold           = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.this.id
        time_grain          = "PT1M"
        statistic           = "Average"
        time_window         = "PT5M"
        time_aggregation   = "Average"
        operator            = "LessThan"
        threshold           = 30
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
    }
  }
}

