locals {
  # Matches your pattern: `cp-mobile-$-$$$`
  # - `$`      -> environment (Dev/UAT/Prod)
  # - `$$$`    -> name_suffix (e.g., 001 / 002 ...)
  resource_group_name = "cp-mobile-${var.environment}-${var.name_suffix}"

  base_prefix = "cp-mobile-${var.environment}-${var.name_suffix}"

  vnet_name          = "${local.base_prefix}-vnet"
  appgw_name         = "${local.base_prefix}-appgw"
  service_plan_name  = "${local.base_prefix}-asp"
  key_vault_name     = substr(replace(lower("${local.base_prefix}kv"), "-", ""), 0, 24)
  sql_server_name    = substr(replace(lower("${local.base_prefix}-sqlsrv"), "-", ""), 0, 63)
  sql_database_name = "${local.base_prefix}-sqldb"
  redis_name         = substr(replace(lower("${local.base_prefix}-redis"), "-", ""), 0, 50)
  webapp_name        = substr(replace(lower("${local.base_prefix}-web"), "-", ""), 0, 60)

  log_analytics_workspace_name = substr(replace(lower("${local.base_prefix}-law"), "-", ""), 0, 64)
  app_insights_name             = substr(replace(lower("${local.base_prefix}-appi"), "-", ""), 0, 128)

  cdn_profile_name  = substr(replace(lower("${local.base_prefix}-cdnprof"), "-", ""), 0, 50)
  cdn_endpoint_name = substr(replace(lower("${local.base_prefix}-cdnend"), "-", ""), 0, 60)
}

module "resourcegroup" {
  source = "./modules/resourcegroup"

  resource_group_name = local.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "networking" {
  source = "./modules/networking"

  resource_group_name = module.resourcegroup.resource_group_name
  location            = var.location
  tags                = var.tags

  vnet_name        = local.vnet_name
  appgw_subnet_name = "applicationgateway-10.247.20.32-28"
  app_subnet_name   = "application-10.247.20.64-27"
  db_subnet_name    = "database-10.247.20.96-27"

  vnet_address_space  = "10.247.20.0/24"
  appgw_subnet_prefix = "10.247.20.32/28"
  app_subnet_prefix   = "10.247.20.64/27"
  db_subnet_prefix    = "10.247.20.96/27"
}

module "service_plan" {
  source = "./modules/service-plan"

  resource_group_name = module.resourcegroup.resource_group_name
  location            = var.location
  tags                = var.tags

  service_plan_name = local.service_plan_name
  app_subnet_id     = module.networking.app_subnet_id
}

module "keyvault" {
  source = "./modules/keyvault"

  resource_group_name = module.resourcegroup.resource_group_name
  location            = var.location
  tags                = var.tags

  tenant_id       = var.tenant_id
  key_vault_name  = local.key_vault_name

  private_endpoint_subnet_id = module.networking.db_subnet_id
  vault_private_dns_zone_id  = module.networking.vault_private_dns_zone_id

  identity_principal_id = module.service_plan.identity_principal_id
}

module "sql" {
  source = "./modules/sql-server"

  resource_group_name = module.resourcegroup.resource_group_name
  location            = var.location
  tags                = var.tags

  sql_server_name    = local.sql_server_name
  sql_database_name = local.sql_database_name

  private_endpoint_subnet_id = module.networking.db_subnet_id
  sql_private_dns_zone_id    = module.networking.sql_private_dns_zone_id

  aad_admin_login     = var.aad_admin_login
  aad_admin_object_id = var.aad_admin_object_id
}

module "redis" {
  source = "./modules/redis"

  resource_group_name = module.resourcegroup.resource_group_name
  location            = var.location
  tags                = var.tags

  redis_name = local.redis_name

  capacity = 2

  private_endpoint_subnet_id = module.networking.db_subnet_id
  redis_private_dns_zone_id   = module.networking.redis_private_dns_zone_id
}

module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = module.resourcegroup.resource_group_name
  location            = var.location
  tags                = var.tags

  log_analytics_workspace_name = local.log_analytics_workspace_name
  app_insights_name             = local.app_insights_name

  alert_emails = var.alert_emails
  app_service_plan_id = module.service_plan.service_plan_id
}

module "webapp" {
  source = "./modules/webapp"

  resource_group_name = module.resourcegroup.resource_group_name
  location            = var.location
  tags                = var.tags

  webapp_name       = local.webapp_name
  service_plan_id  = module.service_plan.service_plan_id
  identity_id      = module.service_plan.identity_id
  app_subnet_id    = module.networking.app_subnet_id

  app_insights_connection_string   = module.monitoring.app_insights_connection_string
  app_insights_instrumentation_key = module.monitoring.app_insights_instrumentation_key

  key_vault_uri = module.keyvault.key_vault_uri

  cdn_profile_name  = local.cdn_profile_name
  cdn_endpoint_name = local.cdn_endpoint_name
}

module "appgateway_waf" {
  source = "./modules/application-gateway-waf"

  resource_group_name = module.resourcegroup.resource_group_name
  location            = var.location
  tags                = var.tags

  app_gateway_name = local.appgw_name
  subnet_id        = module.networking.appgw_subnet_id

  backend_fqdns = [module.webapp.webapp_default_hostname]

  waf_capacity_min = 2
  waf_capacity_max = 10

  enable_https                  = var.app_gateway_enable_https
  app_gateway_ssl_certificate_secret_id = var.app_gateway_ssl_certificate_secret_id
}

