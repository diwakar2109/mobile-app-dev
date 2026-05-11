resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

resource "azurerm_network_security_group" "appgw" {
  name                = local.nsg_appgw_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowVNetInboundAll"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix     = local.vnet_cidr
    source_port_range         = "*"
    destination_address_prefix = "*"
    destination_port_range    = "*"
  }
}

resource "azurerm_network_security_group" "app" {
  name                = local.nsg_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowVNetInboundAll"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix     = local.vnet_cidr
    source_port_range         = "*"
    destination_address_prefix = "*"
    destination_port_range    = "*"
  }
}

resource "azurerm_network_security_group" "db" {
  name                = local.nsg_db_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowVNetInboundAll"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix     = local.vnet_cidr
    source_port_range         = "*"
    destination_address_prefix = "*"
    destination_port_range    = "*"
  }
}

resource "azurerm_subnet" "appgw" {
  name                 = var.appgw_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.appgw_subnet_prefix]

  network_security_group_id = azurerm_network_security_group.appgw.id

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet" "app" {
  name                 = var.app_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.app_subnet_prefix]

  network_security_group_id = azurerm_network_security_group.app.id

  delegation {
    name = "appservice-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  private_endpoint_network_policies_enabled = true
}

resource "azurerm_subnet" "db" {
  name                 = var.db_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.db_subnet_prefix]

  network_security_group_id = azurerm_network_security_group.db.id

  # Required so private endpoints can be created in this subnet.
  private_endpoint_network_policies_enabled = false
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_dns_zone" "vaultcore" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vaultcore" {
  name                  = "link-${var.vnet_name}-vaultcore"
  resource_group_name  = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.vaultcore.name
  virtual_network_id   = azurerm_virtual_network.this.id
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "link-${var.vnet_name}-sql"
  resource_group_name  = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id   = azurerm_virtual_network.this.id
  tags                  = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "link-${var.vnet_name}-redis"
  resource_group_name  = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id   = azurerm_virtual_network.this.id
  tags                  = var.tags
}

