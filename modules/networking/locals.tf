locals {
  # Default NSG inbound rule: allow everything inside the VNet CIDR.
  vnet_cidr = split("/", var.vnet_address_space)[0] == "" ? var.vnet_address_space : var.vnet_address_space

  nsg_appgw_name = "${var.vnet_name}-nsg-appgw"
  nsg_app_name   = "${var.vnet_name}-nsg-app"
  nsg_db_name    = "${var.vnet_name}-nsg-db"
}

